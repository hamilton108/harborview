module Common.Html exposing (..)

import Http
import Html as H
import VirtualDom as VD
import Json.Decode as JD
import Html.Events as E
import Html.Attributes as A


httpErr2str : Http.Error -> String
httpErr2str err =
    case err of
        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "NetworkError"

        Http.BadUrl s ->
            "BadUrl: " ++ s

        Http.BadStatus r ->
            "BadStatus: "

        Http.BadPayload s r ->
            "BadPayload: " ++ s


onChange : (String -> a) -> H.Attribute a
onChange tagger =
    E.on "change" (JD.map tagger E.targetValue)



-- onChange : (a -> msg) -> Html.Attribute msg
-- onChange tagger =
--     E.on "change" (JD.succeed tagger)
-- makeInput : (String -> a) -> String -> VD.Node a


makeInput : String -> (String -> msg) -> String -> H.Html msg
makeInput caption msg initVal =
    H.span
        [ A.class "form-group" ]
        [ H.label [] [ H.text caption ]
        , H.input
            [ onChange msg
            , A.class "form-control"
            , A.value initVal
            ]
            []
        ]
