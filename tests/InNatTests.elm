module InNatTests exposing (suite)

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
        []



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
