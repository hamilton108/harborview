module Maunaloa.Options.Main exposing (..)

import Common.Buttons as BTN
import Common.ComboBox as CMB
import Common.Miscellaneous as M
import Common.ModalDialog as DLG exposing (errorAlert)
import Dict exposing (Dict, fromList)
import Html as H
import Html.Attributes as A
import Html.Events as E
import Http
import Json.Decode as Json
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Table exposing (defaultCustomizations)
import Maunaloa.Options.Types
    exposing
        ( Stock
        , Option
        , Options
        , StockAndOptions
        , RiscItem
        , RiscItems
        , PurchaseStatus
        , Msg(..)
        , Model
        )


mainUrl =
    "/maunaloa"


type alias Flags =
    { isCalls : Bool
    }


main : Program Flags Model Msg
main =
    H.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, fetchTickers )



------------------- MODEL ---------------------
-- {:dx "2017-3-31", :ticker "YAR7U240", :days 174.0, :buy 1.4, :sell 2.0, :iv-buy 0.313, :iv-sell 0.338}
-- #region TYPES
-- | FetchPurchases
-- | PurchasesFetched (Result Http.Error OptionPurchases)
-- | ToggleRealTimePurchase


initModel : Flags -> Model
initModel flags =
    { tickers = Nothing
    , selectedTicker = "-1"
    , stock = Nothing
    , options = Nothing
    , risc = "0.0"
    , flags = flags
    , tableState = Table.initialSort "Ticker"
    , dlgPurchase = DLG.DialogHidden
    , dlgAlert = DLG.DialogHidden
    , selectedPurchase = Nothing
    , isRealTimePurchase = True
    , ask = "0.0"
    , bid = "0.0"
    , volume = "10"
    , spot = "0.0"
    }
