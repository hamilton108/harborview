module Critters.Views exposing (..)

import Common.Buttons as BTN
import Critters.Types
    exposing
        ( AccRule
        , Critter
        , DenyRule
        , Model
        , Msg(..)
        , OptionPurchase
        , OptionPurchases
        , rtypDesc
        )
import Html as H
import Html.Attributes as A


{-
   <details><summary>[ 44 ] YAR8L240</summary>
       <table class="table">
           <thead>
           <tr>
               <th>Oid</th>
               <th>Sell volume</th>
               <th>Status</th>
               <th>-</th>
               <th>Acc.oid</th>
               <th>Rtyp</th>
               <th>Desc</th>
               <th>Value</th>
               <th>Active</th>
               <th>-</th>
               <th>Deny oid</th>
               <th>Rtyp</th>
               <th>Desc</th>
               <th>Value</th>
               <th>Active</th>
               <th>Memory</th>
           </tr>
           </thead>
           <tbody>


           <tr>
               <td>41</td>
               <td>10</td>
               <td>0</td>

               <td><a href="#dlg-new-accrule" class="newaccrule href-td" data-critid="41" data-puid="44">Acc</a></td>

               <td>68</td>
               <td>1</td>
               <td>Diff from watermark</td>
               <td>2.0</td>


                   <td><input data-oid="68" class="acc-active" type="checkbox" checked></td>



               <td><a href="#dlg-new-dnyrule" class="newdenyrule href-td" data-accid="68" data-puid="44">Deny</a></td>

               <td></td>
               <td></td>
               <td></td>
               <td></td>
                   <td></td>
               <td></td>
           </tr>
         </tbody>
       </table>
   </details>
-}


tableHeader : H.Html Msg
tableHeader =
    H.thead []
        [ H.tr
            []
            [ H.th [] [ H.text "Oid" ]
            , H.th [] [ H.text "Sell" ]
            , H.th [] [ H.text "Status" ]
            , H.th [] [ H.text "-" ]
            , H.th [] [ H.text "Acc.oid" ]
            , H.th [] [ H.text "Rtyp" ]
            , H.th [] [ H.text "Desc" ]
            , H.th [] [ H.text "Value" ]
            , H.th [] [ H.text "Active" ]
            , H.th [] [ H.text "-" ]
            , H.th [] [ H.text "Deny" ]
            , H.th [] [ H.text "Rtyp" ]
            , H.th [] [ H.text "Desc" ]
            , H.th [] [ H.text "Value" ]
            , H.th [] [ H.text "Active" ]
            , H.th [] [ H.text "Memory" ]
            ]
        ]



