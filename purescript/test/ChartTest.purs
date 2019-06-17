module Test.ChartTest where

import Prelude

import Foreign (F, Foreign, unsafeToForeign)
import Control.Monad.Except (runExcept)
import Test.Unit.Assert as Assert
import Test.Unit (suite, test, TestSuite)
import Data.Maybe (fromJust,isJust)
import Data.Array as Array

import Partial.Unsafe (unsafePartial)
import Data.Either (Either(..),isRight,fromRight)

import Maunaloa.Common (ValueRange(..))
import Util.Value (foreignValue)
import Maunaloa.Chart as C

import Maunaloa.Lines as L
import Test.Common as TC -- (moreOrLessEq,chartDim,pad0,pad1)

demo :: F Foreign
demo = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[10,9,8,5,4], 
  "chart3": null,
  "chart2": null,
  "chart": { "lines":[[3.0,2.2,3.1,4.2,3.5]],"valueRange":[2.2,4.2] }}"""

demox :: Foreign
demox = 
  case runExcept demo of
    Right result -> result
    Left _ -> unsafeToForeign "what?"

cid :: C.ChartId
cid = C.ChartId "chart"

echart :: C.Chart
echart = C.Chart {
  lines: [[360.0,600.0,330.0,0.0,210.0]]
}

getLines :: C.Chart -> L.Lines2
getLines (C.Chart {lines}) = lines

getLine :: C.Chart -> L.Line
getLine c =  
  let
    lx = getLines c
  in
  unsafePartial $ fromJust $ Array.head lx

testChartSuite :: TestSuite
testChartSuite = 
  suite "TestChartSuite" do
    test "valueRangeFor" do
      let vr = C.valueRangeFor [10.0,35.0]
      let expVr = ValueRange { minVal: 10.0, maxVal: 35.0 }
      Assert.equal expVr vr
    test "readChart chart2 and chart3 are null" do
      let chart = runExcept $ C.readChart cid demox
      let rchart = unsafePartial $ fromRight chart
      Assert.equal true $ isRight chart
      let rline = getLine rchart
      let eline = getLine echart
      let result = Array.zipWith TC.moreOrLessEq rline eline
      Assert.equal [true,true,true,true,true] result
    test "Create HRuler" do
      let ruler = runExcept $ C.readHRuler demox
      Assert.equal true $ isRight ruler
      let mr = unsafePartial $ fromRight ruler
      Assert.equal true $ isJust mr
      -- let result = unsafePartial $ fromJust mr

