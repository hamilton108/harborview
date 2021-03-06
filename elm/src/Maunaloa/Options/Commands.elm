module Maunaloa.Options.Commands exposing
    ( calcRisc
    , fetchOptions
    , fetchTickers
    , purchaseOption
    , registerAndPurchaseOption
    , setRisc
    , toggle
    )

--import Common.Miscellaneous as M

import Common.Decoders as DEC
import Common.Select as CMB
import Common.Types as T
import Common.Utils as U
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Maunaloa.Options.Decoders as D
import Maunaloa.Options.Types
    exposing
        ( Ask(..)
        , Bid(..)
        , Model
        , Msg(..)
        , Option
        , OptionMsg(..)
        , Options
        , PurchaseMsg(..)
        , RiscItem
        , RiscItems
        , RiscMsg(..)
        , Spot(..)
        , Stock
        , StockAndOptions
        , StockId(..)
        , Ticker(..)
        , Volume(..)
        )


mainUrl =
    "/maunaloa"


purchaseOption : Ticker -> Ask -> Bid -> Volume -> Spot -> Bool -> Cmd Msg
purchaseOption (Ticker ticker) (Ask ask) (Bid bid) (Volume volume) (Spot spot) isRealTime =
    let
        url =
            mainUrl ++ "/purchaseoption"

        params =
            [ ( "ticker", JE.string ticker )
            , ( "ask", JE.float ask )
            , ( "bid", JE.float bid )
            , ( "volume", JE.int volume )
            , ( "spot", JE.float spot )
            , ( "rt", JE.bool isRealTime )
            ]

        jbody =
            U.asHttpBody params
    in
    Http.send
        (PurchaseMsgFor << OptionPurchased)
    <|
        Http.post url jbody T.jsonStatusDecoder


registerAndPurchaseOption_ : Model -> Option -> Cmd Msg
registerAndPurchaseOption_ model opx =
    let
        url =
            mainUrl ++ "/regpuroption"

        soids =
            Maybe.withDefault "-1" model.selectedTicker

        soid =
            Maybe.withDefault -1 (String.toInt soids)

        curAsk =
            Maybe.withDefault -1 (String.toFloat model.ask)

        curBid =
            Maybe.withDefault -1 (String.toFloat model.bid)

        curVol =
            Maybe.withDefault -1 (String.toInt model.volume)

        curSpot =
            Maybe.withDefault -1 (String.toFloat model.spot)

        opType =
            if model.flags.isCalls == True then
                "c"

            else
                "p"

        params =
            [ ( "ticker", JE.string opx.ticker )
            , ( "ask", JE.float curAsk )
            , ( "bid", JE.float curBid )
            , ( "volume", JE.int curVol )
            , ( "spot", JE.float curSpot )
            , ( "rt", JE.bool model.isRealTimePurchase )
            , ( "stockId", JE.int soid )
            , ( "opType", JE.string opType )
            , ( "expiry", JE.string opx.expiry )
            , ( "x", JE.float opx.x )
            ]

        jbody =
            U.asHttpBody params
    in
    Http.send (PurchaseMsgFor << OptionPurchased) <|
        Http.post url jbody T.jsonStatusDecoder


registerAndPurchaseOption : Model -> Cmd Msg
registerAndPurchaseOption model =
    case model.selectedPurchase of
        Nothing ->
            Cmd.none

        Just opx ->
            registerAndPurchaseOption_ model opx


toggle : String -> Option -> Option
toggle ticker opt =
    if opt.ticker == ticker then
        { opt | selected = not opt.selected }

    else
        opt


setRisc : Float -> RiscItems -> Option -> Option
setRisc curRisc riscItems opt =
    let
        predicate =
            \x -> x.ticker == opt.ticker

        curRiscItem =
            List.head <| List.filter predicate riscItems
    in
    case curRiscItem of
        Nothing ->
            opt

        Just curRiscItem_ ->
            { opt
                | stockPriceAtRisc = U.toDecimal curRiscItem_.risc 100
                , optionPriceAtRisc = opt.sell - curRisc
                , risc = curRisc
            }


calcRisc : Maybe String -> String -> Options -> Cmd Msg
calcRisc stockTicker riscStr options =
    case stockTicker of
        Nothing ->
            Cmd.none

        Just st ->
            let
                risc =
                    Maybe.withDefault 0 (String.toFloat riscStr)

                url =
                    mainUrl ++ "/calcriscstockprices/" ++ st

                checked =
                    List.filter (\x -> x.selected == True) options

                jbody =
                    U.listAsHttpBody
                        (List.map (\x -> [ ( "ticker", JE.string x.ticker ), ( "risc", JE.float risc ) ]) checked)

                myDecoder =
                    JD.succeed RiscItem
                        |> JP.required "ticker" JD.string
                        |> JP.required "risc" JD.float
            in
            Http.send
                (RiscMsgFor << RiscCalculated)
            <|
                Http.post url jbody (JD.list myDecoder)


bool2json : Bool -> String
bool2json v =
    case v of
        True ->
            "true"

        False ->
            "false"


fetchOptions : Model -> Maybe String -> Cmd Msg
fetchOptions model s =
    case s of
        Nothing ->
            Cmd.none

        Just sx ->
            let
                url =
                    case model.flags.isCalls of
                        True ->
                            mainUrl ++ "/calls/" ++ sx

                        False ->
                            mainUrl ++ "/puts/" ++ sx
            in
            Http.send (OptionMsgFor << OptionsFetched) <|
                Http.get url D.stockAndOptionsDecoder


fetchTickers : Cmd Msg
fetchTickers =
    let
        url =
            mainUrl ++ "/tickers"
    in
    Http.send TickersFetched <|
        Http.get url DEC.selectItemListDecoder
