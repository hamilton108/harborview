module Main where

import Prelude
import Effect (Effect)
import Effect.Console (logShow)
import Partial.Unsafe (unsafePartial)

import Control.Monad.Except (runExcept)
import Foreign (F, Foreign, unsafeToForeign)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..)) 

import Util.Value (foreignValue)
import Maunaloa.ChartCollection as Collection
import Maunaloa.Chart as C
import Maunaloa.HRuler as H
import Maunaloa.Common (ChartDim(..))

demo :: F Foreign
demo = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[90,9,8,5,4], 
  "chart2": { "lines2": null, "lines":[[3.0,2.2,3.1,4.2,3.5],[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] },
  "chart": { "lines2": null, "lines":[[3.0,2.2,3.1,4.2,3.5],[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] }}"""

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

{-
rundemox :: Maybe C.Chart
rundemox = 
  let 
    cid = C.ChartId "chart"
    rc = runExcept $ C.readChart cid demox
    cx = case rc of 
              Right rcx -> Just rcx
              Left _ -> Nothing 
  in
  cx
-}

foreign import fi_demo :: Collection.ChartCollection -> Unit 

{-
drawCollection :: Collection.ChartCollection -> Effect Unit
drawCollection coll = 
  Canvas.getCanvasElementById "canvas" >>= \canvas ->
  case canvas of
        Nothing -> 
          pure unit
        Just canvax ->
          Canvas.getContext2D canvax >>= \ctx ->
            Collection.draw coll ctx
-}

main :: Effect Unit
main = 
  let 
    coll = runExcept $ Collection.readChartCollection demox
  in
  case coll of 
    Right collx -> 
      -- pure (fi_demo collx) *> Collection.draw collx
      Collection.draw collx
    Left _ -> pure unit
{-
main :: Effect Unit
main = void $ unsafePartial do
  logShow "main"

import Data.Maybe (Maybe(..),fromJust)

import Effect.Console (logShow)
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas as C 

import Maunaloa.Common as CO
import Maunaloa.Lines as L
import Maunaloa.HRuler as H
import Maunaloa.VRuler as V


foreign import fx :: C.Context2D -> Unit 

offsets :: Array Int
offsets = [190,17,16,15,14,11,10,9,8,7,4,3,0]

chartDim :: CO.ChartDim 
chartDim = CO.ChartDim { w: 1200.0, h: 600.0 }

valueRange :: CO.ValueRange
valueRange = CO.ValueRange { minVal: 5.0, maxVal: 65.0 }

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
prices = [60.0,48.0,50.0,38.0,30.6,17.0,10.0,30.4,42.0,44.1,46.0,45.6,45.0]

main :: Effect Unit
main = void $ unsafePartial do
  logShow "main"

xmain :: Effect Unit
xmain = void $ unsafePartial do
  Just canvas <- C.getCanvasElementById "canvas"
  ctx <- C.getContext2D canvas
  let vr = vruler
  let yaxis = V.yaxis vr prices
  let (H.HRuler {xaxis}) = hruler 
  let l = L.Line { yaxis: yaxis, xaxis: xaxis, strokeStyle: "#f00" }
  CO.draw l ctx
  CO.draw vr ctx
  CO.draw hruler ctx

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

-}
