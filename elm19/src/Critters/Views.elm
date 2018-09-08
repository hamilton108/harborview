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
            , H.th [] [ H.text "Deny.oid" ]
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
            , H.td [] [ H.text "-" ]
            ]

        Just c ->
            [ H.td [] [ H.text (String.fromInt c.oid) ]
            , H.td [] [ H.text (String.fromInt c.sellVolume) ]
            , H.td [] [ H.text (String.fromInt c.status) ]
            , H.td [] [ H.a [ A.href "#", A.class "newaccrule href-td" ] [ H.text "New Acc" ] ]
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
            , H.td [] [ H.a [ A.href "#", A.class "newdnyrule href-td" ] [ H.text "New Deny" ] ]
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


{-| Return H.tr [][ H.td [][], .. ]
-}
critAccDenyTr : Maybe Critter -> Maybe AccRule -> Maybe DenyRule -> H.Html Msg
critAccDenyTr crit acc dny =
    let
        tdRow =
            List.concat [ critterPart crit, accPart acc, denyPart dny ]
    in
        H.tr [] tdRow


denyTr : DenyRule -> H.Html Msg
denyTr dny =
    let
        tdRow =
            List.concat [ critterPart Nothing, accPart Nothing, denyPart (Just dny) ]
    in
        H.tr [] tdRow


critAccTr : Maybe Critter -> AccRule -> List (H.Html Msg)
critAccTr crit acc =
    case acc.denyRules of
        Nothing ->
            let
                tdRow =
                    List.concat [ critterPart crit, accPart (Just acc), denyPart Nothing ]
            in
                Debug.log "Nothing"
                    [ H.tr [] tdRow ]

        Just dnys ->
            case dnys of
                [] ->
                    let
                        tdRow =
                            List.concat [ critterPart crit, accPart (Just acc), denyPart Nothing ]
                    in
                        [ H.tr [] tdRow ]

                [ dny ] ->
                    let
                        tdRow =
                            List.concat [ critterPart crit, accPart (Just acc), denyPart (Just dny) ]
                    in
                        Debug.log "[ dny ]"
                            [ H.tr [] tdRow ]

                x :: xs ->
                    let
                        firstRow =
                            critAccDenyTr crit (Just acc) (Just x)

                        restRows =
                            List.map denyTr xs

                        -- List.concat [ critterPart crit, accPart (Just acc), denyPart (Just x) ]
                    in
                        firstRow :: restRows



{-
   case crit.accRules of
       Nothing ->
           let
   H.tr [] (List.concat [ critterPart crit, accPart (Just acc), denyPart Nothing ])
-}


{-| Return a list of H.tr [][ H.td [][], .. ]
-}
critterRows : Critter -> List (H.Html Msg)
critterRows crit =
    case crit.accRules of
        Nothing ->
            let
                tdRow =
                    List.concat [ critterPart (Just crit), accPart Nothing, denyPart Nothing ]
            in
                [ H.tr [] tdRow ]

        Just accs ->
            case accs of
                [] ->
                    [ critAccDenyTr (Just crit) Nothing Nothing ]

                [ acc ] ->
                    critAccTr (Just crit) acc

                x :: xs ->
                    let
                        firstRow =
                            critAccTr (Just crit) x

                        --   critAccDenyTr (Just crit) (Just x) Nothing
                    in
                        List.concat [ firstRow, List.concat (List.map (critAccTr Nothing) xs) ]


critterArea : OptionPurchase -> List (H.Html Msg)
critterArea opx =
    case opx.critters of
        Nothing ->
            [ H.tr [] [] ]

        Just c ->
            List.concat (List.map critterRows c)



{-
   let
       c0 =
           List.head c
   in
       case c0 of
           Nothing ->
               [ H.tr [] [] ]

           Just c0x ->
               critterRows c0x
-}
{-
   case c of
       [] ->
           [ H.tr [] [] ]

       [ c0 ] ->
           [ H.tr [] (List.concat [ critterPart (Just c0), accPart Nothing, denyPart Nothing ]) ]

       x :: xs ->
           [ H.tr [] (List.concat [ critterPart (Just x), accPart Nothing, denyPart Nothing ]) ]

-}
{-
   let
       c0 =
           List.head c
   in
       H.tr [] (List.concat [ critterPart c0, accPart Nothing, denyPart Nothing ])
-}


details : OptionPurchase -> H.Html Msg
details opx =
    H.details []
        [ H.summary [] [ H.text ("[ " ++ String.fromInt opx.oid ++ "  ] " ++ opx.ticker) ]
        , H.table [ A.class "table" ]
            [ tableHeader
            , H.tbody [] (critterArea opx)
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
