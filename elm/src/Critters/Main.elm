module Critters.Main exposing (..)

import Browser
import Critters.Types as T exposing (Flags, Model, Msg(..))
import Critters.Update as U
import Critters.Views as V
import Html as H


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = V.view
        , update = U.update
        , subscriptions = \_ -> Sub.none
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel : Flags -> Model
initModel flags =
    let
        dny1 =
            T.DenyRule 1 1 2.0 True False

        dny2 =
            T.DenyRule 2 2 4.0 False True

        acc =
            T.AccRule 1 1 1 7 5.5 True (Just [ dny1, dny2 ])

        acc2 =
            T.AccRule 1 1 2 5 3.5 True Nothing

        critter =
            T.Critter 1 10 1 (Just [ acc, acc2 ])

        opx =
            T.OptionPurchase 1 "YAR8L240" (Just [ critter ])
    in
        { purchases = [ opx ]
        }


initx : Model
initx =
    initModel Flags


mx =
    let
        m =
            initx
    in
        m.purchases
