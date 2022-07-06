module N exposing
    ( N
    , Zero
    , In
    , Min
    , Is, Diff(..), To
    , Exactly
    , abs, range, random
    , isIntInRange, isIntAtLeast
    , AtMostOrAbove(..), BelowOrAtLeast(..), BelowOrInOrAboveRange(..), LessOrEqualOrGreater(..)
    , intAtLeast, intInRange, atMost
    , add, sub, toPower, remainderBy, mul, div
    , inAdd, inSub, inAddIn, inSubIn
    , minSub, minAdd, minAddMin
    , diffAdd, diffSub
    , toInt, toFloat
    , minLower, noDiff, noMax
    , restoreMax
    , maximum, minimum
    , difference0, difference1, differences
    , addDifference, subDifference
    , N0able(..), NoMax, differenceThenAdd
    )

{-| Natural numbers within a typed range.

@docs N


# bounds

@docs Limit, Zero
@docs In


## storage / return type

@docs Min, NoMaximum


### with differences

@docs Is, Diff, To


## argument-only types

@docs Exactly


# create

@docs abs, range, random


# compare

@docs isIntInRange, isIntAtLeast


## comparison result

@docs AtMostOrAbove, BelowOrAtLeast, BelowOrInOrAboveRange, LessOrEqualOrGreater


## compare [`In`](#In) with a maximum

@docs inIs, inIsInRange, inIsAtLeast, inIsAtMost


## compare maximum unconstrained

@docs minIs, minIsAtLeast, minIsAtMost


## clamp

@docs intAtLeast, intInRange, atMost


### clamp [`In`](#In) with a maximum

@docs inAtLeast


### clamp maximum unconstrained

@docs minAtLeast


# alter

@docs add, sub, toPower, remainderBy, mul, div


## alter [`In`](#In) with a maximum

@docs inAdd, inSub, inAddIn, inSubIn


## alter maximum unconstrained

@docs minSub, minAdd, minSubMax, minAddMin


## alter with [`Diff`](#Diff)s

Operations that can only be used with `N (In ... (Is ...))`s (`n0`, `n1`, ...).
You will probably never need those.

@docs diffAdd, diffSub


## transform

@docs toInt, toFloat


# information drop

@docs minLower, noDiff, noMax


# restore

@docs restoreMax


# miss operation x?

Anything that can't be expressed with the available operations? → issue/PR


# internals

Useful for fancy things – building structures like [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)

While the internally stored `Int` isn't directly guaranteed to be in bounds by elm,
[`minimum`](#minimum), [`maximum`](#maximum), [`differences`](#differences)
must be built as actual values checked by the compiler.

@docs maximum, minimum
@docs difference0, difference1, differences
@docs addDifference, subDifference, differenceThen

-}

import Possibly exposing (Possibly(..))
import Random
import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)


type alias N0 =
    N0able Never Possibly


type alias Add1 n =
    N0able n Never


type alias Add2 n =
    Add1 (Add1 n)


type alias N2 =
    Add2 N0


type alias N1 =
    Add1 N0


type N0able successor possiblyOrNever
    = Z possiblyOrNever
    | S successor


{-| A **bounded** natural number (`>= 0`).


### argument-only type

    -- >= 4
    N (In (N4Plus minMinus4_) max_ difference_)

    -- 4 <= n <= 15
    N (In (N4Plus minMinus4_) N15 difference_)

    -- any, just >= 0
    N range


### n types

    -- >= 4
    N (Min N4)

    -- 2 <= n <= 12
    N (In N2 (N12Plus a_))


### storage types

Like what to store in the `Model` for example.

    -- >= 4
    N (Min N4)

    -- 2 <= n <= 12
    N (In N2 N12)


### exact number

It's type enables adding/subtracting `N...` types.

    n3
        : N
            (In
                N3
                (N3Plus x_)
                (Is
                    (Diff a To (N3Plus a))
                    (Diff b To (N3Plus b))
                )
            )

    -- a number nTo15 away from 15
    N (In n atLeastN_ (Is (Diff nTo15 To N15) diff1_))

-}
type N range
    = NLimitedTo range Int


{-| somewhere within a `minimum` & `maximum`

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### `In minimum maximum difference_`

For arguments

Note: `max` >= `min` for every existing `N (In min max ...)`:

    percent : N (In min_ N100 difference_) -> Percent

→ `min <= N100`

If you want a number where you just care about the minimum, leave the `max` as a type _variable_.

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

Any natural number:

    N (In min_ max_ difference_)

A number, at least 5:

    N (In (N5Plus minMinus5_) max_ difference_)

  - `max_` could be a maximum n if there is one

  - `difference_` could contain extra information if the argument is a `N (N ...)`


### `In minimum maximum {}`

A n somewhere within a `minimum` & `maximum`. We don't know the exact n, though.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    N (In N3 (N5Plus a_))

-}
type alias In minimum maximum possibleRepresentationAsDifferences =
    RecordWithoutConstructorFunction
        { min : minimum
        , max : maximum
        , diff : possibleRepresentationAsDifferences
        }


{-| Only **n / return types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> N (In N0 ??)

This is where to use `Min`.

    abs : Int -> N (Min N0)

A number >= 5 for example:

    N (Min N5)

Every `Min min` is of type `In min`.

TODO: remove in favor of `In minimum NoMax {}`?

-}
type alias Min lowestPossibleValue =
    In lowestPossibleValue NoMax {}


