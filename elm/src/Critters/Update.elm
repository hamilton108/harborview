module Critters.Update exposing (..)

import Common.Html as W
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
        , CritterMsg(..)
        )
import Common.ModalDialog as DLG


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
        AlertOk ->
            ( { model | dlgAlert = DLG.DialogHidden }, Cmd.none )

        CritterMsgFor critMsg ->
            case critMsg of
                PaperCritters ->
                    ( model, C.fetchCritters False )

                RealTimeCritters ->
                    ( model, C.fetchCritters True )

                NewCritter ->
                    ( { model | dlgNewCritter = DLG.DialogVisible }, Cmd.none )

                PaperCrittersFetched (Ok p) ->
                    ( { model | purchases = p, currentPurchaseType = 11 }, Cmd.none )

                PaperCrittersFetched (Err s) ->
                    ( DLG.errorAlert "Error" "PaperCrittersFetched Error: " s model, Cmd.none )

                RealTimeCrittersFetched (Ok p) ->
                    ( { model | purchases = p, currentPurchaseType = 4 }, Cmd.none )

                RealTimeCrittersFetched (Err s) ->
                    ( DLG.errorAlert "Error" "RealTimeCrittersFetched Error: " s model, Cmd.none )

                DlgNewCritterOk ->
                    let
                        cmd =
                            case model.selectedPurchase of
                                Nothing ->
                                    Cmd.none

                                Just p ->
                                    C.newCritter p model.saleVol
                    in
                        ( { model | dlgNewCritter = DLG.DialogHidden }, cmd )

                DlgNewCritterCancel ->
                    ( { model | dlgNewCritter = DLG.DialogHidden }, Cmd.none )

                OnNewCritter (Ok s) ->
                    let
                        cmd =
                            if model.currentPurchaseType == 4 then
                                C.fetchCritters True
                            else
                                C.fetchCritters False
                    in
                        ( model, cmd )

                OnNewCritter (Err s) ->
                    ( DLG.errorAlert "Error" "OnNewCritter Error: " s model, Cmd.none )

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
            ( { model | dlgAlert = DLG.DialogVisibleAlert "Toggle" s.msg DLG.Info }, Cmd.none )

        Toggled (Err s) ->
            ( DLG.errorAlert "Error" "Toggled Error: " s model, Cmd.none )

        SelectedPurchaseChanged s ->
            ( { model | selectedPurchase = Just s }, Cmd.none )

        SaleVolChanged s ->
            ( { model | saleVol = s }, Cmd.none )

        ResetCache ->
            ( model, C.resetCache model.currentPurchaseType )

        CacheReset (Ok s) ->
            ( model, Cmd.none )

        CacheReset (Err s) ->
            ( DLG.errorAlert "Error" "CacheReset Error: " s model, Cmd.none )

        NewAccRule critId ->
            Debug.log (String.fromInt critId)
                ( model, Cmd.none )

        NewDenyRule accId ->
            Debug.log (String.fromInt accId)
                ( model, Cmd.none )
