port module Maunaloa.Charts.Update exposing (update)

import Common.Html as CH
import Common.Select as CS
import Maunaloa.Charts.ChartCommon as ChartCommon
import Maunaloa.Charts.Commands as C
import Maunaloa.Charts.Types exposing (Drop(..),ChartInfoWindow, Model, Msg(..), Ticker(..))



-------------------- PORTS ---------------------


port drawCanvas : ChartInfoWindow -> Cmd msg



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
                    if String.isEmpty s then
                        NoTicker

                    else
                        Ticker s
            in
            ( { model | selectedTicker = Just s }, C.fetchCharts curTick model.chartType False )

        ChartsFetched (Ok chartInfo) ->
            let
                ciWin =
                    ChartCommon.chartInfoWindow model.dropAmount model.takeAmount model.chartType chartInfo
            in
            Debug.log (Debug.toString ciWin)
                ( { model | chartInfo = Just chartInfo }
                , drawCanvas ciWin
                )


        ChartsFetched (Err s) ->
            Debug.log ("ChartsFetched Error: " ++ CH.httpErr2str s)
                ( model, Cmd.none )

        ToggleResetCache ->
            ( { model | resetCache = not model.resetCache }, Cmd.none )

        Previous ->
            case model.chartInfo of

                Nothing -> (model, Cmd.none) 

                Just chartInfo ->
                    let 
                        (Drop curDrop) = model.dropAmount

                        newDrop = Drop <| curDrop + 30 

                        ciWin =
                            ChartCommon.chartInfoWindow newDrop model.takeAmount model.chartType chartInfo
                    in
                    ( { model | dropAmount = newDrop }, drawCanvas ciWin  )

        Next ->
            case model.chartInfo of

                Nothing -> (model, Cmd.none) 

                Just chartInfo ->
                    let 
                        (Drop curDrop) = model.dropAmount
                    in
                        if curDrop == 0 then
                            (model, Cmd.none)
                        else
                            let 
                                newDrop = Drop <| curDrop - 30 

                                ciWin =
                                    ChartCommon.chartInfoWindow newDrop model.takeAmount model.chartType chartInfo
                            in
                            ( { model | dropAmount = newDrop }, drawCanvas ciWin  )


--( { model | selectedTicker = Just s }, fetchCharts s model.flags.chartResolution model.isResetCache )