{-| Allow only a specific number.

Useful as an **argument & storage** type in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with `N`s.

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
        (N5Plus a_)
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


{-| Don't check if this number is below a maximum.

    type alias Min min =
        In minimum NoMaximum {}

is the definition of [`Min`](#Min).

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree maximumChildCount a
        = Tree
            a
            (Arr
                (In N0 maximumChildCount)
                (Maybe (Tree maximumChildCount a))
            )

    type alias RoseTree a =
        Tree a NoMaximum

    type alias BinaryTree a =
        Tree N2 a

(btw, feel free to create a package with this type ^^)

-}
type NoMax
    = MaximumUnknown


{-| Just a word in the type [`Limit`](#Limit):

    type alias Add1 n =
        Limit n Zero Never

-}
type Zero
    = ZeroTag Never



--


n0Difference : Diff n To n
n0Difference =
    Difference
        { add = identity
        , sub = identity
        }


n1Difference : Diff n To (Add1 n)
n1Difference =
    Difference
        { add = S
        , sub =
            \zeroableNever ->
                case zeroableNever of
                    S lower ->
                        lower

                    Z possible ->
                        possible |> never
        }


n0 : N (In N0 (N0able add1Max_ Possibly) (Is (Diff n0 To n0) (Diff n1 To n1)))
n0 =
    0
        |> NLimitedTo
            { min = Z Possible
            , max = Z Possible
            , diff = { diff0 = n0Difference, diff1 = n0Difference }
            }


n1 : N (In N1 (Add1 (N0able add2Max_ Possibly)) (Is (Diff n0 To (Add1 n0)) (Diff n1 To (Add1 n1))))
n1 =
    0
        |> NLimitedTo
            { min = S (Z Possible)
            , max = S (Z Possible)
            , diff = { diff0 = n1Difference, diff1 = n1Difference }
            }


n2 : N (In N2 (Add2 (N0able add2Max_ Possibly)) (Is (Diff n0 To (Add2 n0)) (Diff n2 To (Add2 n2))))
n2 =
    n1 |> diffAdd ( n1, n1 )



--


add :
    N
        (In
            addedMin_
            addedMax_
            (Is (Diff min To sumMin) (Diff max To sumMax))
        )
    -> N (In min max diff_)
    -> N (In sumMin sumMax {})
add added =
    \n ->
        NLimitedTo
            { min = (n |> minimum) |> addDifference (added |> difference0)
            , max = (n |> maximum) |> addDifference (added |> difference1)
            , diff = {}
            }
            ((n |> toInt) + (added |> toInt))


sub :
    N
        (In
            subtractedMin_
            subtractedMax_
            (Is (Diff differenceMin To min) (Diff differenceMax To max))
        )
    -> N (In min max diff_)
    -> N (In differenceMin differenceMax {})
sub subtracted =
    \n ->
        ((n |> toInt) - (subtracted |> toInt))
            |> NLimitedTo
                { min = (n |> minimum) |> subDifference (subtracted |> difference0)
                , max = (n |> maximum) |> subDifference (subtracted |> difference1)
                , diff = {}
                }



-- # create


{-| The absolute n of an `Int`, which is `>= 0`.

    N.abs 16 --> N 16

    N.abs -4 --> N 4

Really only use this if you want the absolute n.

    badLength list =
        List.length >> N.abs

    goodLength =
        List.foldl
            (\_ ->
                MinIn.add n1
                    >> N.lowerMin n0
            )
            (n0 |> N.toMin)

If something like this isn't possible, [`MinIn.intAtLeast`](N#intAtLeast) is the best way!

-}
abs : Int -> N (Min N0)
abs int =
    int
        |> Basics.abs
        |> NLimitedTo
            { min = n0 |> minimum
            , max = MaximumUnknown
            , diff = {}
            }


{-| `N`s from a first to last n.

    N.range n3 n10
    --> : List (N (In N3 (N10Plus a_)))

    N.range n3 atLeast10
    --> : List (N (Min N3))

The resulting `List` always has >= 1 element.

Using a [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/Arr#ns) the type even knows the length! Try it.

-}
range :
    N (In firstMin lastMin firstDifference_)
    -> N (In lastMin lastMax lastDifference_)
    -> List (N (In firstMin lastMax {}))
range first last =
    List.range (first |> toInt) (last |> toInt)
        |> List.map
            (NLimitedTo
                { min = first |> minimum
                , max = last |> maximum
                , diff = {}
                }
            )


{-| Generate a random `N` in a range.

    N.random n1 n10
    --> Random.Generator (N (In N1 (N10Plus a_)))

-}
random :
    N (In lowerLimitMin upperLimitMin lowerLimitDifference_)
    -> N (In upperLimitMin upperLimitMax upperLimitDifference_)
    ->
        Random.Generator
            (N (In lowerLimitMin upperLimitMax {}))
random lowest highest =
    Random.int (lowest |> toInt) (highest |> toInt)
        |> Random.map
            (NLimitedTo
                { min = lowest |> minimum
                , max = highest |> maximum
                , diff = {}
                }
            )


{-| Compared to a range from a lower to an upper bound, is the `Int` [`BelowOrInOrAboveRange`](N#BelowOrInOrAboveRange)?

    rejectOrAcceptUserInt :
        Int
        -> Result String (N (In N1 (N100Plus a_)))
    rejectOrAcceptUserInt int =
        case int |> N.isIntInRange n1 n100 of
            InRange inRange ->
                Ok inRange

            BelowRange _ ->
                Err "must be >= 1"

            AboveRange _ ->
                Err "must be <= 100"


    rejectOrAcceptUserInt 0
    --> Err "must be >= 1"

-}
isIntInRange :
    ( N (In minLowerLimit minUpperLimit lowerLimitDifference_)
    , N (In minUpperLimit maxUpperLimit upperLimitDifference_)
    )
    -> Int
    ->
        BelowOrInOrAboveRange
            Int
            (N (In minLowerLimit maxUpperLimit {}))
            (N (Min (Add1 maxUpperLimit)))
isIntInRange ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> BelowRange

        else if int > (upperLimit |> toInt) then
            int
                |> NLimitedTo
                    { min =
                        (upperLimit |> maximum)
                            |> addDifference (n1 |> difference0)
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> AboveRange

        else
            int
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> InRange


{-| Create a `N (In ...)` by **clamping** an `Int` between a minimum & maximum.

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

```
9 |> N.intInRange n3 n12
--> N 9 : N (In N3 (N12Plus a_))

0 |> N.intInRange n3 n12
--> N 3 : N (In N3 (N12Plus a_))

99 |> N.intInRange n3 n12
--> N 12 : N (In N3 (N12Plus a_))

toDigit : Char -> Maybe (N (In N0 (N9Plus a_)))
toDigit char =
    case
        (Char.toCode char - Char.toCode '0')
            |> N.isIntInRange n0 n9
    of
        N.InRange digit ->
            Just digit

        N.BelowRange _ ->
            Nothing

        N.AboveRange _ ->
            Nothing
```

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`isIntInRange`](N#isIntInRange).

-}
intInRange :
    ( N (In minLowerLimit minUpperLimit lowerLimitDifference_)
    , N (In minUpperLimit maxUpperLimit upperLimitDifference_)
    )
    ->
        (Int
         -> N (In minLowerLimit maxUpperLimit {})
        )
intInRange ( lowerLimit, upperLimit ) =
    \int ->
        case isIntInRange ( lowerLimit, upperLimit ) int of
            InRange inRange ->
                inRange

            BelowRange _ ->
                (lowerLimit |> toInt)
                    |> NLimitedTo
                        { min = lowerLimit |> minimum
                        , max = upperLimit |> maximum
                        , diff = {}
                        }

            AboveRange _ ->
                upperLimit |> minLower lowerLimit


{-| If the `Int >= a minimum`, return `Just` the `N (Min minimum)`, else `Nothing`.

    4 |> N.isIntAtLeast n5
    --> Nothing : Maybe (N (Min N5))

    1234 |> N.isIntAtLeast n5
    --> Just (N 1234) : Maybe (N (Min N5))

-}
isIntAtLeast :
    N (In min max_ minimumLimitDifference_)
    -> Int
    -> Maybe (N (Min min))
isIntAtLeast minimumLimit =
    \int ->
        if int >= (minimumLimit |> toInt) then
            int
                |> NLimitedTo
                    { min = minimumLimit |> minimum
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> Just

        else
            Nothing


{-| A `N (Min ...)` from an `Int`; if the `Int < minimum`, `minimum` is returned.

    9 |> N.intAtLeast n3
    --> N 9 : N (Min N3)

    0 |> N.intAtLeast n3
    --> N 3 : N (Min N3)

You can also use this if you know an `Int` must be at least `minimum`.

But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ ->
                MinIn.add n1
                    >> N.lowerMin n0
            )
            (N.toMin n0)

If you want to handle the case `< minimum` yourself, use [`N.isIntAtLeast`](N#isIntAtLeast).

-}
intAtLeast :
    N (In min max_ lowerDifference_)
    -> Int
    -> N (Min min)
intAtLeast minimumLimit =
    isIntAtLeast minimumLimit
        >> Maybe.withDefault (minimumLimit |> noMax)


{-| **Cap** the `N` to at most a number.

    between5And15
        |> N.atMost n10 { lowest = n5 }
    --> : N (In N5 (N10Plus a_))

    atLeast5 |> N.atMost n10 { lowest = n5 }
    --> : N (In N5 (N10Plus a_))

`lowest` can be a number <= the minimum.

-}
atMost :
    N (In minNewMax maxNewMax newMaxDifference_)
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff lowestToMinNewMax_ To minNewMax)
                    )
                )
        }
    -> N (In min max_ difference_)
    -> N (In lowest maxNewMax {})
atMost higherUpperLimit { lowest } =
    \n ->
        Basics.min (n |> toInt) (higherUpperLimit |> toInt)
            |> NLimitedTo
                { min = lowest |> minimum
                , max = higherUpperLimit |> maximum
                , diff = {}
                }



-- # modify


{-| Multiply by a `N` >= 1.
we know that if `a >= 1`, `x * a >= x`.

    atLeast5  |> N.mul n2
    --> N 10 : N (Min N5)

    atLeast2 |> N.mul n5
    --> N 10 : N (Min N2)

-}
mul :
    N (In (Add1 mulMinMinus1_) mulMax_ mulDifference_)
    -> N (In min max_ difference_)
    -> N (Min min)
mul factorToMultiplyBy =
    \n ->
        (n |> toInt)
            * (factorToMultiplyBy |> toInt)
            |> NLimitedTo
                { min = n |> minimum
                , max = MaximumUnknown
                , diff = {}
                }


{-| Divide (`//`) by a `N` >= 1.

  - `/ 0` is impossible
  - `x / d` is at most x

```
atMost7 |> N.div n3
--> N 2 : N (In N0 (N7Plus a_))
```

-}
div :
    N (In (Add1 divMinMinus1_) divMax_ divDifference_)
    -> N (In min_ max difference_)
    -> N (In N0 max {})
div toDivideBy =
    \n ->
        (n |> toInt)
            // (toDivideBy |> toInt)
            |> NLimitedTo
                { min = n0 |> minimum
                , max = n |> maximum
                , diff = {}
                }


{-| The remainder after dividing by a `N` >= 1. `x |> remainderBy d` is at most `d`

    atMost7 |> N.remainderBy n3
    --> N 1 : N (In N0 (N3Plus a_))

In theory, `x % d` should be at most `d - 1`, but this can't be expressed well by the type.

-}
remainderBy :
    N (In (Add1 divMinMinus1_) divMax divDifference_)
    -> N (In min_ max_ difference_)
    -> N (In N0 divMax {})
remainderBy divN =
    \n ->
        (n |> toInt)
            |> Basics.remainderBy (divN |> toInt)
            |> NLimitedTo
                { min = n0 |> minimum
                , max = divN |> maximum
                , diff = {}
                }


{-| The `N ^ a N >= 1`.
We know that if `a >= 1  →  x ^ a >= x`

    atLeast5 |> N.toPower n2
    --> N 25 : N (Min N5)

    atLeast2 |> N.toPower n5
    --> N 25 : N (Min N2)

-}
toPower :
    N (In (Add1 powMinMinus1_) powMax_ powDifference_)
    -> N (In min max_ difference_)
    -> N (Min min)
toPower power =
    \n ->
        (n |> toInt)
            ^ (power |> toInt)
            |> NLimitedTo
                { min = n |> minimum
                , max = MaximumUnknown
                , diff = {}
                }



-- # drop information


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N3)`

    [ atLeast3
    , atLeast4 |> N.lowerMin n3
    ]

-}
minLower :
    N (In newMin min lowerDifference_)
    -> N (In min max difference_)
    -> N (In newMin max {})
minLower newMinimum =
    \n ->
        (n |> toInt)
            |> NLimitedTo
                { min = newMinimum |> minimum
                , max = n |> maximum
                , diff = {}
                }


{-| Convert it to a `N (In min max)`.

    N.noDiff n4
    --> : N (In N4 (N4Plus a_))

Example

    [ in3To10, n3 ]

Elm complains:

> But all the previous elements in the list are: `N (In N3 N10)`

    [ in3To10
    , n3 |> N.noDiff
    ]

-}
noDiff : N (In min max difference_) -> N (In min max {})
noDiff =
    \n ->
        (n |> toInt)
            |> NLimitedTo
                { min = n |> minimum
                , max = n |> maximum
                , diff = {}
                }


{-| Convert a `N (In min ...)` to a `N (Min min)`.

    between3And10 |> N.toMin
    --> : N (Min N4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N1)`

    [ atLeast1
    , between1And10 |> N.toMin
    ]

-}
noMax : N (In min max_ difference_) -> N (Min min)
noMax =
    \n ->
        (n |> toInt)
            |> NLimitedTo
                { min = n |> minimum
                , max = MaximumUnknown
                , diff = {}
                }



-- # restore information


{-| Make it fit into functions with require a higher maximum.

You should design type annotations as general as possible.

    onlyAtMost18 : N (In min_ N18 difference_) -> Fine

    onlyAtMost18 between3And8 --> Fine

But once you implement `onlyAtMost18`, you might use the n in `onlyAtMost19`.

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.restoreMax n18)

-}
restoreMax :
    N (In max newMax newMaxDifference_)
    -> N (In min max difference)
    -> N (In min newMax difference)
