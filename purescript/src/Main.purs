module Main where

import Prelude
import Data.Maybe (Maybe(..),fromJust)

import Effect (Effect)

import Effect.Console (logShow)
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas as C 

import Maunaloa.Common as CO
import Maunaloa.Lines as L
import Maunaloa.HRuler as H
import Maunaloa.VRuler as V


foreign import fx :: C.Context2D -> Unit 

offsets :: Array Int
offsets = [17,16,15,14,11,10,9,8,7,4,3,0]

chartDim :: CO.ChartDim 
chartDim = CO.ChartDim { w: 1200.0, h: 600.0 }

valueRange :: CO.ValueRange
valueRange = CO.ValueRange { minVal: 10.0, maxVal: 50.0 }

padding :: CO.Padding
padding = CO.Padding { left: 20.0, top: 20.0, right: 20.0, bottom: 20.0 }

padding0 :: CO.Padding 
padding0 = CO.Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

curPadding :: CO.Padding 
curPadding = padding

hruler :: H.HRuler 
hruler =
  let 
    april_1_19 :: CO.UnixTime 
    april_1_19 = CO.UnixTime 1554076800000.0
    hr = H.create chartDim april_1_19 offsets curPadding
    hrx = unsafePartial $ fromJust hr
  in 
  hrx


vruler :: V.VRuler
vruler = V.create valueRange chartDim curPadding

prices :: Array Number
prices = [48.0,50.0,38.0,30.6,17.0,10.0,30.4,42.0,44.1,46.0,45.6,45.0]

main :: Effect Unit
main = void $ unsafePartial do
  Just canvas <- C.getCanvasElementById "canvas"
  ctx <- C.getContext2D canvas
  let vr = vruler
  let yaxis = V.yaxis vr prices
  let (H.HRuler {xaxis}) = hruler 
  let l = L.Line { yaxis: yaxis, xaxis: xaxis, strokeStyle: "#f00" }
  CO.draw l ctx
  CO.draw vr ctx

jan2_19 :: CO.UnixTime 
jan2_19 = CO.UnixTime 1546387200000.0

feb2_19 :: CO.UnixTime 
feb2_19 = CO.UnixTime 1549065600000.0

feb1_19 :: CO.UnixTime 
feb1_19 = CO.UnixTime 1548979200000.0

hr :: H.HRuler
hr = unsafePartial $ fromJust $ H.create (CO.ChartDim {w: 600.0, h: 200.0}) jan2_19 [10,9,8,6] padding0


demo :: Effect Unit
demo = do 
  let hrx = H.create (CO.ChartDim {w: 600.0, h: 200.0}) jan2_19 [30,10,8,3] padding0
  -- let p = H.calcPix hr feb1_19
  -- logShow p
  case hrx of 
    Nothing -> 
      logShow "Nothing"
    Just hrxj -> 
      let 
        p = 23.2345 -- H.calcPix hr feb1_19
      in
      logShow p

