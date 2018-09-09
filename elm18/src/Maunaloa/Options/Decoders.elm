module Maunaloa.Options.Decoders exposing (..)

import Json.Decode.Pipeline as JP
import Json.Decode as Json
import Common.Types exposing (JsonStatus)


purchaseStatusDecoder =
    JP.decode JsonStatus
        |> JP.required "ok" Json.bool
        |> JP.required "msg" Json.string
        |> JP.required "statusCode" Json.int
