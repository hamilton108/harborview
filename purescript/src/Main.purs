module Main where

import Prelude
import Effect (Effect)

import Control.Monad.Except (runExcept)
import Foreign (Foreign)

import Data.Either (Either(..))

import Maunaloa.ChartCollection as Collection

import Util.Foreign as UF

import Maunaloa.Elm (ChartInfoWindow)
import Effect.Console (logShow)

{-
newtype Ax = Ax
  { a :: ChartHeight}

instance showAx :: Show Ax where
  show (Ax x) = "(Ax " <> show x <> ")"

tryMe :: Number -> Ax -> Maybe Ax
tryMe v (Ax {a: (ChartHeight h)}) = 
  let 
    axx = Ax { a: ChartHeight (v * h) }
  in
  Just axx

tryMes :: Number -> Array Ax -> Effect Unit
tryMes v axs = 
  let 
    tt = map (tryMe v) axs
  in
  logShow tt
 -}


paint :: Collection.ChartMappings -> ChartInfoWindow -> Effect (Int -> Effect Unit)
paint mappings ciWin = 
    logShow ciWin *> 
    pure (\t -> pure unit)


xpaint :: Collection.ChartMappings -> Foreign -> Effect (Int -> Effect Unit)
xpaint mappings value =
    let 
        coll = runExcept $ Collection.readChartCollection mappings value 
    in
    case coll of 
        Right coll1 -> 
            Collection.paint coll1
        Left e -> 
            UF.logErrors e *>
                pure (\t -> pure unit)

--paintx :: Collection.ChartMappings -> Effect Unit
--paintx mappings = 
--  paint mappings demox

--main :: Effect Unit
--main = 
--  pure unit
--  logShow "main"

{-
  let 
    mappings = 
      [ Collection.ChartMapping {chartId: ChartId "chart", canvasId: CanvasId "chart-1", chartHeight: ChartHeight 600.0}
      ]
  in
  paint mappings demox
-}

{-
demo :: F Foreign
demo = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[90,9,8,5,4], 
  "chart2": { "candlesticks": [
      {"o":2.5,"h":3.1,"l":2.1,"c":2.1},
      {"o":2.5,"h":3.1,"l":2.1,"c":2.1},
      {"o":2.5,"h":3.1,"l":2.1,"c":2.1},
      {"o":2.5,"h":3.1,"l":2.1,"c":2.1},
      {"o":2.5,"h":3.1,"l":2.1,"c":2.1}
      ], "lines":[[3.0,2.2,3.1,4.2,3.5]], "valueRange":[2.0,5.0] },
  "chart": { "candlesticks": null, "lines":[[3.0,2.2,3.1,4.2,3.5],[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] }}"""

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

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

--foreign import fi_demo :: Collection.ChartCollection -> Unit 

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
