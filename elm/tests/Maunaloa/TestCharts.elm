module Maunaloa.TestCharts exposing (suite)

import Common.DateUtil exposing (UnixTime, day_)
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


xAxis : List UnixTime
xAxis =
    [ 100, 98, 97, 95, 94 ]


jlines : JE.Value
jlines =
    toJsonFloatLines lines


jxAxis : JE.Value
jxAxis =
    JE.list JE.int xAxis


jchart : JE.Value
jchart =
    JE.object
        [ ( "lines", jlines )
        , ( "bars", JE.null )
        , ( "cndl", jcandleSticks )
        ]


curMinDx =
    1547282905000


jchartInfo : JE.Value
jchartInfo =
    JE.object
        [ ( "min-dx", JE.int curMinDx )
        , ( "x-axis", jxAxis )
        , ( "chart", jchart )
        , ( "chart2", JE.null )
        , ( "chart3", JE.null )
        ]


chart : T.Chart
chart =
    T.Chart lines [] candleSticks ( 0, 0 ) 10


chart1 : T.Chart
chart1 =
    T.Chart (List.take 3 lines) [] (List.take 3 candleSticks) ( 40.1, 45 ) 10


chartInfo : T.ChartInfo
chartInfo =
    T.ChartInfo curMinDx xAxis chart Nothing Nothing


chartInfo1 : T.ChartInfoWindow
chartInfo1 =
    let
        strokes =
            [ "#000000", "#ff0000", "#aa00ff" ]

        minDx_ =
            curMinDx * day_ * 97
    in
    T.ChartInfoWindow minDx_ (List.take 3 xAxis) chart1 Nothing Nothing strokes 1



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
        , test "Test chartWindow 1" <|
            \_ ->
                ChartCommon.chartWindow (T.Drop 0) (T.Take 3) chart (T.Scaling 1.0) False
                    |> Expect.equal chart1
        , only <|
            test "Test chartInfoWindow 1" <|
                \_ ->
                    ChartCommon.chartInfoWindow (T.Drop 0) (T.Take 3) T.DayChart chartInfo
                        |> Expect.equal chartInfo1
        ]
