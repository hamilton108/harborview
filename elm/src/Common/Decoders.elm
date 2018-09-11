module Common.Decoders exposing (..)

import Json.Decode.Pipeline as JP
import Json.Decode as Json


type alias JsonStatus =
    { ok : Bool, msg : String, statusCode : Int }


jsonStatusDecoder : Json.Decoder JsonStatus
jsonStatusDecoder =
    Json.succeed JsonStatus
        |> JP.required "ok" Json.bool
        |> JP.required "msg" Json.string
        |> JP.required "statusCode" Json.int
