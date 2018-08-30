module Critters.Main exposing (..)

import Html as H
import Critters.Update as U
import Critters.Views as V
import Critters.Types as T exposing (Model, Flags, Msg(..))


main : Program Flags Model Msg
main =
    H.programWithFlags
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
            T.DenyRule 2 2 4.0 True True

        acc =
            T.AccRule 1 7 5.5 True (Just [ dny1, dny2 ])

        critter =
            T.Critter 1 10 1 (Just [ acc ])

        opx =
            T.OptionPurchase 1 "YAR8L240" (Just [ critter ])
    in
        { purchases = Just [ opx ]
        }
