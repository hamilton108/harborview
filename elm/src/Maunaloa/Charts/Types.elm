module Maunaloa.Charts.Types exposing
    ( Candlestick
    , Chart
    , ChartInfo
    , ChartInfoWindow
    , ChartType(..)
    , Drop(..)
    , Model
    , Msg(..)
    , Scaling(..)
    , Take(..)
    )

import Common.DateUtil exposing (UnixTime)
import Time


type alias Flags =
    Int


type Msg
    = NoOp


type alias Candlestick =
    { o : Float
    , h : Float
    , l : Float
    , c : Float
    }


type Drop
    = Drop Int


type Take
    = Take Int


type Scaling
    = Scaling Float


type alias Chart =
    { lines : List (List Float)
    , bars : List (List Float)
    , candlesticks : List Candlestick
    , valueRange : ( Float, Float )
    , numVlines : Int
    }


type alias ChartInfoWindow =
    { startdate : UnixTime
    , xaxis : List UnixTime
    , chart : Chart
    , chart2 : Maybe Chart
    , chart3 : Maybe Chart
    , strokes : List String
    , numIncMonths : Int
    }


type alias ChartInfo =
    { minDx : UnixTime
    , xAxis : List UnixTime
    , chart : Chart
    , chart2 : Maybe Chart
    , chart3 : Maybe Chart
    }


type ChartType
    = DayChart
    | MonthChart
    | YearChart


type alias Model =
    { chartType : ChartType
    }
