module Maunaloa.Charts.View exposing (view)

import Common.Select as CS
import Html as H
import Html.Attributes as A
import Maunaloa.Charts.Types exposing (Model, Msg(..))


view : Model -> H.Html Msg
view model =
    H.div []
        [ H.div [ A.class "grid-elm" ]
            []
        , CS.makeSelect "Tickers: " FetchCharts model.tickers model.selectedTicker
        ]
