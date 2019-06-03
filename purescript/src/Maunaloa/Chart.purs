module Maunaloa.Chart where
  
import Prelude

import Effect (Effect)
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

readNumArray :: Foreign -> F (Array Number)
readNumArray value = 
  readArray value >>= traverse readNumber >>= pure

data Lines2 = Lines2 (Array (Array Number))

instance showLines2 :: Show Lines2 where
  show (Lines2 lx) = "(Lines2 " <> show lx <> ")"

readChartLines :: Foreign -> F Lines2 
readChartLines value = do
  items <- value ! "chart" ! "lines" >>= readArray >>= traverse readNumArray
  pure $ Lines2 items
