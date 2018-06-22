module Maunaloa.Options.Update exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlertOk ->
            ( { model | dlgAlert = DLG.DialogHidden }, Cmd.none )

        TickersFetched (Ok s) ->
            ( { model
                | tickers = Just s
              }
            , Cmd.none
            )

        TickersFetched (Err s) ->
            ( errorAlert "Error" "TickersFetched Error: " s model, Cmd.none )

        FetchOptions s ->
            ( { model | selectedTicker = s }, fetchOptions model s False )

        OptionsFetched (Ok s) ->
            ( { model | stock = Just s.stock, options = Just s.opx }, Cmd.none )

        OptionsFetched (Err s) ->
            ( errorAlert "Error" "OptionsFetched Error: " s model, Cmd.none )

        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        ResetCache ->
            ( model, fetchOptions model model.selectedTicker True )

        CalcRisc ->
            ( model, calcRisc model.risc model.options )

        RiscCalculated (Ok s) ->
            case model.options of
                Nothing ->
                    ( model, Cmd.none )

                Just optionx ->
                    let
                        curRisc =
                            Result.withDefault 0 (String.toFloat model.risc)
                    in
                        ( { model | options = Just (List.map (setRisc curRisc s) optionx) }, Cmd.none )

        RiscCalculated (Err s) ->
            ( errorAlert "RiscCalculated" "RiscCalculated Error: " s model, Cmd.none )

        RiscChange s ->
            --Debug.log "RiscChange"
            ( { model | risc = s }, Cmd.none )

        ToggleSelected ticker ->
            case model.options of
                Nothing ->
                    ( model, Cmd.none )

                Just optionx ->
                    ( { model | options = Just (List.map (toggle ticker) optionx) }
                    , Cmd.none
                    )

        PurchaseClick opt ->
            let
                curSpot =
                    M.unpackMaybe model.stock .c 0

                -- Maybe.withDefault 0 <| Maybe.map .c model.stock
            in
                ( { model
                    | dlgPurchase = DLG.DialogVisible
                    , selectedPurchase = Just opt
                    , ask = toString opt.sell
                    , bid = toString opt.buy
                    , volume = "10"
                    , spot = toString curSpot
                  }
                , Cmd.none
                )

        PurchaseDlgOk ->
            case model.selectedPurchase of
                Just opx ->
                    let
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
                    in
                        ( { model | dlgPurchase = DLG.DialogHidden }
                        , purchaseOption soid opx.ticker curAsk curBid curVol curSpot model.isRealTimePurchase
                        )

                Nothing ->
                    ( { model | dlgPurchase = DLG.DialogHidden }, Cmd.none )

        PurchaseDlgCancel ->
            ( { model | dlgPurchase = DLG.DialogHidden }, Cmd.none )

        OptionPurchased (Ok s) ->
            let
                alertCat =
                    case s.ok of
                        True ->
                            DLG.Info

                        False ->
                            DLG.Error
            in
                ( { model | dlgAlert = DLG.DialogVisibleAlert "Option purchase" s.msg alertCat }, Cmd.none )

        OptionPurchased (Err s) ->
            Debug.log "OptionPurchased ERR"
                ( errorAlert "Purchase Sale ERROR!" "SaleOk Error: " s model, Cmd.none )

        ToggleRealTimePurchase ->
            let
                checked =
                    not model.isRealTimePurchase
            in
                ( { model | isRealTimePurchase = checked }, Cmd.none )

        AskChange s ->
            ( { model | ask = s }, Cmd.none )

        BidChange s ->
            ( { model | bid = s }, Cmd.none )

        VolumeChange s ->
            ( { model | volume = s }, Cmd.none )

        SpotChange s ->
            ( { model | spot = s }, Cmd.none )
