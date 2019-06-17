module Maunaloa.VRuler where

import Prelude 

import Data.Array (range)
import Data.Int (toNumber)
import Data.Number.Format (toStringWith,fixed)
import Graphics.Canvas (Context2D)
import Effect (Effect)
import Effect.Console (logShow)

import Maunaloa.Common (
      ValueRange(..)
    , Pix(..)
    , ChartDim(..)
    , Padding(..)
    , calcPpy
    , RulerLineBoundary
    , RulerLineInfo(..) 
    )

  
newtype VRuler = VRuler {
      ppy :: Pix
    , maxVal :: Number
    , dim :: ChartDim
    , padding :: Padding
}

{-
newtype VRulerLine = VRulerLine {
      p0 :: Number
    , tx :: String
}
-}

-- type LinesX = { x1:: Number, x2 :: Number }

foreign import js_lines :: Context2D -> RulerLineBoundary -> Array RulerLineInfo -> Unit 

draw_ :: VRuler -> Context2D -> Effect Unit
draw_ vruler@(VRuler {padding: (Padding pad), dim: (ChartDim cd)}) ctx = do
  let curLines = lines vruler 4 
  let linesX = { p1: pad.left, p2: cd.w - pad.right }
  let _ = js_lines ctx linesX curLines 
  logShow "vruler"

-- instance graphLine :: Graph VRuler where
--  draw = draw_

createLine :: VRuler -> Number -> Number -> Int -> RulerLineInfo 
createLine vruler vpix padTop n = 
  let
    curPix = padTop + (vpix * (toNumber n))
    val = pixToValue vruler (Pix curPix) 
    tx = toStringWith (fixed 1) val
  in
  RulerLineInfo { p0: curPix, tx: tx }

lines :: VRuler -> Int -> Array RulerLineInfo 
lines vr@(VRuler {dim: (ChartDim dimx),padding: (Padding p)}) num = 
  let
    vpix = (dimx.h - p.top - p.bottom) / (toNumber num)
    -- sections = map (\z -> Pix (toNumber z)) $ range 0 num
    sections = range 0 num
  in 
  map (createLine vr vpix p.top) sections


create :: ValueRange -> ChartDim -> Padding -> VRuler 
create vr@(ValueRange {maxVal}) dim pad = VRuler { 
      ppy: Pix $ calcPpy dim vr pad 
    , maxVal: maxVal 
    , dim: dim
    , padding: pad 
 }
  
yaxis :: VRuler -> Array Number -> Array Number
yaxis vr values = 
  let 
    fn = valueToPix vr
  in
  map fn values

valueToPix :: VRuler -> Number -> Number
valueToPix (VRuler {ppy:(Pix ppyVal), maxVal, padding: (Padding curPad)}) value = 
  -- Pix $ (maxVal - value) * ppyVal
  ((maxVal - value) * ppyVal) + curPad.top 

pixToValue :: VRuler -> Pix -> Number
pixToValue (VRuler {maxVal,ppy:(Pix ppyVal),padding: (Padding curPad)}) (Pix p) = 
  maxVal - ((p - curPad.top) / ppyVal)