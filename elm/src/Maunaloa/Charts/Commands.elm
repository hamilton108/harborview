module Maunaloa.Charts.Commands exposing (fetchTickers)

import Common.Decoders as CD
import Http
import Maunaloa.Charts.Decoders as DEC
import Maunaloa.Charts.Types exposing (ChartType(..), Msg(..))


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
            "&rc=1"

        False ->
            "&rc=0"


fetchCharts : String -> ChartType -> Bool -> Cmd Msg
fetchCharts ticker ct resetCache =
    let
        url =
            case ct of
                DayChart ->
                    mainUrl ++ "/ticker?oid=" ++ ticker ++ resetCacheJson resetCache

                MonthChart ->
                    mainUrl ++ "/tickerweek?oid=" ++ ticker ++ resetCacheJson resetCache

                YearChart ->
                    mainUrl ++ "/tickermonth?oid=" ++ ticker ++ resetCacheJson resetCache
    in
    Http.send ChartsFetched <| Http.get url DEC.chartInfoDecoder
