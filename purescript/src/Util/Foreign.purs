module Util.Foreign where

import Prelude
import Foreign (F, Foreign, readNull, readArray, readInt, readString, readNumber, unsafeToForeign)
import Data.Traversable (traverse)

readNumArray :: Foreign -> F (Array Number)
readNumArray value = 
  readArray value >>= traverse readNumber >>= pure