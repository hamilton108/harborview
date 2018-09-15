module Critters.Commands exposing (..)

import Common.Decoders as Dec
import Critters.Decoders as CD
import Critters.Types exposing (Msg(..))
import Http


mainUrl =
    "purchases"


newCritter_ : Int -> Int -> Int -> Cmd Msg
newCritter_ purchaseType oid vol =
    let
        url =
            mainUrl
                ++ "/newcritter/"
                ++ String.fromInt purchaseType
                ++ "/"
                ++ String.fromInt oid
                ++ "/"
                ++ String.fromInt vol
    in
        Http.send OnNewCritter <|
            Http.get url Dec.jsonStatusDecoder


newCritter : Int -> String -> String -> Cmd Msg
newCritter purchaseType oid vol =
    let
        maybeCmd =
            String.toInt oid
                |> Maybe.andThen
                    (\oidx ->
                        String.toInt vol
                            |> Maybe.andThen (\volx -> Just (newCritter_ purchaseType oidx volx))
                    )
    in
        case maybeCmd of
            Nothing ->
                Cmd.none

            Just cmd ->
                cmd



--  p1m =
--      Utils.findInList m.purchases curAcc.purchaseId
--          |> Maybe.andThen (\p -> Utils.findInList p.critters curAcc.critId)
--          |> Maybe.andThen (\c -> Just (List.map (U.toggleOid curAcc.oid) c.accRules))
--


resetCache : Int -> Cmd Msg
resetCache purchaseType =
    Cmd.none


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
