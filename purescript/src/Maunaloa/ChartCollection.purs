module Maunaloa.ChartCollection where

import Prelude

import Foreign (F, Foreign)
import Data.List (List(..),(:))
import Util.Foreign as FU
import Data.Maybe (Maybe,fromJust)
import Data.Traversable (traverse_)
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas (Context2D)
import Effect (Effect)

import Maunaloa.Chart as C
import Maunaloa.HRuler as H
import Maunaloa.Common 
    ( CanvasId(..)
    , ChartWidth(..)
    , ChartHeight(..)
    )


newtype ChartCollection = ChartCollection {
    charts :: List C.Chart
  , hruler :: H.HRuler
}

instance showChartCollection :: Show ChartCollection where
  show (ChartCollection coll) = "(ChartCollection " <> show coll <> ")"

readChartCollection :: Foreign -> F ChartCollection
readChartCollection value = 
  C.readChart (C.ChartId "chart") (CanvasId "canvas") (ChartWidth 1200.0) (ChartHeight 600.0) value >>= \chart1 ->
  C.readChart (C.ChartId "chart2") (CanvasId "canvas2") (ChartWidth 1200.0) (ChartHeight 300.0) value >>= \chart2 ->
  C.readHRuler value >>= \mhr ->
  let 
    hr = unsafePartial $ fromJust mhr        
  in
  pure $ ChartCollection { charts: (chart1 : chart2 : Nil), hruler: hr } 


draw :: ChartCollection -> Effect Unit
draw (ChartCollection coll) = 
  let 
    paint_ = C.paint coll.hruler
  in
  traverse_ paint_ coll.charts 