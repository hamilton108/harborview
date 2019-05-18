module Main2 where

import Prelude
import Data.Traversable (traverse)
import Control.Monad.Except (runExcept)
import Effect (Effect)
import Effect.Console (log, logShow)
--import Foreign (F, Foreign, readArray, readInt, readString, readNumber, readBoolean)
import Foreign (F, Foreign, readArray, readInt, readString, readNumber)
import Foreign.Index ((!))
import Util.Value (foreignValue)

data Foo = Foo Bar Baz

data Bar = Bar String

data Baz = Baz Number

type Bux = Array Int

instance showFoo :: Show Foo where
  show (Foo bar baz) = "(Foo " <> show bar <> " " <> show baz <> ")"

instance showBar :: Show Bar where
  show (Bar s) = "(Bar " <> show s <> ")"

instance showBaz :: Show Baz where
  show (Baz n) = "(Baz " <> show n <> ")"

instance showLines2 :: Show Lines2 where
  show (Lines2 lx) = "(Lines2 " <> show lx <> ")"
    
data Lines = Lines (Array Int) -- (Array (Array Int))

data Lines2 = Lines2 (Array (Array Int))

data Chart = Chart Lines

data ChartCollection = ChartCollection Chart

paint :: Array Number -> Effect Unit
paint v =  
  log (show v)
  --pure unit

readFoo :: Foreign -> F Foo
readFoo value = do
  s <- value ! "foo" ! "bar" >>= readString
  n <- value ! "foo" ! "baz" >>= readNumber
  pure $ Foo (Bar s) (Baz n)

readBux :: Foreign -> F Lines
readBux value = 
  value ! "lines" >>= readArray >>= traverse readInt >>= \s ->
  pure $ Lines s
  -- pure $ [1,2,3]

{-
readBax :: Foreign -> F Lines2
readBax value = 
  value ! "lines" >>= readArray >>= traverse readIntArray >>= \s ->
  pure $ Lines2 

-}

type ListItem = 
  {
    x :: Int
  , y :: Int
  }

readIntArray :: Foreign -> F (Array Int)
readIntArray value = 
  readArray value >>= traverse readInt >>= pure

readListItem :: Foreign -> F ListItem
readListItem value = do
  x <- value ! "x" >>= readInt
  y <- value ! "y" >>= readInt
  pure { x, y }

listItems :: Foreign -> F (Array ListItem)
listItems value = do
  items <- value ! "lx" >>= readArray >>= traverse readListItem
  pure items

arrayItems :: Foreign -> F Lines2 --(Array (Array Int))
arrayItems value = do
  items <- value ! "lx" >>= readArray >>= traverse readIntArray
  pure $ Lines2 items

main :: Effect Unit
main = do
  logShow $ runExcept $
    readString =<< foreignValue "\"a JSON string\""
  logShow $ runExcept $
    traverse readNumber =<< readArray =<< foreignValue """[1, 2, 3, 4]"""
  logShow $ runExcept $
    readFoo =<< foreignValue """{ "foo": { "bar": "bar", "baz": 1 } }"""
  logShow $ runExcept $
    listItems =<< foreignValue """{ "lx": [ {"x":2,"y":3} ] }"""
  logShow $ runExcept $
    arrayItems =<< foreignValue """{ "lx": [ [1,2,3],[4,5] ] }"""