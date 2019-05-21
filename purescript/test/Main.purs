module Test.Main where

import Prelude

import Data.Array as Array
import Data.Number.Approximate as Approximate
-- import Control.Monad.Aff.Console (logShow)
import Data.Maybe (Maybe(..),fromJust)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Maunaloa.HRuler as H
import Maunaloa.VRuler as V
import Maunaloa.Common (
    ValueRange(..)
    , Pix(..)
    , UnixTime(..)
    , ChartDim(..)
    , Padding(..)
    , RulerLineInfo(..) 
    , calcPpx
    , calcPpy)
import Effect (Effect)
import Partial.Unsafe (unsafePartial)

jan_2_19 :: UnixTime 
jan_2_19 = UnixTime 1546387200000.0

jan_11_19 :: UnixTime 
jan_11_19 = UnixTime 1547164800000.0

jan_20_19 :: UnixTime 
jan_20_19 = UnixTime 1547942400000.0  

jan_21_19 :: UnixTime 
jan_21_19 = UnixTime 1548028800000.0

april_1_19 :: UnixTime 
april_1_19 = UnixTime 1554076800000.0

pad0 :: Padding 
pad0 = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

pad1 :: Padding
pad1 = Padding { left: 10.0, top: 20.0, right: 50.0, bottom: 60.0 }

offsets :: Array Int
offsets = [17,16,15,14,11,10,9,8,7,4,3,2,0]
-- import Node.FS.Aff as FS

chartDim :: ChartDim 
chartDim = ChartDim { w: 600.0, h: 200.0 }

valueRange :: ValueRange
valueRange = ValueRange { minVal: 10.0, maxVal: 50.0 }

testHRuler :: UnixTime -> H.HRuler 
testHRuler tm =
  let 
    hr = H.create chartDim tm offsets pad0
    hrx = unsafePartial $ fromJust hr
  in 
  hrx

testHRulerPadding :: UnixTime -> H.HRuler 
testHRulerPadding tm =
  let 
    hr = H.create chartDim tm offsets pad1
    hrx = unsafePartial $ fromJust hr
  in 
  hrx

testVRuler :: V.VRuler
testVRuler = V.create valueRange chartDim pad0

testVRulerpadding :: V.VRuler
testVRulerpadding = V.create valueRange chartDim pad1

moreOrLessEq :: Number -> Number -> Boolean
moreOrLessEq a b = 
  let 
    f = Approximate.Fraction 0.001
  in 
  Approximate.eqRelative f a b