restoreMax newMaximum =
    \n ->
        (n |> toInt)
            |> NLimitedTo
                { min = n |> minimum
                , max = newMaximum |> maximum
                , diff = n |> differences
                }



-- # compare


{-| The result of comparing a `N` to another `N`.

  - `EqualOrGreater`: >= that `N`

  - `Below`: < that `N`

Values exist for each condition.

-}
type BelowOrAtLeast below equalOrGreater
    = Below below
    | EqualOrGreater equalOrGreater


{-| The result of comparing a `N` to another `N`.

  - `EqualOrLess`: <= that `N`

  - `Above`: > that `N`

Values exist for each condition.

-}
type AtMostOrAbove equalOrLess above
    = EqualOrLess equalOrLess
    | Above above


{-| The result of comparing a `N` to another `N`.

  - `Equal` to that `N`

  - `Less` than that `N`

  - `Greater` than that `N`

Values exist for each condition.

-}
type LessOrEqualOrGreater less equal greater
    = Less less
    | Equal equal
    | Greater greater


{-| The result of comparing a `N` to a range from a lower to an upper bound.

  - `InRange`
  - `AboveRange`: greater than the upper bound
  - `BelowRange`: less than the lower bound?

Values exist for each condition.

-}
type BelowOrInOrAboveRange below inRange above
    = BelowRange below
    | InRange inRange
    | AboveRange above



