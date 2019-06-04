module Maunaloa.Chart where
  
import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Data.Traversable (traverse)

import Foreign (F, Foreign, readArray, readInt, readString, readNumber)
import Foreign.Index ((!))

import Maunaloa.Common (ValueRange)


newtype ChartId = ChartId String

readNumArray :: Foreign -> F (Array Number)
readNumArray value = 
  readArray value >>= traverse readNumber >>= pure

data Lines2 = Lines2 (Array (Array Number))

newtype Chart = Chart {
    lines :: Lines2
}

instance showLines2 :: Show Lines2 where
  show (Lines2 lx) = "(Lines2 " <> show lx <> ")"

readChartLines :: ChartId -> Foreign -> F Lines2 
readChartLines (ChartId cid) value = do
  items <- value ! cid ! "lines" >>= readArray >>= traverse readNumArray
  pure $ Lines2 items

createChart :: ChartId -> Foreign -> Effect Unit
createChart cid value = do
    lines <- readChartLines cid value
    logShow "createChart"
    -- Chart { lines: lines }