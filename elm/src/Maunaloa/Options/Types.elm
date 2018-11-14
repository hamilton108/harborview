module Maunaloa.Options.Types exposing
    ( Flags
    , Model
    , Msg(..)
    , Option
    , OptionMsg(..)
    , OptionSale
    , Options
    , PurchaseMsg(..)
    , RiscItem
    , RiscItems
    , Stock
    , StockAndOptions
    )

import Common.ModalDialog as DLG exposing (errorAlert)
import Common.Select as CMB
import Common.Types exposing (JsonStatus)
import Http
import Table


type alias Flags =
    { isCalls : Bool
    }


type alias Stock =
    { date : String
    , time : String
    , o : Float
    , h : Float
    , l : Float
    , c : Float
    }


type alias Option =
    { ticker : String
    , x : Float
    , days : Float
    , buy : Float
    , sell : Float
    , ivBuy : Float
    , ivSell : Float
    , breakEven : Float
    , expiry : String
    , spread : Float
    , risc : Float
    , optionPriceAtRisc : Float
    , stockPriceAtRisc : Float
    , selected : Bool
    }


type alias Options =
    List Option


type alias StockAndOptions =
    { stock : Stock
    , opx : Options
    }


type alias RiscItem =
    { ticker : String
    , risc : Float
    }


type alias RiscItems =
    List RiscItem


type alias OptionSale =
    {}



{-
   type alias PurchaseStatus =
       { ok : Bool, msg : String, statusCode : Int }
-}


type OptionMsg
    = FetchOptions String
    | OptionsFetched (Result Http.Error StockAndOptions)


type PurchaseMsg
    = PurchaseClick Option
    | PurchaseDlgOk
    | PurchaseDlgCancel
    | OptionPurchased (Result Http.Error JsonStatus)


type Msg
    = AlertOk
    | TickersFetched (Result Http.Error CMB.SelectItems)
      -- | FetchOptions String
      -- | OptionsFetched (Result Http.Error StockAndOptions)
    | SetTableState Table.State
    | ResetCache
    | CalcRisc
    | RiscCalculated (Result Http.Error RiscItems)
    | RiscChange String
    | ToggleSelected String
      --| PurchaseClick Option
      --| PurchaseDlgOk
      --| PurchaseDlgCancel
      -- | OptionPurchased (Result Http.Error PurchaseStatus)
    | ToggleRealTimePurchase
    | AskChange String
    | BidChange String
    | VolumeChange String
    | SpotChange String
    | OptionMsgFor OptionMsg
    | PurchaseMsgFor PurchaseMsg


type alias Model =
    { tickers : Maybe CMB.SelectItems
    , selectedTicker : String
    , stock : Maybe Stock
    , options : Maybe Options
    , risc : String
    , flags : Flags
    , tableState : Table.State
    , dlgPurchase : DLG.DialogState
    , dlgAlert : DLG.DialogState
    , selectedPurchase : Maybe Option
    , isRealTimePurchase : Bool
    , ask : String
    , bid : String
    , volume : String
    , spot : String
    }