-- transform


{-| Drop the range constraints
to supply another library with its `Int` representation.
-}
toInt : N range_ -> Int
toInt =
    \(NLimitedTo _ int) -> int


{-| Drop the range constraints
to supply another library with its `Float` representation.
-}
toFloat : N range_ -> Float
toFloat =
    toInt >> Basics.toFloat



-- `In` with maximum


{-| Is the `N` [`BelowOrAtLeast`](N#BelowOrAtLeast) as big as a given number?

`lowest` can be a number <= the minimum.

    vote :
        { age : N (In (N18Plus minMinus18_) max_ difference_) }
        -> Vote

    tryToVote { age } =
        case age |> InDiff.isAtLeast n18 { lowest = n0 } of
            N.Below _ ->
                --😓
                Nothing

            N.EqualOrGreater oldEnough ->
                Just (vote { age = oldEnough })

-}
isAtLeast :
    N
        (In
            lowerLimit
            (Add1 atLeastLowerLimitMinus1)
            (Is
                (Diff atLeastRange_ To max)
                is_
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff (Add1 lowestToLowerLimit_) To lowerLimit)
                    )
                )
        }
    -> N (In min max difference_)
    ->
        BelowOrAtLeast
            (N (In lowest atLeastLowerLimitMinus1 {}))
            (N (In lowerLimit max {}))
isAtLeast lowerLimit { lowest } =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            lowerLimit
                |> toInt
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max =
                        (lowerLimit |> maximum)
                            |> subDifference (n1 |> difference0)
                    , diff = {}
                    }
                |> Below

        else
            (n |> toInt)
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = n |> maximum
                    , diff = {}
                    }
                |> EqualOrGreater


{-| Is the `N` [`AtMostOrAbove`](N#AtMostOrAbove) a given number?

`lowest` can be a number <= the minimum.

    goToU18Party : { age : N (In min_ N17 difference_) } -> Snack

    tryToGoToU18Party { age } =
        case age |> InDiff.isAtMost n17 { lowest = n0 } of
            N.EqualOrLess u18 ->
                Just (goToU18Party { age = u18 })

            N.Above _ ->
                Nothing

-}
isAtMost :
    N
        (In
            upperLimit
            atLeastUpperLimit
            (Is
                (Diff (Add1 greaterRange_) To max)
                is_
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToUpperLimit_ To upperLimit)
                    )
                )
        }
    -> N (In min max difference_)
    ->
        AtMostOrAbove
            (N (In lowest atLeastUpperLimit {}))
            (N (In (Add1 upperLimit) max {}))
