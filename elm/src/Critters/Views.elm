module Critters.Views exposing (..)

import Html as H
import Html.Attributes as A
import Common.Buttons as BTN
import Common.ComboBox as CB
import Critters.Types exposing (Model, Msg(..))


view : Model -> H.Html Msg
view model =
    H.div []
        [ H.div [ A.class "grid-elm" ]
            [ H.div [ A.class "form-group form-group--elm" ]
                [ BTN.button "Paper Critters" PaperCritters ]
            , H.div [ A.class "form-group form-group--elm" ]
                [ BTN.button "Real Time Critters" RealTimeCritters ]
            , H.div [ A.class "form-group form-group--elm" ]
                [ BTN.button "New Critter" NewCritter ]
            ]
        , H.div [ A.class "grid-elm" ] []
        ]
