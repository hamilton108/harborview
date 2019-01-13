module Maunaloa.Charts.Commands exposing (fetchTickers)

import Common.Decoders as CD
import Http
import Maunaloa.Charts.Types exposing (Msg(..))


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
