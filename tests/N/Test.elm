module N.Test exposing (suite)

import Expect exposing (Expectation)
import N exposing (Add11, Add16, Add4, Add9, In, Min, N, N0, N0able, N1, N10, N11, N15, N3, N4, N7, n0, n1, n10, n11, n12, n14, n16, n2, n3, n4, n5, n6, n7, n9)
import Possibly exposing (Possibly)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "N"
        [ maximumUnconstrainedTest
        , maximumConstrainedTest
        ]



--


factorial : N (In min_ max_) -> N (Min N1)
factorial =
    factorialBody


maximumUnconstrainedTest : Test
maximumUnconstrainedTest =
    describe "maximum unconstrained"
        [ test "list length"
            (\() ->
                listLength [ 1, 2, 3, 4 ]
                    |> N.toInt
                    |> Expect.equal 4
            )
        , test "factorial"
            (\() ->
                factorial n3
                    -- == n6 |> N.min n1 |> N.maxNo
                    |> N.toInt
                    |> Expect.equal 6
            )
        ]



--


listLength : List a_ -> N (Min N0)
listLength =
    List.foldl
        (\_ -> N.minAdd n1 >> N.min n0)
        (n0 |> N.maxNo)


maximumConstrainedTest : Test
maximumConstrainedTest =
    describe "maximum constraint unknown"
        [ describe "toDigit"
            [ test "from invalid char"
                (\() ->
                    [ 'a', '/', ':' ]
                        |> List.map (toDigit >> Result.toMaybe)
                        |> Expect.equalLists
                            (List.repeat 3 Nothing)
                )
            , test "from valid char"
                (\() ->
                    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
                        |> List.map toDigit
                        -- == N.up n10 |> List.map Ok
                        |> List.map (Result.map N.toInt)
                        |> Expect.equalLists
                            (List.range 0 9 |> List.map Ok)
                )
            ]
        ]


toDigit :
    Char
    ->
        Result
            (N.BelowOrAbove
                Int
                (N (Min N10))
            )
            (N (In N0 (Add9 atLeast_)))
toDigit char =
    ((char |> Char.toCode) - ('0' |> Char.toCode))
        |> N.intIsIn ( n0, n9 )


diffSubTypeChecks : Expectation
diffSubTypeChecks =
    n11
        |> N.subIn ( n9, n9 )
        |> Expect.equal n2



--


factorialBody : N (In min_ max_) -> N (Min N1)
factorialBody x =
    case x |> N.isAtLeast n1 of
        Err _ ->
            n1 |> N.maxNo

        Ok atLeast1 ->
            factorial (atLeast1 |> N.minSub n1)
                |> N.mul atLeast1
