module N.Test exposing (suite)

import Expect
import N exposing (Diff, In, Is, Min, N, To, toInt)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "N"
        [ maximumUnconstrainedTest
        , maximumConstrainedTest
        , nDiffTest
        ]


nDiffTest : Test
nDiffTest =
    describe "NDiff"
        [ test "add & sub"
            (\() ->
                n11
                    |> N.diffAdd ( n9, n9 )
                    |> Expect.equal n20
            )
        , test "sub"
            (\() ->
                n11
                    |> N.diffSub ( n9, n9 )
                    |> Expect.equal n2
            )
        ]


test0 :
    N
        (In
            (N160Plus N160)
            (N160Plus (N160Plus a_))
            (Is
                (Diff a To (N160Plus (N160Plus a)))
                (Diff b To (N160Plus (N160Plus b)))
            )
        )
test0 =
    n160 |> N.diffAdd ( n160, n160 )


test1 :
    N
        (In
            (N160Plus N160)
            (N160Plus (N160Plus a_))
            (Is
                (Diff a To (N160Plus (N160Plus a)))
                (Diff b To (N160Plus (N160Plus b)))
            )
        )
test1 =
    n160 |> N.diffAdd ( n160, n160 )


test2 :
    N
        (In
            (N160Plus N160)
            (N160Plus (N160Plus a_))
            (Is
                (Diff a To (N160Plus (N160Plus a)))
                (Diff b To (N160Plus (N160Plus b)))
            )
        )
test2 =
    n160 |> N.diffAdd ( n160, n160 )


test3 :
    N
        (In
            (N160Plus N159)
            (N160Plus (N159Plus a_))
            (Is
                (Diff a To (N160Plus (N159Plus a)))
                (Diff b To (N160Plus (N159Plus b)))
            )
        )
test3 =
    n160 |> N.diffAdd ( n159, n159 )


testBig :
    N
        (In
            (N160Plus (N159Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus N160)))))))
            (N160Plus (N159Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus a_))))))))
            (Is
                (Diff a To (N160Plus (N159Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus a)))))))))
                (Is b To (N160Plus (N159Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus (N160Plus b)))))))))
            )
        )
testBig =
    test0
        |> N.diffAdd ( test1, test1 )
        |> N.diffAdd ( test2, test2 )
        |> N.diffAdd ( test3, test3 )



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
        , test "ultraSafeFactorial"
            (\() ->
                ultraSafeFactorial n4
                    |> Expect.equal (n24 |> N.noMax |> N.minLower n1)
            )
        ]


listLength : List a_ -> N (Min N0)
listLength =
    List.foldl
        (\_ ->
            N.minAdd n1
                >> N.minLower n0
        )
        (n0 |> N.noMax)


{-| recurses indefinitely for negative integers
-}
intFactorial : Int -> Int
intFactorial x =
    if x == 0 then
        1

    else
        x * intFactorial (x - 1)


factorial : N (In min_ max_ difference_) -> N (Min N1)
factorial =
    factorialBody


factorialBody : N (In min_ max_ difference_) -> N (Min N1)
factorialBody x =
    case x |> N.minIsAtLeast n1 { lowest = n0 } of
        N.Below _ ->
            N.noMax n1

        N.EqualOrGreater atLeast1 ->
            N.mul atLeast1
                (factorial
                    (atLeast1 |> N.minSub n1)
                )


ultraSafeFactorial : N (In min_ N18 difference_) -> N (Min N1)
ultraSafeFactorial =
    factorial


minAddMinTest : N (Min N4)
minAddMinTest =
    7
        |> N.intAtLeast n3
        |> N.minAddMin n1 (N.intAtLeast n1 9)


minAddTest : N (Min N15)
minAddTest =
    7
        |> N.intAtLeast n6
        |> N.minAdd n9


testSubN : N (Min N7)
testSubN =
    17
        |> N.intAtLeast n16
        |> MinDiffOldat.sub n9


minLowerTest : List (N (In N3 (N4Plus a_) {}))
minLowerTest =
    [ n3 |> N.noMax
    , n4 |> N.minLower n3
    ]



--


maximumConstrainedTest : Test
maximumConstrainedTest =
    describe "InDiff"
        [ describe "toDigit"
            [ test "from invalid char"
                (\() ->
                    [ 'a', '/', ':' ]
                        |> List.map toDigit
                        |> Expect.equalLists
                            (List.repeat 3 Nothing)
                )
            , test "from valid char"
                (\() ->
                    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
                        |> List.map toDigit
                        |> Expect.equalLists
                            (N.range n0 n9 |> List.map Just)
                )
            ]
        ]



--


testAddIn : N (In N4 (N22Plus a_))
testAddIn =
    N.intInRange n3 n10 7
        |> N.inAddIn n1 n12 (N.intInRange n1 n12 9)


testInAdd : N (In N15 (N19Plus a_))
testInAdd =
    N.intInRange n6 n10 7
        |> N.inAdd n9


testInSubIn : N (In N1 (N9Plus a_) {})
testInSubIn =
    N.intInRange n6 n10 7
        |> N.inSubIn n1 n5 (N.intInRange n1 n5 4)


testSub : N (In N7 (N11Plus a_) {})
testSub =
    N.intInRange n16 n20 17
        |> N.inSub n9


rgbPer100 :
    N (In rMin_ N100 ifRN_)
    -> N (In gMin_ N100 ifGN_)
    -> N (In bMin_ N100 ifBN_)
    -> ()
rgbPer100 _ _ _ =
    ()


grey : Float -> ()
grey float =
    let
        greyLevel =
            N.intInRange ( n0, n100 ) (float * 100 |> round)
    in
    rgbPer100 greyLevel greyLevel greyLevel


toDigit : Char -> Maybe (N (In N0 (N9Plus a_) {}))
toDigit char =
    case
        (Char.toCode char - Char.toCode '0')
            |> N.isIntInRange n0 n9
    of
        N.InRange digit ->
            digit |> Just

        N.BelowRange _ ->
            Nothing

        N.AboveRange _ ->
            Nothing
