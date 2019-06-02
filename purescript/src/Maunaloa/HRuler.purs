module Maunaloa.HRuler where

import Prelude 

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array (head,last,(:))
import Effect (Effect)
import Effect.Console (logShow)
import Graphics.Canvas (Context2D)

import Maunaloa.Common (
      Pix(..)
    , UnixTime(..)
    , Padding(..)
    , ChartDim(..)
    , class Graph
    , RulerLineBoundary
    , RulerLineInfo(..) 
    , OffsetBoundary(..)
    , calcPpx)

foreign import incMonths_ :: Number -> Int -> Number
foreign import incDays_ :: Number -> Int -> Number
foreign import dateToString_ :: Number -> String 
foreign import js_lines :: Context2D -> RulerLineBoundary -> Array RulerLineInfo -> Unit 
foreign import js_startOfNextMonth :: Number -> Number


newtype HRulerLine = HRulerLine {}

newtype HRuler = HRuler { dim :: ChartDim
                        , startTime :: UnixTime
                        , endTime :: UnixTime
                        , xaxis :: Array Number
                        , ppx :: Pix 
                        , padding :: Padding 
                        , myIncMonths :: Int }

instance showHRuler :: Show HRuler where
  show (HRuler v) = "(HRuler " <> show v <> ")"
      
derive instance eqHRuler :: Eq HRuler


draw_ :: HRuler -> Context2D -> Effect Unit
draw_ hruler@(HRuler {padding: (Padding pad), dim: (ChartDim cd)}) ctx = do
  let curLines = lines hruler 4 
  let linesX = { p1: pad.top, p2: cd.h - pad.bottom }
  let _ = js_lines ctx linesX curLines 
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

lines_ :: (UnixTime -> Number) -> UnixTime -> Int -> Array RulerLineInfo -> UnixTime -> Array RulerLineInfo
lines_ timestampFn endTime numMonths curLines curTime 
  | curTime >= endTime = curLines
  | otherwise = 
      let 
        nextTime = incMonths curTime numMonths 
        newCurLines = RulerLineInfo { p0: timestampFn curTime, tx: dateToString curTime } : curLines
      in 
        lines_ timestampFn endTime numMonths newCurLines nextTime

lines :: HRuler -> Int -> Array RulerLineInfo 
lines hr@(HRuler {startTime, endTime, myIncMonths, dim: (ChartDim dimx), padding: (Padding p)}) num = 
  let 
    snm = startOfNextMonth startTime
    timestampFn = timeStampToPix hr
  in
  lines_ timestampFn endTime myIncMonths [] snm

instance graphLine :: Graph HRuler where
  draw = draw_

dayInMillis :: Number
dayInMillis = 86400000.0

create :: ChartDim -> UnixTime -> Array Int -> Padding -> Maybe HRuler 
create dim startTime offsets p@(Padding pad) = 
    head offsets >>= \offset0 ->
    last offsets >>= \offsetN ->
    let 
      offsetBoundary = OffsetBoundary { oHead: offset0, oLast: offsetN }
      pix = calcPpx dim offsetBoundary p 
      curPix = Pix pix
      endTime = incDays startTime offset0
    in
    Just $ HRuler { 
              dim: dim
            , startTime: startTime
            , endTime: endTime
            , xaxis: offsetsToPix offsets curPix pad.left
            , ppx: curPix 
            , padding: p
            , myIncMonths: 1 }

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