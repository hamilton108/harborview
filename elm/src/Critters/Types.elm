module Critters.Types exposing (..)


rtypDesc : Int -> String
rtypDesc rtyp =
    case rtyp of
        1 ->
            "Diff from watermark"

        2 ->
            "Diff from watermark percent"

        3 ->
            "Stock price floor (valid if above price)"

        4 ->
            "Stock price roof (valid if below price)"

        5 ->
            "Option price floor (valid if above price)"

        6 ->
            "Option price roof (valid if below price)"

        7 ->
            "Diff from bought"

        9 ->
            "Gradient diff from watermark"

        _ ->
            "Composite"


type Msg
    = PaperCritters
    | RealTimeCritters
    | NewCritter


type alias OptionPurchase =
    { oid : Int
    , ticker : String
    , critters : Maybe (List Critter)
    }


type alias OptionPurchases =
    List OptionPurchase


type alias Critter =
    { oid : Int
    , sellVolume : Int
    , status : Int
    , accRules : Maybe (List AccRule)
    }


type alias AccRule =
    { oid : Int
    , rtyp : Int
    , value : Float
    , active : Bool
    , denyRules : Maybe (List DenyRule)
    }


type alias DenyRule =
    { oid : Int
    , rtyp : Int
    , value : Float
    , active : Bool
    , memory : Bool
    }


type alias Flags =
    {}


type alias Model =
    { purchases : Maybe OptionPurchases
    }
