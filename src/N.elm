module N exposing
    ( N
    , In, Min, NoMax, Exactly
    , abs, random, up
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , N0able(..), Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , BelowOrAbove(..)
    , intAtLeast, intIn
    , intIsIn, intIsAtLeast
    , atLeast, atMost
    , is, isIn, isAtLeast, isAtMost
    , add, addIn
    , sub, subIn
    , toPower, remainderBy, mul, div
    , minSub, minAdd, minSubMax, addMin
    , toInt, toFloat
    , minDown, noDiff, noMax, maxOpen, maxUp
    , Is, Diff(..), To
    , diffAdd, diffSub
    , maximumUnknown
    , minimum
    , difference0, difference1, differences
    , addDifference, subDifference
    , differenceAdd, differenceSub
    )

{-| Natural numbers within a typed range.

@docs N


# bounds

@docs In, Min, NoMax, Exactly


# create

@docs abs, random, up


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

@docs add, addIn
@docs sub, subIn
@docs toPower, remainderBy, mul, div


## alter maximum unconstrained

@docs minSub, minAdd, minSubMax, addMin


## broaden

@docs toInt, toFloat


# type information

@docs minDown, noDiff, noMax, maxOpen, maxUp


# miss operation x?

Anything that can't be expressed with the available operations? → issue/PR


# internals

Useful for fancy things – building structures like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)

While the internally stored `Int` isn't directly guaranteed to be in bounds by elm,
[`minimum`](#minimum), maximum, [`differences`](#differences)
must be built as actual values checked by the compiler.

@docs Is, Diff, To
@docs diffAdd, diffSub
@docs maximumUnknown

@docs minimum
@docs difference0, difference1, differences
@docs addDifference, subDifference
@docs differenceAdd, differenceSub

-}

