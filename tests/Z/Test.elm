module Z.Test exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Z exposing (Add1, Add10, Add9, In, Min, To, Up, Z, n0, n1, n3, n9)


suite : Test
suite =
    describe "Z"
        [ maximumUnconstrainedTest
        , maximumConstrainedTest
        ]



--


factorial : Z (In min_ max_) -> Z (Min (Up x To (Add1 x)))
factorial =
    factorialBody


maximumUnconstrainedTest : Test
maximumUnconstrainedTest =
    describe "maximum unconstrained"
        [ test "list length"
            (\() ->
                listLength [ 1, 2, 3, 4 ]
                    |> Z.toInt
                    |> Expect.equal 4
            )
        , test "factorial"
            (\() ->
                factorial n3
                    -- == n6 |> Z.min n1 |> Z.maxNo
                    |> Z.toInt
                    |> Expect.equal 6
            )
        ]



--


listLength : List a_ -> Z (Min (Up x To x))
listLength =
    List.foldl
        (\_ -> Z.minAdd n1 >> Z.minDown n1)
        (n0 |> Z.maxNo)


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
                        -- == Z.up n10 |> List.map Ok
                        |> List.map (Result.map Z.toInt)
                        |> Expect.equalLists
                            (List.range 0 9 |> List.map Ok)
                )
            ]
        ]


toDigit :
    Char
    ->
        Result
            (Z.BelowOrAbove
                Int
                (Z (Min (Up maxX To (Add10 maxX))))
            )
            (Z (In (Up minX To minX) (Up maxX To (Add9 maxX))))
toDigit char =
    ((char |> Char.toCode) - ('0' |> Char.toCode))
        |> Z.intIsIn ( n0, n9 )



--


factorialBody : Z (In min_ max_) -> Z (Min (Up x To (Z.Add1 x)))
factorialBody x =
    case x |> Z.isAtLeast n1 of
        Err _ ->
            n1 |> Z.maxNo

        Ok atLeast1 ->
            factorial (atLeast1 |> Z.minSub n1)
                |> Z.mul atLeast1
