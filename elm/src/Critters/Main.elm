module Critters.Main exposing (..)

import Html as H
import Critters.Update as U
import Critters.Views as V
import Critters.Types exposing (Model, Flags, Msg(..))
import Common.ComboBox as CB


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
    { critters = Just [ CB.ComboBoxItem "11" "Paper", CB.ComboBoxItem "4" "Real Time" ]
    , selectedCritter = "-1"
    }
