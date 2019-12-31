module Maunaloa.Elm where

import Prelude 

import Partial.Unsafe (unsafePartial)
import Data.Array (filter)
import Data.Traversable (traverse)
import Data.Nullable (Nullable,toMaybe)
import Data.Maybe 
    ( Maybe(..)
    , fromJust 
    )

-- import Data.Array (map)

import Maunaloa.ChartCollection 
    ( ChartCollection(..)
    , ChartMappings
    , ChartMapping(..)
    , globalChartWidth)
import Maunaloa.Chart 
    ( ChartId(..)
    , Chart(..)
    , padding)
import Maunaloa.HRuler as H
import Maunaloa.Common 
    ( UnixTime(..)
    )

type ElmCandlestick =
    { o :: Number 
    , h :: Number 
    , l :: Number 
    , c :: Number 
    }


type ElmChart =
    { lines :: Array (Array Number)
    , bars :: Array (Array Number)
    , candlesticks :: Array ElmCandlestick
    , valueRange :: Array Number
    , numVlines :: Int
    }


type ChartInfoWindow =
    { ticker :: String
    , startdate :: Number
    , xaxis :: Array Int
    , chart :: ElmChart
    , chart2 :: Nullable ElmChart
    , chart3 :: Nullable ElmChart
    , strokes :: Array String
    , numIncMonths :: Int
    }

transformMapping1 :: ChartMapping -> Maybe ElmChart -> Maybe Chart 
transformMapping1 (ChartMapping mapping) elmChart = 
    elmChart >>= \elmChart1 -> 
    Just $ 
    Chart 
    { lines :: L.Lines
    , candlesticks :: CNDL.Candlesticks
    , canvasId :: HtmlId 
    , vruler :: V.VRuler
    , w :: ChartWidth
    , h :: ChartHeight
    , chartLevel :: Maybe ChartLevel
    }

transformMapping :: ChartInfoWindow -> ChartMapping -> Maybe Chart 
transformMapping ciwin mapping1@(ChartMapping mapping) =
    case mapping.chartId of
        ChartId "chart" -> 
            transformMapping1 mapping1 (Just ciwin.chart)
        ChartId "chart2" -> 
            transformMapping1 mapping1 (toMaybe ciwin.chart2)
        ChartId "chart3" -> 
            transformMapping1 mapping1 (toMaybe ciwin.chart3)
        _ -> 
            Nothing


transform :: ChartMappings -> ChartInfoWindow -> ChartCollection
transform mappings ciwin = 
    let 
        tm = UnixTime ciwin.startdate
        ruler = H.create globalChartWidth tm ciwin.xaxis padding
        ruler1 = unsafePartial (fromJust ruler)
        maybeCharts = filter (\c -> c /= Nothing) (map (transformMapping ciwin) mappings)
        charts1 = map (unsafePartial $ fromJust) maybeCharts
    in
    ChartCollection 
    { charts: charts1
    , hruler: ruler1
    }

