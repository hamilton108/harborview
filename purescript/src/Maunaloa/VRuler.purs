module Maunaloa.VRuler where

import Prelude 

import Data.Maybe (Maybe(..))
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
    , class Graph
    , calcPpy
    )

  
newtype VRuler = VRuler {
      ppy :: Pix
    , maxVal :: Number
    , dim :: ChartDim
    , padding :: Maybe Padding
}

newtype VRulerLine = VRulerLine {
      y :: Number
    , tx :: String
}

foreign import js_lines :: Array VRulerLine -> Context2D -> Unit 

draw_ :: VRuler -> Context2D -> Effect Unit
draw_ vruler ctx = do
  let curLines = lines vruler 4 
  let _ = js_lines curLines ctx 
  logShow "id"

instance graphLine :: Graph VRuler where
  draw = draw_

createLine :: VRuler -> Number -> Int -> VRulerLine
createLine vruler vpix n = 
  let
    curPix = vpix * (toNumber n)
    val = pixToValue vruler (Pix curPix) 
    tx = toStringWith (fixed 1) val
  in
  VRulerLine {y: curPix, tx: tx }

lines :: VRuler -> Int -> Array VRulerLine
lines vr@(VRuler {dim: (ChartDim dimx)}) num = 
  let
    vpix = dimx.h / (toNumber num)
    -- sections = map (\z -> Pix (toNumber z)) $ range 0 num
    sections = range 0 num
  in 
  map (createLine vr vpix) sections


create :: ValueRange -> ChartDim -> Maybe Padding -> VRuler 
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
valueToPix (VRuler {ppy:(Pix ppyVal), maxVal, padding}) value = 
  -- Pix $ (maxVal - value) * ppyVal
  let 
    paddingTop = case padding of 
      Nothing -> 0.0
      Just (Padding p) -> p.top
  in
  ((maxVal - value) * ppyVal) + paddingTop

pixToValue :: VRuler -> Pix -> Number
pixToValue (VRuler {maxVal,ppy:(Pix ppyVal)}) (Pix p) = maxVal - (p / ppyVal)