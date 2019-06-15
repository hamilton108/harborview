module Test.Main where

import Prelude

import Test.Unit.Main (runTest)

import Effect (Effect)

import Test.CandlesticksTest (testCandlesticksSuite)
import Test.HRulerTest (testHRulerSuite)
import Test.VRulerTest (testVRulerSuite)


main :: Effect Unit
main = runTest do
  testCandlesticksSuite
  testHRulerSuite
  testVRulerSuite