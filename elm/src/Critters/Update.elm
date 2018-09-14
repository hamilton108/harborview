module Critters.Update exposing (..)

import Common.Web as W
import Common.Utils as U
import Critters.Commands as C
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


toggleDenyRule : Model -> DenyRule -> Model
toggleDenyRule model dny =
    let
        pm =
            U.findInList model.purchases dny.purchaseId
    in
        case pm of
            Nothing ->
                model

            Just p ->
                let
                    cm =
                        U.findInList p.critters dny.critId
                in
                    case cm of
                        Nothing ->
                            model

                        Just c ->
                            let
                                accm =
                                    U.findInList c.accRules dny.accId
                            in
                                case accm of
                                    Nothing ->
                                        model

                                    Just acc ->
                                        let
                                            newDenys =
                                                List.map (toggleOid dny.oid) acc.denyRules

                                            newAcc =
                                                { acc | denyRules = newDenys }

                                            newAccs =
                                                List.map (U.replaceWith newAcc) c.accRules

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



--newDnys =
--  List.map (toggleOid dny.oid) acc.denyRules
-- in model
{-
       newDnys =
           List.map (toggleOid dny.oid) c.denyRules

       newCrit =
           { c | denyRules = newDnys }

       newCrits =
           List.map (U.replaceWith newCrit) p.critters

       newPurchase =
           { p | critters = newCrits }

       newPurchases =
           List.map (U.replaceWith newPurchase) model.purchases
   in
   { model | purchases = newPurchases }
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PaperCritters ->
            ( model, C.fetchCritters False )

        PaperCrittersFetched (Ok p) ->
            Debug.log "PaperCrittersFetched"
                ( { model | purchases = p }, Cmd.none )

        PaperCrittersFetched (Err s) ->
            Debug.log (W.httpErr2str s)
                ( model, Cmd.none )

        RealTimeCritters ->
            ( model, C.fetchCritters True )

        RealTimeCrittersFetched (Ok p) ->
            Debug.log "RealTimeCrittersFetched"
                ( { model | purchases = p }, Cmd.none )

        RealTimeCrittersFetched (Err s) ->
            Debug.log (W.httpErr2str s)
                ( model, Cmd.none )

        NewCritter ->
            ( model, Cmd.none )

        ToggleAccActive accRule ->
            let
                newVal =
                    not accRule.active

                newModel =
                    toggleAccRule model accRule
            in
                ( newModel, C.toggleRule True accRule.oid newVal )

        ToggleDenyActive denyRule ->
            let
                newVal =
                    not denyRule.active

                newModel =
                    toggleDenyRule model denyRule
            in
                ( newModel, C.toggleRule False denyRule.oid newVal )

        Toggled (Ok s) ->
            ( model, Cmd.none )

        Toggled (Err s) ->
            Debug.log "Toggled Err"
                ( model, Cmd.none )
