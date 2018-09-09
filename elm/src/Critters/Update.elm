module Critters.Update exposing (..)

import Common.Utils as U
import Critters.Types exposing (Model, Msg(..))
import Critters.Types
    exposing
        ( AccRule
        , DenyRule
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


type alias Activable a =
    { a | oid : Int, active : Bool }


accs =
    [ AccRule 1 1 1.0 True Nothing
    , AccRule 2 2 2.0 True Nothing
    , AccRule 3 3 3.0 True Nothing
    ]


toggleOid : Int -> Activable a -> Activable a
toggleOid oid acc =
    if acc.oid == oid then
        { acc | active = not acc.active }
    else
        acc


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
            Debug.log (Debug.toString accRule)
                ( model, Cmd.none )

        ToggleDenyActive ->
            Debug.log "ToggleDenyActive"
                ( model, Cmd.none )
