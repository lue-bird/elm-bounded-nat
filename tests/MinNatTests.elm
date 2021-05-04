module MinNatTests exposing (suite)

{-| Especially type tests.
-}

import Expect
import InNat
import MinNat
import NNats exposing (..)
import Nat exposing (ArgIn, In, Min, Nat)
import Test exposing (Test, describe, test)
import TypeNats exposing (..)
import Typed exposing (val)


suite : Test
suite =
    describe "MinNat"
        [ test "list length"
            (\() ->
                listLength [ 1, 2, 3, 4 ]
                    |> val
                    |> Expect.equal 4
            )
        , test "ultraSafeFactorial"
            (\() ->
                ultraSafeFactorial nat4
                    |> Expect.equal (nat24 |> MinNat.value |> Nat.lowerMin nat1)
            )
        ]


listLength : List a -> Nat (Min Nat0)
listLength =
    List.foldl
        (\_ ->
            MinNat.addN nat1
                >> Nat.lowerMin nat0
        )
        (nat0 |> MinNat.value)



--recurses idefinitely for negative integers


intFactorial : Int -> Int
intFactorial x =
    if x == 0 then
        1

    else
        x * intFactorial (x - 1)


factorial : Nat (ArgIn min max maybeN) -> Nat (Min Nat1)
factorial =
    let
        factorialHelp x =
            case x |> MinNat.isAtLeast nat1 { min = nat0 } of
                Nat.Below _ ->
                    MinNat.value nat1

                Nat.EqualOrGreater atLeast1 ->
                    Nat.mul atLeast1
                        (factorial
                            (atLeast1 |> MinNat.subN nat1)
                        )
    in
    Nat.lowerMin nat0 >> factorialHelp


ultraSafeFactorial : Nat (ArgIn min Nat18 maybeN) -> Nat (Min Nat1)
ultraSafeFactorial =
    factorial


testAdd : Nat (Min Nat4)
testAdd =
    Nat.intAtLeast nat3 7
        |> MinNat.add (Nat.intAtLeast nat1 9) nat1


testAddN : Nat (Min Nat15)
testAddN =
    Nat.intAtLeast nat6 7
        |> MinNat.addN nat9


testSubIn : Nat (Min Nat1)
testSubIn =
    Nat.intAtLeast nat6 7
        |> MinNat.sub (Nat.intInRange nat1 nat5 4)
            nat5


testSubN : Nat (Min Nat7)
testSubN =
    Nat.intAtLeast nat16 17
        |> MinNat.subN nat9


testLowerMin : List (Nat (In Nat3 (Nat4Plus a)))
testLowerMin =
    [ nat3 |> InNat.value
    , nat4 |> Nat.lowerMin nat3
    ]
