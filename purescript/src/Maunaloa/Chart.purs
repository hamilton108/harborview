module Maunaloa.Chart where
  
import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Data.Traversable (traverse)

import Foreign (F, Foreign, readArray, readInt, readString, readNumber)
import Foreign.Index ((!))

{-
instance showChart :: Show Chart where
    show _ = "Chart"

newtype Line = Line (Array Number)

newtype Lines = Lines (Array Line)

data Chart = Chart Lines
-}

newtype ChartId = ChartId String

readNumArray :: Foreign -> F (Array Number)
readNumArray value = 
  readArray value >>= traverse readNumber >>= pure

data Lines2 = Lines2 (Array (Array Number))

instance showLines2 :: Show Lines2 where
  show (Lines2 lx) = "(Lines2 " <> show lx <> ")"

readChartLines :: ChartId -> Foreign -> F Lines2 
readChartLines (ChartId cid) value = do
  items <- value ! cid ! "lines" >>= readArray >>= traverse readNumArray
  pure $ Lines2 items

demo :: Effect Unit
demo = 
  logShow "demo"
