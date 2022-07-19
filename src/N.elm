module N exposing
    ( N
    , Limit, Fixed
    , In, Min, MaxNo, Exactly
    , abs, randomIn, until
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , N0able(..), Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , BelowOrAbove(..)
    , intAtLeast, intIn
    , intIsIn, intIsAtLeast
    , atLeast, atMost
    , is, isIn, isAtLeast, isAtMost
    , add, addIn, minAdd
    , sub, subIn, minSub
    , toPower, remainderBy, mul, div
    , toInt, toFloat
    , minFixed, maxFixed
    , min, maxNo, max, maxUp
    , Increase, To
    , limitFixed, limitUp, limitDown
    , minimum, maximum
    , decreaseByDifference, increaseByDifference
    , differenceDecrease, differenceIncrease
    , minimumDifferenceUp, minimumDifferenceDown
    , maximumDifferenceDown, maximumDifferenceUp
    , differencesSwap
    )

{-| Natural numbers within a typed range.

@docs N
@docs Limit, Fixed


# bounds

@docs In, Min, MaxNo, Exactly


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

@docs add, addIn, minAdd, minAddAtLeast
@docs sub, subIn, minSub, minSubAtMost
@docs toPower, remainderBy, mul, div


## broaden

@docs toInt, toFloat


# type information

@docs minFixed, maxFixed
@docs min, maxNo, max, maxUp


# miss operation x?

Anything that can't be expressed with the available operations? → issue/PR


# fancy

Useful for extensions to this library
– building structures like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)

While the internally stored `Int` isn't directly guaranteed to be in bounds by elm,
[`minimum`](#minimum), [maximum](#maximum) and their representation as an [`Increase`](#Increase)
must be built as actual values checked by the compiler.
No shenanigans like runtime errors for impossible cases.

@docs In, Increase, To
@docs diffAdd, subDiff

@docs limitFixed, limitUp, limitDown

@docs minimum, maximum

@docs decreaseByDifference, increaseByDifference
@docs differenceDecrease, differenceIncrease
@docs minimumDifferenceUp, minimumDifferenceDown
@docs maximumDifferenceDown, maximumDifferenceUp

-}

import Emptiable exposing (Emptiable)
import Help exposing (valueElseOnError)
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

