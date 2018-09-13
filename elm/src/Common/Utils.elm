module Common.Utils exposing (..)

import Http
import Critters.Types exposing (Oidable)


flip : (a -> b -> c) -> b -> a -> c
flip fn x y =
    fn y x


findInList : List (Oidable a) -> Int -> Maybe (Oidable a)
findInList lx oid =
    List.head <| List.filter (\x -> x.oid == oid) lx


replaceWith : Oidable a -> Oidable a -> Oidable a
replaceWith newEl el =
    if el.oid == newEl.oid then
        newEl
    else
        el


httpErr2str : Http.Error -> String
httpErr2str err =
    case err of
        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "NetworkError"

        Http.BadUrl s ->
            "BadUrl: " ++ s

        Http.BadStatus r ->
            "BadStatus: "

        Http.BadPayload s r ->
            "BadPayload: " ++ s