isAtMost upperLimit { lowest } =
    \n ->
        if (n |> toInt) > (upperLimit |> toInt) then
            upperLimit
                |> toInt
                |> NLimitedTo
                    { min =
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    , max = n |> maximum
                    , diff = {}
                    }
                |> Above

        else
            (n |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> EqualOrLess


{-| Is the `N` [`LessOrEqualOrGreater`](N#LessOrEqualOrGreater) than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> InDiff.is n18 { lowest = n0 } of
            N.Less younger ->
                toy { age = younger }

            N.Greater older ->
                book { age = older }

            N.Equal _ ->
                bigPresent

    toy : { age : N (In min_ N17 difference_) } -> Toy

    book :
        { age : N (In (N19Plus minMinus19_) max_ difference_) }
        -> Book

-}
inIs :
    N
        (In
            (Add1 comparedAgainstMinus1)
            comparedAgainstAtLeast
            (Is
                (Diff (Add1 comparedAgainstMinus1) To (Add1 comparedAgainstMinus1AtLeast))
                (Diff comparedAgainstToMax_ To max)
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToValue_ To (Add1 comparedAgainstMinus1))
                    )
                )
        }
    ->
        (N (In min max difference_)
         ->
            LessOrEqualOrGreater
                (N (In lowest comparedAgainstMinus1AtLeast {}))
                (N (In (Add1 comparedAgainstMinus1) comparedAgainstAtLeast {}))
                (N (In (Add2 comparedAgainstMinus1) max {}))
        )
inIs comparedAgainst { lowest } =
    \n ->
        case compare (n |> toInt) (comparedAgainst |> toInt) of
            EQ ->
                comparedAgainst
                    |> noDiff
                    |> Equal

            GT ->
                (n |> toInt)
                    |> NLimitedTo
                        { min =
                            (comparedAgainst |> minimum)
                                |> addDifference (n1 |> difference0)
                        , max = n |> maximum
                        , diff = {}
                        }
                    |> Greater

            LT ->
                (n |> toInt)
                    |> NLimitedTo
                        { min = lowest |> minimum
                        , max =
                            (comparedAgainst |> minimum)
                                |> addDifference (comparedAgainst |> difference0)
                                |> subDifference (n1 |> difference0)
                        , diff = {}
                        }
                    |> Less


{-| Compared to a range from a lower to an upper bound, is the `N` [`BelowOrInOrAboveRange`](N#BelowOrInOrAboveRange)?

`lowest` can be a number <= the minimum.

    ifBetween3And10 n =
        case n |> InDiff.isInRange n3 n10 { lowest = n0 } of
            N.InRange inRange ->
                Just inRange

            _ ->
                Nothing

    ifBetween3And10 n9
    --> Just (N 9)

    ifBetween3And10 n123
    --> Nothing

-}
isInRange :
    ( N
        (In
            lowerLimit
            (Add1 atLeastLowerLimitMinus1)
            (Is
                (Diff lowerLimitToUpperLimit_ To upperLimit)
                lowerLimitIs_
            )
        )
    , N
        (In
            upperLimit
            atLeastUpperLimit
            (Is
                (Diff upperLimitToMax_ To max)
                upperLimitIs_
            )
        )
    )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToLowerLimit_ To lowerLimit)
                    )
                )
        }
    -> N (In min max difference_)
    ->
        BelowOrInOrAboveRange
            (N (In lowest atLeastLowerLimitMinus1 {}))
            (N (In lowerLimit atLeastUpperLimit {}))
            (N (In (Add1 upperLimit) max {}))
isInRange ( lowerLimit, upperLimit ) { lowest } =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            (n |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max =
                        (lowerLimit |> maximum)
                            |> subDifference (n1 |> difference0)
                    , diff = {}
                    }
                |> BelowRange

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> NLimitedTo
                    { min =
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    , max = n |> maximum
                    , diff = {}
                    }
                |> AboveRange

        else
            (n |> toInt)
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> InRange



-- ## clamp


{-| Return the given number if the `N` is less.

    between5And9 |> InDiff.atLeast n10
    --> N 10 : N (In N10 (N10Plus a_))

    n15 |> InDiff.atLeast n10
    --> N 15

-}
atLeast :
    N (In minNewMin max lowerDifference_)
    -> N (In min_ max difference_)
    -> N (In minNewMin max {})
atLeast lowerLimit =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            lowerLimit |> noDiff

        else
            n
                |> toInt
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = n |> maximum
                    , diff = {}
                    }



-- ## compare


inIsIntInRange :
    ( N (In minLowerLimit minUpperLimit lowerLimitDifference_)
    , N (In minUpperLimit maxUpperLimit upperLimitDifference_)
    )
    -> Int
    ->
        BelowOrInOrAboveRange
            Int
            (N (In minLowerLimit maxUpperLimit {}))
            (N (Min (Add1 maxUpperLimit)))
