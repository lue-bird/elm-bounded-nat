module N exposing
    ( N
    , In, Min, MaxNo, Exactly
    , Up(..), Down, To, Fixed
    , abs, randomIn, until
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , intAtLeast, intIn
    , intIsAtLeast, intIsIn, BelowOrAbove(..)
    , atLeast, minAtLeast, atMost, in_
    , is, isIn, isAtLeast, isAtMost
    , add, minAdd
    , sub, minSub
    , toPower, remainderBy, mul, div
    , toInt, toFloat
    , min, minDown
    , maxNo, max, maxUp
    , range, minimumAsDifference, maximumAsDifference
    , N0able(..)
    , fixed
    , differenceUp, differenceDown
    , upDifference, downDifference
    )

{-| Natural numbers within a typed range.

@docs N


# bounds

@docs In, Min, MaxNo, Exactly
@docs Up, Down, To, Fixed


# create

@docs abs, randomIn, until


# specific numbers

If the package exposed every number 0 → 1000+, [tools can become unusably slow](https://github.com/lue-bird/elm-typesafe-array/issues/2).

So only 0 → 16 are exposed, while larger numbers have to be generated locally.

Current method: [generate them](https://lue-bird.github.io/elm-bounded-nat/generate/) into a `module exposing (n500, N500, Add500, ...)` + `import as N exposing (n500, ...)`

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


### `Int` clamp

@docs intAtLeast, intIn


## `Int` compare

@docs intIsAtLeast, intIsIn, BelowOrAbove


## clamp

@docs atLeast, minAtLeast, atMost, in_


## compare maximum constrained

@docs is, isIn, isAtLeast, isAtMost


# alter

@docs add, minAdd
@docs sub, minSub
@docs toPower, remainderBy, mul, div


## broaden

@docs toInt, toFloat


# type information

@docs min, minDown
@docs maxNo, max, maxUp


# miss operation x?

Anything that can't be expressed with the available operations? → issue/PR


# fancy

Building extensions to this library
– like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/) or other structures

While the internally stored `Int` can't directly be guaranteed to be in bounds by elm,
[minimum](#minimumAsDifference), [maximum](#maximumAsDifference) as their representation as a [difference](#Up)
must be built as actual values checked by the compiler.
No shenanigans like runtime errors for impossible cases.

@docs range, minimumAsDifference, maximumAsDifference

@docs N0able
@docs fixed
@docs differenceUp, differenceDown
@docs upDifference, downDifference

-}

import Emptiable exposing (Emptiable)
import Help exposing (valueElseOnError)
import Possibly exposing (Possibly(..))
import Random
import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)
import Stack exposing (Stacked)


{-| A **bounded** natural number `>= 0`


### argument type

    -- ≥ 0, any limitations allowed
    N range_

    -- ≥ 4
    N (In (Fixed (Add4 minMinus4_)) max_)

    -- 4 ≤ n ≤ 15
    N (In (Fixed (Add4 minMinus4_)) (Up maxTo15_ To N15))

`In (Add4 minMinus4_) N15` says:

  - the minimum-constraint can be `4 + 0`|`4 + 1`|`4 + 2`|...
  - the argument's maximum `+` some variable `maxTo15` is `15`
    which means: the maximum is ≤ 15


### result type

    -- ≥ 4
    N (Min (Up x To (Add4 x)))

    -- 2 ≤ n ≤ 12
    N (In (Up x To (Add2 x)) (Up x To (Add12 x)))

    n3 : N (In (Up minX To (Add3 minX)) (Up maxX To (Add3 maxX)))

[`Up low To high`] is a representation as a difference of the limit `high - low`

This enables adding, subtracting.
Consider it an implementation detail.

    n3 |> N.add n6
    --→ n9


### stored type

what to put in declared types like `Model`

    -- ≥ 4
    N (Min (Fixed N4))

    -- 2 ≤ n ≤ 12
    N (In (Fixed N2) (Fixed N12))

They are like [result types](#result-type) but type variables are set to [`N0`](#N0).

more type examples at [`In`](#In), [`Min`](#Min)

-}
type N range
    = LimitedIn range Int


{-| somewhere within a `minimum` & `maximum`

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### argument type in a range

    -- number between 3 and 5
    N (In (Fixed (Add3 minX_)) (Up maxTo5_ N5))

    percent : N (In min_ (Up maxTo100 To N100)) -> Percent

`min ≤ max ≤ N100`

If you want a number where you just care about the minimum, leave `max` as a type _variable_

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

    -- any natural number
    N (In min_ max_)

A number, at least 5:

    N (In (Add5 minMinus5_) max_)

→ `max_` could be a specific maximum or [no maximum at all](#MaxNo)


### result type in a range

    n3 : N (In (Up x0 To (Add3 x0)) (Up x1 To (Add3 x1)))

    between3And6 : N (In (Up minX To (Add3 minX)) (Up maxX To (Add6 maxX)))

    between3And6 |> N.add n3
    --: N (In (Up minX To (Add6 minX)) (Up maxX To (Add9 maxX)))


### stored type in a range

Like the result type but every `Up x To (Add<x> x)` becomes [`Fixed N<x>`](#Fixed)

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeBinary element =
        Tree (Exactly N2) element

Remember: ↑ and other [`Min`](#Min)/[`Exactly`](#Exactly)/[`Fixed`](#Fixed) are result/stored types, not argument types.

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

       ↓ minimum    ↓ or →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...


### result type without maximum constraint

Sometimes, you simply cannot compute a maximum.

    abs : Int -> N (In (Up x To x) ??)
                    ↓
    abs : Int -> N (Min (Up x To x))

    -- number ≥ 5
    atLeast5 : N (Min (Up x To (Add5 x)))

    atLeast5 |> N.minAdd n3
    --: N (Min (Up x To (Add8 x)))


### argument type without maximum constraint

Every `Min min` is of type `In min ...`,
so using a type variable for the maximum on arguments is highly encouraged
when no maximum constraint should be enforced.

    -- any natural number
    N (In min_ max_)

    -- number, at least 5
    N (In (Add5 minMinus5_) max_)


### stored type without maximum constraint

Like the result type but every `Up x To (Add<x> x)` becomes [`Fixed N<x>`](#Fixed)

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeMulti element =
        Tree (Min (Fixed N2)) element

Remember: ↑ and other [`Min`](#Min)/[`Exactly`](#Exactly)/[`Fixed`](#Fixed) are result/stored types, not argument types.

---

Do not use `==` on 2 values storing a range.
It can lead to elm crashing because [difference](#Up)s are stored as functions.
[compare](#compare) instead.

-}
type alias Min lowestPossibleValue =
    In lowestPossibleValue MaxNo


{-| Allow only a specific number.

Useful as a **stored & argument** type in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with [`N`](#N)s.

    byte : ArraySized (Exactly N8) Bit -> Byte

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s.

    type alias TicTacToeBoard =
        ArraySized
            (Exactly N3)
            (ArraySized (Exactly N3) TicTacToField)

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s.

-}
type alias Exactly n =
    In (Fixed n) (Fixed n)


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


{-| Flag "The number's upper limit is unknown" used in the definition of [`Min`](#Min):

    type alias Min min =
        In minimum MaxNo

-}
type alias MaxNo =
    Fixed { maximumUnknown : () }


{-| The exact number as the difference from 0 to the number.

A stored type looks
like a [result type](#result-type)
but every [`Up x To (Add<x> x)`](#Up) becomes [`Fixed N<x>`](#Fixed)

-}
type alias Fixed n =
    Up N0 To n


{-| [`To`](#To) the exact given number, create a [fixed difference from 0](#Fixed)
-}
fixed : n -> Fixed n
fixed n =
    Difference
        { up = \_ -> n
        , down = \_ -> N0 Possible
        }


{-| Add a given [specific](#In) [`N`](#N).

    between70And100 |> N.add n7
    --: N (In (Up minX To (Add77 minX)) (Up maxX To (Add107 maxX)))

One addend has an unconstrained maximum? → [`minAdd`](#minAdd)

-}
add :
    N
        (In
            (Up minPlusX To sumMinPlusX)
            (Up maxPlusX To sumMaxPlusX)
        )
    ->
        (N (In (Up minX To minPlusX) (Up maxX To maxPlusX))
         ->
            N
                (In
                    (Up minX To sumMinPlusX)
                    (Up maxX To sumMaxPlusX)
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


maximumNo : MaxNo
maximumNo =
    { maximumUnknown = () } |> fixed


{-| The absolute value of an `Int` which is always `≥ 0`

    -4
        |> N.abs
        --: N (Min (Up x To x))
        |> N.toInt

    --> 4
    16 |> N.abs |> N.toInt --> 16

Really only use this if you want the absolute value.

    badLength =
        List.length >> N.abs

  - maybe, there's a solution that never even theoretically deals with unexpected values:

        mostCorrectLength =
            List.foldl
                (\_ -> N.minAdd n1 >> N.minDown n1)
                (n0 |> N.maxNo)

  - other times, though, like with `Array.length`, which isn't `O(n)`,
    you can escape with for example

        arrayLength =
            Array.length >> N.intAtLeast n0

-}
abs : Int -> N (Min (Up x To x))
abs =
    Basics.abs
        >> LimitedIn
            { minimumAsDifference = n0 |> minimumAsDifference
            , maximumAsDifference = maximumNo
            }



--


untilReverse :
    N (In (Fixed min_) max)
    ->
        Emptiable
            (Stacked
                (N (In (Up x0 To x0) max))
            )
            Never
untilReverse last =
    case last |> isAtLeast n1 of
        Err _ ->
            n0 |> max last |> Stack.only

        Ok lastAtLeast1 ->
            (lastAtLeast1 |> minSub n1 |> untilReverseRecursive)
                |> Stack.onTopLay (lastAtLeast1 |> min n0)


{-| [`N`](#N)s increasing from `0` to `n`
In the end, there are `n` numbers.

    import Stack

    N.until n6
        |> Stack.map (\_ -> N.add n3)
        --: Emptiable
        --:     (Stacked
        --:         (N
        --:             (In
        --:                 (Up minX To (Add3 minX))
        --:                 (Up maxX To (Add9 maxX))
        --:             )
        --:         )
        --:     )
        --:     Never
        |> Stack.map (\_ -> N.toInt)
    --> Stack.topDown 3 [ 4, 5, 6, 7, 8, 9 ]

    N.until atLeast7 |> Stack.map (\_ -> N.minAdd n3)
    --: Emptiable
    --:     (Stacked (N (Min (Up x To (Add10 x)))))
    --:     Never

[`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/ArraySized#until) even knows the length!
Wanna try it?

-}
until :
    N (In (Fixed min_) max)
    ->
        Emptiable
            (Stacked
                (N (In (Up x0 To x0) max))
            )
            Never
until last =
    untilReverse last |> Stack.reverse


untilReverseRecursive :
    N (In (Fixed min_) max)
    ->
        Emptiable
            (Stacked
                (N (In (Up x0 To x0) max))
            )
            Never
untilReverseRecursive =
    untilReverse


{-| Generate a random [`N`](#N) in a range.

    N.randomIn ( n1, n10 )
    --: Random.Generator
    --:     (N
    --:         (In
    --:             (Up minX To (Add1 minX))
    --:             (Up maxX To (Add10 maxX))
    --:         )
    --:     )

-}
randomIn :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N (In (Fixed upperLimitMin) upperLimitMax)
    )
    ->
        Random.Generator
            (N (In lowerLimitMin upperLimitMax))
randomIn ( lowestPossible, highestPossible ) =
    Random.int (lowestPossible |> toInt) (highestPossible |> toInt)
        |> Random.map
            (LimitedIn
                { minimumAsDifference = lowestPossible |> minimumAsDifference
                , maximumAsDifference = highestPossible |> maximumAsDifference
                }
            )


{-| Compared to a range from a lower to an upper bound, is the `Int` in range, [`BelowOrAbove`](#BelowOrAbove)?

    inputIntJudge : Int -> Result String (N (In (Up minX To (Add1 minX)) (Up maxX To (Add10 maxX))))
    inputIntJudge int =
        case int |> N.intIsIn ( n1, n10 ) of
            Ok inRange ->
                inRange |> Ok
            Err (N.Below _) ->
                Err "must be ≥ 1"
            Err (N.Above _) ->
                Err "must be ≤ 100"

    0 |> inputIntJudge
    --> Err "must be ≥ 1"

-}
intIsIn :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N
        (In
            (Fixed upperLimitMin)
            (Up upperLimitMaxX To upperLimitMaxPlusX)
        )
    )
    ->
        (Int
         ->
            Result
                (BelowOrAbove
                    Int
                    (N
                        (Min
                            (Up upperLimitMaxX To (Add1 upperLimitMaxPlusX))
                        )
                    )
                )
                (N (In lowerLimitMin (Up upperLimitMaxX To upperLimitMaxPlusX)))
        )
intIsIn ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> Below |> Err

        else if int > (upperLimit |> toInt) then
            int
                |> LimitedIn
                    { minimumAsDifference =
                        (upperLimit |> maximumAsDifference)
                            |> differenceUp (n1 |> minimumAsDifference)
                    , maximumAsDifference = maximumNo
                    }
                |> Above
                |> Err

        else
            int
                |> LimitedIn
                    { minimumAsDifference = lowerLimit |> minimumAsDifference
                    , maximumAsDifference = upperLimit |> maximumAsDifference
                    }
                |> Ok


{-| If the `Int ≥` a given `minimum`,
return `Ok` with the `N (Min minimum)`,
else `Err` with the input `Int`.

    4 |> N.intIsAtLeast n5
    --: Result Int (N (Min (Up x To (Add5 x))))
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
                |> LimitedIn
                    { minimumAsDifference = minimumLimit |> minimumAsDifference
                    , maximumAsDifference = maximumNo
                    }
                |> Ok

        else
            int |> Err


{-| Create a `N (In ...)` by **clamping** an `Int` between a minimum & maximum.

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`intIsIn`](#intIsIn).

    0
        |> N.intIn ( n3, n12 )
        --: N (In (Up minX To (Add3 minX)) (Up minX To (Add12 minX)))
        |> N.toInt
    --> 3

    99
        |> N.intIn ( n3, n12 )
        |> N.toInt
    --> 12

    9
        |> N.intIn ( n3, n12 )
        |> N.toInt
    --> 9


    toDigit : Char -> Maybe (N (In (Up minX To minX) (Up maxX To (Add9 maxX))))
    toDigit char =
        ((char |> Char.toCode) - ('0' |> Char.toCode))
            |> N.intIsIn ( n0, n9 )
            |> Result.toMaybe

-}
intIn :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N
        (In
            (Fixed upperLimitMin)
            (Up upperLimitMaxX To upperLimitMaxPlusX)
        )
    )
    ->
        (Int
         -> N (In lowerLimitMin (Up upperLimitMaxX To upperLimitMaxPlusX))
        )
intIn ( lowerLimit, upperLimit ) =
    intIsIn ( lowerLimit, upperLimit )
        >> valueElseOnError
            (\error ->
                case error of
                    Below _ ->
                        (lowerLimit |> toInt)
                            |> LimitedIn
                                { minimumAsDifference = lowerLimit |> minimumAsDifference
                                , maximumAsDifference = upperLimit |> maximumAsDifference
                                }

                    Above _ ->
                        (upperLimit |> toInt)
                            |> LimitedIn
                                { minimumAsDifference = lowerLimit |> minimumAsDifference
                                , maximumAsDifference = upperLimit |> maximumAsDifference
                                }
            )


{-| A `N (Min ...)` from an `Int`;
if the `Int < minimum`, `minimum` is returned.

    0
        |> N.intAtLeast n3
        --: N (Min (Up x To (Add3 x)))
        |> N.toInt
    --> 3

    9
        |> N.intAtLeast n3
        --: N (Min (Up x To (Add3 x)))
        |> N.toInt
    --> 9

You can also use this as an escape hatch
if you know an `Int` must be at least `minimum`.
But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ -> N.minAdd n1 >> N.minDown n1)
            (n0 |> N.maxNo)

To handle the case `< minimum` yourself → [`intIsAtLeast`](#intIsAtLeast)

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


{-| **Clamp** the number to between both given limits.

    between5And9 |> N.in_ ( n10, n10 )
    --: N (In (Up x0 To (Add10 x0)) (Up x1 To (Add10 x1)))

    between5And15 |> N.in_ ( n5, n10 )
    --: N (In (Up minX To (Add5 minX)) (Up maxX To (Add10 maxX)))

    atLeast5 |> N.in_ ( n5, n10 )
    --: N (In (Up minX To (Add5 minX)) (Up maxX To (Add10 maxX)))

  - There shouldn't be an upper limit? → [`minAtLeast`](#minAtLeast)
  - To keep the current maximum? → [`atLeast`](#atLeast)
  - To keep the current minimum? → [`atMost`](#atMost)

(The type doesn't forbid that the limits you're comparing against
are beyond the current limits.)

-}
in_ :
    ( N (In minNew (Up minNewMaxToMaxNewMin_ To maxNewMin))
    , N (In (Fixed maxNewMin) maxNew)
    )
    ->
        (N (In min_ max_)
         -> N (In minNew maxNew)
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


{-| **Cap** the [`N`](#N) to `>=` a given new lower limit.

    n5AtLeast |> N.minAtLeast n10
    --: N (Min (Up x To (Add10 x)))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15AtLeast |> N.minAtLeast n10 |> N.toInt
    --: N (Min (Up x To (Add10 x)))

Know both maxima? → [`atLeast`](#atLeast)

-}
minAtLeast :
    N (In minNew maxNew_)
    ->
        (N (In min_ max_)
         -> N (Min minNew)
        )
minAtLeast minimumLimit =
    toInt
        >> intIsAtLeast minimumLimit
        >> Result.withDefault (minimumLimit |> maxNo)


{-| **Cap** the [`N`](#N) to `<=` a given new upper limit.

    between3And10
        |> N.atMost between2And5
    --: N (In (Fixed 2) (Up x To (Add5 x)))

To replace the [`Fixed`](#Fixed) minimum with a [difference](#Up)
(for results etc.) → [`min`](#min)

To enforce a new minimum, too? → [`in_`](#in_)

-}
atMost :
    N (In (Fixed takenMin) takenMax)
    ->
        (N (In (Up minToTakenMin_ To takenMin) max_)
         -> N (In (Fixed takenMin) takenMax)
        )
atMost maximumLimit =
    \n ->
        if (n |> toInt) <= (maximumLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimumAsDifference = maximumLimit |> minimumAsDifference
                    , maximumAsDifference = maximumLimit |> maximumAsDifference
                    }

        else
            maximumLimit


{-| **Cap** the [`N`](#N) to `>=` a given new lower limit.

    between5And12 |> N.atLeast n10
    --: N (In (Up x To (Add10 x)) (Fixed N12))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15
        |> N.atLeast n10
        --: N (In (Up x To (Add10 x)) (Fixed N15))
        |> N.toInt
    --> 15

Don't know both maxima? → [`minAtLeast`](#minAtLeast)

-}
atLeast :
    N (In minNew (Up minNewMaxToMax_ To max))
    ->
        (N (In min_ (Fixed max))
         -> N (In minNew (Fixed max))
        )
atLeast minimumLimit =
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


{-| Multiply by a given [`n`](#N) `≥ 1`.
which means `x * n ≥ x`.

    atLeast5 |> N.mul n2
    --: N (Min (Up x To (Add5 x)))

    atLeast2 |> N.mul n5
    --: N (Min (Up x To (Add2 x)))

-}
mul :
    N (In (Fixed (Add1 multiplicandMinMinus1_)) multiplicandMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
mul multiplicand =
    \n ->
        (n |> toInt)
            * (multiplicand |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = maximumNo
                }


{-| Divide (`//`) by an [`N`](#N) `d ≥ 1`.

  - → `/ 0` is impossible
  - → `x / d <= x`

.

    atMost7
        |> N.div n3
        --: N (In (Up minX To minX) (Up maxX To (Add7 maxX)))
        |> N.toInt

-}
div :
    N (In (Fixed (Add1 divisorMinMinus1_)) divisorMax_)
    ->
        (N (In min_ max)
         -> N (In (Up minX To minX) max)
        )
div divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> LimitedIn
                { minimumAsDifference = n0 |> minimumAsDifference
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| The remainder after dividing by a [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In (Up minX To minX) (Up maxX To (Add2 maxX)))

-}
remainderBy :
    N
        (In
            (Fixed (Add1 divisorMinMinus1_))
            (Up divX To (Add1 divisorMaxPlusXMinus1))
        )
    ->
        (N (In min_ max_)
         ->
            N
                (In
                    (Up x0 To x0)
                    (Up divX To divisorMaxPlusXMinus1)
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


{-| [`N`](#N) Raised to a given power `p ≥ 1`
→ `x ^ p ≥ x`

    atLeast5 |> N.toPower n2
    --: N (Min (Up x To (Add5 x)))

    atLeast2 |> N.toPower n5
    --: N (Min (Up x To (Add2 x)))

-}
toPower :
    N (In (Fixed (Add1 exponentMinMinus1_)) exponentMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
toPower exponent =
    \n ->
        (n |> toInt)
            ^ (exponent |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = maximumNo
                }


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N3)`

    [ atLeast3
    , atLeast4 |> N.min n3
    ]

-}
min :
    N (In minNew (Up minNewMaxToMin_ To min))
    ->
        (N (In (Fixed min) max)
         -> N (In minNew max)
        )
min newMinimum =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = newMinimum |> minimumAsDifference
                , maximumAsDifference = n |> maximumAsDifference
                }


{-| On `N (In min max)`'s type, drop `max` to get a `N (Min min)`.

    between3And10 |> N.maxNo
    --: N (Min (Up x To (Add3 x)))

Use it to unify different types of number minimum constraints like

    [ atLeast1, between1And10 ]

elm complains:

> But all the previous elements in the list are: `N (Min (Up x To (Add1 x)))`

    [ atLeast1
    , between1And10 |> N.maxNo
    ]

-}
maxNo : N (In min max_) -> N (Min min)
maxNo =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimumAsDifference = n |> minimumAsDifference
                , maximumAsDifference = maximumNo
                }


{-| Make it fit into functions with require a higher maximum.

You should type arguments and stored types as broad as possible.

    onlyAtMost18 : N (In min_ (Up maxX To (Add18 maxX)) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the n in `onlyAtMost19`:

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.max n18)

-}
max :
    N (In (Fixed maxNewMin) maxNew)
    ->
        (N (In min (Up maxToMaxNewMin_ To maxNewMin))
         -> N (In min maxNew)
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
    N
        (In
            maxIncreasedMin_
            (Up maxPlusX To maxIncreasedPlusX)
        )
    ->
        (N (In min (Up x To maxPlusX))
         -> N (In min (Up x To maxIncreasedPlusX))
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


{-| Have a specific minimum in mind? → [`min`](#min)

Want to decrease the lower bound by a fixed amount? → [`minDown`](#minDown)

-}
minDown :
    N
        (In
            maxIncreasedMin_
            (Down minPlusX To minDecreasedPlusX)
        )
    ->
        (N (In (Up x To minPlusX) max)
         -> N (In (Up x To minDecreasedPlusX) max)
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


{-| The error result of comparing [`N`](#N)s.

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
toInt : N range_ -> Int
toInt =
    \(LimitedIn _ int) -> int


{-| Drop the range constraints
to feed another library with its `Float` representation.
-}
toFloat : N range_ -> Float
toFloat =
    toInt >> Basics.toFloat



-- transform


{-| Is the [`N`](#N) equal to, [`BelowOrAbove`](#BelowOrAbove) a given number?

    giveAPresent { age } =
        case age |> N.is n18 of
            Err (N.Below younger) ->
                toy { age = younger }

            Err (N.Above older) ->
                book { age = older }

            Ok _ ->
                bigPresent

    toy : { age : N (In min_ (Up maxX To (Add17 maxX)) } -> Toy

    book :
        { age : N (In (Fixed (Add19 minMinus19_)) max_) }
        -> Book

(The type doesn't forbid that the number you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min <= max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
is :
    N
        (In
            (Up minX To (Add1 comparedAgainstMinPlusXMinus1))
            (Up maxX To (Add1 comparedAgainstMaxPlusXMinus1))
        )
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (N
                        (In
                            min
                            (Up maxX To comparedAgainstMaxPlusXMinus1)
                        )
                    )
                    (N
                        (In
                            (Up minX To (Add2 comparedAgainstMinPlusXMinus1))
                            max
                        )
                    )
                )
                (N
                    (In
                        (Up minX To (Add1 comparedAgainstMinPlusXMinus1))
                        (Up maxX To (Add1 comparedAgainstMaxPlusXMinus1))
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
is the [`N`](#N) in range or [`BelowOrAbove`](#BelowOrAbove)?

    isIn3To10 : N (In min_ max_) -> Maybe (N (In (Up minX To (Add3 minX)) (Up maxX To (Add10 maxX))))
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
            lowerLimitMin
            (Up lowerLimitMaxX To (Add1 lowerLimitMaxPlusXMinus1))
        )
    , N
        (In
            (Up upperLimitMinX To upperLimitMinPlusX)
            upperLimitMax
        )
    )
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (N
                        (In
                            min
                            (Up lowerLimitMaxX To lowerLimitMaxPlusXMinus1)
                        )
                    )
                    (N
                        (In
                            (Up upperLimitMinX To (Add1 upperLimitMinPlusX))
                            max
                        )
                    )
                )
                (N (In lowerLimitMin upperLimitMax))
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


{-| Is the [`N`](#N) below than or at least as big as a given number?

    vote :
        { age : N (In (Fixed (Add18 minMinus18_)) max_) }
        -> Vote

    tryToVote { age } =
        case age |> N.isAtLeast n18 of
            Err _ ->
                --😓
                Nothing

            Ok oldEnough ->
                vote { age = oldEnough } |> Just

    factorial : N (In min_ max_) -> N (Min (Up x To (Add1 x)))
    factorial =
        factorialBody

    factorialBody : N (In min_ max_) -> N (Min (Up x To (Add1 x)))
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
            (Up lowerLimitMaxX To (Add1 lowerLimitMaxMinus1PlusX))
        )
    ->
        (N (In min max)
         ->
            Result
                (N (In min (Up lowerLimitMaxX To lowerLimitMaxMinus1PlusX)))
                (N (In lowerLimitMin max))
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


{-| Is the [`N`](#N) at most (`Ok`) or greater than (`Err`) a given number?

    goToBelow18Party : { age : N (In min_ (Up maxTo17 To N17)) } -> Snack

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
    N (In (Up upperLimitMinX To upperLimitMinPlusX) upperLimitMax)
    ->
        (N (In min max)
         ->
            Result
                (N (In (Up upperLimitMinX To (Add1 upperLimitMinPlusX)) max))
                (N (In min upperLimitMax))
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


{-| To the [`N`](#N) without a known maximum-constraint,
add a number that (only) has [information on how to add](#Up) the minima.

    atLeast70 |> N.minAdd n7
    --: N (Min (Up x To (Add77 x))

Use [`add`](#add) if both maxima are known [difference](#Up)s as well.

If the added minimum is [`Fixed`](#Fixed), supply the [`min`](#min) manually
to re-enable adding both minimum types!

    atLeast5 |> N.minAdd (min n2 atLeastFixed2)
    --: N (Min (Up x To (Add7 x)))

-}
minAdd :
    N
        (In
            (Up minPlusX To sumMinPlusX)
            addedMax_
        )
    ->
        (N (In (Up x To minPlusX) max_)
         -> N (Min (Up x To sumMinPlusX))
        )
minAdd toAdd =
    \n ->
        ((n |> toInt) + (toAdd |> toInt))
            |> LimitedIn
                { minimumAsDifference =
                    (n |> minimumAsDifference)
                        |> differenceUp (toAdd |> minimumAsDifference)
                , maximumAsDifference = maximumNo
                }


{-| From the [`N`](#N) in a range subtract another [`N`](#N) in a range.

    n6 |> N.sub n5
    --→ n1
    --: N (In (Fixed N1) (Fixed N1))

One of the terms has no maximum constraint? → [`minSub`](#minSub)

-}
sub :
    N
        (In
            (Down maxPlusX To differenceMaxPlusX)
            (Down min To differenceMin)
        )
    ->
        (N (In (Fixed min) (Up maxX To maxPlusX))
         ->
            N
                (In
                    (Fixed differenceMin)
                    (Up maxX To differenceMaxPlusX)
                )
        )
sub toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> LimitedIn
                { minimumAsDifference =
                    (n |> minimumAsDifference)
                        |> differenceDown (toSubtract |> maximumAsDifference)
                , maximumAsDifference =
                    (n |> maximumAsDifference)
                        |> differenceDown (toSubtract |> minimumAsDifference)
                }


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#In)

    atLeast7 |> N.minSub n2
    --: N (Min (Fixed N5))

    atLeast6 |> N.minSub between0And5
    --: N (Min (Fixed N1))

    between6And12 |> N.minSub between1And5
    --: N (In (Fixed min) (Up maxX To (Add12 maxX)))

Use [`sub`](#sub) if you want to subtract an [`N`](#N) in a range.

-}
minSub :
    N
        (In
            subtractedDifference0_
            (Down min To differenceMin)
        )
    ->
        (N (In (Fixed min) max)
         -> N (In (Fixed differenceMin) max)
        )
minSub subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> LimitedIn
                { minimumAsDifference =
                    (n |> minimumAsDifference)
                        |> differenceDown
                            (subtrahend |> maximumAsDifference)
                , maximumAsDifference = n |> maximumAsDifference
                }



-- # internals


{-| Its limits.
Both its [`minimumAsDifference`](#minimumAsDifference)
and its [`maximumAsDifference`](#maximumAsDifference)
-}
range : N range -> range
range =
    \(LimitedIn rangeLimits _) -> rangeLimits


{-| The smallest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
minimumAsDifference : N (In minimumAsDifference maximum_) -> minimumAsDifference
minimumAsDifference =
    range >> .minimumAsDifference


{-| The greatest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
maximumAsDifference : N (In min_ maximumAsDifference) -> maximumAsDifference
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
n0 : N (In (Up minX To minX) (Up maxX To maxX))
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
    N
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
n2 : N (In (Up minX To (Add2 minX)) (Up maxX To (Add2 maxX)))
n2 =
    n1 |> add n1


{-| The specific natural number `3`
-}
n3 : N (In (Up minX To (Add3 minX)) (Up maxX To (Add3 maxX)))
n3 =
    n2 |> add n1


{-| The specific natural number `4`
-}
n4 : N (In (Up minX To (Add4 minX)) (Up maxX To (Add4 maxX)))
n4 =
    n3 |> add n1


{-| The specific natural number `5`
-}
n5 : N (In (Up minX To (Add5 minX)) (Up maxX To (Add5 maxX)))
n5 =
    n4 |> add n1


{-| The specific natural number `6`
-}
n6 : N (In (Up minX To (Add6 minX)) (Up maxX To (Add6 maxX)))
n6 =
    n5 |> add n1


{-| The specific natural number `7`
-}
n7 : N (In (Up minX To (Add7 minX)) (Up maxX To (Add7 maxX)))
n7 =
    n6 |> add n1


{-| The specific natural number `8`
-}
n8 : N (In (Up minX To (Add8 minX)) (Up maxX To (Add8 maxX)))
n8 =
    n7 |> add n1


{-| The specific natural number `9`
-}
n9 : N (In (Up minX To (Add9 minX)) (Up maxX To (Add9 maxX)))
n9 =
    n8 |> add n1


{-| The specific natural number `10`
-}
n10 : N (In (Up minX To (Add10 minX)) (Up maxX To (Add10 maxX)))
n10 =
    n9 |> add n1


{-| The specific natural number `11`
-}
n11 : N (In (Up minX To (Add11 minX)) (Up maxX To (Add11 maxX)))
n11 =
    n10 |> add n1


{-| The specific natural number `12`
-}
n12 : N (In (Up minX To (Add12 minX)) (Up maxX To (Add12 maxX)))
n12 =
    n11 |> add n1


{-| The specific natural number `13`
-}
n13 : N (In (Up minX To (Add13 minX)) (Up maxX To (Add13 maxX)))
n13 =
    n12 |> add n1


{-| The specific natural number `14`
-}
n14 : N (In (Up minX To (Add14 minX)) (Up maxX To (Add14 maxX)))
n14 =
    n13 |> add n1


{-| The specific natural number `15`
-}
n15 : N (In (Up minX To (Add15 minX)) (Up maxX To (Add15 maxX)))
n15 =
    n14 |> add n1


{-| The specific natural number `16`
-}
n16 : N (In (Up minX To (Add16 minX)) (Up maxX To (Add16 maxX)))
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
