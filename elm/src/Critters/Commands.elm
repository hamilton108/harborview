module Critters.Commands exposing (..)

import Common.Decoders as Dec
import Critters.Decoders as CD
import Critters.Types exposing (Msg(..))
import Http


mainUrl =
    "purchases"


toggleRule : Bool -> Int -> Bool -> Cmd Msg
toggleRule isAccRule oid newVal =
    let
        rt =
            if isAccRule == True then
                "1"
            else
                "2"

        newValx =
            if newVal == True then
                "true"
            else
                "false"

        url =
            mainUrl ++ "/toggle/" ++ rt ++ "/" ++ String.fromInt oid ++ "/" ++ newValx
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
            mainUrl ++ "/" ++ critterTypeUrl

        msg =
            if isRealTime == True then
                RealTimeCrittersFetched
            else
                PaperCrittersFetched
    in
        Http.send msg <|
            Http.get url CD.optionPurchasesDecoder
