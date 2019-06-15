module Test.Main where

import Prelude

import Test.Unit.Main (runTest)

import Effect (Effect)

import Test.CandlesticksTest (testCandlesticksSuite)
import Test.HRulerTest (testHRulerSuite)
import Test.VRulerTest (testVRulerSuite)
import Test.ChartTest (testChartSuite)


main :: Effect Unit
main = runTest do
  testChartSuite
  --testCandlesticksSuite
  --testHRulerSuite
  --testVRulerSuite
