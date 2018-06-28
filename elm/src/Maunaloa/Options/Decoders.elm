module Maunaloa.Options.Decoders exposing (..)

import Json.Decode.Pipeline as JP
import Json.Decode as Json
import Maunaloa.Options.Types exposing (PurchaseStatus)


purchaseStatusDecoder =
    JP.decode PurchaseStatus
        |> JP.required "ok" Json.bool
        |> JP.required "msg" Json.string
        |> JP.required "statusCode" Json.int
