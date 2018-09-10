module Critters.Main exposing (..)

import Browser
import Critters.Types as T exposing (Flags, Model, Msg(..), Oidable)
import Critters.Update as U
import Common.Utils as Utils
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


dny1 =
    T.DenyRule 1 1 2.0 True False


dny2 =
    T.DenyRule 2 2 4.0 False True


acc =
    T.AccRule 1 1 1 7 5.5 True [ dny1, dny2 ]


acc2 =
    T.AccRule 2 1 1 5 3.5 True []


critter =
    T.Critter 1 10 1 [ acc, acc2 ]


opx =
    T.OptionPurchase 1 "YAR8L240" [ critter ]


initModel : Flags -> Model
initModel flags =
    { purchases = [ opx ]
    }


initx : Model
initx =
    initModel Flags


mx curAcc =
    let
        m =
            initx

        p1m =
            Utils.findInList m.purchases curAcc.purchaseId
                |> Maybe.andThen (\p -> Utils.findInList p.critters curAcc.critId)
                -- |> Maybe.andThen (\c -> findInList c.accRules curAcc.oid)
                |> Maybe.andThen (\c -> Just (List.map (U.toggleOid curAcc.oid) c.accRules))
    in
        case p1m of
            Nothing ->
                []

            Just toggleList ->
                toggleList
