module Maunaloa.Candlesticks where

import Prelude

import Maunaloa.VRuler as V

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