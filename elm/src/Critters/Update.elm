module Critters.Update exposing (..)

import Common.Utils as U
import Critters.Types
    exposing
        ( AccRule
        , Activable
        , DenyRule
        , Model
        , Msg(..)
        , OptionPurchase
        , OptionPurchases
        )


-- https://medium.com/elm-shorts/updating-nested-records-in-elm-15d162e80480
-- https://stackoverflow.com/questions/40732840/more-efficient-way-to-update-an-element-in-a-list-in-elm/40733516#40733516
-- List.take n list ++ newN :: List.drop (n+1) list
-- https://www.brianthicks.com/post/2016/06/23/candy-and-allowances-parent-child-communication-in-elm/
{-
   updateInList : List a -> Int -> a -> List a
   updateInList lx index newVal =
       List.take index lx ++ newVal :: List.drop (index + 1) lx

-}
-- accs =
--     [ AccRule 1 1 1.0 True Nothing
--     , AccRule 2 2 2.0 True Nothing
--     , AccRule 3 3 3.0 True Nothing
--     ]
--


toggleOid : Int -> Activable a -> Activable a
toggleOid oid acc =
    if acc.oid == oid then
        { acc | active = not acc.active }
    else
        acc


toggleAccRule : Model -> AccRule -> Model
toggleAccRule model curAcc =
    let
        pm =
            U.findInList model.purchases curAcc.purchaseId
    in
    case pm of
        Nothing ->
            model

        Just p ->
            let
                cm =
                    U.findInList p.critters curAcc.critId
            in
            case cm of
                Nothing ->
                    model

                Just c ->
                    let
                        newAccs =
                            List.map (toggleOid curAcc.oid) c.accRules

                        newCrit =
                            { c | accRules = newAccs }

                        newCrits =
                            List.map (U.replaceWith newCrit) p.critters

                        newPurchase =
                            { p | critters = newCrits }

                        newPurchases =
                            List.map (U.replaceWith newPurchase) model.purchases
                    in
                    { model | purchases = newPurchases }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PaperCritters ->
            ( model, Cmd.none )

        RealTimeCritters ->
            ( model, Cmd.none )

        NewCritter ->
            ( model, Cmd.none )

        ToggleAccActive accRule ->
            let
                newModel =
                    toggleAccRule model accRule
            in
            ( newModel, Cmd.none )

        ToggleDenyActive ->
            Debug.log "ToggleDenyActive"
                ( model, Cmd.none )
