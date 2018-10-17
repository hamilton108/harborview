module Critters.Types exposing
    ( AccRule
    , AccRuleMsg(..)
    , Activable
    , Critter
    , CritterMsg(..)
    , DenyRule
    , DenyRuleMsg(..)
    , Flags
    , JsonStatus
    , Model
    , Msg(..)
    , Oidable
    , OptionPurchase
    , OptionPurchases
    , rtypDesc
    )

import Common.ModalDialog as DLG
import Common.Select as S
import Http


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


rtypSelectItems : S.SelectItems
rtypSelectItems =
    Debug.todo "rtypSelectItems"


type CritterMsg
    = PaperCritters
    | RealTimeCritters
    | NewCritter
    | PaperCrittersFetched (Result Http.Error OptionPurchases)
    | RealTimeCrittersFetched (Result Http.Error OptionPurchases)
    | DlgNewCritterOk
    | DlgNewCritterCancel
    | OnNewCritter (Result Http.Error JsonStatus)


type AccRuleMsg
    = ToggleAccActive AccRule
    | NewAccRule Int
    | DlgNewAccOk
    | DlgNewAccCancel
    | OnNewAccRule (Result Http.Error JsonStatus)


type DenyRuleMsg
    = ToggleDenyActive DenyRule
    | NewDenyRule Int
    | DlgNewDenyOk
    | DlgNewDenyCancel
    | OnNewDenyRule (Result Http.Error JsonStatus)


type Msg
    = AlertOk
    | CritterMsgFor CritterMsg
    | AccRuleMsgFor AccRuleMsg
    | DenyRuleMsgFor DenyRuleMsg
    | Toggled (Result Http.Error JsonStatus)
    | SelectedPurchaseChanged String
    | SaleVolChanged String
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
    { dlgAlert : DLG.DialogState
    , dlgNewCritter : DLG.DialogState
    , dlgNewAccRule : DLG.DialogState
    , dlgNewDenyRule : DLG.DialogState
    , purchases : OptionPurchases
    , currentPurchaseType : Int
    , saleVol : String
    , selectedPurchase : Maybe String
    }
