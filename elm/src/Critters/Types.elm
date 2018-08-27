module Critters.Types exposing (..)

import Common.ComboBox as CB


type Msg
    = NewCritter
    | FetchCritters String


type alias Flags =
    {}


type alias Model =
    { critters : Maybe CB.SelectItems
    , selectedCritter : String
    }
