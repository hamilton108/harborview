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
                        , padding :: Padding }

instance showHRuler :: Show HRuler where
  show (HRuler v) = "(HRuler " <> show v <> ")"
      
derive instance eqHRuler :: Eq HRuler

dayInMillis :: Number
dayInMillis = 86400000.0

create :: ChartDim -> UnixTime -> Array Int -> Padding -> Maybe HRuler 
create dim startTime offsets p@(Padding pad) = 
    calcPpx dim offsets p >>= \pix ->
    let 
      curPix = Pix pix
    in
    Just $ HRuler { 
              dim: dim
            , startTime: startTime
            , xaxis: offsetsToPix offsets curPix pad.left
            , ppx: curPix 
            , padding: p}

timeStampToPix :: HRuler -> UnixTime -> Number
timeStampToPix (HRuler {startTime,ppx,padding: (Padding p)}) (UnixTime tm) = 
  let 
    (UnixTime stm) = startTime
    (Pix pix) = ppx 
    days = (tm - stm) / dayInMillis
  in 
    p.left + (days * pix)
    

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