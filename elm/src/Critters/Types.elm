module Critters.Types exposing (..)

import Http
import Common.ModalDialog as DLG


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
    = AlertOk
    | PaperCritters
    | PaperCrittersFetched (Result Http.Error OptionPurchases)
    | RealTimeCritters
    | RealTimeCrittersFetched (Result Http.Error OptionPurchases)
    | NewCritter
    | ToggleAccActive AccRule
    | ToggleDenyActive DenyRule
    | Toggled (Result Http.Error JsonStatus)
    | DlgNewCritterOk
    | DlgNewCritterCancel
    | SelectedPurchaseChanged String
    | SaleVolChanged String
    | OnNewCritter (Result Http.Error JsonStatus)
    | ResetCache
    | CacheReset (Result Http.Error JsonStatus)


type alias JsonStatus =
    { ok : Bool, msg : String, statusCode : Int }


type alias Activable a =
    { a | oid : Int, active : Bool }


type alias Oidable a =
    { a | oid : Int }


type alias OptionPurchase =
    { oid : Int
    , ticker : String
    , critters : List Critter
    }


type alias OptionPurchases =
    List OptionPurchase


type alias Critter =
    { oid : Int
    , sellVolume : Int
    , status : Int
    , accRules : List AccRule
    }


type alias AccRule =
    { oid : Int
    , purchaseId : Int
    , critId : Int
    , rtyp : Int
    , value : Float
    , active : Bool
    , denyRules : List DenyRule
    }


type alias DenyRule =
    { oid : Int
    , purchaseId : Int
    , critId : Int
    , accId : Int
    , rtyp : Int
    , value : Float
    , active : Bool
    , memory : Bool
    }


type alias Flags =
    {}


type alias Model =
    { dlgNewCritter : DLG.DialogState
    , dlgAlert : DLG.DialogState
    , purchases : OptionPurchases
    , currentPurchaseType : Int
    , saleVol : String
    , selectedPurchase : Maybe String
    }
