module Maunaloa.Charts.Main exposing (main)

import Browser
import Html as H
import Maunaloa.Charts.Commands exposing (fetchTickers)
import Maunaloa.Charts.Types exposing (ChartInfoWindow, ChartType(..), Flags, Model, Msg(..))
import Maunaloa.Charts.Update exposing (update)
import Maunaloa.Charts.View exposing (view)



-------------------- INIT ---------------------


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
    ( initModel flags, fetchTickers )


initModel : Flags -> Model
initModel flags =
    { chartType =
        case flags of
            2 ->
                MonthChart

            3 ->
                YearChart

            _ ->
                DayChart
    }
