module Maunaloa.Options.Views exposing (view)

import Common.Buttons as BTN
import Common.ComboBox as CMB
import Common.Miscellaneous as M
import Common.ModalDialog as DLG
import Html as H
import Html.Attributes as A
import Html.Events as E
import Maunaloa.Options.Tables exposing (config)
import Maunaloa.Options.Types
    exposing
        ( Model
        , Msg(..)
        , OptionMsg(..)
        , PurchaseMsg(..)
        )
import Table


view : Model -> H.Html Msg
view model =
    let
        opx =
            Maybe.withDefault [] model.options

        stockInfo =
            case model.stock of
                Nothing ->
                    ""

                Just sx ->
                    toString sx

        dlgHeader =
            case model.selectedPurchase of
                Nothing ->
                    "Option Purchase"

                Just sp ->
                    "Option Purchase " ++ sp.ticker
    in
    H.div []
        [ H.div [ A.class "grid-elm" ]
            [ H.div [ A.class "form-group form-group--elm" ]
                [ H.text stockInfo ]
            , BTN.button "Calc Risc" CalcRisc
            , H.div [ A.class "form-group form-group--elm" ]
                [ H.input [ A.placeholder "Risc", E.onInput RiscChange ] [] ]
            , BTN.button "Reset Cache" ResetCache
            , CMB.makeSelect "Tickers: " (OptionMsgFor << FetchOptions) model.tickers model.selectedTicker
            ]
        , H.div [ A.class "grid-elm" ]
            [ Table.view config model.tableState opx ]
        , DLG.modalDialog dlgHeader
            model.dlgPurchase
            (PurchaseMsgFor PurchaseDlgOk)
            (PurchaseMsgFor PurchaseDlgCancel)
            [ H.div [ A.class "form-group row" ]
                [ H.input [ A.class "form-control", A.checked True, A.type_ "checkbox", E.onClick ToggleRealTimePurchase ]
                    []
                , H.text "Real-time purchase"
                ]
            , M.makeFGRInput AskChange "id1" "Ask:" "number" M.CX39 model.ask
            , M.makeFGRInput BidChange "id2" "Bid:" "number" M.CX39 model.bid
            , M.makeFGRInput VolumeChange "id3" "Volume:" "number" M.CX39 model.volume
            , M.makeFGRInput SpotChange "id4" "Spot:" "number" M.CX39 model.spot
            ]
        , DLG.alert model.dlgAlert AlertOk
        ]
