module Test.CandlesticksTest where

import Test.Unit (TestSuite,suite,test)
import Test.Unit.Assert as Assert

import Maunaloa.Candlesticks as CA
import Test.VRulerTest as VT

testCandle :: CA.Candlestick
testCandle = CA.Candlestick { o: 40.0, h: 50.0, l: 10.0, c: 30.0 }

pixCandle :: CA.Candlestick
pixCandle = CA.Candlestick { o: 50.0, h: 0.0, l: 200.0, c: 100.0 }

testCandlesticksSuite :: TestSuite
testCandlesticksSuite = 
  suite "Candlesticks" do
    test "Scale candlestick" do
      let result = CA.candleToPix VT.testVRuler testCandle
      Assert.equal pixCandle result