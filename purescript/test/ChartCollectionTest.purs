module Test.ChartCollectionTest where

import Prelude 

import Control.Monad.Except (runExcept)
import Partial.Unsafe (unsafePartial)
import Data.Array as Array
import Data.Maybe (Maybe(..),fromJust)
import Data.Either (Either(..),fromRight,isRight)
import Test.Unit (TestSuite,suite,test)
import Test.Unit.Assert as Assert

import Util.Value (foreignValue)
import Maunaloa.Chart as Chart 
import Maunaloa.ChartCollection as ChartCollection
import Maunaloa.Common 
    ( HtmlId(..)
    , ChartHeight(..)
    )

import Test.Common as TC 

chartMapping :: HtmlId -> ChartCollection.ChartMapping
chartMapping levelCanvasId = 
    ChartCollection.ChartMapping 
    { chartId: Chart.ChartId "chart"
    , canvasId: HtmlId "test-canvasId"
    , chartHeight: ChartHeight 500.0
    , levelCanvasId: levelCanvasId
    }

chartMappings :: ChartCollection.ChartMappings 
chartMappings = [chartMapping (HtmlId "level-canvasid")]
-- chartMappings = [chartMapping (CanvasId ""), chartMapping (CanvasId "test-level-canvasId") ]
     
--collectionx = runExcept $ ChartCollection.fromMappings chartMappings TC.demox 

testChartColletionSuite :: TestSuite
testChartColletionSuite = 
    suite "ChartCollection" do
        test "ChartCollection" do
            let collection = runExcept $ ChartCollection.fromMappings chartMappings TC.demox 
            let collection1 = unsafePartial $ fromRight collection
            let (Chart.Chart chart1) = unsafePartial $ fromJust $ Array.head collection1
            Assert.equal chart1.levelCanvasId (Just (HtmlId "level-canvasid"))
        --let result = CA.candleToPix VT.testVRuler testCandle
        --Assert.equal pixCandle result

