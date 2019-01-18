port module Maunaloa.Charts.Update exposing (update)

import Common.Html as CH
import Common.Select as CS
import Maunaloa.Charts.ChartCommon as ChartCommon
import Maunaloa.Charts.Commands as C
import Maunaloa.Charts.Types
    exposing
        ( ChartInfo
        , ChartInfoWindow
        , ChartType(..)
        , Drop(..)
        , Model
        , Msg(..)
        , RiscLines
        , RiscLinesJs
        , Take(..)
        , Ticker(..)
        , asTicker
        )



-------------------- PORTS ---------------------


port drawCanvas : ChartInfoWindow -> Cmd msg


port drawRiscLines : RiscLinesJs -> Cmd msg



-------------------- UPDATE ---------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TickersFetched (Ok s) ->
            ( { model
                | tickers = s
              }
            , Cmd.none
            )

        TickersFetched (Err s) ->
            Debug.log ("TickersFetched Error: " ++ CH.httpErr2str s)
                ( model, Cmd.none )

        FetchCharts s ->
            let
                curTick =
                    asTicker s
            in
            ( { model | selectedTicker = Just s }, C.fetchCharts curTick model.chartType False )

        ChartsFetched (Ok chartInfo) ->
            let
                ciWin =
                    ChartCommon.chartInfoWindow model.dropAmount model.takeAmount model.chartType chartInfo
            in
            Debug.log (Debug.toString ciWin)
                ( { model | chartInfo = Just chartInfo, curValueRange = Just ciWin.chart.valueRange }
                , drawCanvas ciWin
                )

        ChartsFetched (Err s) ->
            Debug.log ("ChartsFetched Error: " ++ CH.httpErr2str s)
                ( model, Cmd.none )

        ToggleResetCache ->
            ( { model | resetCache = not model.resetCache }, Cmd.none )

        Previous ->
            let
                (Drop curDrop) =
                    model.dropAmount
            in
            shift model (Drop <| curDrop + 30)

        Next ->
            let
                (Drop curDrop) =
                    model.dropAmount
            in
            if curDrop == 0 then
                ( model, Cmd.none )

            else
                shift model (Drop <| curDrop - 30)

        Last ->
            shift model (Drop 0)

        FetchRiscLines ->
            case model.selectedTicker of
                Nothing ->
                    ( model, Cmd.none )

                Just s ->
                    let
                        curTick =
                            asTicker s
                    in
                    ( model, C.fetchRiscLines curTick )

        --( model, fetchRiscLines model )
        RiscLinesFetched (Ok riscLines) ->
            case model.curValueRange of
                Just vr ->
                    let
                        riscLinesJs =
                            RiscLinesJs riscLines vr
                    in
                    --( { model | riscLines = Just riscLines }, drawRiscLines riscLinesJs )
                    ( model, drawRiscLines riscLinesJs )

                Nothing ->
                    --( { model | riscLines = Just riscLines }, Cmd.none )
                    ( model, Cmd.none )

        RiscLinesFetched (Err s) ->
            Debug.log ("RiscLinesFetched Error: " ++ CH.httpErr2str s) ( model, Cmd.none )


shift : Model -> Drop -> ( Model, Cmd Msg )
shift model newDrop =
    case model.chartInfo of
        Nothing ->
            ( model, Cmd.none )

        Just chartInfo ->
            let
                ciWin =
                    ChartCommon.chartInfoWindow newDrop model.takeAmount model.chartType chartInfo
            in
            ( { model | dropAmount = newDrop }, drawCanvas ciWin )
