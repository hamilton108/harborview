module Maunaloa.ChartCollection where

import Prelude

import Foreign (F, Foreign)
import Data.List (List(..),(:))
import Util.Foreign as FU
import Data.Maybe (Maybe,fromJust)
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas (Context2D)
import Effect (Effect)

import Maunaloa.Chart as C
import Maunaloa.HRuler as H
import Maunaloa.Common 
    ( CanvasId(..)
    , ChartHeight(..))


newtype ChartCollection = ChartCollection {
    charts :: List C.Chart
  , hruler :: H.HRuler
}

instance showChartCollection :: Show ChartCollection where
  show (ChartCollection coll) = "(ChartCollection " <> show coll <> ")"

readChartCollection :: Foreign -> F ChartCollection
readChartCollection value = 
  C.readChart (C.ChartId "chart") (CanvasId "c1") (ChartHeight 600.0) value >>= \chart1 ->
  C.readHRuler value >>= \mhr ->
  let 
    hr = unsafePartial $ fromJust mhr        
  in
  pure $ ChartCollection { charts: (chart1 : Nil), hruler: hr } 


draw :: ChartCollection -> Context2D -> Effect Unit
draw (ChartCollection coll) ctx = 
  H.draw coll.hruler C.chartDim ctx *>
  pure unit 