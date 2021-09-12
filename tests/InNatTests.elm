module InNatTests exposing (suite, toDigit)

{-| Especially type tests.
-}

import Expect
import InNat
import Nat exposing (ArgIn, In, Min, Nat)
import Nats exposing (..)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "InNat"
        [ describe "toDigit"
            [ test "from invalid char"
                (\() ->
                    [ 'a', '/', ':' ]
                        |> List.map toDigit
                        |> Expect.equalLists
                            (List.repeat 3 Nothing)
                )
            , test "from valid char"
                (\() ->
                    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
                        |> List.map toDigit
                        |> Expect.equalLists
                            (Nat.range nat0 nat9 |> List.map Just)
                )
            ]
        ]



--


testAddIn : Nat (In Nat4 (Nat22Plus a_))
testAddIn =
    Nat.intInRange nat3 nat10 7
        |> InNat.addIn nat1 nat12 (Nat.intInRange nat1 nat12 9)


testAdd : Nat (In Nat15 (Nat19Plus a_))
testAdd =
    Nat.intInRange nat6 nat10 7
        |> InNat.add nat9


testSubIn : Nat (In Nat1 (Nat9Plus a_))
testSubIn =
    Nat.intInRange nat6 nat10 7
        |> InNat.subIn nat1 nat5 (Nat.intInRange nat1 nat5 4)


testSub : Nat (In Nat7 (Nat11Plus a_))
testSub =
    Nat.intInRange nat16 nat20 17
        |> InNat.sub nat9


rgbPer100 :
    Nat (ArgIn rMin_ Nat100 ifRN_)
    -> Nat (ArgIn gMin_ Nat100 ifGN_)
    -> Nat (ArgIn bMin_ Nat100 ifBN_)
    -> ()
rgbPer100 _ _ _ =
    ()


grey : Float -> ()
grey float =
    let
        greyLevel =
            Nat.intInRange nat0
                nat100
                (float * 100 |> round)
    in
    rgbPer100 greyLevel greyLevel greyLevel


toDigit : Char -> Maybe (Nat (In Nat0 (Nat9Plus a_)))
toDigit char =
    case
        (Char.toCode char - Char.toCode '0')
            |> Nat.isIntInRange nat0 nat9
    of
        Nat.InRange digit ->
            Just digit

        Nat.BelowRange _ ->
            Nothing

        Nat.AboveRange _ ->
            Nothing
