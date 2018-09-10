module Common.Utils exposing (..)

import Critters.Types exposing (Oidable)


flip : (a -> b -> c) -> b -> a -> c
flip fn x y =
    fn y x


findInList : List (Oidable a) -> Int -> Maybe (Oidable a)
findInList lx oid =
    List.head <| List.filter (\x -> x.oid == oid) lx
