module Common.Decoders exposing (..)

import Critters.Types exposing (JsonStatus)
import Json.Decode.Pipeline as JP
import Json.Decode as Json


jsonStatusDecoder : Json.Decoder JsonStatus
jsonStatusDecoder =
    Json.succeed JsonStatus
        |> JP.required "ok" Json.bool
        |> JP.required "msg" Json.string
        |> JP.required "statusCode" Json.int
