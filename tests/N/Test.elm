module N.Test exposing (suite)

import Expect
import N exposing (Add1, Add10, Add9, In, Min, N, To, Up, Up0, Up1, Up10, Up9, n0, n1, n3, n9)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "N"
        [ maximumUnconstrainedTest
        , maximumConstrainedTest
        , test "infinity == infinity"
            (\() ->
                (N.differenceInfinity |> N.differenceToInt |> toFloat)
                    |> Expect.within (Expect.Absolute 0.1)
                        (N.differenceInfinity |> N.differenceToInt |> toFloat)
            )
        , test "Value == Value"
            (\() ->
                (n9 |> N.toValue)
                    |> Expect.equal
                        (n9 |> N.toValue)
            )
        ]



--


factorial : N (In min_ max_) -> N (Min (Up1 x_))
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
                    -- == n6 |> N.minTo n1 |> N.maxToInfinity
                    |> N.toInt
                    |> Expect.equal 6
            )
        ]



--


listLength : List a_ -> N (Min (Up0 x_))
listLength =
    List.foldl
        (\_ -> N.addMin n1 >> N.minDown n1)
        (n0 |> N.maxToInfinity)


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
                (N (Min (Up10 maxX)))
            )
            (N (In (Up0 minX_) (Up9 maxX)))
toDigit char =
    ((char |> Char.toCode) - ('0' |> Char.toCode))
        |> N.intIsIn ( n0, n9 )



--


factorialBody : N (In min_ max_) -> N (Min (Up x To (N.Add1 x)))
factorialBody x =
    case x |> N.isAtLeast n1 of
        Err _ ->
            n1 |> N.maxToInfinity

        Ok atLeast1 ->
            factorial (atLeast1 |> N.subtractMin n1)
                |> N.multiplyBy atLeast1
