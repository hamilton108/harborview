module Maunaloa.ChartCollection where

import Prelude

import Foreign (F, Foreign)
import Data.Maybe (fromJust)
import Data.String (length)
import Data.Traversable (traverse,traverse_)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Data.Array as Array

import Effect.Console (logShow)

import Maunaloa.Chart as C
import Maunaloa.HRuler as H
import Maunaloa.Common 
    ( CanvasId(..)
    , ChartWidth(..)
    , ChartHeight
    )
import Maunaloa.LevelLine as LevelLine


newtype ChartCollection = ChartCollection 
    { charts :: Array C.Chart -- List C.Chart
    , hruler :: H.HRuler
    }

newtype ChartMapping = ChartMapping 
    { chartId :: C.ChartId
    , canvasId :: CanvasId
    , chartHeight :: ChartHeight 
    , levelCanvasId :: CanvasId
    }

instance showChartMapping :: Show ChartMapping where
    show (ChartMapping x) = "(ChartMapping " <> show x <> ")"

type ChartMappings = Array ChartMapping

-- createChartFromMapping :: ChartMapping -> Foreign -> F 

instance showChartCollection :: Show ChartCollection where
    show (ChartCollection coll) = "(ChartCollection " <> show coll <> ")"


globalChartWidth :: ChartWidth
globalChartWidth = ChartWidth 1310.0


fromMappings :: ChartMappings -> Foreign -> F (Array C.Chart)
fromMappings mappings value =
    let
        tfn :: ChartMapping -> F C.Chart
        tfn (ChartMapping {chartId, canvasId, chartHeight, levelCanvasId: (CanvasId lcid)}) = 
            let 
                lcid1 = 
                    if length lcid == 0 then
                        Nothing
                    else 
                        Just (CanvasId lcid)
            in
            C.readChart chartId canvasId globalChartWidth chartHeight value lcid1
    in
    traverse tfn mappings

readChartCollection :: ChartMappings -> Foreign -> F ChartCollection
readChartCollection mappings value = 
    fromMappings mappings value >>= \charts -> 
    C.readHRuler globalChartWidth value >>= \mhr ->
    let 
        hr = unsafePartial $ fromJust mhr        
    in
    pure $ ChartCollection { charts: charts, hruler: hr } 

{-
readChartCollection :: Foreign -> F ChartCollection
readChartCollection value = 
  C.readChart (C.ChartId "chart") (CanvasId "chart-1") globalChartWidth (ChartHeight 600.0) value >>= \chart1 ->
  C.readChart (C.ChartId "chart2") (CanvasId "osc-1") globalChartWidth (ChartHeight 200.0) value >>= \chart2 ->
  C.readHRuler globalChartWidth value >>= \mhr ->
  let 
    hr = unsafePartial $ fromJust mhr        
  in
  pure $ ChartCollection { charts: (chart1 : chart2 : Nil), hruler: hr } 
-}

--initEvents :: Effect (Int -> Effect Unit)
--initEvents =

findChartPredicate :: C.Chart -> Boolean
findChartPredicate (C.Chart chart) =
    chart.levelCanvasId /= Nothing

findLevelLineChart :: Array C.Chart -> Maybe C.Chart
findLevelLineChart charts = 
    Array.find findChartPredicate charts

levelLines :: Array C.Chart -> Effect (Int -> Effect Unit)
levelLines charts = 
    let
        levelLine = Array.find findChartPredicate charts
    in
    case levelLine of 
        Nothing ->
            pure $ \t -> pure unit
        Just (C.Chart levelLine1) ->
            let 
                caid = unsafePartial $ fromJust levelLine1.levelCanvasId 
            in
            LevelLine.initEvents levelLine1.vruler caid 

paint :: ChartCollection -> Effect (Int -> Effect Unit)
paint (ChartCollection coll) = 
    let 
        paint_ = C.paint coll.hruler
    in
    traverse_ paint_ coll.charts *>
    levelLines coll.charts