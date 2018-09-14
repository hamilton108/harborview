module Common.Html exposing (..)

import Http
import Html
import VirtualDom as VD
import Json.Decode as JD
import Html.Events as E


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


onChange : (String -> a) -> Html.Attribute a
onChange tagger =
    E.on "change" (JD.map tagger E.targetValue)



-- onChange : (a -> msg) -> Html.Attribute msg
-- onChange tagger =
--     E.on "change" (JD.succeed tagger)
