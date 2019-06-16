module Maunaloa.Chart where
  
import Prelude

import Partial.Unsafe (unsafePartial)
-- import Data.Maybe (Maybe(..)) 
import Data.Maybe as M
import Data.Array as A

import Foreign (F, Foreign, readNull, readNumber)
import Foreign.Index ((!))
import Data.Maybe (Maybe(..))

import Maunaloa.Common (UnixTime(..),ValueRange(..),Padding(..),ChartDim(..))
import Maunaloa.HRuler as H
import Maunaloa.VRuler as V
import Maunaloa.Lines as L
import Util.Foreign as FU
import Data.List (List(..))


newtype ChartId = ChartId String

newtype FragmentId = FragmentId String

newtype Chart = Chart {
    lines :: L.Lines2
}

derive instance eqChart :: Eq Chart

instance showChart :: Show Chart where
  show (Chart cx) = "(Chart " <> show cx.lines <> ")"

chartDim :: ChartDim 
chartDim = ChartDim { w: 1200.0, h: 600.0 }

padding :: Padding 
padding = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

vruler :: ValueRange -> V.VRuler
vruler vr = V.create vr chartDim padding

valueRangeFor :: Array Number -> ValueRange
valueRangeFor [mi,ma] = ValueRange { minVal: mi, maxVal: ma }
valueRangeFor _ = ValueRange { minVal: 0.0, maxVal: 0.0 }

readChart :: ChartId -> Foreign -> F Chart
readChart (ChartId cid) value = 
  let 
    cidValue = value ! cid
  in
  cidValue ! "lines" >>= readNull >>= L.lines >>= \l1 ->
  cidValue ! "valueRange" >>= FU.readNumArray >>= \v1 ->
  let 
    valueRange = valueRangeFor v1 
    curVruler = vruler valueRange
    linesToPix = map (L.lineToPix curVruler) l1 
  in
  pure $ Chart { lines: linesToPix }

readHRuler :: Foreign -> F (Maybe H.HRuler)
readHRuler value = 
  value ! "startDate" >>= readNumber >>= \sd ->
  value ! "xaxis" >>= FU.readIntArray >>= \x ->  
  let 
    tm = UnixTime sd
  in
  pure $ H.create chartDim tm x padding

newtype ChartCollection = ChartCollection {
    charts :: List Chart
}




