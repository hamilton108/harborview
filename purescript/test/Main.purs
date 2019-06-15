module Test.Main where

import Prelude

import Test.Unit.Main (runTest)

import Effect (Effect)

import Test.CandlesticksTest (runTestCandlesticks)
import Test.HRulerTest (runTestHRuler)
import Test.VRulerTest (runTestVRuler)


main :: Effect Unit
main = runTest do
  runTestCandlesticks
  runTestHRuler
  runTestVRuler 