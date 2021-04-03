module InNatTests exposing (suite)

{-| Especially type tests.
-}

import Expect
import InNat
import MinNat
import MinNatTests
import NNat
import NNats exposing (..)
import Nat exposing (Nat)
import Nat.Bound exposing (..)
import Test exposing (Test, describe, test)
import TypeNats exposing (..)


suite : Test
suite =
    describe "InNat"
        [ describe "recursive"
            [ test "ultraSafeFactorial"
                (\() ->
                    ultraSafeFactorial nat4
                        |> Nat.toInt
                        |> Expect.equal 24
                )
            ]
        ]



--recurses idefinitely for negative integers


intFactorial : Int -> Int
intFactorial x =
    if x == 0 then
        1

    else
        x * intFactorial (x - 1)


factorialHelp : Nat (In Nat0 max maybeN) -> Nat (ValueMin Nat1)
factorialHelp =
    MinNat.isAtLeast nat1
        { min = nat0 }
        { less = \_ -> nat1 |> Nat.toMin
        , equalOrGreater =
            \atLeast1 ->
                atLeast1
                    |> Nat.mul
                        (factorial
                            (atLeast1 |> MinNat.subN nat1)
                        )
        }


factorial : Nat (In min max maybeN) -> Nat (ValueMin Nat1)
factorial =
    Nat.lowerMin nat0 >> factorialHelp


ultraSafeFactorial : Nat (In min Nat18 maybeN) -> Nat (ValueMin Nat1)
ultraSafeFactorial =
    MinNatTests.factorial



--


testAdd : Nat (ValueIn Nat4 (Nat22Plus a))
testAdd =
    Nat.intInRange nat3 nat10 7
        |> InNat.add (Nat.intInRange nat1 nat12 9) nat1 nat12


testAddN : Nat (ValueIn Nat15 (Nat19Plus a))
testAddN =
    Nat.intInRange nat6 nat10 7
        |> InNat.addN nat9


testSub : Nat (ValueIn Nat1 (Nat9Plus a))
testSub =
    Nat.intInRange nat6 nat10 7
        |> InNat.sub (Nat.intInRange nat1 nat5 4) nat1 nat5


testSubN : Nat (ValueIn Nat7 (Nat11Plus a))
testSubN =
    Nat.intInRange nat16 nat20 17
        |> InNat.subN nat9


rgbPer100 :
    Nat (In redMin Nat100 maybeN)
    -> Nat (In greenMin Nat100 maybeN)
    -> Nat (In blueMin Nat100 maybeN)
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
