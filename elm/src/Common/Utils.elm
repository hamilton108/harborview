module Common.Utils exposing
    ( findInList
    , flip
    , replaceWith
    , toDecimal
    , unpackMaybe
    )

import Critters.Types exposing (Oidable)


flip : (a -> b -> c) -> b -> a -> c
flip fn x y =
    fn y x


toDecimal : Float -> Float -> Float
toDecimal value roundFactor =
    let
        valx =
            toFloat <| round <| value * roundFactor
    in
    valx / roundFactor


findInList : List (Oidable a) -> Int -> Maybe (Oidable a)
findInList lx oid =
    List.head <| List.filter (\x -> x.oid == oid) lx


replaceWith : Oidable a -> Oidable a -> Oidable a
replaceWith newEl el =
    if el.oid == newEl.oid then
        newEl

    else
        el


unpackMaybe : Maybe a -> (a -> b) -> b -> b
unpackMaybe obj fn default =
    Maybe.withDefault default <| Maybe.map fn obj
