module Common.Utils exposing (..)


flip : (a -> b -> c) -> b -> a -> c
flip fn x y =
    fn y x
