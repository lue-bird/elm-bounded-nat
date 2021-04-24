module MinNatTests exposing (factorial, suite)

{-| Especially type tests.
-}

import Expect
import MinNat
import NNat
import NNats exposing (..)
import Nat exposing (In, Nat, ValueIn, ValueMin)
import Test exposing (Test, describe, test)
import TypeNats exposing (..)
import Typed exposing (val)


suite : Test
suite =
    describe "MinNat"
        [ test "factorial"
            (\() ->
                factorial nat4
                    |> val
                    |> Expect.equal 24
            )
        ]


{-| recurses indefinitely for negative integers
-}
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
        { less = \_ -> nat1 |> MinNat.value
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


listLength : List a -> Nat (ValueMin Nat0)
listLength =
    List.foldl
        (\_ ->
            MinNat.addN nat1
                >> Nat.lowerMin nat0
        )
        (nat0 |> MinNat.value)



-- type tests


testAdd : Nat (ValueMin Nat4)
testAdd =
    Nat.intAtLeast nat3 7
        |> MinNat.add (Nat.intAtLeast nat1 9) nat1


testAddN : Nat (ValueMin Nat15)
testAddN =
    Nat.intAtLeast nat6 7
        |> MinNat.addN nat9


testSubIn : Nat (ValueMin Nat1)
testSubIn =
    Nat.intAtLeast nat6 7
        |> MinNat.sub (Nat.intInRange nat1 nat5 4)
            nat5


testSubN : Nat (ValueMin Nat7)
testSubN =
    Nat.intAtLeast nat16 17
        |> MinNat.subN nat9


testLowerMin : List (Nat (ValueIn Nat3 (Nat4Plus a)))
testLowerMin =
    [ nat3 |> InNat.value
    , nat4 |> InNat.value |> Nat.lowerMin nat3
    ]
