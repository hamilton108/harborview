module Maunaloa.Options.Decoders exposing (purchaseStatusDecoder)

import Common.Types exposing (JsonStatus)
import Json.Decode as JD
import Json.Decode.Pipeline as JP


purchaseStatusDecoder =
    JD.succeed JsonStatus
        |> JP.required "ok" JD.bool
        |> JP.required "msg" JD.string
        |> JP.required "statusCode" JD.int
