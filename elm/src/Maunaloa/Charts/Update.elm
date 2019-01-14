port module Maunaloa.Charts.Update exposing (update)

import Common.Html as CH
import Common.Select as CS
import Maunaloa.Charts.ChartCommon as ChartCommon
import Maunaloa.Charts.Commands as C
import Maunaloa.Charts.Types exposing (ChartInfoWindow, Model, Msg(..), Ticker(..))



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
            Debug.log (Debug.toString chartInfo)
                ( model
                , drawCanvas ciWin
                )

        {-
           let
               ciWin =
                   chartInfoWindow s model
           in
           ( { model
               | chartInfo = Just s
               , chartInfoWin = Just ciWin
             }
           , drawCanvas ciWin
           )
        -}
        ChartsFetched (Err s) ->
            Debug.log ("ChartsFetched Error: " ++ CH.httpErr2str s)
                ( model, Cmd.none )



--( { model | selectedTicker = Just s }, fetchCharts s model.flags.chartResolution model.isResetCache )
