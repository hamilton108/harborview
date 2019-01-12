module Maunaloa.Charts.Types exposing
    ( Candlestick
    , Chart
    , ChartInfo
    , ChartInfoWindow
    , ChartType(..)
    , Model
    , Msg(..)
    , UnixTime
    )

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


type alias UnixTime =
    Int


type alias Chart =
    { lines : List (List Float)
    , bars : List (List Float)
    , candlesticks : List Candlestick
    , valueRange : ( Float, Float )
    , numVlines : Int
    }


type alias ChartInfoWindow =
    { startdate : UnixTime
    , xaxis : List Float
    , chart : Chart
    , chart2 : Maybe Chart
    , chart3 : Maybe Chart
    , strokes : List String
    , numIncMonths : Int
    }


type alias ChartInfo =
    { minDx : UnixTime
    , xAxis : List Float
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
