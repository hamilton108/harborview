module Maunaloa.Charts.Commands exposing
    ( clearRiscLines
    , fetchCharts
    , fetchRiscLines
    , fetchSpot
    , fetchTickers
    )

import Common.Decoders as CD
import Common.Types as T
import Http
import Maunaloa.Charts.Decoders as DEC
import Maunaloa.Charts.Types
    exposing
        ( ChartType(..)
        , Msg(..)
        , Ticker(..)
        )


mainUrl =
    "/maunaloa"


fetchTickers : Cmd Msg
fetchTickers =
    let
        url =
            mainUrl ++ "/tickers"
    in
    Http.send TickersFetched <|
        Http.get url CD.selectItemListDecoder


resetCacheJson : Bool -> String
resetCacheJson resetCache =
    case resetCache of
        True ->
            "true"

        False ->
            "false"


fetchCharts : Ticker -> ChartType -> Bool -> Cmd Msg
fetchCharts ticker ct resetCache =
    case ticker of
        NoTicker ->
            Cmd.none

        Ticker s ->
            let
                url =
                    case ct of
                        DayChart ->
                            mainUrl ++ "/ticker/" ++ s ++ "/" ++ resetCacheJson resetCache

                        WeekChart ->
                            mainUrl ++ "/tickerweek/" ++ s ++ "/" ++ resetCacheJson resetCache

                        MonthChart ->
                            mainUrl ++ "/tickermonth?oid=" ++ s ++ resetCacheJson resetCache
            in
            Http.send ChartsFetched <| Http.get url DEC.chartInfoDecoder


fetchRiscLines : Ticker -> Cmd Msg
fetchRiscLines ticker =
    case ticker of
        NoTicker ->
            Cmd.none

        Ticker s ->
            let
                url =
                    mainUrl ++ "/risclines/" ++ s
            in
            Http.send RiscLinesFetched <|
                Http.get url DEC.riscsDecoder


clearRiscLines : Ticker -> Cmd Msg
clearRiscLines ticker =
    case ticker of
        NoTicker ->
            Cmd.none

        Ticker s ->
            let
                url =
                    mainUrl ++ "/clearrisclines/" ++ s
            in
            Http.send RiscLinesCleared <|
                Http.get url T.jsonStatusDecoder


fetchSpot : Ticker -> Bool -> Cmd Msg
fetchSpot ticker resetCache =
    case ticker of
        NoTicker ->
            Cmd.none

        Ticker s ->
            let
                url =
                    mainUrl ++ "/spot/" ++ s ++ "/" ++ resetCacheJson resetCache
            in
            Http.send SpotFetched <|
                Http.get url DEC.spotDecoder