inIsIntInRange ( lowerLimit, upperLimit ) =
    \int ->
        if int < toInt lowerLimit then
            int |> BelowRange

        else if int > toInt upperLimit then
            int
                |> NLimitedTo
                    { min =
                        (upperLimit |> maximum)
                            |> addDifference (n1 |> difference0)
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> AboveRange

        else
            int
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> InRange


inIsIntAtLeast :
    N (In min max_ difference_)
    -> (Int -> Maybe (N (Min min)))
inIsIntAtLeast minimumLimit =
    \int ->
        if int >= toInt minimumLimit then
            int
                |> NLimitedTo
                    { min = minimumLimit |> minimum
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> Just

        else
            Nothing


{-| Is the `N` [`LessOrEqualOrGreater`](N#LessOrEqualOrGreater) than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> MinDiff.is n18 { lowest = n0 } of
            N.Less younger ->
                toy { age = younger }

            N.Greater older ->
                book { age = older }

            N.Equal _ ->
                bigPresent

    toy : { age : N (In min_ N17 difference_) } -> Toy

    book :
        { age : N (In (N19 minMinus19_) max_ difference_) }
        -> Book

-}
minIs :
    N
        (In
            (Add1 nMinus1)
            nAtLeast
            (Is
                (Diff nMinus1 To nMinus1AtLeast)
                nDiff1_
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToValueMinus1_ To nMinus1)
                    )
                )
        }
    -> N (In min max_ difference_)
    ->
        LessOrEqualOrGreater
            (N (In lowest nMinus1AtLeast {}))
            (N (In (Add1 nMinus1) nAtLeast {}))
            (N (Min (Add2 nMinus1)))
minIs comparedAgainst { lowest } =
    \minN ->
        case compare (minN |> toInt) (comparedAgainst |> toInt) of
            LT ->
                (minN |> toInt)
                    |> NLimitedTo
                        { min = lowest |> minimum
                        , max =
                            (comparedAgainst |> minimum)
                                |> subDifference (n1 |> difference0)
                                |> addDifference (comparedAgainst |> difference0)
                        , diff = {}
                        }
                    |> Less

            EQ ->
                comparedAgainst
                    |> noDiff
                    |> Equal

            GT ->
                (minN |> toInt)
                    |> NLimitedTo
                        { min =
                            (comparedAgainst |> minimum)
                                |> addDifference (n1 |> difference0)
                        , max = MaximumUnknown
                        , diff = {}
                        }
                    |> Greater


{-| Is the `N` [`BelowOrAtLeast`](N#BelowOrAtLeast) a given number?

    factorial : N (In min_ max_ difference_) -> N (Min N1)
    factorial =
        factorialBody

    factorialBody : N (In min_ max_ difference_) -> N (Min N1)
    factorialBody =
        case x |> MinDiff.isAtLeast n1 { lowest = n0 } of
            N.Below _ ->
                N.toMin n1

            N.EqualOrGreater atLeast1 ->
                N.mul atLeast1
                    (factorial
                        (atLeast1 |> MinDiff.sub n1)
                    )

-}
minIsAtLeast :
    N
        (In
            minLowerLimit
            (Add1 maxLowerLimitMinus1)
            lowerLimitDifference_
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff lowestToMinLowerLimit_ To minLowerLimit)
                    )
                )
        }
    -> N (In min max_ difference_)
    ->
        BelowOrAtLeast
            (N (In lowest maxLowerLimitMinus1 {}))
            (N (Min minLowerLimit))
minIsAtLeast lowerLimit { lowest } =
    \minIn ->
        if (minIn |> toInt) >= (lowerLimit |> toInt) then
            (minIn |> toInt)
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> EqualOrGreater

        else
            (minIn |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max =
                        (lowerLimit |> maximum)
                            |> subDifference (n1 |> difference0)
                    , diff = {}
                    }
                |> Below


{-| Is the `N` [`AtMostOrAbove`](N#AtMostOrAbove) a given number?

    goToBelow18Party : { age : N (In min_ N17 difference_) } -> Snack

    tryToGoToBelow18Party { age } =
        case age |> MinDiff.isAtMost n17 { lowest = n0 } of
            EqualOrLess u18 ->
                Just (goToBelow18Party { age = u18 })

            Greater _ ->
                Nothing

-}
minIsAtMost :
    N (In minUpperLimit maxUpperLimit upperLimitDifference_)
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToAtMostMin_ To minUpperLimit)
                    )
                )
        }
    -> N (In min max_ difference_)
    ->
        AtMostOrAbove
            (N (In lowest maxUpperLimit {}))
            (N (Min (Add1 minUpperLimit)))
minIsAtMost upperLimit { lowest } =
    \minIn ->
        if (minIn |> toInt) <= (upperLimit |> toInt) then
            minIn
                |> toInt
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> EqualOrLess

        else
            minIn
                |> toInt
                |> NLimitedTo
                    { min =
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    , max = MaximumUnknown
                    , diff = {}
                    }
                |> Above


inIsAtLeast :
    N
        (In
            lowerLimit
            (Add1 atLeastLowerLimitMinus1)
            (Is
                (Diff atLeastRange_ To max)
                is_
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff (Add1 lowestToLowerLimit_) To lowerLimit)
                    )
                )
        }
    -> N (In min max difference_)
    ->
        BelowOrAtLeast
            (N (In lowest atLeastLowerLimitMinus1 {}))
            (N (In lowerLimit max {}))
inIsAtLeast lowerLimit { lowest } =
    \nIn ->
        if (nIn |> toInt) >= (lowerLimit |> toInt) then
            (nIn |> toInt)
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = nIn |> maximum
                    , diff = {}
                    }
                |> EqualOrGreater

        else
            (nIn |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max =
                        (lowerLimit |> maximum)
                            |> subDifference (n1 |> difference1)
                    , diff = {}
                    }
                |> Below


inIsAtMost :
    N
        (In
            upperLimit
            atLeastUpperLimit
            (Is
                (Diff (Add1 greaterRange_) To max)
                upperLimitDiff1_
            )
        )
    ->
        { lowest :
            N
                (In
                    lowest
                    atLeastLowest_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToUpperLimit_ To upperLimit)
                    )
                )
        }
    -> N (In min max difference_)
    ->
        AtMostOrAbove
            (N (In lowest atLeastUpperLimit {}))
            (N (In (Add1 upperLimit) max {}))
