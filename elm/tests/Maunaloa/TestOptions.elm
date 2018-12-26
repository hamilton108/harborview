module Maunaloa.TestOptions exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as JD
import Json.Encode as JE
import Maunaloa.Options.Decoders as D
import Maunaloa.Options.Main as Main
import Maunaloa.Options.Types as T
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as S



--option : JE.Value
--option =


stockJson : JE.Value
stockJson =
    JE.object
        [ ( "dx", JE.string "2018-12-17" )
        , ( "tm", JE.string "18:30" )
        , ( "o", JE.float 347.5 )
        , ( "h", JE.float 350.0 )
        , ( "l", JE.float 337.3 )
        , ( "c", JE.float 337.4 )
        ]


optionJson : List ( String, JE.Value )
optionJson =
    [ ( "days", JE.float 209.0 )
    , ( "expiry", JE.string "2018-12-21" )
    , ( "ticker", JE.string "YAR8L305" )
    , ( "x", JE.float 305.0 )
    , ( "buy", JE.float 32.5 )
    , ( "sell", JE.float 34.5 )
    , ( "ivSell", JE.float 1.4 )
    , ( "ivBuy", JE.float 1.2 )
    , ( "brEven", JE.float 35.7 )
    ]


optionObj =
    T.Option "YAR8L305" 305 209 32.5 34.5 1.2 1.4 35.7 "2018-12-21" 6.2 0 0 0 False


stockObj =
    T.Stock "2018-12-17" "18:30" 347.5 350 337.3 337.4


optionsJson : JE.Value
optionsJson =
    JE.list JE.object
        [ optionJson
        ]


stockAndOptionsJson : JE.Value
stockAndOptionsJson =
    JE.object
        [ ( "stock", stockJson )
        , ( "options", optionsJson )
        ]


suite : Test
suite =
    --let
    --    m =
    --        Main.initModel <| T.Flags True
    --in
    describe "Testing OPTIONS"
        [ {-
             test "Test fetching calls" <|
               \_ ->
                   let
                       wi =
                           JD.decodeValue D.stockAndOptionsDecoder stockAndOptionsJson
                   in
                   Expect.equal (Ok {})
          -}
          test "Test option" <|
            \_ ->
                JE.object optionJson
                    |> JD.decodeValue D.optionDecoder
                    |> Expect.equal (Ok optionObj)
        , test "Test stock" <|
            \_ ->
                stockJson
                    |> JD.decodeValue D.stockDecoder
                    |> Expect.equal (Ok stockObj)
        ]
