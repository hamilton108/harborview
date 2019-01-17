module Maunaloa.Charts.Commands exposing (fetchCharts, fetchTickers)

import Common.Decoders as CD
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

                        MonthChart ->
                            mainUrl ++ "/tickerweek/" ++ s ++ "/" ++ resetCacheJson resetCache

                        YearChart ->
                            mainUrl ++ "/tickermonth?oid=" ++ s ++ resetCacheJson resetCache
            in
            Http.send ChartsFetched <| Http.get url DEC.chartInfoDecoder
