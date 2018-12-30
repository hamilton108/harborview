module Common.Html exposing
    ( Checked(..)
    , HtmlClass(..)
    , HtmlId(..)
    , InputCaption(..)
    , InputType(..)
    , InputValue(..)
    , httpErr2str
    , inputItem
    , labelCheckBox
    , labelInputItem
    , makeInput
    , onChange
    )

import Html as H
import Html.Attributes as A
import Html.Events as E
import Http
import Json.Decode as JD
import VirtualDom as VD


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


type InputType
    = InputType String


type InputValue
    = InputValue String


type InputCaption
    = InputCaption String


type HtmlClass
    = HtmlClass String


type Checked
    = Checked Bool


type HtmlId
    = HtmlId String


inputItem : InputType -> InputValue -> HtmlClass -> Maybe (String -> msg) -> H.Html msg
inputItem (InputType inputType) (InputValue value) (HtmlClass clazz) event =
    case event of
        Nothing ->
            H.input [ A.value value, A.type_ inputType, A.class clazz ] []

        Just event_ ->
            H.input [ A.value value, E.onInput event_, A.type_ inputType, A.class clazz ] []


labelInputItem : InputCaption -> InputType -> InputValue -> HtmlClass -> Maybe (String -> msg) -> H.Html msg
labelInputItem (InputCaption caption) inputType inputValue htmlClass event =
    H.div
        [ A.class "form-group" ]
        [ H.label [ A.class "control-label" ] [ H.text caption ]
        , inputItem inputType inputValue htmlClass event
        ]



{-
     <div class="checkbox">
       <label><input type="checkbox"> Remember me</label>
     </div>

    <div class="custom-control custom-checkbox">
       <input type="checkbox" class="custom-control-input" id="defaultChecked2" checked>
       <label class="custom-control-label" for="defaultChecked2">Default checked</label>
   </div>


                <div class="form-group">
                    <div class="checkbox">
                        <label for="check">
                            <input type="checkbox" id="check" />
                            <span class="fake-input"></span>
                            <span class="fake-label">Option 2</span>
                        </label>
                    </div>
                </div>
-}


labelCheckBox : HtmlId -> InputCaption -> Checked -> msg -> H.Html msg
labelCheckBox (HtmlId htmlId) (InputCaption caption) (Checked isChecked) event =
    H.div [ A.class "form-group" ]
        [ H.div [ A.class "checkbox" ]
            [ H.label [ A.for htmlId ]
                [ H.input [ A.type_ "checkbox", A.checked isChecked, E.onClick event, A.id htmlId ] []
                , H.span [ A.class "fake-input" ] []
                , H.span [ A.class "fake-label" ] [ H.text caption ]
                ]
            ]
        ]



{-
   labelCheckBox : InputCaption -> Checked -> msg -> H.Html msg
   labelCheckBox (InputCaption caption) (Checked isChecked) event =
       H.div
           [ A.class "form-check abc-checkbox" ]
           [ H.input [ E.onClick event, A.checked isChecked, A.id "ax", A.type_ "checkbox", A.class "form-check-input" ] []
           , H.label [ A.class "form-check-label", A.for "ax" ] [ H.text caption ]
           ]



      labelCheckBox : InputCaption -> msg -> H.Html msg
      labelCheckBox (InputCaption caption) event =
          H.div
              [ A.class "checkbox" ]
              [ H.label []
                  [ H.input [ E.onClick event, A.type_ "checkbox" ] [ H.text caption ]
                  ]
              ]
-}


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