{-

   accRow : AccRule -> List (H.Html Msg)
   accRow acc =
       [ H.td [] [ H.text (toString acc.oid) ]
       , H.td [] [ H.text (toString acc.rtyp) ]
       , H.td [] [ H.text (rtypDesc acc.rtyp) ]
       , H.td [] [ H.text (toString acc.value) ]
       , H.td [] [ H.text "Active" ]
       , H.td [] [ H.text "New Deny" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       ]


   accDenyRow : AccRule -> DenyRule -> List (H.Html Msg)
   accDenyRow acc dny =
       [ H.td [] [ H.text (toString acc.oid) ]
       , H.td [] [ H.text (toString acc.rtyp) ]
       , H.td [] [ H.text (rtypDesc acc.rtyp) ]
       , H.td [] [ H.text (toString acc.value) ]
       , H.td [] [ H.text "Active" ]
       , H.td [] [ H.text "New Deny" ]
       , H.td [] [ H.text (toString dny.oid) ]
       , H.td [] [ H.text (toString dny.rtyp) ]
       , H.td [] [ H.text (rtypDesc dny.rtyp) ]
       , H.td [] [ H.text (toString dny.value) ]
       , H.td [] [ H.text "Active" ]
       , H.td [] [ H.text "Memory" ]
       ]


   denyRow : DenyRule -> List (H.Html Msg)
   denyRow dny =
       [ H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text "-" ]
       , H.td [] [ H.text (toString dny.oid) ]
       , H.td [] [ H.text (toString dny.rtyp) ]
       , H.td [] [ H.text (rtypDesc dny.rtyp) ]
       , H.td [] [ H.text (toString dny.value) ]
       , H.td [] [ H.text "Active" ]
       , H.td [] [ H.text "Memory" ]
       ]
-}
{-
   accToRows : AccRule -> H.Html Msg
   accToRows acc =
       case acc.denyRules of
           Nothing ->
               H.tr []
                   [ H.td [] [ H.text (toString acc.oid) ]
                   , H.td [] [ H.text (toString acc.rtyp) ]
                   , H.td [] [ H.text (rtypDesc acc.rtyp) ]
                   , H.td [] [ H.text (toString acc.value) ]
                   , H.td [] [ H.text "Active" ]
                   , H.td [] [ H.text "New Deny" ]
                   , H.td [] []
                   , H.td [] []
                   , H.td [] []
                   , H.td [] []
                   , H.td [] []
                   , H.td [] []
                   ]

           Just dny ->
               let
                   rows =
                       case acc.denyRules of
                           [ dr ] ->
                               H.tr []
                                   [ H.td [] [ H.text (toString acc.oid) ]
                                   , H.td [] [ H.text (toString acc.rtyp) ]
                                   , H.td [] [ H.text (rtypDesc acc.rtyp) ]
                                   , H.td [] [ H.text (toString acc.value) ]
                                   , H.td [] [ H.text "Active" ]
                                   , H.td [] [ H.text "New Deny" ]
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   ]

                           dr :: xs ->
                               H.tr []
                                   [ H.td [] [ H.text (toString acc.oid) ]
                                   , H.td [] [ H.text (toString acc.rtyp) ]
                                   , H.td [] [ H.text (rtypDesc acc.rtyp) ]
                                   , H.td [] [ H.text (toString acc.value) ]
                                   , H.td [] [ H.text "Active" ]
                                   , H.td [] [ H.text "New Deny" ]
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   , H.td [] []
                                   ]
               in
                   rows

-}
{-
   H.tr []
       [ H.button [ A.class "btn btn-success", E.onClick (SellClick x) ] [ H.text ("Sell " ++ oidStr) ]
       , H.td [] [ H.text oidStr ]
-}


critterPart : Maybe Critter -> List (H.Html Msg)
critterPart crit =
    case crit of
        Nothing ->
            [ H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            ]

        Just c ->
            [ H.td [] [ H.text (String.fromInt c.oid) ]
            , H.td [] [ H.text (String.fromInt c.sellVolume) ]
            , H.td [] [ H.text (String.fromInt c.status) ]
            ]


accPart : Maybe AccRule -> List (H.Html Msg)
accPart acc =
    case acc of
        Nothing ->
            [ H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            ]

        Just a ->
            [ H.td [] [ H.text (String.fromInt a.oid) ]
            , H.td [] [ H.text (String.fromInt a.rtyp) ]
            , H.td [] [ H.text (rtypDesc a.rtyp) ]
            , H.td [] [ H.text (String.fromFloat a.value) ]
            , H.td [] [ H.text "Active" ]
            , H.td [] [ H.text "New Deny" ]
            ]


denyPart : Maybe DenyRule -> List (H.Html Msg)
denyPart dny =
    case dny of
        Nothing ->
            [ H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            , H.td [] [ H.text "-" ]
            ]

        Just d ->
            [ H.td [] [ H.text (String.fromInt d.oid) ]
            , H.td [] [ H.text (String.fromInt d.rtyp) ]
            , H.td [] [ H.text (rtypDesc d.rtyp) ]
            , H.td [] [ H.text (String.fromFloat d.value) ]
            , H.td [] [ H.text "Active" ]
            , H.td [] [ H.text "Memory" ]
            ]


critterAccDeny : Maybe Critter -> Maybe AccRule -> Maybe DenyRule -> List (H.Html Msg)
critterAccDeny crit acc dny =
    List.concat [ critterPart crit, accPart acc, denyPart dny ]


critterAccDenys : Maybe Critter -> Maybe AccRule -> List DenyRule -> List (H.Html Msg) -> List (H.Html Msg)
critterAccDenys crit acc dnys result =
    Debug.todo "critterAccDenys"


critterAccs : Maybe Critter -> List AccRule -> List (H.Html Msg) -> List (H.Html Msg)
critterAccs crit accs result =
    case accs of
        [] ->
            result

        [ acc ] ->
            result ++ List.concat [ critterPart crit, accPart (Just acc), denyPart Nothing ]

        x :: xs ->
            let
                firstRow =
                    List.concat [ critterPart crit, accPart (Just x), denyPart Nothing ]
            in
                firstRow ++ critterAccs crit xs result


critterRows : Critter -> List (H.Html Msg)
critterRows crit =
    case crit.accRules of
        Nothing ->
            List.concat [ critterPart (Just crit), accPart Nothing, denyPart Nothing ]

        Just accs ->
            critterAccs (Just crit) accs []



{-
   case accs of
       critterAcc crit acc
       [ acc ] ->
           -- H.tr [] (List.concat [ critterPart (Just crit), accPart acc, denyPart Nothing ])

       x :: xs ->
           H.div [] []
-}
{-
   let
       c =
           critterPart crit

       a =
           accPart acc

       d =
           denyPart dny
   in
       H.tr []
           (List.concat [ c, a, d ])
-}


ca : Model -> List (H.Html Msg)
ca model =
    case model.purchases of
        Nothing ->
            []

        Just p ->
            case List.head p of
                Nothing ->
                    []

                Just p0 ->
                    case p0.critters of
                        Nothing ->
                            []

                        Just c ->
                            -- List.concat (List.map critterRows c)
                            critterPart (List.head c)


critterArea : OptionPurchase -> H.Html Msg
critterArea opx =
    case opx.critters of
        Nothing ->
            H.p [] [ H.text "-" ]

        Just c ->
            let
                c0 =
                    List.head c
            in
                H.tr [] (List.concat [ critterPart c0, accPart Nothing, denyPart Nothing ])



-- (List.concat [ critterPart (Just c0), accPart Nothing, denyPart Nothing ])
-- H.div [] (List.map critterRows c)


details : OptionPurchase -> H.Html Msg
details opx =
    H.details []
        [ H.summary [] [ H.text ("[ " ++ String.fromInt opx.oid ++ "  ] " ++ opx.ticker) ]
        , H.table [ A.class "table" ]
            [ tableHeader
            , H.tbody []
                [ critterArea opx
                ]
            ]
        ]


view : Model -> H.Html Msg
view model =
    let
        ps =
            case
                model.purchases
            of
                Nothing ->
                    []

                Just opxx ->
                    List.map details opxx
    in
        H.div []
            [ H.div [ A.class "grid-elm" ]
                [ H.div [ A.class "form-group form-group--elm" ]
                    [ BTN.button "Paper Critters" PaperCritters ]
                , H.div [ A.class "form-group form-group--elm" ]
                    [ BTN.button "Real Time Critters" RealTimeCritters ]
                , H.div [ A.class "form-group form-group--elm" ]
                    [ BTN.button "New Critter" NewCritter ]
                ]
            , H.div [ A.class "grid-elm" ]
                ps
            ]
