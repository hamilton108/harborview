module Maunaloa.Charts.Types exposing
    ( Candlestick
    , Chart
    , ChartInfo
    , ChartInfoWindow
    , ChartType(..)
    , Drop(..)
    , Flags
    , Model
    , Msg(..)
    , Scaling(..)
    , Take(..)
    , Ticker(..)
    )

import Common.DateUtil exposing (UnixTime)
import Common.Select as CS
import Http
import Time


type alias Flags =
    Int


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


type Ticker
    = NoTicker
    | Ticker String


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


type Msg
    = TickersFetched (Result Http.Error CS.SelectItems)
    | FetchCharts String
    | ChartsFetched (Result Http.Error ChartInfo)
    | ToggleResetCache
    | Previous
    | Next


type alias Model =
    { chartType : ChartType
    , selectedTicker : Maybe String
    , tickers : CS.SelectItems
    , dropAmount : Drop
    , takeAmount : Take
    , resetCache : Bool
    , chartInfo : Maybe ChartInfo
    }
