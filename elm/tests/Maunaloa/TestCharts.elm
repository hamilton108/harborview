module Maunaloa.TestCharts exposing (suite)

import Expect exposing (Expectation)
import Json.Decode as JD
import Json.Encode as JE
import Maunaloa.Charts.ChartCommon as ChartCommon
import Maunaloa.Charts.Decoders as DEC
import Maunaloa.Charts.Types as T
import Test exposing (..)



--import Test.Html.Event as Event
--import Test.Html.Query as Query
--import Test.Html.Selector as S


toJsonFloatLines : List (List Float) -> JE.Value
toJsonFloatLines lx =
    JE.list (JE.list JE.float) lx


jcandleStick : Float -> Float -> Float -> Float -> List ( String, JE.Value )
jcandleStick opn hi lo close =
    [ ( "o", JE.float opn )
    , ( "h", JE.float hi )
    , ( "l", JE.float lo )
    , ( "c", JE.float close )
    ]


jcandleSticks : JE.Value
jcandleSticks =
    JE.list JE.object
        [ jcandleStick 42.0 44.5 40.1 42.5
        ]


candleSticks : List T.Candlestick
candleSticks =
    [ T.Candlestick 42.0 44.5 40.1 42.5
    , T.Candlestick 42.0 44.5 40.1 42.5
    , T.Candlestick 42.0 44.5 40.1 42.5
    , T.Candlestick 42.0 44.5 40.1 42.5
    , T.Candlestick 42.0 44.5 40.1 42.5
    ]


lines : List (List Float)
lines =
    [ [ 42, 45, 44.7, 44, 43.6 ] ]


xAxis : List Float
xAxis =
    [ 1, 2, 3, 4, 5 ]


jlines : JE.Value
jlines =
    toJsonFloatLines lines


jxAxis : JE.Value
jxAxis =
    JE.list JE.float xAxis


jchart : JE.Value
jchart =
    JE.object
        [ ( "lines", jlines )
        , ( "bars", JE.null )
        , ( "cndl", jcandleSticks )
        ]


jchartInfo : JE.Value
jchartInfo =
    JE.object
        [ ( "min-dx", JE.int 1547282905000 )
        , ( "x-axis", jxAxis )
        , ( "chart", jchart )
        , ( "chart2", JE.null )
        , ( "chart3", JE.null )
        ]


chart : T.Chart
chart =
    T.Chart lines [] candleSticks ( 0, 0 ) 10


chartInfo : T.ChartInfo
chartInfo =
    T.ChartInfo 1547282905000 xAxis chart Nothing Nothing


chartInfoWin : T.ChartInfoWindow
chartInfoWin =
    Debug.todo "char"


createChartInfoWin : T.ChartInfo -> T.ChartInfoWindow
createChartInfoWin ci =
    Debug.todo "char"



{-
   let
       incMonths = case
   in
-}


suite : Test
suite =
    describe "Testing CHART"
        [ test "Test chartDecoder" <|
            \_ ->
                JD.decodeValue DEC.chartInfoDecoder jchartInfo
                    |> Expect.equal (Ok chartInfo)
        , only <|
            test "Test chartWindow" <|
                \_ ->
                    let
                        model =
                            T.Model T.DayChart
                    in
                    Expect.equal 2 2
        ]