main :: Effect Unit
main = runTest do
  suite "VRuler" do
    test "valueToPix" do
      let pix = V.valueToPix testVRuler 30.0
      Assert.equal 100.0 pix 
    test "valueToPix (padding)" do
      let pix = V.valueToPix testVRulerpadding 30.0
      Assert.equal 80.0 pix 
    test "pixToValue " do
      let val = V.pixToValue testVRuler (Pix 100.0)
      Assert.equal 30.0 val
    test "pixToValue (padding)" do
      let val = V.pixToValue testVRulerpadding (Pix 100.0)
      Assert.assert "pixToValue with padding should be 23.33" $ moreOrLessEq 23.33 val
    test "calcPpy" do
      let vr = ValueRange { minVal: 10.0, maxVal: 50.0 }
      Assert.equal 5.0 (calcPpy chartDim vr pad0)
    test "calcPpy (padding)" do
      let vr = ValueRange { minVal: 10.0, maxVal: 50.0 }
      Assert.equal 3.0 (calcPpy chartDim vr pad1)
    test "yaxis" do
      let prices = [50.0,40.0,30.0,10.0]
      let cyrYaxis = V.yaxis testVRuler prices
      let expectedYaxis = [0.0,50.0,100.0,200.0]
      Assert.equal expectedYaxis cyrYaxis 
    test "yaxis (padding)" do
      let prices = [50.0,40.0,30.0,10.0]
      let cyrYaxis = V.yaxis testVRuler prices
      let expectedYaxis = [0.0,50.0,100.0,200.0]
      Assert.equal expectedYaxis cyrYaxis 
    test "vruler lines" do
      let result = V.lines testVRuler 4
      let exTx (RulerLineInfo {tx}) = tx
      let resultTx = map exTx result
      Assert.equal ["50.0","40.0","30.0","20.0","10.0"] resultTx 
    test "vruler lines (padding)" do
      let result = V.lines testVRulerpadding 4
      let exTx (RulerLineInfo {tx}) = tx
      let resultTx = map exTx result
      Assert.equal ["50.0","40.0","30.0","20.0","10.0"] resultTx 
  suite "HRuler" do
    test "timeStampToPix half width of canvas" do
      let hr = testHRuler jan_2_19 
      let t = H.timeStampToPix hr jan_11_19
      Assert.equal 300.0 t
    test "timeStampToPix half width of canvas (padding)" do
      let hr = testHRulerPadding jan_2_19 
      let t = H.timeStampToPix hr jan_11_19
      Assert.equal 280.0 t
    test "timeStampToPix full width of canvas" do
      let hr = testHRuler jan_2_19 
      let t = H.timeStampToPix hr jan_20_19
      Assert.equal 600.0 t
    test "timeStampToPix full width of canvas (padding)" do
      let hr = testHRulerPadding jan_2_19 
      let t = H.timeStampToPix hr jan_20_19
      Assert.equal 550.0 t
    test "offsetsToPix" do
      let (H.HRuler {ppx: (Pix ppd),xaxis}) = testHRuler jan_2_19 
      Assert.assert "Pix pr day should be 33.33" $ moreOrLessEq ppd 33.33
      let expectedOffests = [566.66,533.28,499.95,466.62,366.63,333.3,299.97,266.64,233.31,133.32,99.99,66.66,0.0]
      let result = Array.zipWith moreOrLessEq expectedOffests xaxis
      Assert.equal [true,true,true,true,true,true,true,true,true,true,true,true,true] result 
    test "offsetsToPix (padding)" do
      let (H.HRuler {ppx: (Pix ppd),xaxis}) = testHRulerPadding jan_2_19 
      Assert.assert "Pix pr day should be 30.0" $ moreOrLessEq ppd 30.0
      let expectedOffests = [520.0,490.0,460.0,430.0,340.0,310.0,280.0,250.0,220.0,130.0,100.0,70.0,10.0]
      let result = Array.zipWith moreOrLessEq expectedOffests xaxis
      Assert.equal [true,true,true,true,true,true,true,true,true,true,true,true,true] result
    test "wrong pix should be Nothing" do
      let wrongOffsets = [1,4,5,8,9]
      let wrongPix = calcPpx chartDim wrongOffsets pad0
      Assert.assert "Wrong pix should be Nothing" $ wrongPix == Nothing
    test "pixPrUnit" do
      let myOffsets = [12,9,8,7,1]
      let pix = unsafePartial $ fromJust $ calcPpx chartDim myOffsets pad0
      Assert.equal 50.0 pix 
    test "pixPrUnit (padding)" do
      let myOffsets = [12,9,8,7,1]
      let pix = unsafePartial $ fromJust $ calcPpx chartDim myOffsets pad1
      Assert.equal 45.0 pix 
    test "incMonts" do
      let tm = H.incMonths jan_2_19 3
      Assert.equal tm april_1_19
    test "dateToString" do
      let s = H.dateToString jan_2_19 
      Assert.equal "01.2019" s
    test "pixToDays" do
      let hr = testHRuler jan_2_19 
      let days = H.pixToDays hr (Pix 200.0)
      Assert.equal 6.0 days
    test "pixToDays (padding)" do
      let hr = testHRulerPadding jan_2_19 
      let days = H.pixToDays hr (Pix 200.0)
      Assert.assert "pixToDays should be 6.33" $ moreOrLessEq 6.33 days
    test "pixToTimeStamp" do
      let hr = testHRuler jan_2_19 
      let result = H.pixToTimeStamp hr (Pix 200.0)
      Assert.equal result (UnixTime 1546905600000.0)
    test "pixToTimeStamp (padding)" do
      let hr = testHRulerPadding jan_2_19 
      let result = H.pixToTimeStamp hr (Pix 200.0)
      Assert.equal result (UnixTime 1546934400000.0)

      
      {-
    test "hruler lines" do
      let hr = testHRuler jan_2_19 
      let result = H.lines hr 4
      let exTx (RulerLineInfo {tx}) = tx
      let resultTx = map exTx result
      Assert.equal ["50.0","40.0","30.0","20.0","10.0"] resultTx 
      -}



{-
main = runTest do
  suite "sync code" do
    test "arithmetic" do
      Assert.assert "2 + 2 should be 4" $ (2 + 2) == 4
      Assert.assertFalse "2 + 2 shouldn't be 5" $ (2 + 2) == 5
      Assert.equal 4 (2 + 2)
      Assert.expectFailure "2 + 2 shouldn't be 5" $ Assert.equal 5 (2 + 2)

  suite "async code" do
    test "with async IO" do
      fileContents <- FS.readTextFile UTF8 "file.txt"
      Assert.equal "hello here are your file contents\n" fileContents
    test "async operation with a timeout" do
      timeout 100 $ do
        file2Contents <- FS.readTextFile UTF8 "file2.txt"
        Assert.equal "can we read a file in 100ms?\n" file2Contents
-}

