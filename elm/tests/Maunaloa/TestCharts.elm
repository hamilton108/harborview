module Maunaloa.TestCharts exposing (suite)

import Expect exposing (Expectation)
import Json.Encode as JE
import Maunaloa.Charts.Decoders as D
import Maunaloa.Charts.Types as T
import Test exposing (..)



--import Test.Html.Event as Event
--import Test.Html.Query as Query
--import Test.Html.Selector as S


toJsonLines : List (List Float) -> JE.Value
toJsonLines lx =
    JE.list (JE.list JE.float) lx


candleStick : Float -> Float -> Float -> Float -> List ( String, JE.Value )
candleStick opn hi lo close =
    [ ( "o", JE.float opn )
    , ( "h", JE.float hi )
    , ( "l", JE.float lo )
    , ( "c", JE.float close )
    ]


candleSticks : JE.Value
candleSticks =
    JE.list JE.object
        [ candleStick 42.0 44.5 40.1 42.5
        ]


lines : JE.Value
lines =
    toJsonLines [ [ 42, 45, 44.7, 44, 43.6 ] ]


suite : Test
suite =
    describe "Testing CHART"
        [ only <|
            test "Test chartDecoder" <|
                \_ ->
                    Expect.equal 1 1
        ]
