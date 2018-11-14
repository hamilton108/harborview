module Maunaloa.Options.Main exposing (main)

import Browser
import Common.ModalDialog as DLG exposing (errorAlert)
import Maunaloa.Options.Types exposing (Flags, Model, Msg(..))
import Maunaloa.Options.Update exposing (update)
import Maunaloa.Options.Views exposing (view)
import Table


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
