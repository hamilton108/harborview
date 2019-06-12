module Maunaloa.Chart where
  
import Prelude

import Partial.Unsafe (unsafePartial)
import Effect (Effect)
import Effect.Console (logShow)
import Data.Traversable (traverse)
import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))

import Foreign (F, Foreign, readNull, readArray, readInt, readString, readNumber, unsafeToForeign)
import Foreign.NullOrUndefined (readNullOrUndefined)
import Foreign.Index ((!))
import Foreign.JSON (parseJSON)
import Data.Array as A
import Data.Maybe as M

import Maunaloa.Common (ValueRange(..),Padding(..),ChartDim(..))
import Maunaloa.VRuler as V

import Util.Value (foreignValue)

demo :: F Foreign
demo = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[10,9,8,5,4], 
  "chart2": null,
  "chart": { "lines2": null, "lines":[[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] }}"""

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

newtype ChartId = ChartId String

cix = ChartId "chart"

newtype FragmentId = FragmentId String

frx = FragmentId "lines"

readNumArray :: Foreign -> F (Array Number)
readNumArray value = 
  readArray value >>= traverse readNumber >>= pure

type Line = Array Number

type Lines2 = Array Line

newtype Chart = Chart {
    lines :: Lines2
}

instance showChart :: Show Chart where
  show (Chart cx) = "(Chart " <> show cx.lines <> ")"

--instance showLines2 :: Show Lines2 where
--  show (Lines2 lx) = "(Lines2 " <> show lx <> ")"

{-
readChartLines :: ChartId -> Foreign -> F Lines2 
readChartLines (ChartId cid) value = do
  items <- value ! cid ! "lines" >>= readArray >>= traverse readNumArray
  pure $ Lines2 items
-}

chartDim :: ChartDim 
chartDim = ChartDim { w: 1200.0, h: 600.0 }

padding :: Padding 
padding = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

vruler :: ValueRange -> V.VRuler
vruler vr = V.create vr chartDim padding

lineToPix :: V.VRuler -> Line -> Line 
lineToPix vr line = 
  let
    vfun = V.valueToPix vr
  in
  map vfun line

fragment :: ChartId -> FragmentId -> Foreign -> Maybe Foreign
fragment (ChartId cid) (FragmentId fid) value = 
  let 
    fr = runExcept $ value ! cid ! fid >>= readNull 
  in case fr of
                Right frx -> frx
                Left _ -> Nothing

-- lines :: ChartId -> 

fragment2 = 
    demox ! "chart" ! "lines" >>= readNull 

rx2 :: F Chart
rx2 =
  fragment2 >>= \f2 ->
    case f2 of 
      Nothing -> 
        pure $ Chart { lines: [] }
      Just f2x ->
        readArray f2x >>= traverse readNumArray >>= \items ->
        pure $ Chart { lines: items }



{-
lines = 
  let 
    mfr = fragment cix frx demox
    res = case mfr of 
            Nothing -> []
            Just resx -> 
              readArray resx >>= traverse readNumArray 

  in
-}


readChart :: ChartId -> Foreign -> F Chart
readChart (ChartId cid) value = 
  -- value ! cid ! "lines" >>= readNullOrUndefined >>= readArray >>= traverse readNumArray >>= \items ->
  value ! cid ! "lines" >>= readArray >>= traverse readNumArray >>= \items ->
  value ! cid ! "valueRange" >>= readNumArray >>= \valueRangex ->
  let 
    minVal = unsafePartial $ M.fromJust $ A.head valueRangex
    maxVal = unsafePartial $ M.fromJust $ A.last valueRangex
    valueRange = ValueRange { minVal: minVal, maxVal: maxVal }
    curVruler = vruler valueRange
    linesToPix = [] -- map (lineToPix curVruler) items
  in
  pure $ Chart { lines: linesToPix }

rundemox = 
  let bx = runExcept $
             demox ! "chart" ! "lines" >>= readNull -- >>= readArray >>= traverse readNumArray 
      result = case bx of 
                Right bx2 -> 
                  case bx2 of 
                    Just bx3 -> 1
                    Nothing -> 2
                Left _ -> 3

  in
  result

ax value cid = 
  runExcept $ value ! cid ! "lines" >>= readNull

ax2 value cid = 
  value ! cid ! "lines" >>= readNull
{-
  let 
    lines = demox ! "chart" ! "lines" >>= readNull -- >>= readArray >>= traverse readNumArray >>= \items ->
    bx = case lines of 
          Nothing -> Lines2 []
          Just lx -> readArray lx >>= traverse readNumArray >>= \items -> 
            pure $ Lines2 items
  in
  "sdfsd"
  --pure items
  -}



runDemox2 :: Chart
runDemox2 = 
  let 
    cid = ChartId "chart"
    rc = runExcept $ readChart cid demox
    cx = case rc of 
              Right rcx -> rcx
              Left _ -> Chart {lines: [[1.1]] }
  in
  cx

{-
readChartLines :: ChartId -> Foreign -> F Lines2 
readChartLines (ChartId cid) value = 
  value ! cid ! "lines" >>= readArray >>= traverse readNumArray >>= \items ->
  value ! cid ! "valueRange" >>= readNumArray >>= \valueRangex ->
  let 
    minVal = unsafePartial $ M.fromJust $ A.head valueRangex
    maxVal = unsafePartial $ M.fromJust $ A.last valueRangex
    valueRange = ValueRange { minVal: minVal, maxVal: maxVal }
    curVruler = vruler valueRange
    linesToPix = map (lineToPix curVruler) items
  in
  pure $ Lines2 linesToPix 

createChart :: ChartId -> Foreign -> Chart 
createChart cid value = do
  let ax = readChartLines cid value
  let bx = runExcept  ax
  let cx = case bx of 
              Right bxr -> bxr
              Left bxl -> Lines2 [] 
  Chart { lines: cx }  

createChart2 :: ChartId -> Foreign -> Chart 
createChart2 cid value = 
  let 
    bx = runExcept $ readChartLines cid value 
    cx = case bx of 
              Right bxr -> bxr
              Left bxl -> Lines2 [] 
  in
  Chart { lines: cx }  

see :: ChartId -> Foreign -> String
see cid value = 
  let 
    bux = readChartLines cid value 
    bx = runExcept bux
    cx = case bx of 
              Right bxr -> "Found it"
              Left bxl -> "What?"
  in
  cx

seex = see $ ChartId "chart"

crx :: Foreign -> F Chart
crx value = do
  items <- value ! "lines" >>= readArray >>= traverse readNumArray
  pure $ Chart { lines: Lines2 items }

cr2 :: Foreign -> F Foreign
cr2 value = do
  value ! "chart" 

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

valueRangeDemo cid value = 
  let 
    bx = runExcept $
      value ! cid ! "valueRange" >>= readNumArray 
    bux = case bx of
            Right result -> result
            Left _ -> [0.0,0.0]
  in 
  bux

runDemox = 
  let 
    cid = ChartId "chart"
  in
  createChart cid demox 
-}