The type [`In`](#In) `(`[`Increase x0 To nPlusX0`](#Increase)`) ...`
enables adding, subtracting `N<x>` types.
Consider the type an implementation detail.
You can come back to [understand them later](#fancy).

    n3 :
        N
            (In
                N3
                (Increase x0 To (Add3 x0))
                (Increase x1 To (Add3 x1))
                (Add3 atLeast_)
            )

-}
type N range
    = LimitedIn range Int


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

  - `max_` could be a specific maximum or [no maximum at all](#MaxNo)


### `In minimum maximum`

A number somewhere within a `minimum` & `maximum`. We don't know it exactly, though

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    N (In N3 (Add5 a_))

-}
type alias In minimum maximum =
    RecordWithoutConstructorFunction
        { minimum : minimum
        , maximum : maximum
        }


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
    In lowestPossibleValue MaxNo


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
type alias Increase low toTag high =
    RecordWithoutConstructorFunction
        { increase : low -> high
        , decrease : high -> low
        , toTag : toTag
        }


type alias Decrease high toTag low =
    Increase low toTag high


{-| Just a word in the [type `Increase`](#Increase).

    Increase low To high

→ distance `high - low`.

-}
type alias To =
    RecordWithoutConstructorFunction
        { to : () }


{-| Flag "The number's maximum limit is unknown".

    type alias Min min =
        In minimum MaxNo

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
        Tree MaxNo element

Remember: ↑ and other [`Min`](#Min)/[`MaxNo`](#MaxNo) are result/stored types, not argument types.
You can just use a variable `Tree childCountMax_ element` if you don't care about an enforced maximum.

-}
type alias MaxNo =
    -- TODO: can we add a type variable so it adds any distance to { noMaximum : () }?
    Fixed { noMaximum : () }


{-| The minimum or maximum, represented as a [fixed value](#N0able)
and an difference, as either an [`Increase`](#Increase) or [`Decrease`](#Decrease)
-}
type alias Limit fixed difference =
    RecordWithoutConstructorFunction
        { fixed : fixed
        , increase : difference
        }


type alias Fixed n =
    Limit n (Increase N0 To n)


limitFixed : n -> Fixed n
limitFixed =
    \n ->
        { fixed = n
        , increase = increase0To n
        }


maximumNo : MaxNo
maximumNo =
    { noMaximum = () } |> limitFixed


increase0To : n -> Increase N0 To n
increase0To n =
    { increase = \_ -> n
    , decrease = \_ -> N0 Possible
    , toTag = { to = () }
    }


n0Difference : Increase x To x
n0Difference =
    { increase = identity
    , decrease = identity
    , toTag = { to = () }
    }


n1Difference : Increase x To (Add1 x)
n1Difference =
    { increase = Add1
    , decrease =
        \n0Never ->
            case n0Never of
                Add1 predecessor ->
                    predecessor

                N0 possible ->
                    possible |> never
    , toTag = { to = () }
    }


limitUp :
    N
        (In
            (Limit increase (Increase n To nIncreased))
            (Limit increase (Increase nPlusX To nIncreasedPlusX))
        )
    ->
        (Limit n (Increase x To nPlusX)
         -> Limit nIncreased (Increase x To nIncreasedPlusX)
        )
limitUp increase =
    \limit ->
        { fixed =
            (limit |> .fixed)
                |> increaseByDifference (increase |> minimum |> .increase)
        , increase =
            (limit |> .increase)
                |> differenceIncrease (increase |> maximum |> .increase)
        }


limitDown :
    N
        (In
            (Limit decrease (Decrease n To nDecreased))
            (Limit decrease (Decrease nPlusX To nDecreasedPlusX))
        )
    ->
        (Limit n (Increase x To nPlusX)
         -> Limit nDecreased (Increase x To nDecreasedPlusX)
        )
limitDown decrease =
    \limit ->
        { fixed =
            (limit |> .fixed)
                |> decreaseByDifference (decrease |> minimum |> .increase)
        , increase =
            (limit |> .increase)
                |> differenceDecrease (decrease |> maximum |> .increase)
        }



--


{-| Add a given [specific](#In) [`N`](#N).

    between70And100 |> N.add n7
    --: N (In N77 (Add107 a_))

Use [`addAtMost`](#addAtMost)/[`minAdd`](#minAdd) to add an [`N`](#N) in a range.

-}
add :
    N
        (In
            (Limit addedMin_ (Increase min To sumMin))
            (Limit addedMax_ (Increase max To sumMax))
        )
    ->
        (N (In (Fixed min) (Fixed max))
         -> N (In (Fixed sumMin) (Fixed sumMax))
        )
add toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> LimitedIn
                { minimum =
                    (n |> minimum |> .fixed)
                        |> increaseByDifference
                            (toAdd |> minimum |> .increase)
                        |> limitFixed
                , maximum =
                    (n |> maximum |> .fixed)
                        |> increaseByDifference
                            (toAdd |> maximum |> .increase)
                        |> limitFixed
                }


{-| Subtract a given [specific](#In) [`N`](#N).

    between7And10 |> N.sub n7
    --: N (In N0 (Add3 a_))

Use [`subIn`](#subIn) if you want to subtract an [`N`](#N) in a range.

-}
sub :
    N
        (In
            (Limit
                subtractedMin_
                (Increase differenceMax To max)
            )
            (Limit
                subtractedMax_
                (Increase differenceMin To min)
            )
        )
    ->
        (N (In (Fixed min) (Fixed max))
         -> N (In (Fixed differenceMin) (Fixed differenceMax))
        )
sub toSubtract =
    \n ->
        (n |> toInt)
            + (toSubtract |> toInt)
            |> LimitedIn
                { minimum =
                    (n |> minimum |> .fixed)
                        |> decreaseByDifference
                            (toSubtract |> maximum |> .increase)
                        |> limitFixed
                , maximum =
                    (n |> maximum |> .fixed)
                        |> decreaseByDifference
                            (toSubtract |> minimum |> .increase)
                        |> limitFixed
                }


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
abs : Int -> N (Min (Limit N0 (Increase x To x)))
abs =
    Basics.abs
        >> LimitedIn
            { minimum = n0 |> minimum
            , maximum = maximumNo
            }


untilReverse :
    N (In (Fixed min_) (Limit max maxDifference))
    ->
        Emptiable
            (Stacked
                (N
                    (In
                        (Limit N0 (Increase x0 To x0))
                        (Limit max maxDifference)
                    )
                )
            )
            Never
untilReverse last =
    case last |> isAtLeast n1 of
        Err _ ->
            n0 |> max last |> Stack.only

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
    N (In (Fixed min_) (Limit max maxDifference))
    ->
        Emptiable
            (Stacked
                (N
                    (In
                        (Limit N0 (Increase x0 To x0))
                        (Limit max maxDifference)
                    )
                )
            )
            Never
until last =
    untilReverse last |> Stack.reverse


untilReverseRecursive :
    N (In (Fixed min_) (Limit max maxDifference))
    ->
        Emptiable
            (Stacked
                (N
                    (In
                        (Limit N0 (Increase x0 To x0))
                        (Limit max maxDifference)
                    )
                )
            )
            Never
untilReverseRecursive =
    untilReverse


{-| Generate a random [`N`](#N) in a range.

    N.randomIn ( n1, n10 )
    --: Random.Generator (N (In N1 (Add10 a_)))

-}
randomIn :
    ( N
        (In
            lowerLimitMin
            (Limit
                lowerLimitMax
                (Increase lowerLimitMaxToUpperLimitMin To upperLimitMin)
            )
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
                { minimum = lowestPossible |> minimum
                , maximum = highestPossible |> maximum
                }
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
    ( N
        (In
            lowerLimit
            (Limit
                lowerLimitMax_
                (Increase lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
            )
        )
    , N
        (In
            (Limit
                -- TODO: avoid
                upperLimitMin
                (Increase upperLimitMinX To upperLimitMinPlusX)
            )
            upperLimit
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
                            (Limit
                                (Add1 upperLimitMin)
                                (Increase upperLimitMinX To (Add1 upperLimitMinPlusX))
                            )
                        )
                    )
                )
                (N (In lowerLimit upperLimit))
        )
intIsIn ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> Below |> Err

        else if int > (upperLimit |> toInt) then
            int
                |> LimitedIn
                    { minimum =
                        (upperLimit |> minimum)
                            |> limitUp n1
                    , maximum = maximumNo
                    }
                |> Above
                |> Err

        else
            int
                |> LimitedIn
                    { minimum = lowerLimit |> minimum
                    , maximum = upperLimit |> maximum
                    }
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
                |> LimitedIn
                    { minimum = minimumLimit |> minimum
                    , maximum = maximumNo
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
    ( N
        (In
            lowerLimit
            (Limit
                lowerLimitMax_
                (Increase lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
            )
        )
    , N
        (In
            (Limit
                upperLimitMin
                (Increase upperLimitMinX To upperLimitMinPlusX)
            )
            upperLimit
        )
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
                            |> LimitedIn
                                { minimum = lowerLimit |> minimum
                                , maximum = upperLimit |> maximum
                                }

                    Above _ ->
                        upperLimit |> minFixed |> min lowerLimit
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
    N (In (Limit minNewMin newMinDiff) (Limit max maxIncrease_))
    ->
        (N (In min_ max)
         -> N (In (Limit minNewMin newMinDiff) max)
        )
atLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimum = lowerLimit |> minimum
                    , maximum = n |> maximum
                    }

        else
            (lowerLimit |> toInt)
                |> LimitedIn
                    { minimum = lowerLimit |> minimum
                    , maximum = n |> maximum
                    }


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
    N (In (Fixed min) maxCapped)
    ->
        (N (In (Limit min (Increase x To minPlusX)) max_)
         -> N (In (Limit min (Increase x To minPlusX)) maxCapped)
        )
atMost upperLimit =
    \n ->
        n
            |> isAtMost upperLimit
            |> valueElseOnError
                (\_ ->
                    (upperLimit |> toInt)
                        |> LimitedIn
                            { minimum = n |> minimum
                            , maximum = upperLimit |> maximum
                            }
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
            |> LimitedIn
                { minimum = n |> minimum
                , maximum = maximumNo
                }


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
         -> N (In (Limit N0 (Increase x0 To x0)) max)
        )
div divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> LimitedIn
                { minimum = n0 |> minimum
                , maximum = n |> maximum
                }


{-| The remainder after dividing by a [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In N0 (Add3 a_))

-}
remainderBy :
    N
        (In
            (Fixed (Add1 divisorMinMinus1_))
            (Limit (Add1 divisorMaxMinus1) (Increase divX To (Add1 divisorMaxPlusXMinus1)))
        )
    ->
        (N (In min_ max_)
         ->
            N
                (In
                    (Limit N0 (Increase x0 To x0))
                    (Limit divisorMaxMinus1 (Increase divX To divisorMaxPlusXMinus1))
                )
        )
remainderBy divisor =
    \n ->
        (n |> toInt)
            |> Basics.remainderBy (divisor |> toInt)
            |> LimitedIn
                { minimum = n0 |> minimum
                , maximum =
                    (divisor |> maximum)
                        |> limitDown n1
                }


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
            |> LimitedIn
                { minimum = n |> minimum
                , maximum = maximumNo
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
    N (In minNew (Limit minNewMax_ (Increase minNewMaxToMin_ To min)))
    ->
        (N (In (Fixed min) max)
         -> N (In minNew max)
        )
min newMinimum =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = newMinimum |> minimum
                , maximum = n |> maximum
                }


{-| Convert an [`N`](#N) with specific minimum differences it to a `N (In min max)`.

    take : In (Limit min (Increase ...)) (Fixed max) -> ...
    take taken =
        ...
        taken
            -- differences are set in stone to specific type variables
            -- so supplying it to a function that requires `Fixed ...` is impossible
            |> N.minFixed
        ...
    --: N (In N4 (Add4 a_))

A more common example:

    [ in3To10, n3 ]

> all the previous elements in the list are: `N (In N3 N10)`

    [ in3To10
    , n3 |> N.minFixed |> N.maxFixed
    ]

-}
minFixed :
    N (In (Limit min minDiff_) max)
    -> N (In (Fixed min) max)
minFixed =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum |> .fixed |> limitFixed
                , maximum = n |> maximum
                }


{-| Convert an [`N`](#N) with specific minimum differences it to a `N (In min max)`.

    take : In (Limit min (Increase ...)) (Fixed max) -> ...
    take taken =
        ...
        taken
            -- differences are set in stone to specific type variables
            -- so supplying it to a function that requires `Fixed ...` is impossible
            |> N.minFixed
        ...
    --: N (In N4 (Add4 a_))

A more common example:

    [ in3To10, n3 ]

> all the previous elements in the list are: `N (In N3 N10)`

    [ in3To10
    , n3 |> N.minFixed |> N.maxFixed
    ]

-}
maxFixed :
    N (In min (Limit max maxDiff_))
    -> N (In min (Fixed max))
maxFixed =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum = n |> maximum |> .fixed |> limitFixed
                }


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
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum = maximumNo
                }


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
    N (In maxNewMin_ (Limit maxNew maxNewDiff))
    ->
        (N (In min (Limit max_ (Increase maxToMaxNew_ To maxNew)))
         -> N (In min (Limit maxNew maxNewDiff))
        )
max maximumNew =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum = maximumNew |> maximum
                }


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
        (In
            (Limit
                increase
                (Increase max To maxIncreased)
            )
            (Limit
                increase
                (Increase maxPlusX To maxIncreasedPlusX)
            )
        )
    ->
        (N (In min (Limit max (Increase x To maxPlusX)))
         -> N (In min (Limit maxIncreased (Increase x To maxIncreasedPlusX)))
        )
maxUp maxRelativeIncrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum =
                    { fixed =
                        (n |> maximum |> .fixed)
                            |> increaseByDifference
                                (maxRelativeIncrease |> minimum |> .increase)
                    , increase =
                        (n |> maximum |> .increase)
                            |> differenceIncrease
                                (maxRelativeIncrease |> maximum |> .increase)
                    }
                }


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
    \(LimitedIn _ int) -> int


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
    N
        (In
            (Limit
                (Add1 comparedAgainstMinMinus1)
                (Increase minX To (Add1 comparedAgainstMinPlusXMinus1))
            )
            (Limit
                (Add1 comparedAgainstMaxMinus1)
                (Increase maxX To (Add1 comparedAgainstMaxPlusXMinus1))
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
                            (Limit
                                comparedAgainstMaxMinus1
                                (Increase maxX To comparedAgainstMaxPlusXMinus1)
                            )
                        )
                    )
                    (N
                        (In
                            (Limit
                                (Add2 comparedAgainstMinMinus1)
                                (Increase minX To (Add2 comparedAgainstMinPlusXMinus1))
                            )
                            max
                        )
                    )
                )
                (N
                    (In
                        (Limit
                            (Add1 comparedAgainstMinMinus1)
                            (Increase minX To (Add1 comparedAgainstMinPlusXMinus1))
                        )
                        (Limit
                            (Add1 comparedAgainstMaxMinus1)
                            (Increase maxX To (Add1 comparedAgainstMaxPlusXMinus1))
                        )
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
                        { minimum =
                            (comparedAgainst |> minimum)
                                |> limitUp n1
                        , maximum = n |> maximum
                        }
                    |> Above
                    |> Err

            LT ->
                (n |> toInt)
                    |> LimitedIn
                        { minimum = n |> minimum
                        , maximum =
                            (comparedAgainst |> maximum)
                                |> limitDown n1
                        }
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
            (Limit
                (Add1 lowerLimitMaxMinus1)
                (Increase lowerLimitMaxX To (Add1 lowerLimitMaxPlusXMinus1))
            )
        )
    , N
        (In
            (Limit
                upperLimitMin
                (Increase upperLimitMinX To upperLimitMinPlusX)
            )
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
                            (Limit
                                lowerLimitMaxMinus1
                                (Increase lowerLimitMaxX To lowerLimitMaxPlusXMinus1)
                            )
                        )
                    )
                    (N
                        (In
                            (Limit
                                (Add1 upperLimitMin)
                                (Increase upperLimitMinX To (Add1 upperLimitMinPlusX))
                            )
                            max
                        )
                    )
                )
                (N (In lowerLimit upperLimitMax))
        )
isIn ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimum = n |> minimum
                    , maximum =
                        (lowerLimit |> maximum)
                            |> limitDown n1
                    }
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimum =
                        (upperLimit |> minimum)
                            |> limitUp n1
                    , maximum = n |> maximum
                    }
                |> Above
                |> Err

        else
            (n |> toInt)
                |> LimitedIn
                    { minimum =
                        lowerLimit |> minimum
                    , maximum = upperLimit |> maximum
                    }
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
            (Limit (Add1 lowerLimitMaxMinus1) (Increase x0 To (Add1 lowerLimitMaxMinus1)))
        )
    ->
        (N (In min max)
         ->
            Result
                (N (In min (Limit lowerLimitMaxMinus1 (Increase x0 To lowerLimitMaxMinus1))))
                (N (In lowerLimitMin max))
        )
isAtLeast lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimum = lowerLimit |> minimum
                    , maximum = n |> maximum
                    }
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    { minimum = n |> minimum
                    , maximum =
                        (lowerLimit |> maximum)
                            |> limitDown n1
                    }
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
    N (In (Limit upperLimitMin (Increase x To minPlusX)) upperLimitMax)
    ->
        (N (In min max)
         ->
            Result
                (N (In (Limit (Add1 upperLimitMin) (Increase x To (Add1 minPlusX))) max))
                (N (In min upperLimitMax))
        )
isAtMost upperLimit =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    { minimum = n |> minimum
                    , maximum = upperLimit |> maximum
                    }
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    { minimum =
                        (upperLimit |> minimum)
                            |> limitUp n1
                    , maximum = n |> maximum
                    }
                |> Err


{-| The [specific](#In) [`N`](#N) plus another [specific](#In) [`N`](#N).
Give the added number twice as a tuple.

    n6 |> N.diffAdd ( n5, n5 )
    --→ n11
    --: N
    --:     (In
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
addIn :
    ( N
        (In
            (Limit
                addedMin
                (Increase min To sumMin)
            )
            (Limit
                addedMin
                (Increase minPlusX To sumMinPlusX)
            )
        )
    , N
        (In
            (Limit
                addedMax
                (Increase max To sumMax)
            )
            (Limit
                addedMax
                (Increase maxPlusX To sumMaxPlusX)
            )
        )
    )
    -> N (In (Fixed addedMin) (Fixed addedMax))
    ->
        (N
            (In
                (Limit
                    min
                    (Increase minX To minPlusX)
                )
                (Limit
                    max
                    (Increase maxX To maxPlusX)
                )
            )
         ->
            N
                (In
                    (Limit
                        sumMin
                        (Increase minX To sumMinPlusX)
                    )
                    (Limit
                        sumMax
                        (Increase maxX To sumMaxPlusX)
                    )
                )
        )
addIn ( lowestPossibleAdded, highestPossibleAdded ) toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> LimitedIn
                { minimum =
                    (n |> minimum)
                        |> limitUp lowestPossibleAdded
                , maximum =
                    (n |> maximum)
                        |> limitUp highestPossibleAdded
                }


{-| To the [`N`](#N) without a known maximum-constraint,
add a number that has [information on how to add](#Diff) the minima.

    atLeast70 |> N.minAdd n7
    --: N (Min N77)

Use [`addAtLeast`](#addAtLeast) if you want to add an [`N`](#N) in a range.

If the added value is in a range, supply the [`min`](#min) manually
to re-enable adding both minimum types!

    atLeast5 |> N.minAdd (min n2 atLeast2)
    --: N (Min N7)

    between3And10 |> N.addAtMost n12 (min n1 between1And12)
    --: N (In N4 (N22Plus a_))

TODO: add `minAddDiff`

-}
minAdd :
    N
        (In
            (Limit
                addedMin_
                (Increase min To sumMin)
            )
            addedMax_
        )
    ->
        (N (In (Fixed min) max_)
         -> N (Min (Fixed sumMin))
        )
minAdd toAdd =
    \n ->
        ((n |> toInt) + (toAdd |> toInt))
            |> LimitedIn
                { minimum =
                    (n |> minimum |> .fixed)
                        |> increaseByDifference (toAdd |> minimum |> .increase)
                        |> limitFixed
                , maximum = maximumNo
                }


{-| The [specific](#In) [`N`](#N) minus another [specific](#In) [`N`](#N).
Give the subtracted value twice as a tuple.

    n6 |> N.subDiff ( n5, n5 )
    --→ n1
    --: N
    --:     (In
    --:         N1
    --:         (Increase x0 To (Add1 x0))
    --:         (Increase x1 To (Add1 x1))
    --:         (Add1 a_)
    --:     )

This is only rarely useful, as for example

    isInXMinus10ToX x =
        isIn ( x |> N.subDiff ( n10, n10 ), x )

would force `x` to be a specific [`In`](#In).
Instead,

    isInXMinus10ToX x =
        isIn ( x |> N.sub n10, x )

-}
subIn :
    ( N
        (In
            (Limit
                subtractedMin
                (Decrease max To differenceMax)
            )
            (Limit
                subtractedMin
                (Decrease maxPlusX To differenceMaxPlusX)
            )
        )
    , N
        (In
            (Limit
                subtractedMax
                (Decrease min To differenceMin)
            )
            (Limit
                subtractedMax
                (Decrease minPlusX To differenceMinPlusX)
            )
        )
    )
    -> N (In (Fixed subtractedMin) (Fixed subtractedMax))
    ->
        (N
            (In
                (Limit
                    min
                    (Increase minX To minPlusX)
                )
                (Limit
                    max
                    (Increase maxX To maxPlusX)
                )
            )
         ->
            N
                (In
                    (Limit
                        differenceMin
                        (Increase minX To differenceMinPlusX)
                    )
                    (Limit
                        differenceMax
                        (Increase maxX To differenceMaxPlusX)
                    )
                )
        )
subIn ( subtrahendLowerLimit, subtrahendUpperLimit ) toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> LimitedIn
                { minimum =
                    (n |> minimum)
                        |> limitDown subtrahendUpperLimit
                , maximum =
                    (n |> maximum)
                        |> limitDown subtrahendLowerLimit
                }


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#In)

    atLeast7 |> N.minSub n2
    --: N (Min N5)

    atLeast6 |> N.minSubAtMost n5 between0And5
    --: N (Min N1)

    between6And12 |> N.subAtMost n5 (min n1 between1And5)
    --: N (In N1 (Add5 a_))

Use [`minSubAtMost`](#minSubAtMost) if you want to subtract an [`N`](#N) in a range.

-}
minSub :
    N
        (In
            (Limit
                subtracted
                (Increase differenceMin To min)
            )
            (Limit
                subtracted
                subtractedDiff1_
            )
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
                { minimum =
                    (n |> minimum |> .fixed)
                        |> decreaseByDifference (subtrahend |> minimum |> .increase)
                        |> limitFixed
                , maximum = n |> maximum
                }



-- # internals


{-| The smallest allowed number promised by the range type
including its value as a difference → [`Bound`](#Bound).
-}
minimum : N (In minimum maximum_) -> minimum
minimum =
    \(LimitedIn rangeLimits _) -> rangeLimits.minimum


{-| The greatest allowed number promised by the range type
including its value as a difference → [`Bound`](#Bound).
-}
maximum : N (In min_ maximum) -> maximum
maximum =
    \(LimitedIn rangeLimits _) -> rangeLimits.maximum


{-| To the number, add a specific other one by supplying a [difference](#Increase).
-}
increaseByDifference : Increase low To high -> (low -> high)
increaseByDifference =
    \differenceOperation -> differenceOperation.increase


{-| To the number, subtract a specific other one by supplying a [difference](#Increase).
-}
decreaseByDifference : Increase low To high -> (high -> low)
decreaseByDifference =
    \differenceOperation -> differenceOperation.decrease


{-| Chain the [difference](#Increase) further to a higher number.
-}
differenceIncrease :
    Increase middle To high
    -> (Increase low To middle -> Increase low To high)
differenceIncrease diffMiddleToHigh =
    \diffLowToMiddle ->
        { increase =
            increaseByDifference diffLowToMiddle
                >> increaseByDifference diffMiddleToHigh
        , decrease =
            decreaseByDifference diffMiddleToHigh
                >> decreaseByDifference diffLowToMiddle
        , toTag = { to = () }
        }


{-| Chain the [difference](#Increase) back to a lower number.
-}
differenceDecrease :
    Increase middle To high
    -> (Increase low To high -> Increase low To middle)
differenceDecrease diffMiddleToHigh =
    \diffLowToHigh ->
        { increase =
            increaseByDifference diffLowToHigh
                >> decreaseByDifference diffMiddleToHigh
        , decrease =
            increaseByDifference diffMiddleToHigh
                >> decreaseByDifference diffLowToHigh
        , toTag = { to = () }
        }


{-| Increase its [`minimum |> .increase`](#minimum |> .increase) by a specific given number.
-}
minimumDifferenceUp :
    N
        (In
            (Limit
                min
                (Increase middle To high)
            )
            (Limit
                max
                minDifference
            )
        )
    ->
        (N
            (In
                (Limit
                    min
                    (Increase low To middle)
                )
                (Limit
                    max
                    minDifference
                )
            )
         ->
            N
                (In
                    (Limit
                        min
                        (Increase low To high)
                    )
                    (Limit
                        max
                        minDifference
                    )
                )
        )
minimumDifferenceUp minimumIncrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum =
                    { fixed = n |> minimum |> .fixed
                    , increase =
                        (n |> minimum |> .increase)
                            |> differenceIncrease
                                (minimumIncrease |> minimum |> .increase)
                    }
                , maximum = n |> maximum
                }


{-| Increase its [`maximum |> .increase`](#maximum |> .increase) by a specific given number.
-}
maximumDifferenceUp :
    N
        (In
            (Limit
                min
                minDifference0
            )
            (Limit
                max
                (Increase middle To high)
            )
        )
    ->
        (N
            (In
                (Limit
                    min
                    minDifference0
                )
                (Limit
                    max
                    (Increase low To middle)
                )
            )
         ->
            N
                (In
                    (Limit
                        min
                        minDifference0
                    )
                    (Limit
                        max
                        (Increase low To high)
                    )
                )
        )
maximumDifferenceUp maximumIncrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum =
                    { fixed = n |> maximum |> .fixed
                    , increase =
                        (n |> maximum |> .increase)
                            |> differenceIncrease
                                (maximumIncrease |> maximum |> .increase)
                    }
                }


{-| Decrease its [`minimum |> .increase`](#minimum |> .increase) by a specific given number.
-}
minimumDifferenceDown :
    N
        (In
            (Limit
                min
                (Increase middle To high)
            )
            (Limit
                max
                minDifference0
            )
        )
    ->
        (N
            (In
                (Limit
                    min
                    (Increase low To high)
                )
                (Limit
                    max
                    minDifference0
                )
            )
         ->
            N
                (In
                    (Limit
                        min
                        (Increase low To middle)
                    )
                    (Limit
                        max
                        minDifference0
                    )
                )
        )
minimumDifferenceDown minimumDecrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum =
                    { fixed = n |> minimum |> .fixed
                    , increase =
                        (n |> minimum |> .increase)
                            |> differenceDecrease
                                (minimumDecrease |> minimum |> .increase)
                    }
                , maximum = n |> maximum
                }


{-| Decrease its [`maximum |> .increase`](#maximum |> .increase) by a specific given number.
-}
maximumDifferenceDown :
    N
        (In
            (Limit
                min
                minDifference
            )
            (Limit
                max
                (Increase middle To high)
            )
        )
    ->
        (N
            (In
                (Limit
                    min
                    minDifference
                )
                (Limit
                    max
                    (Increase low To high)
                )
            )
         ->
            N
                (In
                    (Limit
                        min
                        minDifference
                    )
                    (Limit
                        max
                        (Increase low To middle)
                    )
                )
        )
maximumDifferenceDown maximumDecrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum = n |> minimum
                , maximum =
                    { fixed = n |> maximum |> .fixed
                    , increase =
                        (n |> maximum |> .increase)
                            |> differenceDecrease
                                (maximumDecrease |> maximum |> .increase)
                    }
                }


{-| Switch [`minimum |> .increase`](#minimum |> .increase), [`maximum |> .increase`](#maximum |> .increase)
in the type.

    addAtMostSwapped :
        N
            (In
                addedMax
                (Increase max To sumMax)
                addedMaxDiff0_
                addedMax
            )
        ->
            N
                (In
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
    N (In (Limit n diff0) (Limit n diff1))
    -> N (In (Limit n diff1) (Limit n diff0))
differencesSwap =
    \n ->
        (n |> toInt)
            |> LimitedIn
                { minimum =
                    { fixed = n |> minimum |> .fixed
                    , increase = n |> maximum |> .increase
                    }
                , maximum =
                    { fixed = n |> maximum |> .fixed
                    , increase = n |> minimum |> .increase
                    }
                }



--


{-| The specific natural number `0`
-}
n0 : N (In (Limit N0 (Increase x0 To x0)) (Limit N0 (Increase x1 To x1)))
n0 =
    0
        |> LimitedIn
            { minimum =
                { fixed = N0 Possible
                , increase = n0Difference
                }
            , maximum =
                { fixed = N0 Possible
                , increase = n0Difference
                }
            }


{-| The specific natural number `1`
-}
n1 :
    N
        (In
            (Limit
                N1
                (Increase x0 To (Add1 x0))
            )
            (Limit
                N1
                (Increase x1 To (Add1 x1))
            )
        )
n1 =
    1
        |> LimitedIn
            { minimum =
                { fixed = N0 Possible |> Add1
                , increase = n1Difference
                }
            , maximum =
                { fixed = N0 Possible |> Add1
                , increase = n1Difference
                }
            }


{-| The specific natural number `2`
-}
n2 : N (In (Limit N2 (Increase minX To (Add2 minX))) (Limit N2 (Increase maxX To (Add2 maxX))))
n2 =
    n1 |> addIn ( n1, n1 ) n1


{-| The specific natural number `3`
-}
n3 : N (In (Limit N3 (Increase minX To (Add3 minX))) (Limit N3 (Increase maxX To (Add3 maxX))))
n3 =
    n2 |> addIn ( n1, n1 ) n1


{-| The specific natural number `4`
-}
n4 : N (In (Limit N4 (Increase minX To (Add4 minX))) (Limit N4 (Increase maxX To (Add4 maxX))))
n4 =
    n3 |> addIn ( n1, n1 ) n1


{-| The specific natural number `5`
-}
n5 : N (In (Limit N5 (Increase minX To (Add5 minX))) (Limit N5 (Increase maxX To (Add5 maxX))))
n5 =
    n4 |> addIn ( n1, n1 ) n1


{-| The specific natural number `6`
-}
n6 : N (In (Limit N6 (Increase minX To (Add6 minX))) (Limit N6 (Increase maxX To (Add6 maxX))))
n6 =
    n5 |> addIn ( n1, n1 ) n1


{-| The specific natural number `7`
-}
n7 : N (In (Limit N7 (Increase minX To (Add7 minX))) (Limit N7 (Increase maxX To (Add7 maxX))))
n7 =
    n6 |> addIn ( n1, n1 ) n1


{-| The specific natural number `8`
-}
n8 : N (In (Limit N8 (Increase minX To (Add8 minX))) (Limit N8 (Increase maxX To (Add8 maxX))))
n8 =
    n7 |> addIn ( n1, n1 ) n1


{-| The specific natural number `9`
-}
n9 : N (In (Limit N9 (Increase minX To (Add9 minX))) (Limit N9 (Increase maxX To (Add9 maxX))))
n9 =
    n8 |> addIn ( n1, n1 ) n1


{-| The specific natural number `10`
-}
n10 : N (In (Limit N10 (Increase minX To (Add10 minX))) (Limit N10 (Increase maxX To (Add10 maxX))))
n10 =
    n9 |> addIn ( n1, n1 ) n1


{-| The specific natural number `11`
-}
n11 : N (In (Limit N11 (Increase minX To (Add11 minX))) (Limit N11 (Increase maxX To (Add11 maxX))))
n11 =
    n10 |> addIn ( n1, n1 ) n1


{-| The specific natural number `12`
-}
n12 : N (In (Limit N12 (Increase minX To (Add12 minX))) (Limit N12 (Increase maxX To (Add12 maxX))))
n12 =
    n11 |> addIn ( n1, n1 ) n1


{-| The specific natural number `13`
-}
n13 : N (In (Limit N13 (Increase minX To (Add13 minX))) (Limit N13 (Increase maxX To (Add13 maxX))))
n13 =
    n12 |> addIn ( n1, n1 ) n1


{-| The specific natural number `14`
-}
n14 : N (In (Limit N14 (Increase minX To (Add14 minX))) (Limit N14 (Increase maxX To (Add14 maxX))))
n14 =
    n13 |> addIn ( n1, n1 ) n1


{-| The specific natural number `15`
-}
n15 : N (In (Limit N15 (Increase minX To (Add15 minX))) (Limit N15 (Increase maxX To (Add15 maxX))))
n15 =
    n14 |> addIn ( n1, n1 ) n1


{-| The specific natural number `16`
-}
n16 : N (In (Limit N16 (Increase minX To (Add16 minX))) (Limit N16 (Increase maxX To (Add16 maxX))))
n16 =
    n15 |> addIn ( n1, n1 ) n1


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
