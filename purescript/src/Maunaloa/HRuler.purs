module Maunaloa.HRuler where

import Prelude 

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))

import Maunaloa.Common (
      Pix(..)
    , UnixTime(..)
    , ChartDim
    , Padding(..)
    , calcPpx)

foreign import incMonths_ :: Number -> Int -> Number
foreign import dateToString_ :: Number -> String 

newtype HRulerLine = HRulerLine {}

newtype HRuler = HRuler { dim :: ChartDim
                        , startTime :: UnixTime
                        , xaxis :: Array Number
                        , ppx :: Pix 
                        , padding :: Maybe Padding }

instance showHRuler :: Show HRuler where
  show (HRuler v) = "(HRuler " <> show v <> ")"
      
derive instance eqHRuler :: Eq HRuler

dayInMillis :: Number
dayInMillis = 86400000.0

create :: ChartDim -> UnixTime -> Array Int -> Maybe Padding -> Maybe HRuler 
create dim startTime offsets pad = 
    calcPpx dim offsets pad >>= \pix ->
    let 
      curPix = Pix pix
      padLeft = case pad of
                  Nothing -> 0.0
                  Just (Padding p) -> p.left
    in
    Just $ HRuler { 
              dim: dim
            , startTime: startTime
            , xaxis: offsetsToPix offsets curPix padLeft
            , ppx: curPix 
            , padding: pad}

timeStampToPix :: HRuler -> UnixTime -> Number
timeStampToPix (HRuler {startTime,ppx,padding}) (UnixTime tm) = 
  let 
    offset = case padding of
                Nothing -> 0.0
                Just (Padding p) -> p.left
    (UnixTime stm) = startTime
    (Pix pix) = ppx 
    days = (tm - stm) / dayInMillis
  in 
    offset + (days * pix)
    

offsetsToPix :: Array Int -> Pix -> Number -> Array Number
offsetsToPix offsets (Pix pix) padLeft =
  map (\x -> padLeft + ((toNumber x) * pix)) offsets

incMonths :: UnixTime -> Int -> UnixTime
incMonths (UnixTime tm) numMonths = UnixTime $ incMonths_ tm numMonths


dateToString :: UnixTime -> String
dateToString (UnixTime tm) = dateToString_ tm
{-
defcr :: Maybe HRuler
defcr =
    Just $ HRuler {
          dim: ChartDim { w: 600.0, h: 200.0 }
        , startTime: UnixTime 1.0 
        , xaxis: [1.0] 
    }
    -}