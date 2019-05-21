module Maunaloa.HRuler where

import Prelude 

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (logShow)
import Graphics.Canvas (Context2D)

import Maunaloa.Common (
      Pix(..)
    , UnixTime(..)
    , Padding(..)
    , ChartDim(..)
    , class Graph
    , RulerLineLevel
    , RulerLineInfo(..) 
    , calcPpx)

foreign import incMonths_ :: Number -> Int -> Number
foreign import dateToString_ :: Number -> String 
foreign import js_lines :: Context2D -> RulerLineLevel -> Array RulerLineInfo -> Unit 


newtype HRulerLine = HRulerLine {}

newtype HRuler = HRuler { dim :: ChartDim
                        , startTime :: UnixTime
                        , xaxis :: Array Number
                        , ppx :: Pix 
                        , padding :: Padding }

instance showHRuler :: Show HRuler where
  show (HRuler v) = "(HRuler " <> show v <> ")"
      
derive instance eqHRuler :: Eq HRuler


draw_ :: HRuler -> Context2D -> Effect Unit
draw_ hruler@(HRuler {padding: (Padding pad), dim: (ChartDim cd)}) ctx = do
  logShow "hruler"
  
 
 {-
createLine :: HRuler -> Number -> Number -> Int -> RulerLineInfo 
createLine ruler hpix padLeft n = 
  let
    curPix = padLeft + (hpix * (toNumber n))
    val = pixToValue vruler (Pix curPix) 
    tx = toStringWith (fixed 1) val
  in
  RulerLineInfo { p0: curPix, tx: tx }
-}

lines :: HRuler -> Int -> Array RulerLineInfo 
lines hr@(HRuler {dim: (ChartDim dimx),padding: (Padding p)}) num = 
  let 
    hpix = (dimx.w - p.left - p.right) / (toNumber num)
  in
  []

instance graphLine :: Graph HRuler where
  draw = draw_

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
    
pixToTimeStamp :: HRuler -> Pix -> UnixTime
pixToTimeStamp ruler (Pix pix) = UnixTime 3434.9

offsetsToPix :: Array Int -> Pix -> Number -> Array Number
offsetsToPix offsets (Pix pix) padLeft =
  map (\x -> padLeft + ((toNumber x) * pix)) offsets

incMonths :: UnixTime -> Int -> UnixTime
incMonths (UnixTime tm) numMonths = UnixTime $ incMonths_ tm numMonths

pixToDays :: HRuler -> Pix -> Number
pixToDays (HRuler {ppx: (Pix ppxVal), padding: (Padding p)}) (Pix pix) = (pix - p.left) / ppxVal


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