module Maunaloa.Candlestick where

import Prelude

import Effect (Effect)
import Graphics.Canvas (Context2D)

import Data.Traversable (traverse)
import Foreign (F,Foreign,readArray,readNumber)
import Foreign.Index ((!))

import Data.Maybe (Maybe(..))

import Maunaloa.Common (Xaxis)

import Maunaloa.VRuler as V
import Maunaloa.HRuler as H

foreign import fi_paint :: Xaxis -> Candlesticks -> Context2D -> Effect Unit 

newtype Candlestick = Candlestick {
      o :: Number
    , h :: Number
    , l :: Number
    , c :: Number
}

instance showCandlestick :: Show Candlestick where
  show (Candlestick v) = "(Candlestick " <> show v <> ")"

derive instance eqCandlestick :: Eq Candlestick 

type Candlesticks = Array Candlestick

candleToPix :: V.VRuler -> Candlestick -> Candlestick 
candleToPix vr (Candlestick {o,h,l,c}) =  
    let 
        po = V.valueToPix vr o
        ph = V.valueToPix vr h
        pl = V.valueToPix vr l
        pc = V.valueToPix vr c
    in
    Candlestick { o: po, h: ph, l: pl, c: pc }

readCandlestick :: Foreign -> F Candlestick
readCandlestick value = 
  value ! "o" >>= readNumber >>= \opn ->
  value ! "h" >>= readNumber >>= \hi ->
  value ! "l" >>= readNumber >>= \lo ->
  value ! "c" >>= readNumber >>= \cls ->
  pure $ Candlestick {o:opn,h:hi,l:lo,c:cls}

readCandlesticks :: Maybe Foreign -> F Candlesticks
readCandlesticks Nothing = pure []
readCandlesticks (Just cndls) = readArray cndls >>= traverse readCandlestick 

paint :: H.HRuler -> Candlesticks -> Context2D -> Effect Unit
paint (H.HRuler {xaxis: xaxis}) cndls ctx = 
  fi_paint xaxis cndls ctx