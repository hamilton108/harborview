module Maunaloa.Options.Commands exposing (..)

import Common.ComboBox as CMB
import Common.Miscellaneous as M
import Http
import Json.Decode as Json
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Maunaloa.Options.Types
    exposing
        ( Model
        , Msg(..)
        , Option
        , OptionMsg(..)
        , Options
        , PurchaseMsg(..)
        , PurchaseStatus
        , RiscItem
        , RiscItems
        , Stock
        , StockAndOptions
        )
import Maunaloa.Options.Decoders as D


mainUrl =
    "/maunaloa"


purchaseOption : Int -> String -> Float -> Float -> Int -> Float -> Bool -> Cmd Msg
purchaseOption stockId ticker ask bid volume spot isRealTime =
    let
        url =
            mainUrl ++ "/purchaseoption"

        params =
            [ ( "ticker", JE.string ticker )
            , ( "ask", JE.float ask )
            , ( "bid", JE.float bid )
            , ( "vol", JE.int volume )
            , ( "spot", JE.float spot )
            , ( "rt", JE.bool isRealTime )
            ]

        jbody =
            M.asHttpBody params
    in
        Debug.log (toString jbody)
            Http.send
            (PurchaseMsgFor << OptionPurchased)
        <|
            Http.post url jbody D.purchaseStatusDecoder


registerAndPurchaseOption_ : Model -> Option -> Cmd Msg
registerAndPurchaseOption_ model opx =
    let
        url =
            mainUrl ++ "/regpuroption"

        soid =
            Result.withDefault -1 (String.toInt model.selectedTicker)

        curAsk =
            Result.withDefault -1 (String.toFloat model.ask)

        curBid =
            Result.withDefault -1 (String.toFloat model.bid)

        curVol =
            Result.withDefault -1 (String.toInt model.volume)

        curSpot =
            Result.withDefault -1 (String.toFloat model.spot)

        opType =
            if model.flags.isCalls == True then
                "c"
            else
                "p"

        params =
            [ ( "ticker", JE.string opx.ticker )
            , ( "ask", JE.float curAsk )
            , ( "bid", JE.float curBid )
            , ( "vol", JE.int curVol )
            , ( "spot", JE.float curSpot )
            , ( "rt", JE.bool model.isRealTimePurchase )
            , ( "stockId", JE.int soid )
            , ( "opType", JE.string opType )
            , ( "expiry", JE.string opx.expiry )
            , ( "x", JE.float opx.x )
            ]

        jbody =
            M.asHttpBody params
    in
        Http.send (PurchaseMsgFor << OptionPurchased) <|
            Http.post url jbody D.purchaseStatusDecoder


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
            M.findInList predicate riscItems
    in
        case curRiscItem of
            Nothing ->
                opt

            Just curRiscItem_ ->
                { opt
                    | stockPriceAtRisc = M.toDecimal curRiscItem_.risc 100
                    , optionPriceAtRisc = opt.sell - curRisc
                    , risc = curRisc
                }


calcRisc : String -> Maybe Options -> Cmd Msg
calcRisc riscStr options =
    let
        risc =
            Result.withDefault 0 (String.toFloat riscStr)

        url =
            mainUrl ++ "/calcriscstockprices"

        opx =
            Maybe.withDefault [] options

        checked =
            List.filter (\x -> x.selected == True) opx

        jbody =
            M.listAsHttpBody
                (List.map (\x -> [ ( "ticker", JE.string x.ticker ), ( "risc", JE.float risc ) ]) checked)

        myDecoder =
            JP.decode RiscItem
                |> JP.required "ticker" Json.string
                |> JP.required "risc" Json.float
    in
        Debug.log (toString jbody)
            Http.send
            RiscCalculated
        <|
            Http.post url jbody (Json.list myDecoder)


buildOption :
    String
    -> Float
    -> Float
    -> Float
    -> Float
    -> Float
    -> Float
    -> Float
    -> String
    -> Option
buildOption t x d b s ib is be ex =
    Option
        t
        x
        d
        b
        s
        ib
        is
        be
        ex
        (M.toDecimal (100 * ((s / b) - 1.0)) 10.0)
        0
        0
        0
        False


optionDecoder : Json.Decoder Option
optionDecoder =
    JP.decode buildOption
        |> JP.required "ticker" Json.string
        |> JP.required "x" Json.float
        |> JP.required "days" Json.float
        |> JP.required "buy" Json.float
        |> JP.required "sell" Json.float
        |> JP.required "ivBuy" Json.float
        |> JP.required "ivSell" Json.float
        |> JP.required "brEven" Json.float
        |> JP.required "expiry" Json.string


stockDecoder : Json.Decoder Stock
stockDecoder =
    JP.decode Stock
        |> JP.required "dx" Json.string
        |> JP.required "tm" Json.string
        |> JP.required "o" Json.float
        |> JP.required "h" Json.float
        |> JP.required "l" Json.float
        |> JP.required "c" Json.float


bool2json : Bool -> String
bool2json v =
    case v of
        True ->
            "true"

        False ->
            "false"


fetchOptions : Model -> String -> Bool -> Cmd Msg
fetchOptions model s resetCache =
    let
        url =
            case model.flags.isCalls of
                True ->
                    mainUrl ++ "/calls/" ++ s ++ "/" ++ bool2json resetCache

                False ->
                    mainUrl ++ "/puts/" ++ s ++ "/" ++ bool2json resetCache

        myDecoder =
            JP.decode StockAndOptions
                |> JP.required "stock" stockDecoder
                |> JP.required "options" (Json.list optionDecoder)
    in
        Http.send (OptionMsgFor << OptionsFetched) <|
            Http.get url myDecoder


fetchTickers : Cmd Msg
fetchTickers =
    let
        url =
            mainUrl ++ "/tickers"
    in
        Http.send TickersFetched <|
            Http.get url CMB.comboBoxItemListDecoder
