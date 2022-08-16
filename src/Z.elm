module Z exposing
    ( Z
    , In, Min, Max, Unlimited, UpExactly
    , Up(..), Down, To, UpExact, DownExact
    , int, randomIn, until
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , BelowOrAbove(..)
    , atLeast, minAtLeast, atMost, in_
    , is, isIn, isAtLeast, isAtMost
    , negate, abs
    , add, minAdd, maxAdd
    , sub, minSub, maxSub
    , toPower, remainderBy, mul, div
    , toInt, toFloat
    , minNo, min, minDown
    , maxNo, max, maxUp
    , range, minimumAsDifference, maximumAsDifference
    , N0able(..), unlimited
    , upFixed, downFixed
    , differenceUp, differenceDown, differenceNegate
    , upDifference, downDifference
    , maxAtMost
    )

{-| Natural numbers within a typed range.

@docs Z


# bounds

@docs In, Min, Max, Unlimited, UpExactly
@docs Up, Down, To, UpExact, DownExact


# create

@docs int, randomIn, until


# specific numbers

If the package exposed every number 0 → 1000+, [tools can become unusably slow](https://github.com/lue-bird/elm-typesafe-array/issues/2).

So only 0 → 16 are exposed, while larger numbers have to be generated locally.

Current method: [generate them](https://lue-bird.github.io/elm-bounded-nat/generate/) into a `module exposing (n500, N500, Add500, ...)` + `import as Z exposing (n500, ...)`

In the future, [`elm-generate`](https://github.com/lue-bird/generate-elm) will allow auto-generating via [`elm-review`](https://dark.elm.dmy.fr/packages/jfmengels/elm-review/latest/).


## type `n`

[⏭ skip to last](#N16)

@docs N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16


## type `n +`

[⏭ skip to last](#Add16)

@docs Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16


## exact

[⏭ skip to last](#n16)

@docs n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16


## compare


## `Int` compare

@docs intIsAtLeast, intIsIn, BelowOrAbove


## clamp

@docs atLeast, minAtLeast, atMost, in_


## compare maximum constrained

@docs is, isIn, isAtLeast, isAtMost


# alter

@docs negate, abs
@docs add, minAdd, maxAdd
@docs sub, minSub, maxSub
@docs toPower, remainderBy, mul, div


## broaden

@docs toInt, toFloat


# type information

@docs minNo, min, minDown
@docs maxNo, max, maxUp


# miss operation x?

Anything that can't be expressed with the available operations
like `positiveInfinity` and `negativeInfinity`?
→ issue/PR


# fancy

Building extensions to this library
– like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/) or other structures

While the internally stored `Int` can't directly be guaranteed to be in bounds by elm,
[minimum](#minimumAsDifference), [maximum](#maximumAsDifference) as their representation as a [difference](#Up)
must be built as actual values checked by the compiler.
No shenanigans like runtime errors for impossible cases.

@docs range, minimumAsDifference, maximumAsDifference

@docs N0able, unlimited
@docs upFixed, downFixed
@docs differenceUp, differenceDown, differenceNegate
@docs upDifference, downDifference

-}

import Emptiable exposing (Emptiable)
import Help exposing (valueElseOnError)
import Possibly exposing (Possibly(..))
import Random
import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)
import Stack exposing (Stacked)


{-| A **bounded** number


### argument type

    -- ≥ 0, any limitations allowed
    Z range_

    -- ≥ 4
    Z (In (UpExact (Add4 minMinus4_)) max_)

    -- 4 ≤ n ≤ 15
    Z (In (UpExact (Add4 minMinus4_)) (Up maxTo15_ To N15))

`In (Add4 minMinus4_) N15` says:

  - the minimum-constraint can be `4 + 0`|`4 + 1`|`4 + 2`|...
  - the argument's maximum `+` some variable `maxTo15` is `15`
    which means: the maximum is ≤ 15


### result type

    -- ≥ 4
    Z (Min (Up x To (Add4 x)))

    -- 2 ≤ n ≤ 12
    Z (In (Up x To (Add2 x)) (Up x To (Add12 x)))

    n3 : Z (In (Up minX To (Add3 minX)) (Up maxX To (Add3 maxX)))

[`Up low To high`] is a representation as a difference of the limit `high - low`

This enables adding, subtracting.
Consider it an implementation detail.

    n3 |> Z.add n6
    --→ n9


### stored type

what to put in declared types like `Model`

    -- ≥ 4
    Z (Min (UpExact N4))

    -- 2 ≤ n ≤ 12
    Z (In (UpExact N2) (UpExact N12))

They are like [result types](#result-type) but type variables are set to [`N0`](#N0).

more type examples at [`In`](#In), [`Min`](#Min)

-}
type Z range
    = LimitedIn range Int


{-| somewhere within a `minimum` & `maximum`

           ↓ minimum   ↓ maximum
    ....⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### argument type in a range

    -- number between 3 and 5
    Z (In (UpExact (Add3 minX_)) (Up maxTo5_ N5))

    percent : Z (In min_ (Up maxTo100 To N100)) -> Percent

`min ≤ max ≤ N100`

Leave limits you don't care about as a type _variable_

    -- any number
    Z (In min_ max_)

    minimum  maximum
       ↓     ↓ or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

    -- number, at least 5
    Z (In (Add5 minMinus5_) max_)

    minimum       maximum
    ← or ↓           ↓
      ...✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯

    -- number, at most 5
    Z (In min_ (Up maxTo5_ To N5))

  - → `min_` could be a specific maximum or [no minimum at all](#Unlimited)
  - → `max_` could be a specific maximum or [no maximum at all](#Unlimited)


### result type in a range

    n3 : Z (In (Up minX To (Add3 minX)) (Up maxX To (Add3 maxX)))

    between3And6 : Z (In (Up minX To (Add3 minX)) (Up maxX To (Add6 maxX)))

    between3And6 |> Z.add n3
    --: Z (In (Up minX To (Add6 minX)) (Up maxX To (Add9 maxX)))


### stored type in a range

Like the result type but every `Up x To (Add<x> x)` becomes [`UpExact N<x>`](#UpExact)

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeBinary element =
        Tree (UpExactly N2) element

Remember: ↑ and other [`Min`](#Min)/[`UpExactly`](#UpExactly)/[`UpExact`](#UpExact) are result/stored types, not argument types.

---

Do not use `==` on 2 values storing a range.
It can lead to elm crashing because [difference](#Up)s are stored as functions.
[compare](#compare) instead.

-}
type alias In minimumAsDifference maximumAsDifference =
    RecordWithoutConstructorFunction
        { minimumAsDifference : minimumAsDifference
        , maximumAsDifference : maximumAsDifference
        }


{-| Only **stored / result types should use the type `Min`**:

    minimum  maximum
       ↓     ↓ or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...


### result type without maximum constraint

Sometimes, you simply cannot compute a maximum.

    abs : Int -> Z (In (Up x To x) ??)
                    ↓
    abs : Int -> Z (Min (Up x To x))

    -- number ≥ 5
    atLeast5 : Z (Min (Up x To (Add5 x)))

    atLeast5 |> Z.minAdd n3
    --: Z (Min (Up x To (Add8 x)))


### argument type without maximum constraint

Every `Min min` is of type `In min ...`,
so using a type variable for the maximum on arguments is highly encouraged
when no maximum constraint should be enforced.

    -- any number
    Z (In min_ max_)

    -- number, at least 5
    Z (In (Add5 minMinus5_) max_)


### stored type without maximum constraint

Like the result type but every `Up x To (Add<x> x)` becomes [`UpExact N<x>`](#UpExact)

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeMulti element =
        Tree (Min (UpExact N2)) element

Remember: ↑ and other [`Min`](#Min)/[`UpExactly`](#UpExactly)/[`UpExact`](#UpExact) are result/stored types, not argument types.

---

Do not use `==` on 2 values storing a range.
It can lead to elm crashing because [difference](#Up)s are stored as functions.
[compare](#compare) instead.

-}
type alias Min lowestPossibleValue =
    In lowestPossibleValue Unlimited


{-| Only **stored / result types should use the type `Max`**:

    minimum       maximum
    ← or ↓           ↓
      ...✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯


### result type without maximum constraint

Sometimes, you simply cannot compute a maximum.

    absNegative : Int -> Z (In (Up x To x) ??)
                             ↓
    absNegative : Int -> Z (Max (Up x To x))

    -- number <= 5
    atMost5 : Z (Max (Up x To (Add5 x)))

    atMost5 |> Z.maxAdd n3
    --: Z (Max (Up x To (Add8 x)))


### argument type without maximum constraint

Every `Min min` is of type `In min ...`,
so using a type variable for the maximum on arguments is highly encouraged
when no maximum constraint should be enforced.

    -- any number
    Z (In min_ max_)

    -- number, at most 5
    Z (In min_ (Up maxTo5_ To N5))


### stored type without maximum constraint

Like the result type but every `Up x To (Add<x> x)` becomes [`UpExact N<x>`](#UpExact)

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeMulti element =
        Tree (Min (UpExact N2)) element

Remember: ↑ and other [`Min`](#Min)/[`UpExactly`](#UpExactly)/[`UpExact`](#UpExact) are result/stored types, not argument types.

---

Do not use `==` on 2 values storing a range.
It can lead to elm crashing because [difference](#Up)s are stored as functions.
[compare](#compare) instead.

-}
type alias Max max =
    In Unlimited max


{-| Allow only the specific given non-negative number

Useful as a **stored & argument** type in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with [`Z`](#Z)s.

    byte : ArraySized (UpExactly N8) Bit -> Byte

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s.

    type alias TicTacToeBoard =
        ArraySized
            (UpExactly N3)
            (ArraySized (UpExactly N3) TicTacToField)

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s.

Have a use-case for `DownExactly`? → issue/PR

-}
type alias UpExactly n =
    In (UpExact n) (UpExact n)


{-| `Up low To high`: an exact number as the difference `high - low`.
-}
type Up low toTag high
    = Difference
        { up : low -> high
        , down : high -> low
        }


{-| `Down high To low`: an exact number as the difference `high - low`.
-}
type alias Down high toTag low =
    Up low toTag high


{-| Just a word in a [difference type](#Up):

    Up low To high

    Down high To high

→ distance `high - low`.

-}
type To
    = To Never


{-| Flag "The number's limit is unknown" used in the definitions

    type alias Min min =
        In min Unlimited

    type alias Max max =
        In Unlimited max

    int : Int -> Z (In Unlimited Unlimited)

-}
type alias Unlimited =
    Up { unlimited : () } To { unlimited : () }


{-| An [`Unlimited`](#Unlimited) [difference](#Up)
-}
unlimited : Unlimited
unlimited =
    n0Difference


{-| The exact number as the difference from 0 to the number.

A stored type looks
like a [result type](#result-type)
but every [`Up x To (Add<x> x)`](#Up) becomes [`UpExact N<x>`](#UpExact)

-}
type alias UpExact n =
    Up N0 To n


{-| The exact number as the difference from a number to 0.

A stored type looks
like a [result type](#result-type)
but every [`Down (Add<x> x) To x`](#Down) becomes [`DownExact N<x>`](#UpExact)

-}
type alias DownExact n =
    Down N0 To n


{-| [`To`](#To) the exact given number, create a [fixed difference from 0](#UpExact)
-}
upFixed : n -> UpExact n
upFixed n =
    Difference
        { up = \_ -> n
        , down = \_ -> N0 Possible
        }


{-| From the exact given number, create a [fixed difference to 0](#DownExact)
-}
downFixed : n -> DownExact n
downFixed n =
    Difference
        { up = \_ -> N0 Possible
        , down = \_ -> n
        }


differenceNegate : Up x To upX -> Down x To upX
differenceNegate =
    \difference ->
        Difference
            { up = difference |> downDifference
            , down = difference |> upDifference
            }



--


{-| Flip its sign `+ ⇆ -`
-}
negate :
    Z (In (Up minX To minUpX) (Up maxX To maxUpX))
    -> Z (In (Down maxX To maxUpX) (Down minX To minUpX))
negate =
    \z ->
        (z |> toInt)
            |> Basics.negate
            |> LimitedIn
                { minimumAsDifference =
                    (z |> maximumAsDifference)
                        |> differenceNegate
                , maximumAsDifference =
                    (z |> minimumAsDifference)
                        |> differenceNegate
                }


{-| Its distance from `0` which is always `≥ 0`

    -4
        |> Z.int
        |> Z.abs
        --: Z (Min (Up x To x))
        |> Z.toInt
    --> 4

    16 |> Z.int |> Z.abs |> Z.toInt
    --> 16

Really only use this if you want the absolute value.

    badLength =
        List.length >> Z.int >> Z.abs

  - maybe, there's a solution that never even theoretically deals with unexpected values:

        mostCorrectLength =
            List.foldl
                (\_ -> Z.minAdd n1 >> Z.minDown n1)
                (n0 |> Z.maxNo)

  - other times, though, like with `Array.length`, which isn't `O(n)`,
    you can escape with for example

        arrayLength =
            Array.length >> Z.int >> Z.atLeast n0

To handle the cases negative or not yourself → [`isAtLeast n0`](#isAtLeast)

-}
abs :
    Z (In min_ max_)
    -> Z (Min (Up x To x))
abs =
    \z ->
        case z |> isAtLeast n0 of
            Ok n0AtLeast ->
                n0AtLeast |> maxNo

            Err negative ->
                negative |> minNo |> negate |> min n0


{-| Add a given [specific](#In) [`Z`](#Z).

    between70And100 |> Z.add n7
    --: Z (In (Up minX To (Add77 minX)) (Up maxX To (Add107 maxX)))

One addend has an unconstrained maximum? → [`minAdd`](#minAdd)

-}
add :
    Z
        (In
            (Up minUpX To sumMinUpX)
            (Up maxUpX To sumMaxUpX)
        )
    ->
        (Z (In (Up minX To minUpX) (Up maxX To maxUpX))
         ->
            Z
                (In
                    (Up minX To sumMinUpX)
                    (Up maxX To sumMaxUpX)
                )
        )
add toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> LimitedIn
                { minimumAsDifference =
                    (n |> minimumAsDifference)
                        |> differenceUp
                            (toAdd |> minimumAsDifference)
                , maximumAsDifference =
                    (n |> maximumAsDifference)
                        |> differenceUp
                            (toAdd |> maximumAsDifference)
                }


{-| 1:1 Conversion from a given `Int` to a [`Z`](#Z)
that neither has minimum nor maximum constraints

    -5 |> int
    --: Z (In Unlimited Unlimited)

-}
int : Int -> Z (In Unlimited Unlimited)
int =
    LimitedIn
        { minimumAsDifference = unlimited
        , maximumAsDifference = unlimited
        }



--


untilReverse :
    Z (In (UpExact min_) (Up maxX To maxUpX))
    ->
        Emptiable
            (Stacked
                (Z (In (Up x0 To x0) (Up maxX To maxUpX)))
            )
            Never
untilReverse last =
    case last |> isAtLeast n1 of
        Err _ ->
            n0 |> max last |> Stack.only

        Ok lastAtLeast1 ->
            (lastAtLeast1 |> maxUp n1 |> sub n1 |> untilReverseRecursive)
                |> Stack.onTopLay (lastAtLeast1 |> min n0)


{-| [`Z`](#Z)s increasing from `0` to `n`
In the end, there are `n` numbers.

    import Stack

    Z.until n6
        |> Stack.map (\_ -> Z.add n3)
        --: Emptiable
        --:     (Stacked
        --:         (Z
        --:             (In
        --:                 (Up minX To (Add3 minX))
        --:                 (Up maxX To (Add9 maxX))
        --:             )
        --:         )
        --:     )
        --:     Never
        |> Stack.map (\_ -> Z.toInt)
    --> Stack.topDown 3 [ 4, 5, 6, 7, 8, 9 ]

    Z.until atLeast7 |> Stack.map (\_ -> Z.minAdd n3)
    --: Emptiable
    --:     (Stacked (Z (Min (Up x To (Add10 x)))))
    --:     Never

[`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/ArraySized#until) even knows the length!
Wanna try it?

-}
until :
    Z (In (UpExact min_) (Up maxX To maxUpX))
    ->
        Emptiable
            (Stacked
                (Z (In (Up x0 To x0) (Up maxX To maxUpX)))
            )
            Never
until last =
    untilReverse last |> Stack.reverse


untilReverseRecursive :
    Z (In (UpExact min_) (Up maxX To maxUpX))
    ->
        Emptiable
            (Stacked
                (Z (In (Up x0 To x0) (Up maxX To maxUpX)))
            )
            Never
untilReverseRecursive =
    untilReverse


{-| Generate a random [`Z`](#Z) in a range.

    Z.randomIn ( n1, n10 )
    --: Random.Generator
    --:     (Z
    --:         (In
    --:             (Up minX To (Add1 minX))
    --:             (Up maxX To (Add10 maxX))
    --:         )
    --:     )

-}
randomIn :
    ( Z
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , Z (In (UpExact upperLimitMin) upperLimitMax)
    )
    ->
        Random.Generator
            (Z (In lowerLimitMin upperLimitMax))
randomIn ( lowestPossible, highestPossible ) =
    Random.int (lowestPossible |> toInt) (highestPossible |> toInt)
        |> Random.map
            (LimitedIn
                { minimumAsDifference = lowestPossible |> minimumAsDifference
                , maximumAsDifference = highestPossible |> maximumAsDifference
                }
            )



--


{-| **Clamp** the number to between both a given minimum & maximum

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

.

    0
        |> Z.int
        |> Z.in_ ( n3, n12 )
        --: Z (In (Up minX To (Add3 minX)) (Up minX To (Add12 minX)))
        |> Z.toInt
    --> 3

    99
        |> Z.int
        |> Z.in_ ( n3, n12 )
        |> Z.toInt
    --> 12

    9
        |> Z.int
        |> Z.in_ ( n3, n12 )
        |> Z.toInt
    --> 9





    between5And9 |> Z.in_ ( n10, n10 )
    --: Z (In (Up x0 To (Add10 x0)) (Up x1 To (Add10 x1)))

    between5And15 |> Z.in_ ( n5, n10 )
    --: Z (In (Up minX To (Add5 minX)) (Up maxX To (Add10 maxX)))

    atLeast5 |> Z.in_ ( n5, n10 )
    --: Z (In (Up minX To (Add5 minX)) (Up maxX To (Add10 maxX)))

(The type doesn't forbid that the limits you're comparing against
are beyond the current limits.)

  - To handle the cases `< minimum` & `> maximum` explicitly → [`intIsIn`](#intIsIn)
  - There shouldn't be an upper limit? → [`minAtLeast`](#minAtLeast)
  - To keep the current maximum → [`atLeast`](#atLeast)
  - To keep the current minimum → [`atMost`](#atMost)

-}
in_ :
    ( Z (In minNew (Up minNewMaxToMaxNewMin_ To maxNewMin))
    , Z (In (UpExact maxNewMin) maxNew)
    )
    ->
        (Z (In min_ max_)
         -> Z (In minNew maxNew)
        )
in_ ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            lowerLimit |> max upperLimit

        else if (n |> toInt) > (upperLimit |> toInt) then
            upperLimit |> min lowerLimit

        else
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = lowerLimit |> minimumAsDifference
                    , maximumAsDifference = upperLimit |> maximumAsDifference
                    }


{-| **Cap** the [`Z`](#Z) without maximum constraint
to `>=` a given new lower limit.

    n5AtLeast |> Z.minAtLeast n10
    --: Z (Min (Up x To (Add10 x)))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15AtLeast |> Z.minAtLeast n10 |> Z.toInt
    --: Z (Min (Up x To (Add10 x)))

  - Know both maxima? → [`atLeast`](#atLeast)
  - To handle the case where it's less yourself → [`isAtLeast`](#isAtLeast)

-}
minAtLeast :
    Z (In minNew (Up minNewMaxX_ To minNewMaxUpX_))
    ->
        (Z (In min_ max_)
         -> Z (Min minNew)
        )
minAtLeast minimumLimit =
    \z ->
        case z |> isAtLeast (minimumLimit |> maxUp n1) of
            Ok atLeastMinimum ->
                atLeastMinimum |> maxNo

            Err _ ->
                minimumLimit |> maxNo


{-| **Cap** the [`Z`](#Z) to `<=` a given new upper limit.

    between3And10
        |> Z.atMost between2And5
    --: Z (In (UpExact 2) (Up x To (Add5 x)))

To replace the [`UpExact`](#UpExact) minimum with a [difference](#Up)
(for results etc.) → [`min`](#min)

To enforce a new minimum as well → [`in_`](#in_)

-}
atMost :
    Z (In (UpExact maxNewMin) maxNew)
    ->
        (Z (In (Up minToTakenMin_ To maxNewMin) max_)
         -> Z (In (UpExact maxNewMin) maxNew)
        )
atMost maximumLimitNew =
    -- TODO check correctness:
    -- min = Up x To (Add3 x), UpExact N4
    --     works
    -- min = Up x To (Add3 x), DownExact N2
    --     correctly doesn't work
    -- min = Up (Add3 x) To x, UpExact N4
    --     works
    -- min = Up (Add3 x) To x, DownExact N2
    --     impossible
    \z ->
        case z |> isAtMost maximumLimitNew of
            Ok atMostMaximumLimit ->
                (atMostMaximumLimit |> toInt)
                    |> LimitedIn
                        { minimumAsDifference = maximumLimitNew |> minimumAsDifference
                        , maximumAsDifference = maximumLimitNew |> maximumAsDifference
                        }

            Err _ ->
                maximumLimitNew


{-| **Cap** the [`Z`](#Z) to `<=` a given new upper limit.

    atMost10
        |> Z.minAtMost between2And5
    --: Z (Max (Up x To (Add5 x)))

  - Know both maxima? → [`atMost`](#atMost)
  - To enforce a new minimum as well → [`in_`](#in_)

-}
maxAtMost :
    Z (In (Up maxNewMinX_ To maxNewMinUpX_) maxNew)
    ->
        (Z (In min_ max_)
         -> Z (Max maxNew)
        )
maxAtMost maximumLimitNew =
    \z ->
        case z |> isAtMost maximumLimitNew of
            Err _ ->
                maximumLimitNew |> minNo

            Ok atMostMaximumLimitNew ->
                atMostMaximumLimitNew |> minNo



{- \n ->
   if (n |> toInt) <= (maximumLimit |> toInt) then
       (n |> toInt)
           |> LimitedIn
               { minimumAsDifference = maximumLimit |> minimumAsDifference
               , maximumAsDifference = maximumLimit |> maximumAsDifference
               }

   else
       maximumLimit
-}


{-| **Cap** the [`Z`](#Z) to `>=` a given new lower limit.

    between5And12 |> Z.atLeast n10
    --: Z (In (Up x To (Add10 x)) (UpExact N12))

    0
        |> Z.int
        |> Z.atLeast n3
        --: Z (Min (Up x To (Add3 x)))
        |> Z.toInt
    --> 3

    9
        |> Z.int
        |> Z.atLeast n3
        --: Z (Min (Up x To (Add3 x)))
        |> Z.toInt
    --> 9

You can also use this as an escape hatch
if you know an `Int` must be at least `minimum`.
But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ -> Z.minAdd n1 >> Z.minDown n1)
            (n0 |> Z.maxNo)

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15
        |> Z.atLeast n10
        --: Z (In (Up x To (Add10 x)) (UpExact N15))
        |> Z.toInt
    --> 15

  - Don't know both maxima? → [`minAtLeast`](#minAtLeast)
  - To handle the case where it's less yourself → [`isAtLeast`](#isAtLeast)

-}
atLeast :
    Z (In minNew (Up minNewMaxToMax_ To max))
    ->
        (Z (In min_ (UpExact max))
         -> Z (In minNew (UpExact max))
        )
atLeast minimumLimit =
    -- TODO check correctness:
    -- min = Up x To (Add3 x), UpExact N4
    --     works
    -- min = Up x To (Add3 x), DownExact N2
    --     correctly doesn't work
    -- min = Up (Add3 x) To x, UpExact N4
    --     works
    -- min = Up (Add3 x) To x, DownExact N2
    --     impossible
    \n ->
        if (n |> toInt) >= (minimumLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = minimumLimit |> minimumAsDifference
                    , maximumAsDifference = n |> maximumAsDifference
                    }

        else
            (minimumLimit |> toInt)
                |> LimitedIn
                    { minimumAsDifference = minimumLimit |> minimumAsDifference
                    , maximumAsDifference = n |> maximumAsDifference
                    }



--


{-| Multiply by a given [`n`](#Z) `≥ 1`.
which means `x * n ≥ x`.

    atLeast5 |> Z.mul n2
    --: Z (Min (Up x To (Add5 x)))

    atLeast2 |> Z.mul n5
    --: Z (Min (Up x To (Add2 x)))

-}
mul :
    Z (In (UpExact (Add1 multiplicandMinMinus1_)) multiplicandMax_)
    ->
        (Z (In min max_)
         -> Z (Min min)
        )
mul multiplicand =
    \n ->
        (n |> toInt)
            * (multiplicand |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = unlimited
                }


{-| Divide (`//`) by an [`Z`](#Z) `d ≥ 1`.

  - → `/ 0` is impossible
  - → `x / d <= x`

.

    atMost7
        |> Z.div n3
        --: Z (In (Up minX To minX) (Up maxX To (Add7 maxX)))
        |> Z.toInt

-}
div :
    Z (In (UpExact (Add1 divisorMinMinus1_)) divisorMax_)
    ->
        (Z (In min_ max)
         -> Z (In (Up minX To minX) max)
        )
div divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> LimitedIn
                { minimumAsDifference = n0 |> minimumAsDifference
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| The remainder after dividing by a [`Z`](#Z) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> Z.remainderBy n3
    --: Z (In (Up minX To minX) (Up maxX To (Add2 maxX)))

-}
remainderBy :
    Z
        (In
            (UpExact (Add1 divisorMinMinus1_))
            (Up divX To (Add1 divisorMaxUpXMinus1))
        )
    ->
        (Z (In min_ max_)
         ->
            Z
                (In
                    (Up x0 To x0)
                    (Up divX To divisorMaxUpXMinus1)
                )
        )
remainderBy divisor =
    \n ->
        (n |> toInt)
            |> Basics.remainderBy (divisor |> toInt)
            |> LimitedIn
                { minimumAsDifference = n0 |> minimumAsDifference
                , maximumAsDifference =
                    (divisor |> maximumAsDifference)
                        |> differenceDown (n1 |> minimumAsDifference)
                }


{-| [`Z`](#Z) Raised to a given power `p ≥ 1`
→ `x ^ p ≥ x`

    atLeast5 |> Z.toPower n2
    --: Z (Min (Up x To (Add5 x)))

    atLeast2 |> Z.toPower n5
    --: Z (Min (Up x To (Add2 x)))

-}
toPower :
    Z (In (UpExact (Add1 exponentMinMinus1_)) exponentMax_)
    ->
        (Z (In min max_)
         -> Z (Min min)
        )
toPower exponent =
    \n ->
        (n |> toInt)
            ^ (exponent |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = unlimited
                }



-- type information


{-| On `Z (In min max)`'s type, drop `min` to get a `Z (Max max)`.

    between3And10 |> Z.minNo
    --: Z (Max (Up x To (Add10 x)))

Use it to unify different types of number minimum constraints like

    [ atMost1, between1And10 ]

elm complains:

> But all the previous elements in the list are: `Z (Max (Up x To (Add1 x)))`

    [ atMost1
    , between1And10 |> Z.minNo
    ]

-}
minNo : Z (In min_ max) -> Z (Max max)
minNo =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = unlimited
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `Z (Min N3)`

    [ atLeast3
    , atLeast4 |> Z.min n3
    ]

-}
min :
    Z (In minNew (Up minNewMaxToMin_ To min))
    ->
        (Z (In (UpExact min) max)
         -> Z (In minNew max)
        )
min minimumNew =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = minimumNew |> minimumAsDifference
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| Have a specific minimum in mind? → [`min`](#min)

Want to decrease the lower bound by a fixed amount? → [`minDown`](#minDown)

-}
minDown :
    Z
        (In
            maxIncreasedMin_
            (Down minUpX To minDecreasedUpX)
        )
    ->
        (Z (In (Up x To minUpX) max)
         -> Z (In (Up x To minDecreasedUpX) max)
        )
minDown minRelativeDecrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference =
                    (n |> minimumAsDifference)
                        |> differenceDown
                            (minRelativeDecrease |> maximumAsDifference)
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| On `Z (In min max)`'s type, drop `max` to get a `Z (Min min)`.

    between3And10 |> Z.maxNo
    --: Z (Min (Up x To (Add3 x)))

Use it to unify different types of number maximum constraints like

    [ atLeast1, between1And10 ]

elm complains:

> But all the previous elements in the list are: `Z (Min (Up x To (Add1 x)))`

    [ atLeast1
    , between1And10 |> Z.maxNo
    ]

-}
maxNo : Z (In min max_) -> Z (Min min)
maxNo =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = unlimited
                }


{-| Make it fit into functions with require a higher maximum.

You should type arguments and stored types as broad as possible.

    onlyAtMost18 : Z (In min_ (Up maxX To (Add18 maxX)) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the n in `onlyAtMost19`:

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> Z.max n18)

-}
max :
    Z (In (UpExact maxNewMin) maxNew)
    ->
        (Z (In min (Up maxToMaxNewMin_ To maxNewMin))
         -> Z (In min maxNew)
        )
max maximumNew =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = maximumNew |> maximumAsDifference
                }


{-| Have a specific maximum in mind? → [`max`](#max)

Want to increase the upper bound by a fixed amount? → [`maxUp`](#maxUp)

-}
maxUp :
    Z
        (In
            -- min = UpExact guarantees that max is actually an increase
            (UpExact maxIncreasedMin_)
            (Up maxUpX To maxIncreasedUpX)
        )
    ->
        (Z (In min (Up x To maxUpX))
         -> Z (In min (Up x To maxIncreasedUpX))
        )
maxUp maxRelativeIncrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference =
                    (n |> maximumAsDifference)
                        |> differenceUp
                            (maxRelativeIncrease |> maximumAsDifference)
                }



-- compare


{-| The error result of comparing [`Z`](#Z)s.

  - `Above`: greater
  - `Below`: less

Values exist for each condition.

-}
type BelowOrAbove below above
    = Below below
    | Above above


{-| Drop the range constraints
to feed another library with its `Int` representation.
-}
toInt : Z range_ -> Int
toInt =
    \(LimitedIn _ intValue) -> intValue


{-| Drop the range constraints
to feed another library with its `Float` representation.
-}
toFloat : Z range_ -> Float
toFloat =
    toInt >> Basics.toFloat



-- transform


{-| Is the [`Z`](#Z) equal to, [`BelowOrAbove`](#BelowOrAbove) a given number?

    giveAPresent { age } =
        case age |> Z.is n18 of
            Err (Z.Below younger) ->
                toy { age = younger }

            Err (Z.Above older) ->
                book { age = older }

            Ok _ ->
                bigPresent

    toy : { age : Z (In min_ (Up maxX To (Add17 maxX)) } -> Toy

    book :
        { age : Z (In (UpExact (Add19 minMinus19_)) max_) }
        -> Book

(The type doesn't forbid that the number you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `Z (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
is :
    Z
        (In
            (Up minX To (Add1 comparedAgainstMinUpXMinus1))
            (Up maxX To (Add1 comparedAgainstMaxUpXMinus1))
        )
    ->
        (Z (In min max)
         ->
            Result
                (BelowOrAbove
                    (Z
                        (In
                            min
                            (Up maxX To comparedAgainstMaxUpXMinus1)
                        )
                    )
                    (Z
                        (In
                            (Up minX To (Add2 comparedAgainstMinUpXMinus1))
                            max
                        )
                    )
                )
                (Z
                    (In
                        (Up minX To (Add1 comparedAgainstMinUpXMinus1))
                        (Up maxX To (Add1 comparedAgainstMaxUpXMinus1))
                    )
                )
        )
is comparedAgainst =
    \n ->
        case compare (n |> toInt) (comparedAgainst |> toInt) of
            EQ ->
                comparedAgainst
                    |> Ok

            GT ->
                (n |> toInt)
                    |> LimitedIn
                        { minimumAsDifference =
                            (comparedAgainst |> minimumAsDifference)
                                |> differenceUp (n1 |> minimumAsDifference)
                        , maximumAsDifference = n |> maximumAsDifference
                        }
                    |> Above
                    |> Err

            LT ->
                (n |> toInt)
                    |> LimitedIn
                        { minimumAsDifference = n |> minimumAsDifference
                        , maximumAsDifference =
                            (comparedAgainst |> maximumAsDifference)
                                |> differenceDown (n1 |> minimumAsDifference)
                        }
                    |> Below
                    |> Err


{-| Compared to a range from a lower to an upper bound,
is the [`Z`](#Z) in range or [`BelowOrAbove`](#BelowOrAbove)?

    isIn3To10 : Z (In min_ max_) -> Maybe (Z (In (Up minX To (Add3 minX)) (Up maxX To (Add10 maxX))))
    isIn3To10 =
        Z.isIn ( n3, n10 )
            >> Result.toMaybe

    n9 |> isIn3To10 |> Maybe.map Z.toInt
    --> Just 9

    n12 |> isIn3To10
    --> Nothing

    inputIntJudge : Int -> Result String (Z (In (Up minX To (Add1 minX)) (Up maxX To (Add10 maxX))))
    inputIntJudge int =
        case int |> Z.int |> Z.isIn ( n1, n10 ) of
            Ok inRange ->
                inRange |> Ok
            Err (Z.Below _) ->
                Err "must be ≥ 1"
            Err (Z.Above _) ->
                Err "must be ≤ 100"

    0 |> inputIntJudge
    --> Err "must be ≥ 1"

    toDigit : Char -> Maybe (Z (In (Up minX To minX) (Up maxX To (Add9 maxX))))
    toDigit char =
        ((char |> Char.toCode) - ('0' |> Char.toCode))
            |> Z.int
            |> Z.isIn ( n0, n9 )
            |> Result.toMaybe

(The type doesn't forbid that the limits you're comparing against
are below the current minimum, above the current maximum or in the wrong order.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `Z (In min max ...)`
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
    ( Z
        (In
            lowerLimitMin
            (Up lowerLimitMaxX To (Add1 lowerLimitMaxUpXMinus1))
        )
    , Z
        (In
            (Up upperLimitMinX To upperLimitMinUpX)
            upperLimitMax
        )
    )
    ->
        (Z (In min max)
         ->
            Result
                (BelowOrAbove
                    (Z
                        (In
                            min
                            (Up lowerLimitMaxX To lowerLimitMaxUpXMinus1)
                        )
                    )
                    (Z
                        (In
                            (Up upperLimitMinX To (Add1 upperLimitMinUpX))
                            max
                        )
                    )
                )
                (Z (In lowerLimitMin upperLimitMax))
        )
isIn ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = n |> minimumAsDifference
                    , maximumAsDifference =
                        (lowerLimit |> maximumAsDifference)
                            |> differenceDown (n1 |> minimumAsDifference)
                    }
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference =
                        (upperLimit |> minimumAsDifference)
                            |> differenceUp (n1 |> minimumAsDifference)
                    , maximumAsDifference = n |> maximumAsDifference
                    }
                |> Above
                |> Err

        else
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference =
                        lowerLimit |> minimumAsDifference
                    , maximumAsDifference = upperLimit |> maximumAsDifference
                    }
                |> Ok



--


{-| Is the [`Z`](#Z) below than or at least as big as a given number?

    4 |> Z.int |> Z.isAtLeast n5
    --: Result Int (Z (Min (Up x To (Add5 x))))
    --> Err 4

    1234 |> Z.int |> Z.isAtLeast n5 |> Result.map Z.toInt
    --> Ok 1234

    vote :
        { age : Z (In (UpExact (Add18 minMinus18_)) max_) }
        -> Vote

    tryToVote { age } =
        case age |> Z.isAtLeast n18 of
            Err _ ->
                --😓
                Nothing

            Ok oldEnough ->
                vote { age = oldEnough } |> Just

    factorial : Z (In min_ max_) -> Z (Min (Up x To (Add1 x)))
    factorial =
        factorialBody

    factorialBody : Z (In min_ max_) -> Z (Min (Up x To (Add1 x)))
    factorialBody x =
        case x |> Z.isAtLeast n1 of
            Err _ ->
                n1 |> Z.maxNo

            Ok atLeast1 ->
                factorial (atLeast1 |> Z.minSub n1)
                    |> Z.mul atLeast1

(The type doesn't forbid that the lower limit you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `Z (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtLeast :
    Z
        (In
            lowerLimitMin
            (Up lowerLimitMaxX To (Add1 lowerLimitMaxMinus1UpX))
        )
    ->
        (Z (In min max)
         ->
            Result
                (Z (In min (Up lowerLimitMaxX To lowerLimitMaxMinus1UpX)))
                (Z (In lowerLimitMin max))
        )
isAtLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = lowerLimit |> minimumAsDifference
                    , maximumAsDifference = n |> maximumAsDifference
                    }
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = n |> minimumAsDifference
                    , maximumAsDifference =
                        (lowerLimit |> maximumAsDifference)
                            |> differenceDown (n1 |> minimumAsDifference)
                    }
                |> Err


{-| Is the [`Z`](#Z) at most (`Ok`) or greater than (`Err`) a given number?

    goToBelow18Party : { age : Z (In min_ (Up maxTo17 To N17)) } -> Snack

    tryToGoToBelow18Party { age } =
        case age |> Z.isAtMost n17 of
            Ok below18 ->
                goToBelow18Party { age = below18 } |> Just

            Err _ ->
                Nothing

(The type doesn't forbid that the upper limit you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `Z (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtMost :
    Z (In (Up upperLimitMinX To upperLimitMinUpX) upperLimitMax)
    ->
        (Z (In min max)
         ->
            Result
                (Z (In (Up upperLimitMinX To (Add1 upperLimitMinUpX)) max))
                (Z (In min upperLimitMax))
        )
isAtMost upperLimit =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = n |> minimumAsDifference
                    , maximumAsDifference = upperLimit |> maximumAsDifference
                    }
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference =
                        (upperLimit |> minimumAsDifference)
                            |> differenceUp (n1 |> minimumAsDifference)
                    , maximumAsDifference = n |> maximumAsDifference
                    }
                |> Err


{-| To the [`Z`](#Z) without a known maximum-constraint,
add a number that (only) has [information on how to add](#Up) the minima.

    atLeast70 |> Z.minAdd n7
    --: Z (Min (Up x To (Add77 x))

    Z.minAdd toAdd =
        Z.maxNo >> Z.add (toAdd |> Z.maxNo)

Both maxima are known [difference](#Up)s? → [`add`](#add)

-}
minAdd :
    Z
        (In
            (Up minUpX To sumMinUpX)
            addedMax_
        )
    ->
        (Z (In (Up x To minUpX) max_)
         -> Z (Min (Up x To sumMinUpX))
        )
minAdd toAdd =
    maxNo >> add (toAdd |> maxNo)


{-| To the [`Z`](#Z) without a known minimum-constraint,
add a number that (only) has [information on how to add](#Up) the maxima.

    atMost70 |> Z.maxAdd n7
    --: Z (Max (Up x To (Add77 x))

    Z.maxAdd toAdd =
        Z.minNo >> Z.add (toAdd |> Z.minNo)

Both maxima are known [difference](#Up)s? → [`add`](#add)

-}
maxAdd :
    Z
        (In
            addedMin_
            (Up maxUpX To sumMaxUpX)
        )
    ->
        (Z (In min_ (Up x To maxUpX))
         -> Z (Max (Up x To sumMaxUpX))
        )
maxAdd toAdd =
    minNo >> add (toAdd |> minNo)


{-| From the [`Z`](#Z) in a range subtract another [`Z`](#Z) in a range.

    n6 |> Z.sub n5
    --→ n1
    --: Z (In (Up minX To (Add1 minX)) (Up maxX To (Add1 maxX)))

    Z.sub toSubtract =
        Z.add (toSubtract |> Z.negate)

One of the terms has no maximum constraint? → [`minSub`](#minSub)

-}
sub :
    Z
        (In
            (Down maxUpX To differenceMaxUpX)
            (Down minUpX To differenceMinUpX)
        )
    ->
        (Z (In (Up minX To minUpX) (Up maxX To maxUpX))
         ->
            Z
                (In
                    (Up minX To differenceMinUpX)
                    (Up maxX To differenceMaxUpX)
                )
        )
sub toSubtract =
    add (toSubtract |> negate)


{-| From an [`Z`](#Z) with an unknown maximum constraint,
subtract a [specific number](#In)

    atLeast7 |> Z.minSub n2
    --: Z (Min (UpExact N5))

    atLeast6 |> Z.minSub between0And5
    --: Z (Min (UpExact N1))

    between6And12 |> Z.minSub between1And5
    --: Z (In (UpExact min) (Up maxX To (Add12 maxX)))

    Z.minSub subtrahend =
        Z.minAdd (subtrahend |> Z.negate)

Use [`sub`](#sub) if you want to subtract an [`Z`](#Z) in a range.

-}
minSub :
    Z
        (In
            (Up subtrahendMinX_ To subtrahendMinUpX_)
            (Down minUpX To differenceMinUpX)
        )
    ->
        (Z (In (Up minX To minUpX) max_)
         -> Z (Min (Up minX To differenceMinUpX))
        )
minSub subtrahend =
    minAdd (subtrahend |> negate)


{-| From an [`Z`](#Z) with an unknown minimum constraint,
subtract another [`Z`](#Z)

TODO: fix doc

    atLeast7 |> Z.maxSub n2
    --: Z (Min (UpExact N5))

    atLeast6 |> Z.maxSub between0And5
    --: Z (Min (UpExact N1))

    between6And12 |> Z.maxSub between1And5
    --: Z (In (UpExact min) (Up maxX To (Add12 maxX)))

    Z.maxSub subtrahend =
        Z.maxAdd (subtrahend |> Z.negate)

Use [`sub`](#sub) if you want to subtract an [`Z`](#Z) in a range.

-}
maxSub :
    Z
        (In
            (Down maxUpX To differenceMinUpX)
            (Up subtrahendMaxX_ To subtrahendMaxUpX_)
        )
    ->
        (Z (In min_ (Up maxX To maxUpX))
         -> Z (Max (Up maxX To differenceMinUpX))
        )
maxSub subtrahend =
    maxAdd (subtrahend |> negate)



-- # internals


{-| Its limits.
Both its [`minimumAsDifference`](#minimumAsDifference)
and its [`maximumAsDifference`](#maximumAsDifference)
-}
range : Z range -> range
range =
    \(LimitedIn rangeLimits _) -> rangeLimits


{-| The smallest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
minimumAsDifference : Z (In minimumAsDifference maximum_) -> minimumAsDifference
minimumAsDifference =
    range >> .minimumAsDifference


{-| The greatest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
maximumAsDifference : Z (In min_ maximumAsDifference) -> maximumAsDifference
maximumAsDifference =
    range >> .maximumAsDifference


{-| To the [number](#N0able),
add another [number](#N0able) like shown in a given [difference](#Up)
-}
upDifference : Up low To high -> (low -> high)
upDifference =
    \(Difference differenceOperation) ->
        differenceOperation.up


{-| From the [number](#N0able),
subtract another [number](#N0able) like shown in a given [difference](#Down)
-}
downDifference : Down high To low -> (high -> low)
downDifference =
    \(Difference differenceOperation) ->
        differenceOperation.down


{-| Chain the [difference](#Up) [`Up`](#Up) to a higher [number](#N0able)
-}
differenceUp :
    Up middle To high
    ->
        (Up low To middle
         -> Up low To high
        )
differenceUp differenceMiddleToHigh =
    \diffLowToMiddle ->
        Difference
            { up =
                upDifference diffLowToMiddle
                    >> upDifference differenceMiddleToHigh
            , down =
                downDifference differenceMiddleToHigh
                    >> downDifference diffLowToMiddle
            }


{-| Chain the [difference](#Up) [`Down`](#Down) to a lower [number](#N0able)
-}
differenceDown :
    Down high To middle
    ->
        (Up low To high
         -> Up low To middle
        )
differenceDown differenceMiddleToHigh =
    \diffLowToHigh ->
        Difference
            { up =
                upDifference diffLowToHigh
                    >> downDifference differenceMiddleToHigh
            , down =
                upDifference differenceMiddleToHigh
                    >> downDifference diffLowToHigh
            }


{-| The specific natural number `0`
-}
n0 : Z (In (Up minX To minX) (Up maxX To maxX))
n0 =
    0
        |> LimitedIn
            { minimumAsDifference = n0Difference
            , maximumAsDifference = n0Difference
            }


n0Difference : Up x To x
n0Difference =
    Difference
        { up = identity
        , down = identity
        }



--


{-| The specific natural number `1`
-}
n1 :
    Z
        (In
            (Up minX To (Add1 minX))
            (Up maxX To (Add1 maxX))
        )
n1 =
    1
        |> LimitedIn
            { minimumAsDifference = n1Difference
            , maximumAsDifference = n1Difference
            }


n1Difference : Up x To (Add1 x)
n1Difference =
    Difference
        { up = Add1
        , down =
            \n0Never ->
                case n0Never of
                    Add1 predecessor ->
                        predecessor

                    N0 possible ->
                        possible |> never
        }


{-| The specific natural number `2`
-}
n2 : Z (In (Up minX To (Add2 minX)) (Up maxX To (Add2 maxX)))
n2 =
    n1 |> add n1


{-| The specific natural number `3`
-}
n3 : Z (In (Up minX To (Add3 minX)) (Up maxX To (Add3 maxX)))
n3 =
    n2 |> add n1


{-| The specific natural number `4`
-}
n4 : Z (In (Up minX To (Add4 minX)) (Up maxX To (Add4 maxX)))
n4 =
    n3 |> add n1


{-| The specific natural number `5`
-}
n5 : Z (In (Up minX To (Add5 minX)) (Up maxX To (Add5 maxX)))
n5 =
    n4 |> add n1


{-| The specific natural number `6`
-}
n6 : Z (In (Up minX To (Add6 minX)) (Up maxX To (Add6 maxX)))
n6 =
    n5 |> add n1


{-| The specific natural number `7`
-}
n7 : Z (In (Up minX To (Add7 minX)) (Up maxX To (Add7 maxX)))
n7 =
    n6 |> add n1


{-| The specific natural number `8`
-}
n8 : Z (In (Up minX To (Add8 minX)) (Up maxX To (Add8 maxX)))
n8 =
    n7 |> add n1


{-| The specific natural number `9`
-}
n9 : Z (In (Up minX To (Add9 minX)) (Up maxX To (Add9 maxX)))
n9 =
    n8 |> add n1


{-| The specific natural number `10`
-}
n10 : Z (In (Up minX To (Add10 minX)) (Up maxX To (Add10 maxX)))
n10 =
    n9 |> add n1


{-| The specific natural number `11`
-}
n11 : Z (In (Up minX To (Add11 minX)) (Up maxX To (Add11 maxX)))
n11 =
    n10 |> add n1


{-| The specific natural number `12`
-}
n12 : Z (In (Up minX To (Add12 minX)) (Up maxX To (Add12 maxX)))
n12 =
    n11 |> add n1


{-| The specific natural number `13`
-}
n13 : Z (In (Up minX To (Add13 minX)) (Up maxX To (Add13 maxX)))
n13 =
    n12 |> add n1


{-| The specific natural number `14`
-}
n14 : Z (In (Up minX To (Add14 minX)) (Up maxX To (Add14 maxX)))
n14 =
    n13 |> add n1


{-| The specific natural number `15`
-}
n15 : Z (In (Up minX To (Add15 minX)) (Up maxX To (Add15 maxX)))
n15 =
    n14 |> add n1


{-| The specific natural number `16`
-}
n16 : Z (In (Up minX To (Add16 minX)) (Up maxX To (Add16 maxX)))
n16 =
    n15 |> add n1


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


{-| The [natural number](#N0able) `1 +` another given [natural number](#N0able) `n`
-}
type alias Add1 n =
    N0able n Never


{-| The [natural number](#N0able) `2 +` another given [natural number](#N0able) `n`
-}
type alias Add2 n =
    N0able (N0able n Never) Never


{-| The [natural number](#N0able) `3 +` another given [natural number](#N0able) `n`
-}
type alias Add3 n =
    N0able (N0able (N0able n Never) Never) Never


{-| The [natural number](#N0able) `4 +` another given [natural number](#N0able) `n`
-}
type alias Add4 n =
    N0able (N0able (N0able (N0able n Never) Never) Never) Never


{-| The [natural number](#N0able) `5 +` another given [natural number](#N0able) `n`
-}
type alias Add5 n =
    N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `6 +` another given [natural number](#N0able) `n`
-}
type alias Add6 n =
    N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `7 +` another given [natural number](#N0able) `n`
-}
type alias Add7 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `8 +` another given [natural number](#N0able) `n`
-}
type alias Add8 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `9 +` another given [natural number](#N0able) `n`
-}
type alias Add9 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `10 +` another given [natural number](#N0able) `n`
-}
type alias Add10 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `11 +` another given [natural number](#N0able) `n`
-}
type alias Add11 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `12 +` another given [natural number](#N0able) `n`
-}
type alias Add12 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `13 +` another given [natural number](#N0able) `n`
-}
type alias Add13 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `14 +` another given [natural number](#N0able) `n`
-}
type alias Add14 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `15 +` another given [natural number](#N0able) `n`
-}
type alias Add15 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| The [natural number](#N0able) `16 +` another given [natural number](#N0able) `n`
-}
type alias Add16 n =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able n Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `0`
-}
type alias N0 =
    N0able Never Possibly


{-| Type for the [exact natural number](#N0able) `1`
-}
type alias N1 =
    N0able (N0able Never Possibly) Never


{-| Type for the [exact natural number](#N0able) `2`
-}
type alias N2 =
    N0able (N0able (N0able Never Possibly) Never) Never


{-| Type for the [exact natural number](#N0able) `3`
-}
type alias N3 =
    N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `4`
-}
type alias N4 =
    N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `5`
-}
type alias N5 =
    N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `6`
-}
type alias N6 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `7`
-}
type alias N7 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `8`
-}
type alias N8 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `9`
-}
type alias N9 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `10`
-}
type alias N10 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `11`
-}
type alias N11 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `12`
-}
type alias N12 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `13`
-}
type alias N13 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `14`
-}
type alias N14 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `15`
-}
type alias N15 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never


{-| Type for the [exact natural number](#N0able) `16`
-}
type alias N16 =
    N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able (N0able Never Possibly) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never) Never
