module N.Test exposing (suite)

import Expect
import N exposing (Add1, Add10, Add9, In, Min, N, To, Up, n0, n1, n3, n9)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "N"
        [ maximumUnconstrainedTest
        , maximumConstrainedTest
        ]



--


factorial : N (In min_ max_) -> N (Min (Up x To (Add1 x)))
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


listLength : List a_ -> N (Min (Up x To x))
listLength =
    List.foldl
        (\_ -> N.minAdd n1 >> N.minDown n1)
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
                (N (Min (Up maxX To (Add10 maxX))))
            )
            (N (In (Up minX To minX) (Up maxX To (Add9 maxX))))
toDigit char =
    ((char |> Char.toCode) - ('0' |> Char.toCode))
        |> N.intIsIn ( n0, n9 )



--


factorialBody : N (In min_ max_) -> N (Min (Up x To (N.Add1 x)))
factorialBody x =
    case x |> N.isAtLeast n1 of
        Err _ ->
            n1 |> N.maxNo

        Ok atLeast1 ->
            factorial (atLeast1 |> N.minSub n1)
                |> N.mul atLeast1