inIsAtMost upperLimit { lowest } =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            (n |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> EqualOrLess

        else
            (n |> toInt)
                |> NLimitedTo
                    { min =
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    , max = n |> maximum
                    , diff = {}
                    }
                |> Above


inIsInRange :
    ( N
        (In
            lowerLimit
            (Add1 atLeastLowerLimitMinus1)
            (Is
                (Diff lowerLimitToUpperLimit_ To upperLimit)
                lowerLimitIs_
            )
        )
    , N
        (In
            upperLimit
            upperLimitAtLeast
            (Is
                (Diff upperLimitToMax_ To max)
                upperLimitIs_
            )
        )
    )
    ->
        { lowest :
            N
                (In
                    lowest
                    lowestAtLeast_
                    (Is
                        (Diff lowestToMin_ To min)
                        (Diff minToLowerLimit_ To lowerLimit)
                    )
                )
        }
    ->
        (N (In min max difference_)
         ->
            BelowOrInOrAboveRange
                (N (In lowest atLeastLowerLimitMinus1 {}))
                (N (In lowerLimit upperLimitAtLeast {}))
                (N (In (Add1 upperLimit) max {}))
        )
inIsInRange ( lowerLimit, upperLimit ) { lowest } =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            (n |> toInt)
                |> NLimitedTo
                    { min = lowest |> minimum
                    , max =
                        (lowerLimit |> maximum)
                            |> subDifference (n1 |> difference0)
                    , diff = {}
                    }
                |> BelowRange

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> NLimitedTo
                    { min =
                        (upperLimit |> minimum)
                            |> addDifference (n1 |> difference0)
                    , max = n |> maximum
                    , diff = {}
                    }
                |> AboveRange

        else
            (n |> toInt)
                |> NLimitedTo
                    { min = lowerLimit |> minimum
                    , max = upperLimit |> maximum
                    , diff = {}
                    }
                |> InRange


{-| Return the given number if the `N` is less.

    n5 |> MinDiff.atLeast n10
    --> N 10 : N (Min N10)

    atLeast5 |> MinDiff.atLeast n10
    --> : N (Min N10)

-}
minAtLeast :
    N (In minNewMin newMin_ lowerDifference_)
    -> N (In min_ max_ difference_)
    -> N (Min minNewMin)
minAtLeast lowerLimit =
    noMax
        >> atLeast (lowerLimit |> noMax)



-- ## alter


{-| The `N (N ...)` plus another `N (N ...)`. Give the added value twice as a tuple.

    n6 |> N.diffAdd ( n5, n5 )
    --> n11
    -->     : N
    -->        (N N11
    -->            (N11Plus a_)
    -->            (Is a To N11Plus a)
    -->            (Is b To N11Plus b)
    -->        )

This is only rarely useful, as you shouldn't

    inRangeXAndXPlus10 x =
        -- won't work
        isInRange x (x |> N.diffAdd ( n10, n10 ))

Only use it when the `N (N ...)` is used once.

    isAtLeast10GreaterThan x =
        isAtLeast (x |> N.diffAdd ( n10, n10 ))

(examples don't compile)

-}
diffAdd :
    ( N
        (In
            added
            added0AtLeast_
            (Is (Diff n To sum) (Diff atLeastN To atLeastSum))
        )
    , N
        (In
            added
            added1AtLeast_
            (Is
                (Diff aPlusN To aPlusSum)
                (Diff bPlusN To bPlusSum)
            )
        )
    )
    -> N (In n atLeastN (Is (Diff a To aPlusN) (Diff b To bPlusN)))
    -> N (In sum atLeastSum (Is (Diff a To aPlusSum) (Diff b To bPlusSum)))
diffAdd ( toAdd, toAddWithAdditionalInformation ) =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> addDifference (toAdd |> difference0)
                , max =
                    (n |> maximum)
                        |> addDifference (toAdd |> difference1)
                , diff =
                    { diff0 =
                        (n |> difference0)
                            |> differenceThenAdd (toAddWithAdditionalInformation |> difference0)
                    , diff1 =
                        (n |> difference1)
                            |> differenceThenAdd (toAddWithAdditionalInformation |> difference1)
                    }
                }


{-| Add a `N`. The second argument is the minimum added value. Use [`add`](MinDiff#add) to add exact numbers.

    atLeast5 |> MinDiff.addMin n2 atLeast2
    --> : N (Min N7)

-}
minAddMin :
    N (In minAdded atLeastMinAdded_ (Is (Diff min To sumMin) is_))
    -> N (In minAdded maxAdded_ addedDifference_)
    -> N (In min max_ difference_)
    -> N (Min sumMin)
minAddMin minAdded toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> addDifference (minAdded |> difference0)
                , max = MaximumUnknown
                , diff = {}
                }


{-| Add an exact `N (N ...)` value.

    atLeast70 |> InDiff.add n7
    --> : N (Min N77)

Use [addMin](MinDiff#addMin) if you want to add a `N` that isn't a `N (N ...)`.

-}
minAdd :
    N (In added_ atLeastAdded_ (Is (Diff min To sumMin) is_))
    -> N (In min max_ difference_)
    -> N (Min sumMin)
minAdd toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> addDifference (toAdd |> difference0)
                , max = MaximumUnknown
                , diff = {}
                }


{-| Add a `N` that isn't a `N (N ...)`.

The first 2 arguments are

  - the minimum added value

  - the maximum added value

```
between3And10
    |> InDiff.addIn n1 n12 between1And12
--> : N (In N4 (N22Plus a_))
```

-}
inAddIn :
    N (In minAdded atLeastMinAdded_ (Is (Diff min To sumMin) minAddedIs_))
    -> N (In maxAdded atLeastMaxAdded_ (Is (Diff max To sumMax) maxAddedIs_))
    -> N (In minAdded maxAdded addedDifference_)
    -> N (In min max difference_)
    -> N (In sumMin sumMax {})
inAddIn minAdded maxAdded toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> addDifference (minAdded |> difference0)
                , max =
                    (n |> maximum)
                        |> addDifference (maxAdded |> difference0)
                , diff = {}
                }


{-| Add a `N (In ...)`.

    between70And100
        |> InDiff.add n7
    --> : N (In N77 (N107Plus a_))

Use [`inAddIn`](#inAddIn) if you want to add a `N` that isn't a `N (N ...)`.

-}
inAdd :
    N
        (In
            added_
            atLeastAdded_
            (Is
                (Diff min To sumMin)
                (Diff max To sumMax)
            )
        )
    -> N (In min max difference_)
    -> N (In sumMin sumMax {})
inAdd toAdd =
    \n ->
        (n |> toInt)
            + (toAdd |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> addDifference (toAdd |> difference0)
                , max =
                    (n |> maximum)
                        |> addDifference (toAdd |> difference1)
                , diff = {}
                }


{-| The `N (N ...)` minus another `N (N ...)`. Give the subtracted value twice as a tuple.

    n6 |> N.diffSub ( n5, n5 )
    --> n1 :
    -->     N
    -->         (N
    -->             N1
    -->             (Add1 a_)
    -->             (Is
    -->                 (Diff a To (Add1 a))
    -->                 (Diff b To (Add1 b))
    -->             )
    -->         )

This is only rarely useful, as you shouldn't

    inRangeXMinus10ToX x =
        -- won't work
        isInRange (x |> N.diffSub ( n10, n10 )) x

Only use it when the `N (N ...)` is used once.

    isAtLeast10LessThan x =
        isAtLeast (x |> N.diffSub ( n10, n10 ))

(examples don't compile)

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
                (Diff aPlusDifference To aPlusN)
                (Diff bPlusDifference To bPlusN)
            )
        )
    )
    ->
        (N (In n nAtLeast (Is (Diff a To aPlusN) (Diff b To bPlusN)))
         ->
            N
                (In
                    difference
                    differenceAtLeast
                    (Is
                        (Diff a To aPlusDifference)
                        (Diff b To bPlusDifference)
                    )
                )
        )
