module InNatTests exposing (suite)

{-| Especially type tests.
-}

import Expect
import InNat
import NNats exposing (..)
import Nat exposing (ArgIn, In, Min, Nat)
import Test exposing (Test, describe, test)
import TypeNats exposing (..)


suite : Test
suite =
    describe "InNat"
        []



--


testAdd : Nat (In Nat4 (Nat22Plus a))
testAdd =
    Nat.intInRange nat3 nat10 7
        |> InNat.add (Nat.intInRange nat1 nat12 9) nat1 nat12


testAddN : Nat (In Nat15 (Nat19Plus a))
testAddN =
    Nat.intInRange nat6 nat10 7
        |> InNat.addN nat9


testSub : Nat (In Nat1 (Nat9Plus a))
testSub =
    Nat.intInRange nat6 nat10 7
        |> InNat.sub (Nat.intInRange nat1 nat5 4) nat1 nat5


testSubN : Nat (In Nat7 (Nat11Plus a))
testSubN =
    Nat.intInRange nat16 nat20 17
        |> InNat.subN nat9


rgbPer100 :
    Nat (ArgIn redMin Nat100 maybeN)
    -> Nat (ArgIn greenMin Nat100 maybeN)
    -> Nat (ArgIn blueMin Nat100 maybeN)
    -> ()
rgbPer100 _ _ _ =
    ()


grey : Float -> ()
grey float =
    let
        greyLevel =
            float
                * 100
                |> round
                |> Nat.intInRange nat0 nat100
    in
    rgbPer100 greyLevel greyLevel greyLevel
