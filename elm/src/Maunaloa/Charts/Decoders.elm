module Maunaloa.Charts.Decoders exposing (candlestickDecoder, chartDecoder)

import Json.Decode exposing (Decoder, field, float, int, list, map4, nullable, succeed)
import Json.Decode.Pipeline as JP
import Maunaloa.Charts.Types as T


candlestickDecoder : Decoder T.Candlestick
candlestickDecoder =
    map4 T.Candlestick
        (field "o" float)
        (field "h" float)
        (field "l" float)
        (field "c" float)


chartDecoder : Int -> Decoder T.Chart
chartDecoder numVlines =
    succeed T.Chart
        |> JP.required "lines" (list (list float))
        |> JP.optional "bars" (list (list float)) []
        |> JP.optional "cndl" (list candlestickDecoder) []
        |> JP.hardcoded ( 0, 0 )
        |> JP.hardcoded numVlines


chartInfoDecoder : Decoder T.ChartInfo
chartInfoDecoder =
    succeed T.ChartInfo
        |> JP.required "min-dx" int
        |> JP.required "x-axis" (list float)
        |> JP.required "chart" (chartDecoder 10)
        |> JP.required "chart2" (nullable (chartDecoder 5))
        |> JP.required "chart3" (nullable (chartDecoder 5))