diffSub ( toSubtract, toSubtractWithAdditionalInformation ) =
    \n ->
        let
            differenceDifference :
                Is
                    (Diff a To aPlusDifference)
                    (Diff b To bPlusDifference)
            differenceDifference =
                { diff0 =
                    (n |> difference0)
                        |> differenceThenSub (toSubtractWithAdditionalInformation |> difference0)
                , diff1 =
                    (n |> difference1)
                        |> differenceThenSub (toSubtractWithAdditionalInformation |> difference1)
                }

            differenceMin : difference
            differenceMin =
                (n |> minimum)
                    |> subDifference (toSubtract |> difference0)

            differenceMax : differenceAtLeast
            differenceMax =
                (n |> maximum)
                    |> subDifference (toSubtract |> difference1)
        in
        (n |> toInt)
            - (toSubtract |> toInt)
            |> NLimitedTo
                { min = differenceMin
                , max = differenceMax
                , diff = differenceDifference
                }


{-| Subtract a `N` that isn't a `N (N ...)`.

The first 2 arguments are

  - the minimum subtracted value

  - the maximum subtracted value

```
between6And12
    |> InDiff.subIn n1 n5 between1And5
--> : N (In N1 (N5Plus a_))
```

-}
inSubIn :
    N
        (In
            minSubtracted
            atLeastMinSubtracted_
            (Is
                (Diff differenceMax To max)
                minSubtractedDiff1_
            )
        )
    ->
        N
            (In
                maxSubtracted
                atLeastMaxSubtracted_
                (Is
                    (Diff differenceMin To min)
                    maxSubtractedDiff1_
                )
            )
    -> N (In minSubtracted maxSubtracted subtractedDifference_)
    -> N (In min max difference_)
    -> N (In differenceMin differenceMax {})
inSubIn minSubtracted maxSubtracted toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> subDifference (maxSubtracted |> difference0)
                , max =
                    (n |> maximum)
                        |> subDifference (minSubtracted |> difference0)
                , diff = {}
                }


{-| Subtract an exact `N (N ...)` value.

    between7And10
        |> InDiff.sub n7
    --> : N (In N0 (N3Plus a_))

Use [subIn](InDiff#subIn) if you want to subtract a `N` that isn't a `N (N ...)`.

-}
inSub :
    N
        (In
            subtracted_
            atLeastSubtracted_
            (Is
                (Diff differenceMin To min)
                (Diff differenceMax To max)
            )
        )
    -> N (In min max difference_)
    -> N (In differenceMin differenceMax {})
inSub toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> subDifference (toSubtract |> difference0)
                , max =
                    (n |> maximum)
                        |> subDifference (toSubtract |> difference1)
                , diff = {}
                }


{-| TODO: readd doc
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
    -> N (In min max difference_)
    -> N (In differenceMin max {})
minSubMax maxSubtracted inDiffToSubtract =
    inSubIn
        n0
        maxSubtracted
        (inDiffToSubtract |> minLower n0)


{-| Subtract an exact `N (N ...)`.

    atLeast7 |> MinDiff.sub n2
    --> : N (Min N5)

Use [subMax](MinDiff#subMax) if you want to subtract a `N` that isn't a `N (N ...)`.

-}
minSub :
    N
        (In
            subtracted_
            atLeastSubtracted_
            (Is (Diff differenceMin To min) subtractedDiff1_)
        )
    -> N (In min max difference_)
    -> N (In differenceMin max {})
minSub toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> NLimitedTo
                { min =
                    (n |> minimum)
                        |> subDifference (toSubtract |> difference0)
                , max = n |> maximum
                , diff = {}
                }



-- # internals


minimum : N (In minimum maximum_ difference_) -> minimum
minimum =
    \(NLimitedTo rangeLimits _) -> rangeLimits.min


maximum : N (In minimum_ maximum difference_) -> maximum
maximum =
    \(NLimitedTo rangeLimits _) -> rangeLimits.max


differences : N (In min_ max_ differences) -> differences
differences =
    \(NLimitedTo rangeLimits _) -> rangeLimits.diff


difference0 : N (In min_ max_ { differences_ | diff0 : difference0 }) -> difference0
difference0 =
    differences >> .diff0


difference1 : N (In min_ max_ { differences_ | diff1 : difference1 }) -> difference1
difference1 =
    differences >> .diff1


addDifference : Diff low To high -> (low -> high)
addDifference =
    \(Difference differenceOperation) -> differenceOperation.add


subDifference : Diff low To high -> (high -> low)
subDifference =
    \(Difference differenceOperation) -> differenceOperation.sub


differenceThenAdd : Diff middle To high -> (Diff low To middle -> Diff low To high)
differenceThenAdd diffMiddleToHigh =
    \diffLowToMiddle ->
        Difference
            { add =
                addDifference diffLowToMiddle
                    >> addDifference diffMiddleToHigh
            , sub =
                subDifference diffMiddleToHigh
                    >> subDifference diffLowToMiddle
            }


differenceThenSub : Diff middle To high -> (Diff low To high -> Diff low To middle)
differenceThenSub diffMiddleToHigh =
    \diffLowToHigh ->
        Difference
            { add =
                addDifference diffLowToHigh
                    >> subDifference diffMiddleToHigh
            , sub =
                addDifference diffMiddleToHigh
                    >> subDifference diffLowToHigh
            }
