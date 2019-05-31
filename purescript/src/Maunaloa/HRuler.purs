module Maunaloa.HRuler where

import Prelude 

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array (head,(:))
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
foreign import incDays_ :: Number -> Int -> Number
foreign import dateToString_ :: Number -> String 
foreign import js_lines :: Context2D -> RulerLineLevel -> Array RulerLineInfo -> Unit 
foreign import js_startOfNextMonth :: Number -> Number


newtype HRulerLine = HRulerLine {}

newtype HRuler = HRuler { dim :: ChartDim
                        , startTime :: UnixTime
                        , endTime :: UnixTime
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

lines_ :: (UnixTime -> Number) -> UnixTime -> Array RulerLineInfo -> UnixTime -> Array RulerLineInfo
lines_ timestampFn endTime curLines curTime 
  | curTime >= endTime = curLines
  | otherwise = 
      let 
        nextTime = incMonths curTime 1
        newCurLines = RulerLineInfo { p0: timestampFn curTime, tx: dateToString curTime } : curLines
      in 
        lines_ timestampFn endTime newCurLines nextTime

lines :: HRuler -> Int -> Array RulerLineInfo 
lines hr@(HRuler {startTime, endTime, dim: (ChartDim dimx),padding: (Padding p)}) num = 
  let 
    snm = startOfNextMonth startTime
    timestampFn = timeStampToPix hr
  in
  lines_ timestampFn endTime [] snm

instance graphLine :: Graph HRuler where
  draw = draw_

dayInMillis :: Number
dayInMillis = 86400000.0

create :: ChartDim -> UnixTime -> Array Int -> Padding -> Maybe HRuler 
create dim startTime offsets p@(Padding pad) = 
    calcPpx dim offsets p >>= \pix ->
    head offsets >>= \offset0 ->
    let 
      curPix = Pix pix
      endTime = incDays startTime offset0
    in
    Just $ HRuler { 
              dim: dim
            , startTime: startTime
            , endTime: endTime
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
pixToTimeStamp ruler@(HRuler {startTime: (UnixTime stm)}) pix = 
  let
    days = pixToDays ruler pix
    tm = stm + (dayInMillis * days)
  in
  UnixTime tm

offsetsToPix :: Array Int -> Pix -> Number -> Array Number
offsetsToPix offsets (Pix pix) padLeft =
  map (\x -> padLeft + ((toNumber x) * pix)) offsets

incMonths :: UnixTime -> Int -> UnixTime
incMonths (UnixTime tm) numMonths = UnixTime $ incMonths_ tm numMonths

incDays :: UnixTime -> Int -> UnixTime
incDays (UnixTime tm) offset = UnixTime $ incDays_ tm offset

pixToDays :: HRuler -> Pix -> Number
pixToDays (HRuler {ppx: (Pix ppxVal), padding: (Padding p)}) (Pix pix) = (pix - p.left) / ppxVal


startOfNextMonth :: UnixTime -> UnixTime
startOfNextMonth (UnixTime tm) = 
  UnixTime $ js_startOfNextMonth tm

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