module Common.Select exposing (..)

import Http
import VirtualDom as VD
import Html as H
import Html.Attributes as A
import Common.Html as W


type alias SelectItem =
    { val : String
    , txt : String
    }


type alias SelectItems =
    List SelectItem


emptySelectOption : VD.Node a
emptySelectOption =
    H.option
        [ A.value "-1"
        ]
        [ H.text "-" ]


makeSelectOption : Maybe String -> SelectItem -> VD.Node a
makeSelectOption selected item =
    case selected of
        Nothing ->
            H.option
                [ A.value item.val
                ]
                [ H.text item.txt ]

        Just sel ->
            H.option
                [ A.value item.val
                , A.selected (sel == item.val)
                ]
                [ H.text item.txt ]


makeSelect : String -> (String -> a) -> SelectItems -> Maybe String -> VD.Node a
makeSelect caption msg payload selected =
    let
        makeSelectOption_ =
            makeSelectOption selected

        px =
            emptySelectOption :: List.map makeSelectOption_ payload

        {-
           case payload of
               Just p ->
                   emptySelectOption :: List.map makeSelectOption_ p

               Nothing ->
                   []
        -}
    in
        H.span [ A.class "form-group" ]
            [ H.label [] [ H.text caption ]
            , H.select
                [ W.onChange msg
                , A.class "form-control"
                ]
                px
            ]
