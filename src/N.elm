module N exposing
    ( N
    , In, Min, NoMax, Exactly
    , abs, randomIn, until
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , N0able(..), Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , BelowOrAbove(..)
    , intAtLeast, intIn
    , intIsIn, intIsAtLeast
    , atLeast, atMost
    , is, isIn, isAtLeast, isAtMost
    , add, addAtMost, minAdd
    , sub, minSub, minSubAtMost
    , toPower, remainderBy, mul, div
    , toInt, toFloat
    , min, diffNo, maxNo, max, maxUp
    , MinAndMinAsDifferencesAndMax, Increase(..), To
    , diffAdd, diffSub
    , minimum
    , minimumDifference0, minimumDifference1
    , decreaseByDifference, increaseByDifference
    , differenceDecrease, differenceIncrease
    , minimumDifference0Up, minimumDifference1Up
    , minimumDifference0Down, minimumDifference1Down
    , differencesSwap, subAtMost
    )

{-| Natural numbers within a typed range.

@docs N


# bounds

@docs In, Min, NoMax, Exactly


# create

@docs abs, randomIn, until


# specific numbers

If the package exposed every number 0 → 1000, [tools can become unusably slow](https://github.com/lue-bird/elm-typesafe-array/issues/2).

So only 0 → 16 are exposed, while larger numbers have to be generated locally.

Current method: [generate them](https://lue-bird.github.io/elm-bounded-nat/generate/) into a `module exposing (n500, N500, Add500, ...)` + `import as N exposing (n500, ...)`

In the future, [`elm-generate`](https://github.com/lue-bird/generate-elm) will allow auto-generating via [`elm-review`](https://dark.elm.dmy.fr/packages/jfmengels/elm-review/latest/).


## type `n`

[⏭ skip to last](#N16)

@docs N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16


## type `n +`

[⏭ skip to last](#Add16)

@docs N0able, Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16


## exact

[⏭ skip to last](#n16)

@docs n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16


## compare

@docs BelowOrAbove


### int clamp

@docs intAtLeast, intIn


## int compare

@docs intIsIn, intIsAtLeast


## clamp

@docs atLeast, atMost


## compare maximum constrained

@docs is, isIn, isAtLeast, isAtMost


# alter

@docs add, addAtMost, minAdd
@docs sub, subIn, minSub, minSubAtMost
@docs toPower, remainderBy, mul, div


## broaden

@docs toInt, toFloat


# type information

@docs min, diffNo, maxNo, max, maxUp


# miss operation x?

Anything that can't be expressed with the available operations? → issue/PR


# fancy

Useful for extensions to this library
– building structures like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)

While the internally stored `Int` isn't directly guaranteed to be in bounds by elm,
[`minimum`](#minimum), maximum, [`minimumDifference0`](#minimumDifference0), [`minimumDifference1`](#minimumDifference1)
must be built as actual values checked by the compiler.

@docs MinAndMinAsDifferencesAndMax, Increase, To
@docs diffAdd, diffSub

@docs minimum
@docs minimumDifference0, minimumDifference1

@docs decreaseByDifference, increaseByDifference
@docs differenceDecrease, differenceIncrease
@docs minimumDifference0Up, minimumDifference1Up
@docs minimumDifference0Down, minimumDifference1Down

-}

import Emptiable exposing (Emptiable)
import Help exposing (valueElseOnError)
import N.Internal
import Possibly exposing (Possibly(..))
import Random
import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)
import Stack exposing (Stacked)


{-| A **bounded** natural number `>= 0`


### argument type

    -- ≥ 0, else any limitations allowed
    N range_

    -- ≥ 4
    N (In (Add4 minMinus4_) max_ difference_)

    -- 4 ≤ n ≤ 15
    N (In (Add4 minMinus4_) N15 difference_)

`In (Add4 minMinus4_) N15` says:

  - the minimum-constraint can be `4`|`5`|`6`|...
  - any maximum-constraint greater than `15` is forbidden


### result type

    -- ≥ 4
    N (Min N4)

    -- 2 ≤ n ≤ 12
    N (In N2 (Add12 a_))

`In N2 (Add12 a_)` says:

  - the minimum-constraint can be `4`|`5`|`6`|...
  - any maximum-constraint greater than `15` is forbidden


### stored type

what to put in declared types like `Model`

    -- ≥ 4
    N (Min N4)

    -- 2 ≤ n ≤ 12
    N (In N2 N12)

They are like [result types](#result-type) but without type variables.


### specific number

Numbers [`n0`](#n0), [`n1`](#n1), ... supplied by this library.

The type [`MinAndMinAsDifferencesAndMax`](#MinAndMinAsDifferencesAndMax) `(`[`Increase x0 To nPlusX0`](#Increase)`) ...`
enables adding, subtracting `N<x>` types.
Consider the type an implementation detail.
You can come back to [understand them later](#fancy).

    n3 :
        N
            (MinAndMinAsDifferencesAndMax
                N3
                (Increase x0 To (Add3 x0))
                (Increase x1 To (Add3 x1))
                (Add3 atLeast_)
            )

-}
type alias N range =
    N.Internal.N range


{-| somewhere within a `minimum` & `maximum`

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### `In minimum maximum difference_`

For arguments

    percent : N (In min_ N100 difference_) -> Percent

→ `min ≤ N100`

If you want a number where you just care about the minimum, leave the `max` as a type _variable_.

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

Any natural number:

    N (In min_ max_)

A number, at least 5:

    N (In (Add5 minMinus5_) max_ difference_)

  - `max_` could be a specific maximum or [no maximum at all](#NoMax)


### `In minimum maximum`

A number somewhere within a `minimum` & `maximum`. We don't know it exactly, though

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    N (In N3 (Add5 a_))

-}
type alias In lowestPossibleValue highestPossibleValue =
    MinAndMinAsDifferencesAndMax
        lowestPossibleValue
        (Increase N0 To lowestPossibleValue)
        (Increase N0 To lowestPossibleValue)
        highestPossibleValue


{-| [`In`](#In) with actual known [difference](#Increase)s from variables attached.

TODO: idea: minimumAsDifference0 minimumAsDifference1 → minimumAsDifference maximumAsDifference

  - check if somewhere 2 differences from min are needed

-}
type alias MinAndMinAsDifferencesAndMax minimum minimumAsDifference0 minimumAsDifference1 maximum =
    N.Internal.MinAndMinAsDifferencesAndMax minimum minimumAsDifference0 minimumAsDifference1 maximum


{-| Only **stored / result types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> N (In N0 ??)
                    ↓
    abs : Int -> N (Min N0)

A number `≥ 5` for example:

    N (Min N5)

Every `Min min` is of type `In min ...`.

-}
type alias Min lowestPossibleValue =
    In lowestPossibleValue NoMax


{-| Allow only a specific number.

Useful as a **stored & argument** type in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with [`N`](#N)s.

    byte : Arr (Exactly N8) Bit -> Byte

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s.

    type alias TicTacToeBoard =
        Arr
            (Exactly N3)
            (Arr (Exactly N3) TicTacToField)

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s.

-}
type alias Exactly n =
    In n n


{-| `Increase low To high`: an exact number as the difference `high - low`.

    In
        N5
        (Add5 a_)
        (Is
            (Increase myAge To sistersAge)
            (Increase mothersAge To fathersAge)
        )

  - `myAge + 5 = sistersAge`
  - `mothersAge + 5 = fathersAge`

-}
type Increase low toTag high
    = Difference
        { increase : low -> high
        , decrease : high -> low
        }


differenceFrom0To : min -> Increase (N0able successor_ Possibly) toTag min
differenceFrom0To lowerLimit =
    Difference
        { increase = \_ -> lowerLimit
        , decrease = \_ -> N0 Possible
        }


{-| Just a word in the [type `Increase`](#Increase).

    Increase low To high

→ distance `high - low`.

-}
type To
    = To Never


{-| Flag "The number's maximum limit is unknown".

    type alias Min min =
        In minimum NoMax

is the definition of [`Min`](#Min).

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree childCountMax element
        = Tree
            element
            (Arr
                (In N0 childCountMax)
                (Maybe (Tree childCountMax element))
            )

    type alias TreeBinary element =
        Tree N2 element

    type alias TreeMulti element =
        Tree NoMax element

Remember: ↑ and other [`Min`](#Min)/[`NoMax`](#NoMax) are result/stored types, not argument types.
You can just use a variable `Tree childCountMax_ element` if you don't care about an enforced maximum.

-}
type alias NoMax =
    RecordWithoutConstructorFunction
        { maximumUnknown : () }



--


{-| Add a given [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N).

    between70And100 |> N.add n7
    --: N (In N77 (Add107 a_))

Use [`addAtMost`](#addAtMost)/[`minAdd`](#minAdd) to add an [`N`](#N) in a range.

-}
add :
    N
        (MinAndMinAsDifferencesAndMax
            added
            (Increase min To sumMin)
            (Increase max To sumMax)
            added
        )
    ->
        (N (In min max)
         -> N (In sumMin sumMax)
        )
add toAdd =
    addAtMost toAdd toAdd


{-| Subtract a given [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N).

    between7And10 |> N.sub n7
    --: N (In N0 (Add3 a_))

Use [`subIn`](#subIn) if you want to subtract an [`N`](#N) in a range.

-}
sub :
    N
        (MinAndMinAsDifferencesAndMax
            subtracted
            (Increase differenceMax To max)
            (Increase differenceMin To min)
            subtracted
        )
    ->
        (N (In min max)
         -> N (In differenceMin differenceMax)
        )
sub toSubtract =
    subAtMost toSubtract toSubtract


{-| The absolute value of an `Int` → `≥ 0`

    -4 |> N.abs |> N.toInt --> 4

    16 |> N.abs |> N.toInt --> 16

Really only use this if you want the absolute value.

    badLength =
        List.length >> N.abs

  - maybe, there's a solution that never even theoretically deals with unexpected values:

        mostCorrectLength =
            List.foldl
                (\_ -> N.minAdd n1 >> N.min n0)
                (n0 |> N.maxNo)

  - other times, though, like with `Array.length`, which isn't `O(n)`,
    you can escape with for example

        arrayLength =
            Array.length >> N.intAtLeast n0

-}
abs : Int -> N (Min N0)
abs =
    Basics.abs
        >> minWith (n0 |> minimum)


minWith :
    min
    -> Int
    ->
        N
            (MinAndMinAsDifferencesAndMax
                min
                (Increase N0 To min)
                (Increase N0 To min)
                NoMax
            )
minWith lowerLimit =
    N.Internal.minWith
        lowerLimit
        (differenceFrom0To lowerLimit)
        (differenceFrom0To lowerLimit)


downBelow :
    N (In minimum_ (Add1 maxMinus1))
    -> List (N (In N0 maxMinus1))
downBelow length =
    case length |> isAtLeast n1 of
        Err _ ->
            []

        Ok lengthAtLeast1 ->
            (lengthAtLeast1 |> sub n1)
                :: (lengthAtLeast1 |> minSub n1 |> downBelowRecursive)


downBelowRecursive :
    N (In min_ (Add1 maxMinus1))
    -> List (N (In N0 maxMinus1))
downBelowRecursive length =
    downBelow length


untilReverse :
    N (In min_ max)
    -> Emptiable (Stacked (N (In N0 max))) Never
untilReverse last =
    case last |> isAtLeast n1 of
        Err _ ->
            n0 |> max last |> diffNo |> Stack.only

        Ok lastAtLeast1 ->
            (lastAtLeast1 |> minSub n1 |> untilReverseRecursive)
                |> Stack.onTopLay (last |> min n0)


{-| [`N`](#N)s increasing from `0` to `n`
In the end, there are `n` numbers.

    import Stack

    N.until n6
        |> Stack.map (\_ -> N.add n3)
        --: Emptiable (Stacked (N (In N3 (Add9 a_)))) Never
        |> Stack.map (\_ -> N.toInt)
    --> Stack.topDown 3 [ 4, 5, 6, 7, 8, 9 ]

    N.until atLeast7 |> Stack.map (\_ -> N.minAdd n3)
    --: Emptiable (Stacked (N (Min N10))) Never

[`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/Arr#nats) even knows the length! Try it.

-}
until :
    N (In min_ max)
    -> Emptiable (Stacked (N (In N0 max))) Never
until last =
    untilReverse last |> Stack.reverse


untilReverseRecursive :
    N (In min_ max)
    -> Emptiable (Stacked (N (In N0 max))) Never
untilReverseRecursive =
    untilReverse


{-| Generate a random [`N`](#N) in a range.

    N.randomIn ( n1, n10 )
    --: Random.Generator (N (In N1 (Add10 a_)))

-}
randomIn :
    ( N (In lowerLimitMin upperLimitMin)
    , N (In upperLimitMin upperLimitMax)
    )
    ->
        Random.Generator
            (N (In lowerLimitMin upperLimitMax))
randomIn ( lowestPossible, highestPossible ) =
    Random.int (lowestPossible |> toInt) (highestPossible |> toInt)
        |> Random.map
            (minWith (lowestPossible |> minimum)
                >> N.Internal.maxFrom highestPossible
            )


{-| Compared to a range from a lower to an upper bound, is the `Int` in range, [`BelowOrAbove`](#BelowOrAbove)?

    inputIntJudge : Int -> Result String (N (In N1 (Add10 a_)))
    inputIntJudge int =
        case int |> N.intIsIn ( n1, n10 ) of
            Ok inRange ->
                inRange |> N.max n10 |> Ok
            Err (N.Below _) ->
                Err "must be ≥ 1"
            Err (N.Above _) ->
                Err "must be ≤ 100"

    0 |> inputIntJudge
    --> Err "must be ≥ 1"

-}
intIsIn :
    ( N (In minDownLimit maxUpperLimit)
    , N (In maxUpperLimit maxUpperLimitAtLeast)
    )
    ->
        (Int
         ->
            Result
                (BelowOrAbove
                    Int
                    (N (Min (Add1 maxUpperLimit)))
                )
                (N (In minDownLimit maxUpperLimitAtLeast))
        )
intIsIn ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> Below |> Err

        else if int > (upperLimit |> toInt) then
            int
                |> minWith
                    ((upperLimit |> minimum)
                        |> increaseByDifference (n1 |> minimumDifference0)
                    )
                |> Above
                |> Err

        else
            int
                |> minWith (lowerLimit |> minimum)
                |> N.Internal.maxFrom upperLimit
                |> Ok


{-| If the `Int ≥` a given `minimum`,
return `Ok` with the `N (Min minimum)`,
else `Err` with the input `Int`.

    4 |> N.intIsAtLeast n5
    --: Result Int (N (Min N5))
    --> Err 4

    1234 |> N.intIsAtLeast n5 |> Result.map N.toInt
    --> Ok 1234

-}
intIsAtLeast :
    N (In min max_)
    ->
        (Int
         -> Result Int (N (Min min))
        )
intIsAtLeast minimumLimit =
    \int ->
        if int >= (minimumLimit |> toInt) then
            int
                |> minWith (minimumLimit |> minimum)
                |> Ok

        else
            int |> Err


{-| Create a `N (In ...)` by **clamping** an `Int` between a minimum & maximum.

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`intIsIn`](#intIsIn).

    0
        |> N.intIn ( n3, n12 )
        --: N (In N3 (Add12 a_))
        |> N.toInt
    --> 3

    99
        |> N.intIn ( n3, n12 )
        --: N (In N3 (Add12 a_))
        |> N.toInt
    --> 12

    9
        |> N.intIn ( n3, n12 )
        --: N (In N3 (Add12 a_))
        |> N.toInt
    --> 9


    toDigit : Char -> Maybe (N (In N0 (Add9 atLeast_)))
    toDigit char =
        ((char |> Char.toCode) - ('0' |> Char.toCode))
            |> N.intIsIn ( n0, n9 )
            |> Result.toMaybe

-}
intIn :
    ( N (In lowerLimit upperLimitMin)
    , N (In upperLimitMin upperLimit)
    )
    ->
        (Int
         -> N (In lowerLimit upperLimit)
        )
intIn ( lowerLimit, upperLimit ) =
    intIsIn ( lowerLimit, upperLimit )
        >> valueElseOnError
            (\error ->
                case error of
                    Below _ ->
                        (lowerLimit |> toInt)
                            |> minWith (lowerLimit |> minimum)
                            |> N.Internal.maxFrom upperLimit

                    Above _ ->
                        upperLimit |> min lowerLimit
            )


{-| A `N (Min ...)` from an `Int`; if the `Int < minimum`, `minimum` is returned.

    0
        |> N.intAtLeast n3
        --: N (Min N3)
        |> N.toInt
    --> 3

    9
        |> N.intAtLeast n3
        --: N (Min N3)
        |> N.toInt
    --> 9

You can also use this if you know an `Int` must be at least `minimum`.

But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ -> N.minAdd n1 >> N.min n0)
            (n0 |> N.maxNo)

If you want to handle the case `< minimum` yourself → [`intIsAtLeast`](#intIsAtLeast)

-}
intAtLeast :
    N (In min max_)
    ->
        (Int
         -> N (Min min)
        )
intAtLeast minimumLimit =
    intIsAtLeast minimumLimit
        >> Result.withDefault (minimumLimit |> maxNo)


{-| Return the given number if the [`N`](#N) is less.

    between5And9 |> N.atLeast n10
    --: N (In N10 (Add10 a_))

    n15 |> N.atLeast n10 |> N.toInt
    --> 15

    n5AtLeast |> N.atLeast (n10 |> maxNo)
    --: N (Min N10)

(The type doesn't forbid that the lower limit you're comparing against
is below the current minimum.)

-}
atLeast :
    N (MinAndMinAsDifferencesAndMax minNewMin newMinDiff0 newMinDiff1 max)
    ->
        (N (In min_ max)
         -> N (MinAndMinAsDifferencesAndMax minNewMin newMinDiff0 newMinDiff1 max)
        )
atLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            n
                |> N.Internal.minMap (\_ -> lowerLimit |> minimum)
                |> N.Internal.differencesTo
                    (lowerLimit |> minimumDifference0)
                    (lowerLimit |> minimumDifference1)

        else
            lowerLimit


{-| **Cap** the [`N`](#N) to at most a number.

    between5And15
        |> N.atMost n10
    --: N (In N5 (Add10 a_))

    atLeast5 |> N.atMost n10
    --: N (In N5 (Add10 a_))

(The type doesn't forbid that the upper limit you're comparing against
is above the current maximum.)

-}
atMost :
    N (In min maxCapped)
    ->
        (N (In min max_)
         -> N (In min maxCapped)
        )
atMost upperLimit =
    \n ->
        n
            |> isAtMost upperLimit
            |> valueElseOnError
                (\_ ->
                    upperLimit
                        |> N.Internal.minMap (\_ -> n |> minimum)
                        |> diffNo
                )


{-| Multiply by [`N`](#N) `n ≥ 1`.
we know that if `n ≥ 1`, `x * n ≥ x`.

    atLeast5 |> N.mul n2
    --: N (Min N5)

    atLeast2 |> N.mul n5
    --: N (Min N2)

-}
mul :
    N (In (Add1 multiplicandMinMinus1_) multiplicandMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
mul multiplicand =
    \n ->
        (n |> toInt)
            * (multiplicand |> toInt)
            |> minWith (n |> minimum)


{-| Divide (`//`) by an [`N`](#N) `d ≥ 1`.

  - `/ 0` is impossible
  - `x / d` is at most x

```
atMost7
    |> N.div n3
    --: N (In N0 (Add7 a_))
    |> N.toInt
--> 2
```

-}
div :
    N (In (Add1 divisorMinMinus1_) divisorMax_)
    ->
        (N (In min_ max)
         -> N (In N0 max)
        )
div divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> minWith (n0 |> minimum)
            |> N.Internal.maxFrom n


{-| The remainder after dividing by a [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In N0 (Add3 a_))

-}
remainderBy :
    N (In (Add1 divisorMinMinus1_) (Add1 divisorMaxMinus1))
    ->
        (N (In min_ max_)
         -> N (In N0 divisorMaxMinus1)
        )
remainderBy divisor =
    \n ->
        (n |> toInt)
            |> Basics.remainderBy (divisor |> toInt)
            |> minWith (n0 |> minimum)
            |> N.Internal.maxFrom divisor
            |> N.Internal.maxMap (decreaseByDifference (n1 |> minimumDifference0))


{-| [`N`](#N) Raised to a given power `p ≥ 1`
→ `x ^ p ≥ x`

    atLeast5 |> N.toPower n2
    --: N (Min N5)

    atLeast2 |> N.toPower n5
    --: N (Min N2)

-}
toPower :
    N (In (Add1 exponentMinMinus1_) (Add1 exponentMax_))
    ->
        (N (In min max_)
         -> N (Min min)
        )
toPower exponent =
    \n ->
        (n |> toInt)
            ^ (exponent |> toInt)
            |> minWith (n |> minimum)


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N3)`

    [ atLeast3
    , atLeast4 |> N.min n3
    ]

-}
min :
    N (MinAndMinAsDifferencesAndMax newMin newMinDiff0 newMinDiff1 min)
    ->
        (N (In min max)
         -> N (MinAndMinAsDifferencesAndMax newMin newMinDiff0 newMinDiff1 max)
        )
min newMinimum =
    \n ->
        (n |> toInt)
            |> minWith (newMinimum |> minimum)
            |> N.Internal.maxFrom n
            |> N.Internal.differencesTo
                (newMinimum |> minimumDifference0)
                (newMinimum |> minimumDifference1)


{-| Convert an [`N`](#N) with specific minimum differences it to a `N (In min max)`.

    take : MinAndMinAsDifferencesAndMax min (Diff ...) (Diff ...) max -> ...
    take taken =
        ...
        taken
            -- differences are set in stone to specific type variables
            -- so supplying it to a function that requires `In ...` is impossible
            |> N.diffNo
        ...
    --: N (In N4 (Add4 a_))

A more common example:

    [ in3To10, n3 ]

> all the previous elements in the list are: `N (In N3 N10)`

    [ in3To10
    , n3 |> N.diffNo
    ]

-}
diffNo : N (MinAndMinAsDifferencesAndMax min diff0_ diff1_ max) -> N (In min max)
diffNo =
    \n ->
        (n |> toInt)
            |> minWith (n |> minimum)
            |> N.Internal.maxFrom n


{-| Convert a `N (In min ...)` to a `N (Min min)`.

    between3And10 |> N.maxNo
    --: N (Min N4)

Use it to unify different types of number minimum constraints like

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N1)`

    [ atLeast1
    , between1And10 |> N.maxNo
    ]

-}
maxNo : N (In min max_) -> N (Min min)
maxNo =
    \n ->
        (n |> toInt) |> minWith (n |> minimum)


{-| Make it fit into functions with require a higher maximum.

You should type arguments and stored types as broad as possible.

    onlyAtMost18 : N (In min_ N18 difference_) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the n in `onlyAtMost19`:

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.max n18)

-}
max :
    N (In max maxOpen)
    ->
        (N (MinAndMinAsDifferencesAndMax min minDiff0 minDiff1 max)
         -> N (MinAndMinAsDifferencesAndMax min minDiff0 minDiff1 maxOpen)
        )
max maximumNew =
    N.Internal.maxFrom maximumNew


{-| Have a specific maximum in mind? → [`max`](#max)

Want to increase the upper bound by a fixed amount? ↓

    maxUp4 : N (In min max difference_) -> N (In min (Add4 max))
    maxUp4 =
        N.maxUp n4

When is this useful? Very rarely:

    down :
        N (In min (Add1 maxMinus1) difference_)
        -> List (N (In N0 maxMinus1))
    down length =
        case length |> isAtLeast n1 of
            Err _ ->
                []

            Ok lengthAtLeast1 ->
                let
                    lengthMinus1 =
                        lengthAtLeast1 |> sub n1
                in
                lengthMinus1
                    :: (lengthMinus1
                            -- → In N0 maxMinus1
                            |> maxUp n1
                            |> downRecursive
                       )

(to be fair: here, you're better off using `lengthAtLeast1 |> subMin n1` instead of `lengthMinus1 |> maxUp n1`)

-}
maxUp :
    N
        (MinAndMinAsDifferencesAndMax
            increase_
            (Increase max To maxIncreased)
            diff1_
            increaseAtLeast_
        )
    ->
        (N (In min max)
         -> N (In min maxIncreased)
        )
maxUp maxRelativeIncrease =
    N.Internal.maxMap (increaseByDifference (maxRelativeIncrease |> minimumDifference0))
        >> diffNo


{-| The error result of comparing [`N`](#N)s.

  - `Above`: greater
  - `Below`: less

Values exist for each condition.

-}
type BelowOrAbove below above
    = Below below
    | Above above



-- transform


{-| Drop the range constraints
to feed another library with its `Int` representation.
-}
toInt : N range_ -> Int
toInt =
    N.Internal.toInt


{-| Drop the range constraints
to feed another library with its `Float` representation.
-}
toFloat : N range_ -> Float
toFloat =
    toInt >> Basics.toFloat



--


{-| Is the [`N`](#N) equal to, [`BelowOrAbove`](#BelowOrAbove) a given number?

    giveAPresent { age } =
        case age |> N.is n18 of
            Err (N.Below younger) ->
                toy { age = younger }

            Err (N.Above older) ->
                book { age = older }

            Ok _ ->
                bigPresent

    toy : { age : N (In min_ N17 difference_) } -> Toy

    book :
        { age : N (In (N19 minMinus19_) max_ difference_) }
        -> Book

(The type doesn't forbid that the number you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
is :
    N (In comparedAgainstMin (Add1 comparedAgainstMaxMinus1))
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (N (In min comparedAgainstMaxMinus1))
                    (N (In (Add1 comparedAgainstMin) max))
                )
                (N (In comparedAgainstMin (Add1 comparedAgainstMaxMinus1)))
        )
is comparedAgainst =
    \n ->
        case compare (n |> toInt) (comparedAgainst |> toInt) of
            EQ ->
                comparedAgainst
                    |> Ok

            GT ->
                n
                    |> N.Internal.minMap
                        (\_ ->
                            (comparedAgainst |> minimum)
                                |> increaseByDifference (n1 |> minimumDifference0)
                        )
                    |> diffNo
                    |> Above
                    |> Err

            LT ->
                n
                    |> N.Internal.maxFrom comparedAgainst
                    |> N.Internal.maxMap (decreaseByDifference (n1 |> minimumDifference0))
                    |> diffNo
                    |> Below
                    |> Err


{-| Compared to a range from a lower to an upper bound,
is the [`N`](#N) in range or [`BelowOrAbove`](#BelowOrAbove)?

    isIn3To10 : N (In min_ (Add10 maxMinus10_)) -> Maybe (N (In N3 (Add10 a_)))
    isIn3To10 =
        N.isIn ( n3, n10 )
            >> Result.toMaybe

    n9 |> isIn3To10 |> Maybe.map N.toInt
    --> Just 9

    n12 |> isIn3To10
    --> Nothing

(The type doesn't forbid that the limits you're comparing against
are below the current minimum, above the current maximum or in the wrong order.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

Here's some example-cases:

  - `hi < lo < min < max` → `Below | Above`
  - `hi < min < lo < max` → `Below | Above`
  - `hi < min < max < lo` → `Below | Above`
  - `lo < hi < min < max` → `Above`
  - `max < hi < min < lo` → `Below`
  - `min < hi < lo < max` → `Below | Above`
  - `lo < min < hi < max` → `Ok | Above`
  - `max < min < hi < lo` → `Below`
  - `max < lo < hi < min` → `Below | Ok | Above` ← the default case
  - `lo < min < max < hi` → `Ok`
  - `min < lo < max < hi` → `Ok | Below`
  - `min < max < lo < hi` → `Below`

.

  - did we miss something? → issue
  - feel motivated to add the other cases? → PR

-}
isIn :
    ( N
        (In
            lowerLimit
            (Add1 lowerLimitMaxMinus1)
        )
    , N (In upperLimitMin upperLimitMax)
    )
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (N (In min lowerLimitMaxMinus1))
                    (N (In (Add1 upperLimitMin) max))
                )
                (N (In lowerLimit upperLimitMax))
        )
isIn ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            n
                |> N.Internal.maxFrom lowerLimit
                |> N.Internal.maxMap (decreaseByDifference (n1 |> minimumDifference0))
                |> diffNo
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> minWith
                    ((upperLimit |> minimum)
                        |> increaseByDifference (n1 |> minimumDifference0)
                    )
                |> N.Internal.maxFrom n
                |> Above
                |> Err

        else
            (n |> toInt)
                |> minWith (lowerLimit |> minimum)
                |> N.Internal.maxFrom upperLimit
                |> Ok


{-| Is the [`N`](#N) below than or at least as big as a given number?

    vote :
        { age : N (In (Add18 minMinus18_) max_ difference_) }
        -> Vote

    tryToVote { age } =
        case age |> N.isAtLeast n18 of
            Err _ ->
                --😓
                Nothing

            Ok oldEnough ->
                vote { age = oldEnough } |> Just

    factorial : N (In min_ max_ difference_) -> N (Min N1)
    factorial =
        factorialBody

    factorialBody : N (In min_ max_ difference_) -> N (Min N1)
    factorialBody x =
        case x |> N.isAtLeast n1 of
            Err _ ->
                n1 |> N.maxNo

            Ok atLeast1 ->
                factorial (atLeast1 |> N.minSub n1)
                    |> N.mul atLeast1

(The type doesn't forbid that the lower limit you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtLeast :
    N
        (In
            lowerLimitMin
            (Add1 lowerLimitMaxMinus1)
        )
    ->
        (N (In min max)
         ->
            Result
                (N (In min lowerLimitMaxMinus1))
                (N (In lowerLimitMin max))
        )
isAtLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            n
                |> N.Internal.minMap (\_ -> lowerLimit |> minimum)
                |> diffNo
                |> Ok

        else
            n
                |> N.Internal.maxFrom lowerLimit
                |> N.Internal.maxMap (decreaseByDifference (n1 |> minimumDifference1))
                |> diffNo
                |> Err


{-| Is the [`N`](#N) at most (`Ok`) or greater than (`Err`) a given number?

    goToBelow18Party : { age : N (In min_ N17 difference_) } -> Snack

    tryToGoToBelow18Party { age } =
        case age |> N.isAtMost n17 of
            Ok below18 ->
                goToBelow18Party { age = below18 } |> Just

            Err _ ->
                Nothing

(The type doesn't forbid that the upper limit you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtMost :
    N (In upperLimitMin upperLimitMax)
    ->
        (N (In min max)
         ->
            Result
                (N (In (Add1 upperLimitMin) max))
                (N (In min upperLimitMax))
        )
isAtMost upperLimit =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            n
                |> N.Internal.maxFrom upperLimit
                |> diffNo
                |> Ok

        else
            n
                |> N.Internal.minMap
                    (\_ ->
                        (upperLimit |> minimum)
                            |> increaseByDifference (n1 |> minimumDifference0)
                    )
                |> diffNo
                |> Err


{-| The [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N) plus another [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N).
Give the added number twice as a tuple.

    n6 |> N.diffAdd ( n5, n5 )
    --→ n11
    --: N
    --:     (MinAndMinAsDifferencesAndMax
    --:         N11
    --:         (Increase x0 To (Add11 x0))
    --:         (Increase x1 To (Add11 x1))
    --:         (Add11 a_)
    --:     )

This is only rarely useful, as for example

    isInRangeXToXPlus10 x =
        isIn ( x, x |> N.diffAdd ( n10, n10 ) )

would force x to be of type N (In ... (Is ...)). Instead,

    isInXToXPlus10 x =
        isIn ( x, x |> N.add n10 )

-}
diffAdd :
    ( N
        (MinAndMinAsDifferencesAndMax
            added
            (Increase n To sum)
            (Increase nAtLeast To sumAtLeast)
            added
        )
    , N
        (MinAndMinAsDifferencesAndMax
            added
            (Increase x0PlusN To aPlusSum)
            (Increase x1PlusN To bPlusSum)
            added
        )
    )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                n
                (Increase x0 To x0PlusN)
                (Increase x1 To x1PlusN)
                nAtLeast
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    sum
                    (Increase x0 To aPlusSum)
                    (Increase x1 To bPlusSum)
                    sumAtLeast
                )
        )
diffAdd ( toAdd, toAddWithAdditionalInformation ) =
    \n ->
        let
            sum : sum
            sum =
                (n |> minimum)
                    |> increaseByDifference (toAdd |> minimumDifference0)
        in
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith sum
            |> N.Internal.differencesTo
                ((n |> minimumDifference0)
                    |> differenceIncrease (toAddWithAdditionalInformation |> minimumDifference0)
                )
                ((n |> minimumDifference1)
                    |> differenceIncrease (toAddWithAdditionalInformation |> minimumDifference1)
                )
            |> N.Internal.maxFrom n
            |> N.Internal.maxMap (increaseByDifference (toAdd |> minimumDifference1))


{-| To the [`N`](#N) without a known maximum-constraint,
add a number that has [information on how to add](#Diff) the minima.

    atLeast70 |> N.minAdd n7
    --: N (Min N77)

Use [`addAtLeast`](#addAtLeast) if you want to add an [`N`](#N) in a range.

If the added value is in a range, supply the [`min`](#min) manually!

    atLeast5 |> N.minAdd (min n2 atLeast2)
    --: N (Min N7)

-}
minAdd :
    N
        (MinAndMinAsDifferencesAndMax
            added_
            (Increase min To sumMin)
            (Increase x0_ To x0PlusAdded_)
            addedAtLeast_
        )
    ->
        (N (In min max)
         -> N (Min sumMin)
        )
minAdd toAdd =
    \n ->
        let
            sumMin =
                (n |> minimum)
                    |> increaseByDifference (toAdd |> minimumDifference0)
        in
        ((n |> toInt) + (toAdd |> toInt))
            |> N.Internal.minWith sumMin
                (differenceFrom0To sumMin)
                (differenceFrom0To sumMin)


{-| Add an [`N`](#N) in a range.

The argument is the maximum added value

    between3And10 |> N.addAtMost n12 (min n1 between1And12)
    --: N (In N4 (N22Plus a_))

[`min`](#min) re-enables adding both minimum types.

-}
addAtMost :
    N
        (MinAndMinAsDifferencesAndMax
            addedMax
            addedMaxDiff0_
            (Increase max To sumMax)
            addedMax
        )
    ->
        N
            (MinAndMinAsDifferencesAndMax
                addedMin
                (Increase min To sumMin)
                addedMinDiff1_
                addedMax
            )
    ->
        (N (In min max)
         -> N (In sumMin sumMax)
        )
addAtMost addedAtMost toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith
                ((n |> minimum)
                    |> increaseByDifference (toAdd |> minimumDifference0)
                )
            |> N.Internal.maxFrom n
            |> N.Internal.maxMap (increaseByDifference (addedAtMost |> minimumDifference1))


{-| The [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N) minus another [specific](#MinAndMinAsDifferencesAndMax) [`N`](#N).
Give the subtracted value twice as a tuple.

    n6 |> N.diffSub ( n5, n5 )
    --→ n1
    --: N
    --:     (MinAndMinAsDifferencesAndMax
    --:         N1
    --:         (Increase x0 To (Add1 x0))
    --:         (Increase x1 To (Add1 x1))
    --:         (Add1 a_)
    --:     )

This is only rarely useful, as for example

    isInXMinus10ToX x =
        isIn ( x |> N.diffSub ( n10, n10 ), x )

would force `x` to be a specific [`MinAndMinAsDifferencesAndMax`](#MinAndMinAsDifferencesAndMax).
Instead,

    isInXMinus10ToX x =
        isIn ( x |> N.sub n10, x )

-}
diffSub :
    ( N
        (MinAndMinAsDifferencesAndMax
            subtracted
            (Increase difference To n)
            (Increase differenceAtLeast To nAtLeast)
            subtracted
        )
    , N
        (MinAndMinAsDifferencesAndMax
            subtracted
            (Increase x0PlusDifference To x0PlusN)
            (Increase x1PlusDifference To x1PlusN)
            subtracted
        )
    )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                n
                (Increase x0 To x0PlusN)
                (Increase x1 To x1PlusN)
                nAtLeast
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    difference
                    (Increase x0 To x0PlusDifference)
                    (Increase x1 To x1PlusDifference)
                    differenceAtLeast
                )
        )
diffSub ( subtrahend, subtrahendWithAdditionalInformation ) =
    \n ->
        let
            difference : difference
            difference =
                (n |> minimum)
                    |> decreaseByDifference (subtrahend |> minimumDifference0)
        in
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith difference
            |> N.Internal.differencesTo
                ((n |> minimumDifference0)
                    |> differenceDecrease (subtrahendWithAdditionalInformation |> minimumDifference0)
                )
                ((n |> minimumDifference1)
                    |> differenceDecrease (subtrahendWithAdditionalInformation |> minimumDifference1)
                )
            |> N.Internal.maxFrom n
            |> N.Internal.maxMap (decreaseByDifference (subtrahend |> minimumDifference1))


{-| Subtract an [`N`](#N) in a range.

The argument is the maximum subtracted value

    between6And12 |> N.subAtMost n5 (min n1 between1And5)
    --: N (In N1 (Add5 a_))

-}
subAtMost :
    N
        (MinAndMinAsDifferencesAndMax
            subtractedMax
            subtractedMaxDiff0_
            (Increase differenceMin To min)
            subtractedMax
        )
    ->
        N
            (MinAndMinAsDifferencesAndMax
                subtractedMin
                (Increase differenceMax To max)
                subtractedMinDiff1_
                subtractedMax
            )
    ->
        (N (In min max)
         -> N (In differenceMin differenceMax)
        )
subAtMost subtractedMax subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith
                ((n |> minimum)
                    |> decreaseByDifference (subtractedMax |> minimumDifference1)
                )
            |> N.Internal.maxFrom n
            |> N.Internal.maxMap
                (decreaseByDifference (subtrahend |> minimumDifference0))


{-| From an [`N`](#N) without an unknown maximum constraint,
subtract a number in a range.

The first argument is the maximum of the subtracted number.

    atLeast6 |> N.minSubAtMost n5 between0And5
    --: N (Min N1)

-}
minSubAtMost :
    N
        (MinAndMinAsDifferencesAndMax
            subtractedMax
            subtractedMaxDiff0_
            (Increase differenceMin To min)
            subtractedMax
        )
    -> N (In subtractedMin_ subtractedMax)
    ->
        (N (In min max)
         -> N (In differenceMin max)
        )
minSubAtMost subtractedMax subtrahend =
    subAtMost subtractedMax (subtrahend |> min n0)


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#MinAndMinAsDifferencesAndMax)

    atLeast7 |> N.minSub n2
    --: N (Min N5)

Use [`minSubAtMost`](#minSubAtMost) if you want to subtract an [`N`](#N) in a range.

-}
minSub :
    N
        (MinAndMinAsDifferencesAndMax
            subtracted
            (Increase differenceMin To min)
            subtractedDiff1_
            subtracted
        )
    ->
        (N (In min max)
         -> N (In differenceMin max)
        )
minSub subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith
                ((n |> minimum)
                    |> decreaseByDifference (subtrahend |> minimumDifference0)
                )
            |> N.Internal.maxFrom n



-- # internals


{-| The smallest allowed number promised by the [range type](#In).
-}
minimum :
    N (MinAndMinAsDifferencesAndMax minimum minDiff0_ minDiff1_ maximum_)
    -> minimum
minimum =
    N.Internal.minimum


{-| The minimum number representation as a [difference](#Increase) promised by its type
-}
minimumDifference0 :
    N (MinAndMinAsDifferencesAndMax min_ minimumDifference0 difference1_ max_)
    -> minimumDifference0
minimumDifference0 =
    N.Internal.minDifference0


{-| The minimum number representation as a [difference](#Increase) promised by its type
-}
minimumDifference1 :
    N (MinAndMinAsDifferencesAndMax min_ difference0_ minimumDifference1 max_)
    -> minimumDifference1
minimumDifference1 =
    N.Internal.minDifference1


{-| To the number, add a specific other one by supplying a [difference](#Increase).
-}
increaseByDifference : Increase low To high -> (low -> high)
increaseByDifference =
    \(Difference differenceOperation) -> differenceOperation.increase


{-| To the number, subtract a specific other one by supplying a [difference](#Increase).
-}
decreaseByDifference : Increase low To high -> (high -> low)
decreaseByDifference =
    \(Difference differenceOperation) -> differenceOperation.decrease


{-| Chain the [difference](#Increase) further to a higher number.
-}
differenceIncrease :
    Increase middle To high
    -> (Increase low To middle -> Increase low To high)
differenceIncrease diffMiddleToHigh =
    \diffLowToMiddle ->
        Difference
            { increase =
                increaseByDifference diffLowToMiddle
                    >> increaseByDifference diffMiddleToHigh
            , decrease =
                decreaseByDifference diffMiddleToHigh
                    >> decreaseByDifference diffLowToMiddle
            }


{-| Chain the [difference](#Increase) back to a lower number.
-}
differenceDecrease :
    Increase middle To high
    -> (Increase low To high -> Increase low To middle)
differenceDecrease diffMiddleToHigh =
    \diffLowToHigh ->
        Difference
            { increase =
                increaseByDifference diffLowToHigh
                    >> decreaseByDifference diffMiddleToHigh
            , decrease =
                increaseByDifference diffMiddleToHigh
                    >> decreaseByDifference diffLowToHigh
            }


n0Difference : Increase x To x
n0Difference =
    Difference
        { increase = identity
        , decrease = identity
        }


n1Difference : Increase x To (Add1 x)
n1Difference =
    Difference
        { increase = Add1
        , decrease =
            \n0Never ->
                case n0Never of
                    Add1 predecessor ->
                        predecessor

                    N0 possible ->
                        possible |> never
        }


{-| Increase its [`minimumDifference0`](#minimumDifference0) by a specific given number.
-}
minimumDifference0Up :
    N
        (MinAndMinAsDifferencesAndMax
            min
            (Increase middle To high)
            minDifference1
            max
        )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                min
                (Increase low To middle)
                minDifference1
                max
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    min
                    (Increase low To high)
                    minDifference1
                    max
                )
        )
minimumDifference0Up minimumDifference0Change =
    \n ->
        n
            |> N.Internal.differencesTo
                ((n |> minimumDifference0)
                    |> differenceIncrease
                        (minimumDifference0Change |> minimumDifference0)
                )
                (n |> minimumDifference1)


{-| Increase its [`minimumDifference1`](#minimumDifference1) by a specific given number.
-}
minimumDifference1Up :
    N
        (MinAndMinAsDifferencesAndMax
            min
            minDifference0
            (Increase middle To high)
            max
        )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                min
                minDifference0
                (Increase low To middle)
                max
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    min
                    minDifference0
                    (Increase low To high)
                    max
                )
        )
minimumDifference1Up minimumDifference1Change =
    \n ->
        n
            |> N.Internal.differencesTo
                (n |> minimumDifference0)
                ((n |> minimumDifference1)
                    |> differenceIncrease
                        (minimumDifference1Change |> minimumDifference1)
                )


{-| Decrease its [`minimumDifference0`](#minimumDifference0) by a specific given number.
-}
minimumDifference0Down :
    N
        (MinAndMinAsDifferencesAndMax
            min
            (Increase middle To high)
            minDifference0
            max
        )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                min
                (Increase low To high)
                minDifference0
                max
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    min
                    (Increase low To middle)
                    minDifference0
                    max
                )
        )
minimumDifference0Down minimumDifference0Change =
    \n ->
        n
            |> N.Internal.differencesTo
                ((n |> minimumDifference0)
                    |> differenceDecrease
                        (minimumDifference0Change |> minimumDifference0)
                )
                (n |> minimumDifference1)


{-| Decrease its [`minimumDifference1`](#minimumDifference1) by a specific given number.
-}
minimumDifference1Down :
    N
        (MinAndMinAsDifferencesAndMax
            min
            minDifference0
            (Increase middle To high)
            max
        )
    ->
        (N
            (MinAndMinAsDifferencesAndMax
                min
                minDifference0
                (Increase low To high)
                max
            )
         ->
            N
                (MinAndMinAsDifferencesAndMax
                    min
                    minDifference0
                    (Increase low To middle)
                    max
                )
        )
minimumDifference1Down minimumDifference1Change =
    \n ->
        n
            |> N.Internal.differencesTo
                (n |> minimumDifference0)
                ((n |> minimumDifference1)
                    |> differenceDecrease
                        (minimumDifference1Change |> minimumDifference1)
                )


{-| Switch [`minimumDifference0`](#minimumDifference0), [`minimumDifference1`](#minimumDifference1)
in the type.

    addAtMostSwapped :
        N
            (MinAndMinAsDifferencesAndMax
                addedMax
                (Increase max To sumMax)
                addedMaxDiff0_
                addedMax
            )
        ->
            N
                (MinAndMinAsDifferencesAndMax
                    addedMin
                    addedMinDiff1_
                    (Increase min To sumMin)
                    addedMax
                )
        ->
            (N (In min max)
             -> N (In sumMin sumMax)
            )
    addAtMostSwapped addedAtMost toAdd =
        N.addAtMost
            (addedAtMost |> N.differencesSwap)
            (toAdd |> N.differencesSwap)

The example is pretty arbitrary,
but there really might be some cases where you want to use
for example the second [`Diff`](#Diff)
but the function requires it in first position.

-}
differencesSwap :
    N (MinAndMinAsDifferencesAndMax min diff0 diff1 max)
    -> N (MinAndMinAsDifferencesAndMax min diff1 diff0 max)
differencesSwap =
    \n ->
        n
            |> N.Internal.differencesTo
                (n |> minimumDifference1)
                (n |> minimumDifference0)



--


{-| The exact natural number `0`
-}
n0 : N (MinAndMinAsDifferencesAndMax N0 (Increase x0 To x0) (Increase x1 To x1) atLeast_)
n0 =
    N.Internal.n0 (N0 Possible) n0Difference n0Difference


{-| The exact natural number `1`
-}
n1 :
    N
        (MinAndMinAsDifferencesAndMax
            N1
            (Increase x0 To (Add1 x0))
            (Increase x1 To (Add1 x1))
            (Add1 atLeast_)
        )
n1 =
    1
        |> minWith (n0 |> minimum |> Add1)
        |> N.Internal.differencesTo n1Difference n1Difference
        |> N.Internal.maxFrom n0
        |> N.Internal.maxMap Add1


{-| The exact natural number `2`
-}
n2 : N (MinAndMinAsDifferencesAndMax N2 (Increase x0 To (Add2 x0)) (Increase x1 To (Add2 x1)) (Add2 atLeast_))
n2 =
    n1 |> diffAdd ( n1, n1 )


{-| The exact natural number `3`
-}
n3 : N (MinAndMinAsDifferencesAndMax N3 (Increase x0 To (Add3 x0)) (Increase x1 To (Add3 x1)) (Add3 atLeast_))
n3 =
    n2 |> diffAdd ( n1, n1 )


{-| The exact natural number `4`
-}
n4 : N (MinAndMinAsDifferencesAndMax N4 (Increase x0 To (Add4 x0)) (Increase x1 To (Add4 x1)) (Add4 atLeast_))
n4 =
    n3 |> diffAdd ( n1, n1 )


{-| The exact natural number `5`
-}
n5 : N (MinAndMinAsDifferencesAndMax N5 (Increase x0 To (Add5 x0)) (Increase x1 To (Add5 x1)) (Add5 atLeast_))
n5 =
    n4 |> diffAdd ( n1, n1 )


{-| The exact natural number `6`
-}
n6 : N (MinAndMinAsDifferencesAndMax N6 (Increase x0 To (Add6 x0)) (Increase x1 To (Add6 x1)) (Add6 atLeast_))
n6 =
    n5 |> diffAdd ( n1, n1 )


{-| The exact natural number `7`
-}
n7 : N (MinAndMinAsDifferencesAndMax N7 (Increase x0 To (Add7 x0)) (Increase x1 To (Add7 x1)) (Add7 atLeast_))
n7 =
    n6 |> diffAdd ( n1, n1 )


{-| The exact natural number `8`
-}
n8 : N (MinAndMinAsDifferencesAndMax N8 (Increase x0 To (Add8 x0)) (Increase x1 To (Add8 x1)) (Add8 atLeast_))
n8 =
    n7 |> diffAdd ( n1, n1 )


{-| The exact natural number `9`
-}
n9 : N (MinAndMinAsDifferencesAndMax N9 (Increase x0 To (Add9 x0)) (Increase x1 To (Add9 x1)) (Add9 atLeast_))
n9 =
    n8 |> diffAdd ( n1, n1 )


{-| The exact natural number `10`
-}
n10 : N (MinAndMinAsDifferencesAndMax N10 (Increase x0 To (Add10 x0)) (Increase x1 To (Add10 x1)) (Add10 atLeast_))
n10 =
    n9 |> diffAdd ( n1, n1 )


{-| The exact natural number `11`
-}
n11 : N (MinAndMinAsDifferencesAndMax N11 (Increase x0 To (Add11 x0)) (Increase x1 To (Add11 x1)) (Add11 atLeast_))
n11 =
    n10 |> diffAdd ( n1, n1 )


{-| The exact natural number `12`
-}
n12 : N (MinAndMinAsDifferencesAndMax N12 (Increase x0 To (Add12 x0)) (Increase x1 To (Add12 x1)) (Add12 atLeast_))
n12 =
    n11 |> diffAdd ( n1, n1 )


{-| The exact natural number `13`
-}
n13 : N (MinAndMinAsDifferencesAndMax N13 (Increase x0 To (Add13 x0)) (Increase x1 To (Add13 x1)) (Add13 atLeast_))
n13 =
    n12 |> diffAdd ( n1, n1 )


{-| The exact natural number `14`
-}
n14 : N (MinAndMinAsDifferencesAndMax N14 (Increase x0 To (Add14 x0)) (Increase x1 To (Add14 x1)) (Add14 atLeast_))
n14 =
    n13 |> diffAdd ( n1, n1 )


{-| The exact natural number `15`
-}
n15 : N (MinAndMinAsDifferencesAndMax N15 (Increase x0 To (Add15 x0)) (Increase x1 To (Add15 x1)) (Add15 atLeast_))
n15 =
    n14 |> diffAdd ( n1, n1 )


{-| The exact natural number `16`
-}
n16 : N (MinAndMinAsDifferencesAndMax N16 (Increase x0 To (Add16 x0)) (Increase x1 To (Add16 x1)) (Add16 atLeast_))
n16 =
    n15 |> diffAdd ( n1, n1 )


{-| Base type of [`N0`](#N0), [`Add1 n`](#Add1) following [`allowable-state`](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/):

Is the parameter `possiblyOrNever` set to `Never` like in

    type alias Add1 n =
        N0able n Never

`N0` is impossible to construct.

Is the parameter `possiblyOrNever` set to `Possibly` like in

    type alias N0 =
        N0able Never Possibly

`N0` is a possible value.

-}
type N0able successor possiblyOrNever
    = N0 possiblyOrNever
    | Add1 successor


{-| Type for the natural number `1 +` some natural number `n`
-}
type alias Add1 n =
    N0able n Never


{-| Type for the natural number `2 +` some natural number `n`
-}
type alias Add2 n =
    N0able (N0able n Never) Never


{-| Type for the natural number `3 +` some natural number `n`
-}
type alias Add3 n =
    N0able (N0able (N0able n Never) Never) Never


{-| Type for the natural number `4 +` some natural number `n`
-}
type alias Add4 n =
    N0able (N0able (N0able (N0able n Never) Never) Never) Never


{-| Type for the natural number `5 +` some natural number `n`
-}
type alias Add5 n =
    N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never


{-| Type for the natural number `6 +` some natural number `n`
-}
type alias Add6 n =
    N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never


{-| Type for the natural number `7 +` some natural number `n`
-}
type alias Add7 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `8 +` some natural number `n`
-}
type alias Add8 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `9 +` some natural number `n`
-}
type alias Add9 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `10 +` some natural number `n`
-}
type alias Add10 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `11 +` some natural number `n`
-}
type alias Add11 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `12 +` some natural number `n`
-}
type alias Add12 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `13 +` some natural number `n`
-}
type alias Add13 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `14 +` some natural number `n`
-}
type alias Add14 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `15 +` some natural number `n`
-}
type alias Add15 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the natural number `16 +` some natural number `n`
-}
type alias Add16 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `0`
-}
type alias N0 =
    N0able Never Possibly


{-| Type for the exact natural number `1`
-}
type alias N1 =
    N0able (N0able Never Possibly) Never


{-| Type for the exact natural number `2`
-}
type alias N2 =
    N0able (N0able (N0able Never Possibly) Never) Never


{-| Type for the exact natural number `3`
-}
type alias N3 =
    N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never


{-| Type for the exact natural number `4`
-}
type alias N4 =
    N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never


{-| Type for the exact natural number `5`
-}
type alias N5 =
    N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never


{-| Type for the exact natural number `6`
-}
type alias N6 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `7`
-}
type alias N7 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `8`
-}
type alias N8 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `9`
-}
type alias N9 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `10`
-}
type alias N10 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `11`
-}
type alias N11 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `12`
-}
type alias N12 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `13`
-}
type alias N13 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `14`
-}
type alias N14 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `15`
-}
type alias N15 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the exact natural number `16`
-}
type alias N16 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never
