module Critters.Commands exposing (..)

import Http
import Common.Decoders as Dec
import Critters.Types exposing (Msg(..))


mainUrl =
    "critters"


toggleRule : Bool -> Int -> Cmd Msg
toggleRule isAccRule oid =
    let
        toggle =
            if isAccRule == True then
                "toggleacc"
            else
                "toggledny"

        url =
            mainUrl ++ "/" ++ toggle ++ "/" ++ (String.fromInt oid)
    in
        Http.send Toggled <|
            Http.get url Dec.jsonStatusDecoder