import Help exposing (valueElseOnError)
import N.Internal exposing (differenceTo, maxFrom, maxMap, minMap, minWith)
import Possibly exposing (Possibly(..))
import Random
import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)


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
  - specific numbers like [`n0`](#n0), [`n1`](#n1), ... which carry [`difference_`](#Is)s are allowed


### result type

    -- ≥ 4
    N (Min N4)

    -- 2 ≤ n ≤ 12
    N (In N2 (Add12 a_) {})

`In N2 (Add12 a_) {}` says:

  - the minimum-constraint can be `4`|`5`|`6`|...
  - any maximum-constraint greater than `15` is forbidden
  - `{}`: no [differences](#Is) are attached.
    Only specific numbers like [`n0`](#n0), [`n1`](#n1), ... carry [differences](#Is)s


### storage types

what to put in declared types like `Model`

    -- ≥ 4
    N (Min N4)

    -- 2 ≤ n ≤ 12
    N (In N2 N12 {})

They are like [result types](#result-types) but without type variables.


### specific number

Numbers [`n0`](#n0), [`n1`](#n1), ... supplied by this library.

The type [`Is`](#Is) `(`[`Diff x0 To nPlusX0`](#Diff)`) ...`
enables adding, subtracting `N<x>` types.
Consider the type an implementation detail.
You can come back to understand them later.

    n3 :
        N
            (In
                N3
                (Add3 atLeast_)
                (Is
                    (Diff x0 To (Add3 x0))
                    (Diff x1 To (Add3 x1))
                )
            )

    -- a number nTo15 away from 15
    N (In n nAtLeast_ (Is (Diff nTo15 To N15) diff1_))

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

    N (In min_ max_ difference_)

A number, at least 5:

    N (In (Add5 minMinus5_) max_ difference_)

  - `max_` could be a specific maximum or [no maximum at all](#NoMax)

  - `difference_` could contain extra information if the argument is a [specific](#Is) number
    like [`n0`](#n0), [`n1`](#n1), ...


### `In minimum maximum {}`

A number somewhere within a `minimum` & `maximum`. We don't know it exactly, though

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    N (In N3 (Add5 a_) {})

-}
type alias In minimum maximum possibleRepresentationAsDifferences =
    RecordWithoutConstructorFunction
        { min : minimum
        , max : () -> maximum
        , diff : possibleRepresentationAsDifferences
        }


{-| Only **storage / return types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> N (In N0 ?? {})
                    ↓
    abs : Int -> N (Min N0)

A number `≥ 5` for example:

    N (Min N5)

Every `Min min` is of type `In min ...`.

-}
type alias Min lowestPossibleValue =
    In lowestPossibleValue NoMax {}


{-| Allow only a specific number.

Useful as an **argument & storage** type in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
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
    In n n {}


{-| Associated [difference](#Diff)s.
-}
type alias Is difference0 difference1 =
    RecordWithoutConstructorFunction
        { diff0 : difference0
        , diff1 : difference1
        }


{-| `Diff a To b`: an exact n as the difference `b - a`.

    In
        N5
        (Add5 a_)
        (Is
            (Diff myAge To sistersAge)
            (Diff mothersAge To fathersAge)
        )

  - `myAge + 5 = sistersAge`
  - `mothersAge + 5 = fathersAge`

-}
type Diff low toTag high
    = Difference
        { add : low -> high
        , sub : high -> low
        }


{-| Just a word in the type in [`Diff`](#Diff).

    Diff a To b

→ distance `b - a`.

-}
type To
    = To Never


{-| Flag "The number's maximum limit is unknown".

    type alias Min min =
        In minimum NoMax {}

is the definition of [`Min`](#Min).

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree childCountMax element
        = Tree
            element
            (Arr
                (In N0 childCountMax {})
                (Maybe (Tree childCountMax element))
            )

    type alias TreeBinary element =
        Tree N2 element

    type alias TreeMulti element =
        Tree NoMax element

Remember: ↑ and other [`Min`](#Min)/[`NoMax`](#NoMax) are result/storage types, not argument types.
You can just use a variable `Tree childCountMax_ element` if you don't care about an enforced maximum.

-}
type alias NoMax =
    N.Internal.NoMax



--


{-| Add a given specific `N (In ... (Is ...))`.

    between70And100 |> N.add n7
    --: N (In N77 (Add107 a_) {})

Use [`addIn`](#addIn) if you want to add an [`N`](#N) that isn't a `N (In ... (Is ...))`.

-}
add :
    N
        (In
            added_
            addedAtLeast_
            (Is
                (Diff min To sumMin)
                (Diff max To sumMax)
            )
        )
    ->
        (N (In min max difference_)
         -> N (In sumMin sumMax {})
        )
add toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith
                ((n |> minimum)
                    |> addDifference (toAdd |> difference0)
                )
            |> maxFrom n
            |> maxMap (addDifference (toAdd |> difference1))


{-| Subtract a given specific `N (In ... (Is ...))`.

    between7And10 |> N.sub n7
    --: N (In N0 (Add3 a_) {})

Use [`subIn`](#subIn) if you want to subtract an [`N`](#N) that isn't a `N (In ... (Is ...))`.

-}
sub :
    N
        (In
            subtractedMin_
            subtractedMax_
            (Is
                (Diff differenceMin To min)
                (Diff differenceMax To max)
            )
        )
    ->
        (N (In min max diff_)
         -> N (In differenceMin differenceMax {})
        )
sub subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith
                ((n |> minimum)
                    |> subDifference (subtrahend |> difference0)
                )
            |> maxFrom n
            |> maxMap (subDifference (subtrahend |> difference1))


{-| The absolute value of an `Int` → `≥ 0`

    -4 |> N.abs |> N.toInt --> 4

    16 |> N.abs |> N.toInt --> 16

Really only use this if you want the absolute value.

    badLength =
        List.length >> N.abs

  - maybe, there's a solution that never even theoretically deals with unexpected values:

        mostCorrectLength =
            List.foldl
                (\_ -> N.minAdd n1 >> N.lowerMin n0)
                (n0 |> N.noMax)

  - other times, though, like with `Array.length`, which isn't `O(n)`,
    you can escape with for example

        arrayLength =
            Array.length >> N.intAtLeast n0

-}
abs : Int -> N (Min N0)
abs =
    Basics.abs
        >> minWith (n0 |> minimum)


{-| [`N`](#N)s increasing from `0` to `n - 1`.
In the end, there are `n` numbers.

    N.up n7
        |> List.map (N.add n3)
        --: List (N (In N3 (Add9 a_)))
        |> List.map N.toInt
    --> [ 3, 4, 5, 6, 7, 8, 9 ]

    N.up atLeast7 |> List.map (N.add n3)
    --: List (N (Min N3))

[`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/Arr#nats) even knows the length! Try it.

-}
up :
    N (In min_ (Add1 maxMinus1) difference_)
    -> List (N (In N0 maxMinus1 {}))
up length =
    downBelow length |> List.reverse


downBelow :
    N (In minimum_ (Add1 maxMinus1) difference_)
    -> List (N (In N0 maxMinus1 {}))
downBelow length =
    case length |> isAtLeast n1 of
        Err _ ->
            []

        Ok lengthAtLeast1 ->
            let
                lengthMinus1 =
                    lengthAtLeast1 |> sub n1
            in
            lengthMinus1
                :: (lengthMinus1 |> maxUp n1 |> downBelowRecursive)


downBelowRecursive :
    N (In min_ (Add1 maxMinus1) difference_)
    -> List (N (In N0 maxMinus1 {}))
downBelowRecursive length =
    downBelow length


{-| Generate a random [`N`](#N) in a range.

    N.random ( n1, n10 )
    --: Random.Generator (N (In N1 (Add10 a_) {}))

-}
random :
    ( N (In lowerLimitMin upperLimitMin lowerLimitDifference_)
    , N (In upperLimitMin upperLimitMax upperLimitDifference_)
    )
    ->
        Random.Generator
            (N (In lowerLimitMin upperLimitMax {}))
random ( lowestPossible, highestPossible ) =
    Random.int (lowestPossible |> toInt) (highestPossible |> toInt)
        |> Random.map
            (minWith (lowestPossible |> minimum)
                >> maxFrom highestPossible
            )


{-| Compared to a range from a lower to an upper bound, is the `Int` in range, [`BelowOrAbove`](#BelowOrAbove)?

    inputIntJudge : Int -> Result String (N (In N1 (Add10 a_) {}))
    inputIntJudge int =
        case int |> N.intIsIn ( n1, n10 ) of
            Ok inRange ->
                inRange |> N.maxOpen n10 |> Ok
            Err (N.Below _) ->
                Err "must be ≥ 1"
            Err (N.Above _) ->
                Err "must be ≤ 100"

    0 |> inputIntJudge
    --> Err "must be ≥ 1"

-}
intIsIn :
    ( N (In minDownLimit maxUpperLimit lowerLimitDifference_)
    , N (In maxUpperLimit maxUpperLimitAtLeast upperLimitDifference_)
    )
    ->
        (Int
         ->
            Result
                (BelowOrAbove
                    Int
                    (N (Min (Add1 maxUpperLimit)))
                )
                (N (In minDownLimit maxUpperLimitAtLeast {}))
        )
intIsIn ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> Below |> Err

        else if int > (upperLimit |> toInt) then
            int
                |> minWith
                    ((upperLimit |> minimum)
                        |> addDifference (n1 |> difference0)
                    )
                |> Above
                |> Err

        else
            int
                |> minWith (lowerLimit |> minimum)
                |> maxFrom upperLimit
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
    N (In min max_ minimumLimitDifference_)
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
        --: N (In N3 (Add12 a_) {})
        |> N.toInt
    --> 3

    99
        |> N.intIn n3 n12
        --: N (In N3 (Add12 a_) {})
        |> N.toInt
    --> 12

    9
        |> N.intIn ( n3, n12 )
        --: N (In N3 (Add12 a_) {})
        |> N.toInt
    --> 9


    toDigit : Char -> Maybe (N (In N0 (Add9 atLeast_) {}))
    toDigit char =
        ((char |> Char.toCode) - ('0' |> Char.toCode))
            |> N.intIsIn n0 n9
            |> Result.toMaybe

-}
intIn :
    ( N (In lowerLimit upperLimitMin lowerLimitDifference_)
    , N (In upperLimitMin upperLimit upperLimitDifference_)
    )
    ->
        (Int
         -> N (In lowerLimit upperLimit {})
        )
intIn ( lowerLimit, upperLimit ) =
    intIsIn ( lowerLimit, upperLimit )
        >> valueElseOnError
            (\error ->
                case error of
                    Below _ ->
                        (lowerLimit |> toInt)
                            |> minWith (lowerLimit |> minimum)
                            |> maxFrom upperLimit

                    Above _ ->
                        upperLimit |> minDown lowerLimit
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
            (\_ -> MinIn.add n1 >> N.lowerMin n0)
            (n0 |> N.noMax)

If you want to handle the case `< minimum` yourself → [`intIsAtLeast`](#intIsAtLeast)

-}
intAtLeast :
    N (In min max_ lowerDifference_)
    ->
        (Int
         -> N (Min min)
        )
intAtLeast minimumLimit =
    intIsAtLeast minimumLimit
        >> Result.withDefault (minimumLimit |> noMax)


{-| Return the given number if the [`N`](#N) is less.

    between5And9 |> N.atLeast n10
    --: N (In N10 (Add10 a_) {})

    n15 |> N.atLeast n10 |> N.toInt
    --> 15

    n5AtLeast |> N.atLeast (n10 |> noMax)
    --: N (Min N10)

-}
atLeast :
    N (In minNewMin (Add1 maxMinus1) lowerDifference_)
    ->
        (N (In min_ (Add1 maxMinus1) difference_)
         -> N (In minNewMin (Add1 maxMinus1) {})
        )
atLeast lowerLimit =
    \n ->
        n
            |> isAtLeast lowerLimit
            |> valueElseOnError
                (\_ ->
                    lowerLimit
                        |> noDiff
                )


{-| **Cap** the [`N`](#N) to at most a number.

    between5And15
        |> N.atMost n10
    --: N (In N5 (Add10 a_) {})

    atLeast5 |> N.atMost n10
    --: N (In N5 (Add10 a_) {})

(The type doesn't forbid that the upper limit you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
atMost :
    N (In upperLimitMin_ upperLimitMax newMaxDifference_)
    ->
        (N (In min max_ difference_)
         -> N (In min upperLimitMax {})
        )
atMost upperLimit =
    \n ->
        n
            |> isAtMost upperLimit
            |> valueElseOnError
                (\_ ->
                    upperLimit
                        |> minMap (\_ -> n |> minimum)
                        |> noDiff
                )


{-| Multiply by [`N`](#N) `n ≥ 1`.
we know that if `n ≥ 1`, `x * n ≥ x`.

    atLeast5 |> N.mul n2
    --: N (Min N5)

    atLeast2 |> N.mul n5
    --: N (Min N2)

-}
mul :
    N (In (Add1 mulMinMinus1_) mulMax_ mulDifference_)
    ->
        (N (In min max_ difference_)
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
    --: N (In N0 (Add7 a_) {})
    |> N.toInt
--> 2
```

-}
div :
    N (In (Add1 divMinMinus1_) divMax_ divDifference_)
    ->
        (N (In min_ max difference_)
         -> N (In N0 max {})
        )
div divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> minWith (n0 |> minimum)
            |> maxFrom n


{-| The remainder after dividing by a [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In N0 (Add3 a_) {})

-}
remainderBy :
    N (In (Add1 divMinMinus1_) (Add1 divMaxMinus1) divDifference_)
    ->
        (N (In min_ max_ difference_)
         -> N (In N0 divMaxMinus1 {})
        )
remainderBy divisor =
    \n ->
        (n |> toInt)
            |> Basics.remainderBy (divisor |> toInt)
            |> minWith (n0 |> minimum)
            |> maxFrom divisor
            |> maxMap (subDifference (n1 |> difference0))


{-| [`N`](#N) Raised to a given power `p ≥ 1`
→ `x ^ p ≥ x`

    atLeast5 |> N.toPower n2
    --: N (Min N5)

    atLeast2 |> N.toPower n5
    --: N (Min N2)

-}
toPower :
    N (In (Add1 powMinMinus1_) (Add1 powMax_) powDifference_)
    ->
        (N (In min max_ difference_)
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
    , atLeast4 |> N.lowerMin n3
    ]

-}
minDown :
    N (In newMin min lowerDifference_)
    ->
        (N (In min max difference_)
         -> N (In newMin max {})
        )
minDown newMinimum =
    \n ->
        (n |> toInt)
            |> minWith (newMinimum |> minimum)
            |> maxFrom n


{-| Convert it to a `N (In min max {})`.

    n4 |> N.noDiff
    --: N (In N4 (Add4 a_) {})

Example

    [ in3To10, n3 ]

> all the previous elements in the list are: `N (In N3 N10 {})`

    [ in3To10
    , n3 |> N.noDiff
    ]

-}
noDiff : N (In min max difference_) -> N (In min max {})
noDiff =
    \n ->
        (n |> toInt)
            |> minWith (n |> minimum)
            |> maxFrom n


{-| Convert a `N (In min ...)` to a `N (Min min)`.

    between3And10 |> N.noMax
    --: N (Min N4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N1)`

    [ atLeast1
    , between1And10 |> N.noMax
    ]

-}
noMax : N (In min max_ difference_) -> N (Min min)
noMax =
    \n ->
        (n |> toInt) |> minWith (n |> minimum)


{-| Make it fit into functions with require a higher maximum.

You should type arguments as broad as possible.

    onlyAtMost18 : N (In min_ N18 difference_) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the n in `onlyAtMost19`.

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.maxOpen n18)

-}
maxOpen :
    N (In max newMax newMaxDifference_)
    ->
        (N (In min max difference_)
         -> N (In min newMax {})
        )
maxOpen newMaximum =
    \n ->
        (n |> toInt)
            |> minWith (n |> minimum)
            |> maxFrom newMaximum


{-| Have a specific maximum in mind? → [`maxOpen`](#maxOpen)

Want to increase the upper bound by a fixed amount? ↓

    maxUp4 : N (In min max difference_) -> N (In min (Add4 max) {})
    maxUp4 =
        N.maxUp n4

When is this useful? Very rarely. This is how [`up`](#up) reverse could be implemented

    down :
        N (In min (Add1 maxMinus1) difference_)
        -> List (N (In N0 maxMinus1 {}))
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
                            |> upRecursive
                       )

-}
maxUp :
    N (In increase_ increaseAtLeast_ (Is (Diff max To maxIncreased) diff1_))
    ->
        (N (In min max difference_)
         -> N (In min maxIncreased {})
        )
maxUp maxRelativeIncrease =
    maxMap (addDifference (maxRelativeIncrease |> difference0))
        >> noDiff


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
to supply another library with its `Int` representation.
-}
toInt : N range_ -> Int
toInt =
    N.Internal.toInt


{-| Drop the range constraints
to supply another library with its `Float` representation.
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

-}
is :
    N (In comparedAgainstMin (Add1 comparedAgainstMaxMinus1) comparedAgainstDifference)
    ->
        (N (In min max difference_)
         ->
            Result
                (BelowOrAbove
                    (N (In min comparedAgainstMaxMinus1 {}))
                    (N (In (Add1 comparedAgainstMin) max {}))
                )
                (N (In comparedAgainstMin (Add1 comparedAgainstMaxMinus1) comparedAgainstDifference))
        )
is comparedAgainst =
    \n ->
        case compare (n |> toInt) (comparedAgainst |> toInt) of
            EQ ->
                comparedAgainst
                    |> Ok

            GT ->
                n
                    |> minMap
                        (\_ ->
                            (comparedAgainst |> minimum)
                                |> addDifference (n1 |> difference0)
                        )
                    |> noDiff
                    |> Above
                    |> Err

            LT ->
                n
                    |> maxFrom comparedAgainst
                    |> maxMap (subDifference (n1 |> difference0))
                    |> noDiff
                    |> Below
                    |> Err


{-| Compared to a range from a lower to an upper bound,
is the [`N`](#N) in range or [`BelowOrAbove`](#BelowOrAbove)?

    isIn3To10 : N (In min_ (Add10 maxMinus10_) d_) -> Maybe (N (In N3 (Add10 a_) {}))
    isIn3To10 =
        N.isIn ( n3, n10 )
            >> Result.toMaybe

    n9 |> isIn3To10 |> Maybe.map N.toInt
    --> Just 9

    n12 |> isIn3To10
    --> Nothing

TODO: de-warning

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
            lowerLimitDifference_
        )
    , N
        (In
            upperLimitMin
            upperLimitMax
            upperLimitDifference_
        )
    )
    ->
        (N (In min max difference_)
         ->
            Result
                (BelowOrAbove
                    (N (In min lowerLimitMaxMinus1 {}))
                    (N (In (Add1 upperLimitMin) max {}))
                )
                (N (In lowerLimit upperLimitMax {}))
        )
isIn ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            n
                |> maxFrom lowerLimit
                |> maxMap (subDifference (n1 |> difference0))
                |> noDiff
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> minWith
                    ((upperLimit |> minimum)
                        |> addDifference (n1 |> difference0)
                    )
                |> maxFrom n
                |> Above
                |> Err

        else
            (n |> toInt)
                |> minWith (lowerLimit |> minimum)
                |> maxFrom upperLimit
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
                n1 |> N.noMax

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
            lowerLimitDifference_
        )
    ->
        (N (In min max difference_)
         ->
            Result
                (N (In min lowerLimitMaxMinus1 {}))
                (N (In lowerLimitMin max {}))
        )
isAtLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            n
                |> minMap (\_ -> lowerLimit |> minimum)
                |> noDiff
                |> Ok

        else
            n
                |> maxFrom lowerLimit
                |> maxMap (subDifference (n1 |> difference1))
                |> noDiff
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
    N
        (In
            upperLimitMin
            upperLimitMax
            upperLimitDifference_
        )
    ->
        (N (In min max difference_)
         ->
            Result
                (N (In (Add1 upperLimitMin) max {}))
                (N (In min upperLimitMax {}))
        )
isAtMost upperLimit =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            n
                |> maxFrom upperLimit
                |> noDiff
                |> Ok

        else
            n
                |> minMap
                    (\_ ->
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    )
                |> noDiff
                |> Err


{-| The `N (In ... (Is ...))` plus another `N (In ... (Is ...))`. Give the added value twice as a tuple.

    n6 |> N.diffAdd ( n5, n5 )
    --→ n11
    --: N
    --:     (In
    --:         N11
    --:         (Add11 a_)
    --:         (Is
    --:             (Diff x0 To (Add11 x0))
    --:             (Diff x1 To (Add11 x1))
    --:         )
    --:     )

This is only rarely useful, as you shouldn't

    inRangeXAndXPlus10 x =
        -- won't work
        isIn ( x, x |> N.diffAdd ( n10, n10 ) )

Only use it when the `N (In ... (Is ...))` is used once.

    isAtLeast10GreaterThan x =
        isAtLeast (x |> N.diffAdd ( n10, n10 ))

(examples don't compile)

-}
diffAdd :
    ( N
        (In
            added
            added0AtLeast_
            (Is (Diff n To sum) (Diff nAtLeast To sumAtLeast))
        )
    , N
        (In
            added
            added1AtLeast_
            (Is
                (Diff x0PlusN To aPlusSum)
                (Diff x1PlusN To bPlusSum)
            )
        )
    )
    ->
        (N
            (In
                n
                nAtLeast
                (Is
                    (Diff x0 To x0PlusN)
                    (Diff x1 To x1PlusN)
                )
            )
         ->
            N
                (In
                    sum
                    sumAtLeast
                    (Is
                        (Diff x0 To aPlusSum)
                        (Diff x1 To bPlusSum)
                    )
                )
        )
diffAdd ( toAdd, toAddWithAdditionalInformation ) =
    \n ->
        let
            sum : sum
            sum =
                (n |> minimum)
                    |> addDifference (toAdd |> difference0)

            sumDifference :
                Is
                    (Diff x0 To aPlusSum)
                    (Diff x1 To bPlusSum)
            sumDifference =
                { diff0 =
                    (n |> difference0)
                        |> differenceAdd (toAddWithAdditionalInformation |> difference0)
                , diff1 =
                    (n |> difference1)
                        |> differenceAdd (toAddWithAdditionalInformation |> difference1)
                }
        in
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith sum
            |> differenceTo sumDifference
            |> maxFrom n
            |> maxMap (addDifference (toAdd |> difference1))


{-| Add an [`N`](#N). The second argument is the minimum added value.

    atLeast5 |> N.addMin n2 atLeast2
    --: N (Min N7)

Use [`minAdd`](#minAdd) to add exact numbers.

-}
addMin :
    N (In addedMin addedMinAtLeast_ (Is (Diff min To sumMin) addedDiff1_))
    -> N (In addedMin addedMax_ addedDifference_)
    ->
        (N (In min max_ difference_)
         -> N (Min sumMin)
        )
addMin minAdded toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith
                ((n |> minimum)
                    |> addDifference (minAdded |> difference0)
                )


{-| Add an exact [`N (In ... (Is ...))`](#Is) value.

    atLeast70 |> InDiff.add n7
    --: N (Min N77)

Use [`addMin`](#addMin) if you want to add an [`N`](#N) that can be in a range.

-}
minAdd :
    N (In added_ addedAtLeast_ (Is (Diff min To sumMin) addedDiff1_))
    ->
        (N (In min max_ difference_)
         -> N (Min sumMin)
        )
minAdd toAdd =
    addMin toAdd toAdd


{-| Add an [`N`](#N) that can be in a range.

The tuple argument should contain

1.  the minimum added value
2.  the maximum added value

```
between3And10 |> N.addIn ( n1, n12 ) between1And12
--: N (In N4 (N22Plus a_) {})
```

-}
addIn :
    ( N (In minAdded minAddedAtLeast_ (Is (Diff min To sumMin) minAddedDiff1_))
    , N (In maxAdded maxAddedAtLeast_ (Is (Diff max To sumMax) maxAddedDiff1_))
    )
    -> N (In minAdded maxAdded addedDifference_)
    ->
        (N (In min max difference_)
         -> N (In sumMin sumMax {})
        )
addIn ( minAdded, maxAdded ) toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> minWith
                ((n |> minimum)
                    |> addDifference (minAdded |> difference0)
                )
            |> maxFrom n
            |> maxMap (addDifference (maxAdded |> difference0))


{-| The `N (In ... (Is ...)` minus another `N (In ... (Is ...))`. Give the subtracted value twice as a tuple.

    n6 |> N.diffSub ( n5, n5 )
    --→ n1
    --: N
    --:     (In
    --:         N1
    --:         (Add1 a_)
    --:         (Is
    --:             (Diff x0 To (Add1 x0))
    --:             (Diff x1 To (Add1 x1))
    --:         )
    --:     )

This is only rarely useful, as for example

    inRangeXMinus10ToX x =
        isIn (x |> N.diffSub ( n10, n10 )) x

would force `x` to be of type [`N (In ... (Is ...))`](#Is).
Instead,

    inRangeXMinus10ToX x =
        isIn (x |> N.sub n10) x

-}
diffSub :
    ( N
        (In
            subtracted
            subtracted0AtLeast_
            (Is
                (Diff difference To n)
                (Diff differenceAtLeast To nAtLeast)
            )
        )
    , N
        (In
            subtracted
            subtracted1AtLeast_
            (Is
                (Diff x0PlusDifference To x0PlusN)
                (Diff x1PlusDifference To x1PlusN)
            )
        )
    )
    ->
        (N
            (In
                n
                nAtLeast
                (Is
                    (Diff x0 To x0PlusN)
                    (Diff x1 To x1PlusN)
                )
            )
         ->
            N
                (In
                    difference
                    differenceAtLeast
                    (Is
                        (Diff x0 To x0PlusDifference)
                        (Diff x1 To x1PlusDifference)
                    )
                )
        )
diffSub ( subtrahend, subtrahendWithAdditionalInformation ) =
    \n ->
        let
            difference : difference
            difference =
                (n |> minimum)
                    |> subDifference (subtrahend |> difference0)

            differenceDifference :
                Is
                    (Diff x0 To x0PlusDifference)
                    (Diff x1 To x1PlusDifference)
            differenceDifference =
                { diff0 =
                    (n |> difference0)
                        |> differenceSub (subtrahendWithAdditionalInformation |> difference0)
                , diff1 =
                    (n |> difference1)
                        |> differenceSub (subtrahendWithAdditionalInformation |> difference1)
                }
        in
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith difference
            |> differenceTo differenceDifference
            |> maxFrom n
            |> maxMap (subDifference (subtrahend |> difference1))


{-| Subtract an [`N`](#N) that can be in a range.

The tuple argument should contain

1.  the minimum subtracted value
2.  the maximum subtracted value

```
between6And12 |> N.subIn ( n1, n5 ) between1And5
--: N (In N1 (Add5 a_) {})
```

-}
subIn :
    ( N
        (In
            subtractedMin
            subtractedMinAtLeast_
            (Is
                (Diff differenceMax To max)
                subtractedMinDiff1_
            )
        )
    , N
        (In
            subtractedMax
            subtractedMaxAtLeast_
            (Is
                (Diff differenceMin To min)
                subtractedMaxDiff1_
            )
        )
    )
    -> N (In subtractedMin subtractedMax subtractedDifference_)
    ->
        (N (In min max difference_)
         -> N (In differenceMin differenceMax {})
        )
subIn ( subtractedMin, subtractedMax ) subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith
                ((n |> minimum)
                    |> subDifference (subtractedMax |> difference0)
                )
            |> maxFrom n
            |> maxMap (subDifference (subtractedMin |> difference0))


{-| From an [`N`](#N) without an unknown maximum constraint,
subtract a number in a range.

The first argument is the maximum of the subtracted number.

    atLeast6 |> N.minSubMax n5 between0And5
    --: N (Min N1)

-}
minSubMax :
    N
        (In
            subtractedMax
            subtractedMaxAtLeast_
            (Is
                (Diff differenceMin To min)
                subtractedMaxDiff1_
            )
        )
    -> N (In (N0able add1SubtractedMin_ Possibly) subtractedMax subtractedDifference_)
    ->
        (N (In min max difference_)
         -> N (In differenceMin max {})
        )
minSubMax subtractedMax subtrahend =
    subIn ( n0, subtractedMax ) (subtrahend |> minDown n0)


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#Is)

    atLeast7 |> N.minSub n2
    --: N (Min N5)

Use [`minSubMax`](#minSubMax) if you want to subtract an [`N`](#N) that can be in a range.

-}
minSub :
    N
        (In
            subtracted_
            subtractedAtLeast_
            (Is (Diff differenceMin To min) subtractedDiff1_)
        )
    ->
        (N (In min max difference_)
         -> N (In differenceMin max {})
        )
minSub subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> minWith
                ((n |> minimum)
                    |> subDifference (subtrahend |> difference0)
                )
            |> maxFrom n



-- # internals


{-| Constructor for [`NoMax`](#NoMax)
-}
maximumUnknown : NoMax
maximumUnknown =
    N.Internal.MaximumUnknown


{-| The smallest allowed number promised by the [range type](#In).
-}
minimum : N (In minimum maximum_ difference_) -> minimum
minimum =
    N.Internal.minimum


{-| The number representation as all [difference](#Diff)s promised by its type [`Is (Diff low0 To high0) (Diff low1 To high1)`](#Is).

For the individual [difference](#Diff)s: [`difference0`](#difference0), [`difference1`](#difference1)

-}
differences : N (In min_ max_ differences) -> differences
differences =
    N.Internal.differences


{-| The number representation as a [difference](#Diff) promised by its type [`Is (Diff low To high) ...`](#Is).
-}
difference0 :
    N (In min_ max_ { differences_ | diff0 : difference0 })
    -> difference0
difference0 =
    differences >> .diff0


{-| The number representation as a [difference](#Diff) promised by its type [`Is ... (Diff low To high)`](#Is).
-}
difference1 :
    N (In min_ max_ { differences_ | diff1 : difference1 })
    -> difference1
difference1 =
    differences >> .diff1


{-| To the number, add a specific other one by supplying one of its [difference](#Diff)s
promised by its type [`Is (Diff low0 To high0) (Diff low1 To high1)`](#Is)
-}
addDifference : Diff low To high -> (low -> high)
addDifference =
    \(Difference differenceOperation) -> differenceOperation.add


{-| To the number, subtract a specific other one by supplying one of its [difference](#Diff)s
promised by its type [`Is (Diff low0 To high0) (Diff low1 To high1)`](#Is)
-}
subDifference : Diff low To high -> (high -> low)
subDifference =
    \(Difference differenceOperation) -> differenceOperation.sub


{-| Chain the [difference](#Diff) further to a higher number.
-}
differenceAdd :
    Diff middle To high
    -> (Diff low To middle -> Diff low To high)
differenceAdd diffMiddleToHigh =
    \diffLowToMiddle ->
        Difference
            { add =
                addDifference diffLowToMiddle
                    >> addDifference diffMiddleToHigh
            , sub =
                subDifference diffMiddleToHigh
                    >> subDifference diffLowToMiddle
            }


{-| Chain the [difference](#Diff) back to a lower number.
-}
differenceSub :
    Diff middle To high
    -> (Diff low To high -> Diff low To middle)
differenceSub diffMiddleToHigh =
    \diffLowToHigh ->
        Difference
            { add =
                addDifference diffLowToHigh
                    >> subDifference diffMiddleToHigh
            , sub =
                addDifference diffMiddleToHigh
                    >> subDifference diffLowToHigh
            }


n0Difference : Diff n To n
n0Difference =
    Difference
        { add = identity
        , sub = identity
        }


n1Difference : Diff n To (Add1 n)
n1Difference =
    Difference
        { add = Add1
        , sub =
            \zeroableNever ->
                case zeroableNever of
                    Add1 lower ->
                        lower

                    N0 possible ->
                        possible |> never
        }



--


{-| The exact natural number `0`
-}
n0 : N (In N0 atLeast_ (Is (Diff x0 To x0) (Diff x1 To x1)))
n0 =
    0
        |> minWith (N0 Possible)
        |> maxMap
            (\_ ->
                let
                    {- The [mutual recursion prevents TCO](https://jfmengels.net/tail-call-optimization/#so-what-are-these-conditions),
                       forcing a stack overflow runtime exception.

                       The arguments help identify the cause on inspection when debugging.

                    -}
                    failLoudlyWithStackOverflow : List String -> valueThatWillNeverBeCreatedDueToRuntimeError_
                    failLoudlyWithStackOverflow details =
                        let
                            failLoudlyWithStackOverflowMutuallyRecursive : List String -> valueThatWillNeverBeCreatedDueToRuntimeError_
                            failLoudlyWithStackOverflowMutuallyRecursive messageAndCulpritRecursive =
                                failLoudlyWithStackOverflow messageAndCulpritRecursive
                        in
                        failLoudlyWithStackOverflowMutuallyRecursive details
                in
                {- Currently, by design, no `N0able` unifies with higher `N<x>`s

                       N0 Possible

                   is impossible as a maximum for `n0` for example because

                       N0able atLeast Possibly

                   correctly doesn't unify with any `N< x≥1 >`

                   ideas:

                   - 👎 define
                       n<x> : N (In (Add<x> atLeast\_) N<x> ...)
                       N<x> = Add<x> Never -- to forbid > max
                       N0able s = [ N0 | Add1 s ]
                   - requirements for minimum can't be expressed
                   - `Diff` `sub` becomes impossible to implement
                   - 👎 adding an escape hatch
                       N0able s possiblyOrNever = [ N0AtLeast | N0 possiblyOrNever | Add1 s ]
                   - `Diff` `sub` becomes impossible to implement

                   Happen to have more ideas
                   on how to avoid the current hack (which also makes elm crash on `==`)?
                   → please PR

                -}
                failLoudlyWithStackOverflow
                    [ "internal minimum evaluated or leaked somewhere from `N`'s API."
                    , "💙 Please report under https://github.com/lue-bird/elm-bounded-nat/issues"
                    ]
            )
        |> differenceTo { diff0 = n0Difference, diff1 = n0Difference }


{-| The exact natural number `1`
-}
n1 : N (In N1 (Add1 atLeast_) (Is (Diff x0 To (Add1 x0)) (Diff x1 To (Add1 x1))))
n1 =
    1
        |> minWith (n0 |> minimum |> Add1)
        |> differenceTo { diff0 = n1Difference, diff1 = n1Difference }
        |> maxFrom n0
        |> maxMap Add1


{-| The exact natural number `2`
-}
n2 : N (In N2 (Add2 atLeast_) (Is (Diff x0 To (Add2 x0)) (Diff x1 To (Add2 x1))))
n2 =
    n1 |> diffAdd ( n1, n1 )


{-| The exact natural number `3`
-}
n3 : N (In N3 (Add3 atLeast_) (Is (Diff x0 To (Add3 x0)) (Diff x1 To (Add3 x1))))
n3 =
    n2 |> diffAdd ( n1, n1 )


{-| The exact natural number `4`
-}
n4 : N (In N4 (Add4 atLeast_) (Is (Diff x0 To (Add4 x0)) (Diff x1 To (Add4 x1))))
n4 =
    n3 |> diffAdd ( n1, n1 )


{-| The exact natural number `5`
-}
n5 : N (In N5 (Add5 atLeast_) (Is (Diff x0 To (Add5 x0)) (Diff x1 To (Add5 x1))))
n5 =
    n4 |> diffAdd ( n1, n1 )


{-| The exact natural number `6`
-}
n6 : N (In N6 (Add6 atLeast_) (Is (Diff x0 To (Add6 x0)) (Diff x1 To (Add6 x1))))
n6 =
    n5 |> diffAdd ( n1, n1 )


{-| The exact natural number `7`
-}
n7 : N (In N7 (Add7 atLeast_) (Is (Diff x0 To (Add7 x0)) (Diff x1 To (Add7 x1))))
n7 =
    n6 |> diffAdd ( n1, n1 )


{-| The exact natural number `8`
-}
n8 : N (In N8 (Add8 atLeast_) (Is (Diff x0 To (Add8 x0)) (Diff x1 To (Add8 x1))))
n8 =
    n7 |> diffAdd ( n1, n1 )


{-| The exact natural number `9`
-}
n9 : N (In N9 (Add9 atLeast_) (Is (Diff x0 To (Add9 x0)) (Diff x1 To (Add9 x1))))
n9 =
    n8 |> diffAdd ( n1, n1 )


{-| The exact natural number `10`
-}
n10 : N (In N10 (Add10 atLeast_) (Is (Diff x0 To (Add10 x0)) (Diff x1 To (Add10 x1))))
n10 =
    n9 |> diffAdd ( n1, n1 )


{-| The exact natural number `11`
-}
n11 : N (In N11 (Add11 atLeast_) (Is (Diff x0 To (Add11 x0)) (Diff x1 To (Add11 x1))))
n11 =
    n10 |> diffAdd ( n1, n1 )


{-| The exact natural number `12`
-}
n12 : N (In N12 (Add12 atLeast_) (Is (Diff x0 To (Add12 x0)) (Diff x1 To (Add12 x1))))
n12 =
    n11 |> diffAdd ( n1, n1 )


{-| The exact natural number `13`
-}
n13 : N (In N13 (Add13 atLeast_) (Is (Diff x0 To (Add13 x0)) (Diff x1 To (Add13 x1))))
n13 =
    n12 |> diffAdd ( n1, n1 )


{-| The exact natural number `14`
-}
n14 : N (In N14 (Add14 atLeast_) (Is (Diff x0 To (Add14 x0)) (Diff x1 To (Add14 x1))))
n14 =
    n13 |> diffAdd ( n1, n1 )


{-| The exact natural number `15`
-}
n15 : N (In N15 (Add15 atLeast_) (Is (Diff x0 To (Add15 x0)) (Diff x1 To (Add15 x1))))
n15 =
    n14 |> diffAdd ( n1, n1 )


{-| The exact natural number `16`
-}
n16 : N (In N16 (Add16 atLeast_) (Is (Diff x0 To (Add16 x0)) (Diff x1 To (Add16 x1))))
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
