module Maunaloa.Options.Commands exposing
    ( fetchOptions
    , fetchTickers
    , registerAndPurchaseOption
    )

--import Common.Miscellaneous as M

import Common.Decoders as DEC
import Common.Select as CMB
import Common.Types as T
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Maunaloa.Options.Decoders as D
import Maunaloa.Options.Types
    exposing
        ( Model
        , Msg(..)
        , Option
        , OptionMsg(..)
        , Options
        , PurchaseMsg(..)
        , RiscItem
        , RiscItems
        , Stock
        , StockAndOptions
        )


mainUrl =
    "/maunaloa"


purchaseOption : Int -> String -> Float -> Float -> Int -> Float -> Bool -> Cmd Msg
purchaseOption stockId ticker ask bid volume spot isRealTime =
    Debug.todo "-"



{-
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
           M.asHttpBody params
   in
   Http.send
       (PurchaseMsgFor << OptionPurchased)
   <|
       Http.post url jbody T.jsonStatusDecoder
-}


registerAndPurchaseOption_ : Model -> Option -> Cmd Msg
registerAndPurchaseOption_ model opx =
    Debug.todo "-"



{-
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
           , ( "volume", JE.int curVol )
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
       Http.post url jbody T.jsonStatusDecoder
-}


registerAndPurchaseOption : Model -> Cmd Msg
registerAndPurchaseOption model =
    Debug.todo "-"



{-
   case model.selectedPurchase of
       Nothing ->
           Cmd.none

       Just opx ->
           registerAndPurchaseOption_ model opx
-}


toggle : String -> Option -> Option
toggle ticker opt =
    Debug.todo "-"



{-
   if opt.ticker == ticker then
       { opt | selected = not opt.selected }

   else
       opt
-}


setRisc : Float -> RiscItems -> Option -> Option
setRisc curRisc riscItems opt =
    Debug.todo "-"



{-
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
-}


calcRisc : String -> Options -> Cmd Msg
calcRisc riscStr options =
    Debug.todo "-"



{-
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
               |> JP.required "ticker" JD.string
               |> JP.required "risc" JD.float
   in
   Http.send
       RiscCalculated
   <|
       Http.post url jbody (JD.list myDecoder)
-}


bool2json : Bool -> String
bool2json v =
    case v of
        True ->
            "true"

        False ->
            "false"


fetchOptions : Model -> Maybe String -> Bool -> Cmd Msg
fetchOptions model s resetCache =
    case s of
        Nothing ->
            Cmd.none

        Just sx ->
            let
                url =
                    case model.flags.isCalls of
                        True ->
                            mainUrl ++ "/calls/" ++ sx ++ "/" ++ bool2json resetCache

                        False ->
                            mainUrl ++ "/puts/" ++ sx ++ "/" ++ bool2json resetCache
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
