module Maunaloa.Elm where

import Data.Nullable (Nullable)
import Data.Maybe (Maybe)

type UnixTime = Int

type Candlestick =
    { o :: Number 
    , h :: Number 
    , l :: Number 
    , c :: Number 
    }


type Chart =
    { lines :: Array (Array Number)
    , bars :: Array (Array Number)
    , candlesticks :: Array Candlestick
    , valueRange :: Array Number
    , numVlines :: Int
    }


type ChartInfoWindow =
    { ticker :: String
    , startdate :: UnixTime
    , xaxis :: Array UnixTime
    , chart :: Chart
    , chart2 :: Nullable Chart
    , chart3 :: Nullable Chart
    , strokes :: Array String
    , numIncMonths :: Int
    }
