module Maunaloa.Chart where
  
import Prelude

import Foreign (F, Foreign, readNull, readNumber)
import Foreign.Index ((!))
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas as Canvas -- (Context2D,Canvas)
import Effect (Effect)
import Effect.Console (logShow)

import Maunaloa.Common 
  ( UnixTime(..)
  , ValueRange(..)
  , Padding(..)
  , ChartWidth
  , ChartHeight
  , CanvasId(..)
  , ChartDim(..)
  )
import Maunaloa.HRuler as H
import Maunaloa.VRuler as V
import Maunaloa.Lines as L
import Util.Foreign as FU



newtype ChartId = ChartId String

newtype FragmentId = FragmentId String

newtype Chart = Chart { 
  lines :: L.Lines2
, canvasId :: CanvasId 
, vruler :: V.VRuler
}

derive instance eqChart :: Eq Chart

instance showChart :: Show Chart where
  show (Chart cx) = "(Chart " <> show cx.lines <> ")"

chartDim :: ChartDim 
chartDim = ChartDim { w: 1200.0, h: 600.0 }

padding :: Padding 
padding = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

vruler :: ValueRange -> ChartWidth -> ChartHeight -> V.VRuler
vruler vr w h = V.create vr w h padding

valueRangeFor :: Array Number -> ValueRange
valueRangeFor [mi,ma] = ValueRange { minVal: mi, maxVal: ma }
valueRangeFor _ = ValueRange { minVal: 0.0, maxVal: 0.0 }

--readChart :: ChartId -> ChartDim -> Foreign -> F Chart
readChart :: ChartId -> CanvasId -> ChartWidth -> ChartHeight -> Foreign -> F Chart
readChart (ChartId cid) caId w h value = 
  let 
    cidValue = value ! cid
  in
  cidValue ! "lines" >>= readNull >>= L.lines >>= \l1 ->
  cidValue ! "valueRange" >>= FU.readNumArray >>= \v1 ->
  let 
    valueRange = valueRangeFor v1 
    curVruler = vruler valueRange w h
    linesToPix = map (L.lineToPix curVruler) l1 
  in
  pure $ Chart { lines: linesToPix, canvasId: caId, vruler: curVruler }

readHRuler :: Foreign -> F (Maybe H.HRuler)
readHRuler value = 
  value ! "startDate" >>= readNumber >>= \sd ->
  value ! "xaxis" >>= FU.readIntArray >>= \x ->  
  let 
    tm = UnixTime sd
  in
  pure $ H.create chartDim tm x padding

--draw hruler (Chart {canvasId: (CanvasId curId), chartH: (ChartHeight curH)}) =
paint :: H.HRuler -> Chart -> Effect Unit
paint hruler (Chart {vruler: vrobj@(V.VRuler vr), canvasId: (CanvasId curId)}) =
  Canvas.getCanvasElementById curId >>= \canvas ->
  case canvas of
    Nothing -> 
      logShow $ "CanvasId " <> curId <> " does not exist!"
    Just canvax ->
      logShow ("Drawing canvas: " <> curId) *>
      Canvas.getContext2D canvax >>= \ctx ->
        H.paint hruler vr.h ctx *>
        V.paint vrobj ctx


