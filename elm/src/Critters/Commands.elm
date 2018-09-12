module Critters.Commands exposing (..)

import Common.Decoders as Dec
import Critters.Types exposing (Msg(..))
import Http


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
            mainUrl ++ "/" ++ toggle ++ "/" ++ String.fromInt oid
    in
    Http.send Toggled <|
        Http.get url Dec.jsonStatusDecoder


fetchCritters : Bool -> Cmd Msg
fetchCritters isRealTime =
    let
        critterTypeUrl =
            if isRealTime == True then
                "4"
            else
                "11"

        url =
            mainUrl ++ "/critters/" ++ critterTypeUrl

        msg =
            if isRealTime == True then
                RealTimeCrittersFetched
            else
                PaperCrittersFetched
    in
    Http.send msg <|
        Http.get url Dec.jsonStatusDecoder
