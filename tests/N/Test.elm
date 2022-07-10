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


diffSubTypeChecks : Expectation
diffSubTypeChecks =
    n11
        |> N.diffSub ( n9, n9 )
        |> Expect.equal n2


diffAddTypeChecks : Expectation
diffAddTypeChecks =
    n11
        |> N.diffAdd ( n3, n3 )
        |> Expect.equal n14



--


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
                    -- == n6 |> N.minDown n1 |> N.noMax
                    |> N.toInt
                    |> Expect.equal 6
            )
        ]


listLength : List a_ -> N (Min N0)
listLength =
    List.foldl
        (\_ -> N.minAdd n1 >> N.minDown n0)
        (n0 |> N.noMax)


factorial : N (In min_ max_ difference_) -> N (Min N1)
factorial =
    factorialBody


factorialBody : N (In min_ max_ difference_) -> N (Min N1)
factorialBody x =
    case x |> N.isAtLeast n1 of
        Err _ ->
            n1 |> N.noMax

        Ok atLeast1 ->
            factorial (atLeast1 |> N.minSub n1)
                |> N.mul atLeast1



--


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


addAtLeastTest : N (Min N4)
addAtLeastTest =
    7
        |> N.intAtLeast n3
        |> N.addAtLeast n1 (N.intAtLeast n1 9)


minAddTest : N (Min N15)
minAddTest =
    7
        |> N.intAtLeast n6
        |> N.minAdd n9


minSubTest : N (Min N7)
minSubTest =
    17
        |> N.intAtLeast n16
        |> N.minSub n9


minDownTest : List (N (In N3 (Add4 (N0able a_ Possibly)) {}))
minDownTest =
    [ n3 |> N.noDiff
    , n4 |> N.minDown n3
    ]


addInTest : N (In N4 (Add16 a_) {})
addInTest =
    N.intIn ( n3, n10 ) 7
        |> N.addIn ( n1, n6 ) (N.intIn ( n1, n6 ) 5)


addTest : N (In N11 (Add16 a_) {})
addTest =
    N.intIn ( n2, n7 ) 7
        |> N.add n9


subInTest : N (In N1 (Add9 a_) {})
subInTest =
    N.intIn ( n6, n10 ) 7
        |> N.subIn ( n1, n5 ) (N.intIn ( n1, n5 ) 4)


subTest : N (In N7 (Add11 a_) {})
subTest =
    N.intIn ( n12, n16 ) 1
        |> N.sub n5


toDigit :
    Char
    ->
        Result
            (N.BelowOrAbove
                Int
                (N (Min N10))
            )
            (N (In N0 (Add9 atLeast_) {}))
toDigit char =
    ((char |> Char.toCode) - ('0' |> Char.toCode))
        |> N.intIsIn ( n0, n9 )
        |> Result.map (N.maxOpen n9)
