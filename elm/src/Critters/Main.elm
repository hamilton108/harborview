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



{-
   replaceWith : List (Oidable a) -> Int -> Oidable a -> List (Oidable a)
   replaceWith oldList oid newEl =
       Debug.todo "replaceWith"
-}


replaceWith : Oidable a -> Oidable a -> Oidable a
replaceWith newEl el =
    if (el.oid == newEl.oid) then
        newEl
    else
        el


mx curAcc =
    let
        m =
            initx

        pm =
            Utils.findInList m.purchases curAcc.purchaseId
    in
        case pm of
            Nothing ->
                Nothing

            Just p ->
                let
                    cm =
                        Utils.findInList p.critters curAcc.critId
                in
                    case cm of
                        Nothing ->
                            Nothing

                        Just c ->
                            let
                                newAccs =
                                    (List.map (U.toggleOid curAcc.oid) c.accRules)

                                newCrit =
                                    { c | accRules = newAccs }

                                newCrits =
                                    List.map (replaceWith newCrit) p.critters
                            in
                                Just { p | critters = newCrits }



{-
   mxx curAcc =
       let
           m =
               initx

           p1m =
               Utils.findInList m.purchases curAcc.purchaseId
                   |> Maybe.andThen (\p -> Utils.findInList p.critters curAcc.critId)
                   |> Maybe.andThen (\c -> Just (List.map (U.toggleOid curAcc.oid) c.accRules))
       in
           case p1m of
               Nothing ->
                   []

               Just toggleList ->
                   toggleList
-}
