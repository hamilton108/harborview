module Maunaloa.Chart where
  
import Prelude

import Partial.Unsafe (unsafePartial)
import Control.Monad.Except (runExcept)
import Data.Maybe (Maybe(..)) 
import Data.Maybe as M
import Data.Array as A
import Data.Either (Either(..))

import Foreign (F, Foreign, readNull, unsafeToForeign)
import Foreign.Index ((!))

import Maunaloa.Common (ValueRange(..),Padding(..),ChartDim(..))
import Maunaloa.VRuler as V
import Maunaloa.Lines as L
import Maunaloa.Util.Foreign as FU

import Util.Value (foreignValue)

demo :: F Foreign
demo = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[10,9,8,5,4], 
  "chart2": null,
  "chart": { "lines2": null, "lines":[[3.0,2.2,3.1,4.2,3.5],[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] }}"""

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

newtype ChartId = ChartId String

newtype FragmentId = FragmentId String

newtype Chart = Chart {
    lines :: L.Lines2
}

instance showChart :: Show Chart where
  show (Chart cx) = "(Chart " <> show cx.lines <> ")"

chartDim :: ChartDim 
chartDim = ChartDim { w: 1200.0, h: 600.0 }

padding :: Padding 
padding = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

vruler :: ValueRange -> V.VRuler
vruler vr = V.create vr chartDim padding

readChart :: ChartId -> Foreign -> F Chart
readChart (ChartId cid) value = 
  let 
    cidValue = value ! cid
  in
  cidValue ! "lines" >>= readNull >>= L.lines >>= \l1 ->
  cidValue ! "valueRange" >>= FU.readNumArray >>= \v1 ->
  let 
    minVal = unsafePartial $ M.fromJust $ A.head v1 
    maxVal = unsafePartial $ M.fromJust $ A.last v1 
    valueRange = ValueRange { minVal: minVal, maxVal: maxVal }
    curVruler = vruler valueRange
    -- linesToPix = map (lineToPix curVruler) l1 
  in
  pure $ Chart { lines: l1 }

cix = ChartId "chart"

frx = FragmentId "lines"

rundemox :: Maybe Chart
rundemox = 
  let 
    cid = ChartId "chart"
    rc = runExcept $ readChart cid demox
    cx = case rc of 
              Right rcx -> Just rcx
              Left _ -> Nothing 
  in
  cx





