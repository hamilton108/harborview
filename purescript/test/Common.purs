module Test.Common where

import Data.Number.Approximate as Approximate
import Foreign (F, Foreign)
import Util.Value (foreignValue)
import Maunaloa.Common (
      Padding(..)
    , ChartDim(..))

foreignTestData :: F Foreign
foreignTestData = foreignValue """{ 
  "startDate":1548115200000, 
  "xaxis":[10,9,8,5,4], 
  "chart2": null,
  "chart": { "lines": null, "lines3":[[3.0,2.2,3.1,4.2,3.5],[3.0,2.2,3.1,4.2,3.2]], "valueRange":[2.2,4.2] }}"""

moreOrLessEq :: Number -> Number -> Boolean
moreOrLessEq a b = 
  let 
    f = Approximate.Fraction 0.001
  in 
  Approximate.eqRelative f a b

pad0 :: Padding 
pad0 = Padding { left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 }

pad1 :: Padding
pad1 = Padding { left: 10.0, top: 20.0, right: 50.0, bottom: 60.0 }

chartDim :: ChartDim 
chartDim = ChartDim { w: 600.0, h: 200.0 }