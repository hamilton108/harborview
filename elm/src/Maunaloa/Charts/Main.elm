module Maunaloa.Charts.Main exposing (mx)

import Browser
import Html as H


mx : Int
mx =
    3435


type alias Model =
    {}


type alias Flags =
    Int


type Msg
    = NoOp


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel flags =
    {}


view model =
    H.div [] []


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
