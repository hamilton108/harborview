module Critters.Update exposing (..)

import Critters.Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchCritters s ->
            ( model, Cmd.none )

        NewCritter ->
            ( model, Cmd.none )
