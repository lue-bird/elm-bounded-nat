module N exposing
    ( N
    , In, Min
    , Fixed, InFixed, Exactly, Infinity(..)
    , Up, Down, To
    , inRandom, inFuzz, inFuzzUniform
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , Up0, Up1, Up2, Up3, Up4, Up5, Up6, Up7, Up8, Up9, Up10, Up11, Up12, Up13, Up14, Up15, Up16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , intToAbsolute, intModBy, intToAtLeast, intToIn
    , intIsAtLeast, intIsIn
    , isAtLeast, isAtMost
    , BelowOrAbove(..), is, isIn
    , greater, smaller
    , add, addMin
    , subtract, subtractMin
    , toPower, remainderBy, multiplyBy, divideBy
    , toAtLeast, toAtLeastMin, toAtMost, toIn
    , toInt, toFloat, toString
    , FixedValue, InFixedValue, ExactlyValue, MinFixedValue
    , toValue, fromValue
    , minToValue, minFromValue
    , maxToValue, maxFromValue
    , minTo, minSubtract
    , maxTo, maxToInfinity, maxAdd
    , isAtLeast1, min0Adapt
    , range, min, max
    , fixedInfinity, fixedToNumber
    , exactly
    , differenceAdd, differenceSubtract
    , differenceToInt
    , addDifference, subtractDifference
    , N0OrAdd1(..)
    , number0Adapt, fixed0Adapt
    , fixedToValue, fixedFromValue
    , inFixedToValue, inFixedFromValue
    )

{-| Natural number within a typed range

@docs N


# bounds

@docs In, Min
@docs Fixed, InFixed, Exactly, Infinity
@docs Up, Down, To


# create

@docs inRandom, inFuzz, inFuzzUniform

[`ArraySized.upTo`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/ArraySized#upTo)
to create increasing [`N`](#N)s.
`ArraySized` will even know the final length in its type!
Wanna try?


# specific numbers

If the package exposed every number 0 → 1000+, [tools can become unusably slow](https://github.com/lue-bird/elm-typesafe-array/issues/2)

So only 0 → 16 are exposed, while larger numbers have to be generated locally

Current method: [generate them](https://lue-bird.github.io/elm-bounded-nat/generate/)
into a `module N.Local exposing (n<n>, N<n>, Add<n>, Up<n>, ...)` +
`import N.Local as N exposing (n<n>, N<n>, Add<n>, Up<n>, ...)`

In the future, [`elm-generate`](https://github.com/lue-bird/generate-elm) will allow auto-generating via [`elm-review`](https://dark.elm.dmy.fr/packages/jfmengels/elm-review/latest/)


## type `n`

[⏭ skip to last](#N16)

@docs N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16


## type `n +`

[⏭ skip to last](#Add16)

@docs Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16


## type `Up x To (n + x)`

[⏭ skip to last](#Up16)

@docs Up0, Up1, Up2, Up3, Up4, Up5, Up6, Up7, Up8, Up9, Up10, Up11, Up12, Up13, Up14, Up15, Up16


## exact

[⏭ skip to last](#n16)

@docs n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16


# `Int`

@docs intToAbsolute, intModBy, intToAtLeast, intToIn


### `Int` compare

@docs intIsAtLeast, intIsIn


# compare

@docs isAtLeast, isAtMost
@docs BelowOrAbove, is, isIn
@docs greater, smaller

More advanced stuff in [section type information ) allowable-state](#allowable-state)


# alter

@docs add, addMin
@docs subtract, subtractMin
@docs toPower, remainderBy, multiplyBy, divideBy


## clamp

@docs toAtLeast, toAtLeastMin, toAtMost, toIn


## broaden

@docs toInt, toFloat, toString


# without internal functions

@docs FixedValue, InFixedValue, ExactlyValue, MinFixedValue
@docs toValue, fromValue
@docs minToValue, minFromValue
@docs maxToValue, maxFromValue


# type information

@docs minTo, minSubtract
@docs maxTo, maxToInfinity, maxAdd


## allowable-state

Consider this an advanced technique for packages that use
[`allowable-state`](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/).
Any questions @lue in slack!

@docs isAtLeast1, min0Adapt


# miss an operation?

Anything that can't be expressed with the available operations? → issue/PR


# safe internals

Internal parts you can safely access and transform

While the internally stored `Int` can't directly be guaranteed to be in bounds by elm,
the [minimum](#min), [maximum](#max)
must be built as actual values checked by the compiler.
No shenanigans like runtime errors for impossible cases

Having those exposed can be useful when building extensions to this library like

  - [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)
  - [`morph`](https://github.com/lue-bird/elm-morph)
  - [`bits`](https://dark.elm.dmy.fr/packages/lue-bird/elm-bits/latest/)

@docs range, min, max
@docs fixedInfinity, fixedToNumber
@docs exactly
@docs differenceAdd, differenceSubtract
@docs differenceToInt
@docs addDifference, subtractDifference

@docs N0OrAdd1


## [allowable-state](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/)

@docs number0Adapt, fixed0Adapt


## safe internals without functions

@docs fixedToValue, fixedFromValue
@docs inFixedToValue, inFixedFromValue

-}

import Fuzz exposing (Fuzzer)
import Possibly exposing (Possibly(..))
import Random


{-| A **bounded** natural number `>= 0`


### result type

    -- ≥ 4
    N (Min (Up4 x_))

    -- 2 ≤ n ≤ 12
    N (In (Up2 minX_)) (Up12 maxX_))

    -- n3 :
    N (In (Up3 minX_) (Up3 maxX_))

The type variable enables adding, subtracting.
Consider the "[`Up`](#Up)" thing an implementation detail

    n3
        |> N.add n6
        --: N (In (Up9 minX_) (Up9 maxX_))
        |> N.toValue
    --> n9 |> N.toValue


### argument type

    -- ≥ 0, any limitations allowed
    N range_

    -- ≥ 4
    N (In (Fixed (Add4 minMinus4_)) max_)

    -- 4 ≤ n ≤ 15
    N (In (Fixed (Add4 minMinus4_)) (Up maxTo15_ To N15))

`In (Add4 minMinus4_) (Up maxTo15_ To N15)` says:

  - the minimum-constraint can be `4+ 0`|`4+ 1`|`4+ 2`|...
    which means it's ≥ 4
  - the argument's maximum `+` some variable `maxTo15` is `15`
    which means it's ≤ 15


### stored type

what to put in declared types like `Model`

    -- ≥ 4
    N (Min (Fixed N4))

    -- 2 ≤ n ≤ 12
    N (InFixed N2 N12)

    -- = 3
    N (Exactly N3)

There's also versions of this that don't contain functions internally:

    -- ≥ 4
    N (Min (FixedValue N4))

    -- 2 ≤ n ≤ 12
    N (InFixedValue N2 N12)

    -- = 3
    N (ExactlyValue N3)

more type examples at [`In`](#In), [`Min`](#Min)

-}
type N range
    = LimitedIn range Int


{-| somewhere within a minimum & maximum

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### argument type in a range

    -- 3 ≤ n ≤ 5
    N (In (Fixed (Add3 minX_)) (Up maxTo5_ N5))

    -- 0 ≤ n ≤ 100
    percent : N (In min_ (Up maxTo100_ To N100)) -> Percent

For every constructable value, the minimum is smaller than the maximum

If you want a number where you just care about the minimum, leave `max` as a type _variable_

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

    -- any natural number
    N (In min_ max_)

A number, at least 5:

    N (In (Add5 minMinus5_) max_)

→ `max_` could be a specific maximum or [no maximum at all](#Infinity)


### result type in a range

    n3 : N (In (Up3 minX_) (Up3 maxX_))

    between3And6 : N (In (Up3 minX_) (Up6 maxX_))

    between3And6 |> N.add n3
    --: N (In (Up6 minX_) (Up9 maxX_))


### stored type in a range

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeBinaryFull element =
        Tree (Exactly N2) element

Remember: ↑ and other [`Min`](#Min) `(`[`Fixed`](#Fixed)`...)` / [`Exactly`](#Exactly) / [`InFixed`](#InFixed) aren't argument types

---

Do not use `==` on 2 values storing a range.
It will lead to elm crashing because [difference](#Up)s are stored as functions.
Instead,

  - [compare](#compare) in _your_ code
  - convert to [`FixedValue`](#FixedValue) for _other_ code
    that relies (or performs better) on structural `==`

-}
type In lowestPossibleAsDifference highestPossibleAsDifference
    = Range
        { min : lowestPossibleAsDifference
        , max : highestPossibleAsDifference
        }


{-| Only **stored / result types should use the type `Min`**:

       ↓ minimum    ↓ or →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...


### result type without maximum constraint

Sometimes, you simply cannot compute a maximum

    intToAbsolute : Int -> N (In (Up0 x_) ??)
                    ↓
    intToAbsolute : Int -> N (Min (Up0 x_))

    -- n ≥ 5
    atLeast5 : N (Min (Up5 x_))

    atLeast5 |> N.addMin n3
    --: N (Min (Up8 x_))

    n3 |> N.addMin atLeast5
    --: N (Min (Up8 x_))


### argument type without maximum constraint

Every `Min min` is of type `In min ...`,
so using a type variable for the maximum on arguments is highly encouraged
when no maximum constraint should be enforced

    -- any natural number
    N (In min_ max_)

    -- number, at least 5
    N (In (Add5 minMinus5_) max_)


### stored type without maximum constraint

An example where this is useful using [typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/):

    type Tree branchingFactor element
        = Tree
            element
            (ArraySized
                branchingFactor
                (Maybe (Tree branchingFactor element))
            )

    type alias TreeMulti element =
        Tree (Min (Fixed N1)) element

Remember: ↑ and other [`Min`](#Min)/[`Exactly`](#Exactly)/[`Fixed`](#Fixed) are result/stored types, not argument types

Can't store functions? → [`MinFixedValue`](#MinFixedValue)

-}
type alias Min lowestPossibleAsDifference =
    In lowestPossibleAsDifference (Fixed Infinity)


{-| Lower and upper limits [`Fixed`](#Fixed). For stored types only

Can't store functions? → [`InFixedValue`](#InFixedValue)

-}
type alias InFixed lowestPossibleAsNumber highestPossibleAsNumber =
    In (Fixed lowestPossibleAsNumber) (Fixed highestPossibleAsNumber)


{-| Allow only a specific [`Fixed`](#Fixed) number

Useful as a **stored & argument** type
in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with [`N`](#N)s

    byte : ArraySized (Exactly N8) Bit -> Byte

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s

    type alias TicTacToeBoard =
        ArraySized
            (Exactly N3)
            (ArraySized (Exactly N3) TicTacToField)

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s

-}
type alias Exactly asNumber =
    InFixed asNumber asNumber


{-| `Up low To high`: an exact number as the difference `high - low`
-}
type Up lowRepresentationAsNumber toTag highRepresentationAsNumber
    = Difference
        -- hidden so that the `Int` can't be messed with
        { up : lowRepresentationAsNumber -> highRepresentationAsNumber
        , down : highRepresentationAsNumber -> lowRepresentationAsNumber
        , toInt : Int
        }


{-| In some cases, it's better or required not to store functions etc. in app state, events, ...:

  - serializability, for example
      - json import/export on the debugger → doesn't work
  - calling `==`, for example
      - on hot module reloading,
        old code might end up remaining in the model
      - [lamdera](https://www.lamdera.com/) → doesn't work
      - accidental `==` call → crash

Calling `==` on a [`FixedValue`](#FixedValue) will yield the correct result instead of crashing

[`Fixed` is defined as a difference from 0](#Fixed), so this independent type needed to be created

You can just use [`Fixed`](#Fixed) when you don't have disadvantages storing functions

-}
type FixedValue representedNumber
    = FixedValue
        -- hidden so that the `Int` can't be messed with
        -- detail:
        --     ((1 / 0) |> round) == ((1 / 0) |> round)
        --     --> True
        -- which is nice for our purposes.
        -- If this changes in the future, is found to be unreliable or something else,
        -- change to  `| Finite Int | Infinity`
        { number : representedNumber
        , int : Int
        }


{-| Lower and upper limits as [`FixedValue`](#FixedValue)s. For stored types only

You can just use [`InFixed`](#InFixed) when you don't have disadvantages storing functions.
See [`FixedValue`](#FixedValue)

-}
type alias InFixedValue min max =
    In (FixedValue min) (FixedValue max)


{-| For **storing** in a type. Allow only a specific [`FixedValue`](#FixedValue)

You can just use [`Exactly`](#Exactly) when you don't have disadvantages storing functions.
See [`FixedValue`](#FixedValue)

-}
type alias ExactlyValue n =
    InFixedValue n n


{-| "The limit is unknown".

Used in the definition of [`Min`](#Min):

    type alias Min min =
        In minimum (Fixed Infinity)

and [`MinFixedValue`](#MinFixedValue)

    type alias MinFixedValue min =
        In (FixedValue min) (FixedValue Infinity)

which can be simplified to

    type alias MinFixedValue min =
        InFixedValue min Infinity

You can just use [`Fixed`](#Fixed) when you don't have disadvantages storing functions.
See [`FixedValue`](#FixedValue)

-}
type Infinity
    = Infinity


{-| A lower limit as a [`FixedValue`](#FixedValue). For stored types only

You can just use [`Min`](#Min) `(` [`Fixed`](#Fixed) `...)` when you don't have disadvantages storing functions.
See [`FixedValue`](#FixedValue)

-}
type alias MinFixedValue min =
    InFixedValue min Infinity


{-| The [`N0OrAdd1`](#N0OrAdd1) represented by this [`Fixed`](#Fixed) [difference](#Up)

    import Possibly exposing (Possibly(..))

    N.intToIn ( n3, n10 ) 5
        |> N.min
        |> N.fixedToNumber
    --> N.Add1 (N.Add1 (N.Add1 (N.N0 Possible)))

useful

  - to preserve emptiness knowledge

        numberSuccessor :
            N0OrAdd1 possiblyOrNever successorMinus1
            -> Emptiable (Stacked element) possiblyOrNever
        numberSuccessor =
            \number ->
                case number of
                    N.N0 possiblyOrNever ->
                        Emptiable.Empty possiblyOrNever

                    N.Add1 successor ->
                        successor |> Emptiable.filled

  - as a tag

        type Element index
            = Element index

        element :
            N (Exactly index)
            -> Mapping (List element) (Element index) (Maybe element)
        element index =
            Typed.tag
                (Element (index |> N.min |> N.fixedToNumber))
                List.Extra.getAt

Can be altered with [`addDifference`](#addDifference), [`subtractDifference`](#subtractDifference).

To preserve the ability to turn the number into an `Int`, use [`fixedToValue`](#fixedToValue)

-}
fixedToNumber : Fixed representedNumber -> representedNumber
fixedToNumber =
    \fixed ->
        let
            (FixedValue fixedValueInternal) =
                fixed |> fixedToValue
        in
        fixedValueInternal.number


{-| [`Fixed`](#Fixed) → equatable [`FixedValue`](#FixedValue)
-}
fixedToValue : Fixed n -> FixedValue n
fixedToValue =
    \fixed ->
        FixedValue
            { number = N0 Possible |> addDifference fixed
            , int = fixed |> differenceToInt
            }


{-| [`Fixed`](#Fixed) → equatable [`FixedValue`](#FixedValue)
-}
fixedFromValue : FixedValue n -> Fixed n
fixedFromValue =
    \(FixedValue value) ->
        Difference
            { up = \_ -> value.number
            , down = \_ -> N0 Possible
            , toInt = value.int
            }


{-| [`InFixed`](#InFixed) → equatable [`InFixedValue`](#InFixedValue)
-}
inFixedToValue : InFixed min max -> InFixedValue min max
inFixedToValue =
    \(Range inFixed) ->
        Range
            { min = inFixed |> .min |> fixedToValue
            , max = inFixed |> .max |> fixedToValue
            }


{-| equatable [`InFixedValue`](#InFixedValue) → [`InFixed`](#InFixed)
-}
inFixedFromValue : InFixedValue min max -> InFixed min max
inFixedFromValue =
    \(Range inValue) ->
        Range
            { min = inValue |> .min |> fixedFromValue
            , max = inValue |> .max |> fixedFromValue
            }


{-| Number with [`Fixed` range](#InFixed) → number with equatable [`FixedValue` range](#InFixedValue)
-}
toValue : N (InFixed min max) -> N (InFixedValue min max)
toValue =
    \n ->
        n
            |> minToValue
            |> maxToValue


{-| Number with [`Fixed`](#Fixed) minimum
→ number with equatable [`FixedValue`](#FixedValue) minimum
-}
minToValue : N (In (Fixed min) max) -> N (In (FixedValue min) max)
minToValue =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (let
                    (Range rangeInternal) =
                        n |> range
                 in
                 Range
                    { max = rangeInternal.max
                    , min =
                        rangeInternal.min |> fixedToValue
                    }
                )


{-| Number with [`Fixed`](#Fixed) maximum
→ number with equatable [`FixedValue`](#FixedValue) maximum
-}
maxToValue : N (In min (Fixed max)) -> N (In min (FixedValue max))
maxToValue =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (let
                    (Range rangeInternal) =
                        n |> range
                 in
                 Range
                    { min = rangeInternal.min
                    , max =
                        rangeInternal.max |> fixedToValue
                    }
                )


{-| Number with equatable [`FixedValue` range](#InFixedValue)
→ number with [`Fixed` range](#InFixed) to be [altered](#alter), [compared](#compare), ...
-}
fromValue : N (InFixedValue min max) -> N (InFixed min max)
fromValue =
    \n ->
        n
            |> minFromValue
            |> maxFromValue


{-| Number with equatable [`FixedValue`](#FixedValue) minimum
→ number with [`Fixed`](#Fixed) minimum
-}
minFromValue : N (In (FixedValue min) max) -> N (In (Fixed min) max)
minFromValue =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (let
                    (Range rangeInternal) =
                        n |> range
                 in
                 Range
                    { max = rangeInternal.max
                    , min =
                        rangeInternal.min |> fixedFromValue
                    }
                )


{-| Number with equatable [`FixedValue`](#FixedValue) maximum → number with [`Fixed`](#Fixed) maximum
-}
maxFromValue : N (In min (FixedValue max)) -> N (In min (Fixed max))
maxFromValue =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (let
                    (Range rangeInternal) =
                        n |> range
                 in
                 Range
                    { min = rangeInternal.min
                    , max =
                        rangeInternal.max |> fixedFromValue
                    }
                )


{-| `Down high To low`: an exact number as the difference `high - low`
-}
type alias Down high toTag low =
    Up low toTag high


{-| Just a word in a [difference type](#Up):

    Up low To high

    Down high To high

→ distance `high - low`

-}
type To
    = To Never


{-| The [difference](#Up) from [`0`](#N0) to a given `n`

A stored type looks like a [result type](#result-type)
where every [`Up<n> x`](#Up) is instead [`Fixed N<n>`](#Fixed)

Do not use `==` on 2 numbers in a [`Fixed` range](#InFixed).
It will lead to elm crashing because [difference](#Up)s are stored as functions internally.
Instead,

  - [compare](#compare) in _your_ code
  - convert to [`FixedValue`](#FixedValue) for _other_ code
    that relies (or performs better) on structural `==`

-}
type alias Fixed asNumber =
    Up N0 To asNumber


{-| Add a given [specific](#In) [`N`](#N)

    between70And100 |> N.add n7
    --: N (In (Up77 minX_) (Up107 maxX_))

One addend has an unconstrained maximum? → [`addMin`](#addMin)

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
                (Range
                    { min =
                        (n |> min)
                            |> differenceAdd
                                (toAdd |> min)
                    , max =
                        (n |> max)
                            |> differenceAdd
                                (toAdd |> max)
                    }
                )


{-| [`Fixed`](#Fixed) [difference up](#Up) to [`Infinity`](#Infinity)

    (N.fixedInfinity |> N.differenceToInt)
        == ((1 / 0) |> round)
    --> True

    (N.fixedInfinity |> N.fixedToNumber)
        == N.Infinity
    --> True

-}
fixedInfinity : Fixed Infinity
fixedInfinity =
    { up = \_ -> Infinity
    , down = \_ -> N0 Possible
    , toInt = (1 / 0) |> round
    }
        |> Difference


{-| The `Int`'s distance from `0`.
This ["absolute value"](https://en.wikipedia.org/wiki/Absolute_value) is always `≥ 0`

    -4
        |> N.intToAbsolute
        --: N (Min (Up0 x_))
        |> N.toInt
    --> 4

    16 |> N.intToAbsolute |> N.toInt
    --> 16

Really only use this if you want the absolute value

    badLength =
        List.length >> N.intToAbsolute

  - maybe, there's a solution that never even theoretically deals with unexpected values:

        mostCorrectLength =
            List.foldl
                (\_ -> N.addMin n1 >> N.minSubtract n1)
                (n0 |> N.maxToInfinity)

  - other times, though, like with `Array.length`, which isn't `O(n)`,
    you can escape with for example

        arrayLength =
            Array.length >> N.intToAtLeast n0

-}
intToAbsolute : Int -> N (Min (Up0 x_))
intToAbsolute =
    \int ->
        int
            |> Basics.abs
            |> LimitedIn
                (Range
                    { min = n0 |> min
                    , max = fixedInfinity
                    }
                )


{-| Perform [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic) by an [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    7
        |> N.intModBy n3
        --: N (In (Up0 minX_) (Up2 maxX_))
        |> N.toInt
    --> 1

Works in the typical mathematical way for a negative `Int`

    -7
        |> N.intModBy n3
        --: N (In (Up0 minX_) (Up2 maxX_))
        |> N.toInt
    --> 2

Already have an [`N`](#N)? → [`remainderBy`](#remainderBy)

-}
intModBy :
    N
        (In
            (Fixed (Add1 divisorMinMinus1_))
            (Up divMaxX To (Add1 divisorMaxPlusXMinus1))
        )
    ->
        (Int
         ->
            N
                (In
                    (Up0 remainderMinX_)
                    (Up divMaxX To divisorMaxPlusXMinus1)
                )
        )
intModBy divisor =
    \int ->
        int
            |> Basics.modBy (divisor |> toInt)
            |> LimitedIn
                (Range
                    { min = n0 |> min
                    , max =
                        (divisor |> max)
                            |> differenceSubtract (n1 |> min)
                    }
                )



--


{-| Generate a random [`N`](#N) in a range

    N.inRandom ( n1, n10 )
    --: Random.Generator
    --:     (N (In (Up1 minX_) (Up10 maxX_)))

-}
inRandom :
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
inRandom ( lowestPossible, highestPossible ) =
    Random.map (intToIn ( lowestPossible, highestPossible ))
        (Random.int (lowestPossible |> toInt) (highestPossible |> toInt))


{-| `Fuzzer` for an [`N`](#N) in a given range.
For larger ranges, smaller [`N`](#N)s are preferred

    import Fuzz

    N.inFuzz ( n3, n6 )
        |> Fuzz.map N.toInt
        |> Fuzz.examples 10
    --> [ 5, 6, 3, 3, 4, 6, 3, 6, 3, 5 ]

-}
inFuzz :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N (In (Fixed upperLimitMin) upperLimitMax)
    )
    -> Fuzzer (N (In lowerLimitMin upperLimitMax))
inFuzz ( lowestPossible, highestPossible ) =
    Fuzz.map (intToIn ( lowestPossible, highestPossible ))
        (Fuzz.intRange (lowestPossible |> toInt) (highestPossible |> toInt))


{-| `Fuzzer` for an [`N`](#N) in a given range.
In contrast to [`N.inFuzz`](#inFuzz),
all [`N`](#N)s are equally as likely, even for larger ranges

    import Fuzz

    N.inFuzzUniform ( n2, n2 |> N.toPower n13 )
        |> Fuzz.map N.toInt
        |> Fuzz.examples 3
    --> [ 2244, 4842, 3566 ]

    N.inFuzz ( n2, n2 |> N.toPower n13 )
        |> Fuzz.map N.toInt
        |> Fuzz.examples 3
    --> [ 26, 82, 17 ]

-}
inFuzzUniform :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N (In (Fixed upperLimitMin) upperLimitMax)
    )
    -> Fuzzer (N (In lowerLimitMin upperLimitMax))
inFuzzUniform ( lowestPossible, highestPossible ) =
    Fuzz.map
        (\int0ToHighestMinusLowest ->
            intToIn ( lowestPossible, highestPossible )
                ((lowestPossible |> toInt) + int0ToHighestMinusLowest)
        )
        (Fuzz.uniformInt
            ((highestPossible |> toInt) - (lowestPossible |> toInt))
        )


{-| Compared to a range from a lower to an upper bound, is the `Int` in range, [`BelowOrAbove`](#BelowOrAbove)?

    inputIntJudge : Int -> Result String (N (In (Up1 minX_) (Up10 maxX_)))
    inputIntJudge =
        N.intIsIn ( n1, n10 )
            >> Result.mapError
                (\outOfRange ->
                    case outOfRange of
                        N.Below _ ->
                            "≤ 0"
                        N.Above _ ->
                            "≥ 11"
                )

    0 |> inputIntJudge
    --> Err "≤ 0"

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
                    (Range
                        { min =
                            (upperLimit |> max)
                                |> differenceAdd (n1 |> min)
                        , max = fixedInfinity
                        }
                    )
                |> Above
                |> Err

        else
            int
                |> LimitedIn
                    (Range
                        { min = lowerLimit |> min
                        , max = upperLimit |> max
                        }
                    )
                |> Ok


{-| If the `Int ≥` a given `minimum`,
return `Ok` with the `N (Min minimum)`,
else `Err` with the input `Int`

    4 |> N.intIsAtLeast n5
    --: Result Int (N (Min (Up5 x_)))
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
intIsAtLeast lowerLimit =
    \int ->
        if int >= (lowerLimit |> toInt) then
            int
                |> LimitedIn
                    (Range
                        { min = lowerLimit |> min
                        , max = fixedInfinity
                        }
                    )
                |> Ok

        else
            int |> Err


{-| Create a `N (In ...)` by **clamping** an `Int` between a minimum & maximum

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`intIsIn`](#intIsIn)

    0
        |> N.intToIn ( n3, n12 )
        --: N (In (Up3 minX_) (Up12 minX_))
        |> N.toInt
    --> 3

    99
        |> N.intToIn ( n3, n12 )
        |> N.toInt
    --> 12

    9
        |> N.intToIn ( n3, n12 )
        |> N.toInt
    --> 9


    toDigit : Char -> Maybe (N (In (Up0 minX_) (Up9 maxX_)))
    toDigit char =
        ((char |> Char.toCode) - ('0' |> Char.toCode))
            |> N.intIsIn ( n0, n9 )
            |> Result.toMaybe

-}
intToIn :
    ( N
        (In
            lowerLimitMin
            (Up lowerLimitMaxToUpperLimitMin_ To upperLimitMin)
        )
    , N
        (In
            (Fixed upperLimitMin)
            upperLimitMax
        )
    )
    ->
        (Int
         -> N (In lowerLimitMin upperLimitMax)
        )
intToIn ( lowerLimit, upperLimit ) =
    \int ->
        int
            |> Basics.max (lowerLimit |> toInt)
            |> Basics.min (upperLimit |> toInt)
            |> LimitedIn
                (Range
                    { min = lowerLimit |> min
                    , max = upperLimit |> max
                    }
                )


{-| A `N (Min ...)` from an `Int`;
if the `Int < minimum`, `minimum` is returned

    0
        |> N.intToAtLeast n3
        --: N (Min (Up3 x_))
        |> N.toInt
    --> 3

    9
        |> N.intToAtLeast n3
        --: N (Min (Up3 x_))
        |> N.toInt
    --> 9

You can also use this as an escape hatch
if you know an `Int` must be at least `minimum`.
But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ -> N.addMin n1 >> N.minSubtract n1)
            (n0 |> N.maxToInfinity)

To handle the case `< minimum` yourself → [`intIsAtLeast`](#intIsAtLeast)

-}
intToAtLeast :
    N (In lowerLimitMin lowerLimitMax_)
    ->
        (Int
         -> N (Min lowerLimitMin)
        )
intToAtLeast lowerLimit =
    \int ->
        int
            |> intIsAtLeast lowerLimit
            |> Result.withDefault (lowerLimit |> maxToInfinity)


{-| **Clamp** the number to between both given limits

    between5And9 |> N.toIn ( n10, n10 )
    --: N (In (Up10 minX_) (Up10 maxX_))

    between5And15 |> N.toIn ( n5, n10 )
    --: N (In (Up5 minX_) (Up10 maxX_))

    atLeast5 |> N.toIn ( n5, n10 )
    --: N (In (Up5 minX_) (Up10 maxX_))

  - There shouldn't be an upper limit? → [`toAtLeastMin`](#toAtLeastMin)
  - Keep the current maximum → [`toAtLeast`](#toAtLeast)
  - Keep the current minimum → [`toAtMost`](#toAtMost)

(The type doesn't forbid that the limits you're comparing against
are beyond the current limits)

-}
toIn :
    ( N (In lowerLimitMin (Up minNewMaxToMaxNewMin_ To upperLimitMin))
    , N (In (Fixed upperLimitMin) upperLimitMax)
    )
    ->
        (N range_
         -> N (In lowerLimitMin upperLimitMax)
        )
toIn ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            lowerLimit |> maxTo upperLimit

        else if (n |> toInt) > (upperLimit |> toInt) then
            upperLimit |> minTo lowerLimit

        else
            (n |> toInt)
                |> LimitedIn
                    (Range
                        { min = lowerLimit |> min
                        , max = upperLimit |> max
                        }
                    )


{-| **Cap** the [`N`](#N) to `>=` a given new lower limit

    n5AtLeast |> N.toAtLeastMin n10
    --: N (Min (Up10 x_))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15AtLeast |> N.toAtLeastMin n10 |> N.toInt
    --: N (Min (Up10 x_))

Know both maxima? → [`toAtLeast`](#toAtLeast)

-}
toAtLeastMin :
    N (In lowerLimitMin lowerLimitMax_)
    ->
        (N range_
         -> N (Min lowerLimitMin)
        )
toAtLeastMin lowerLimit =
    \n ->
        n
            |> toInt
            |> intIsAtLeast lowerLimit
            |> Result.withDefault (lowerLimit |> maxToInfinity)


{-| **Cap** the [`N`](#N) to `<=` a given new upper limit

    atLeast3
        |> N.toAtMost (between4And5 |> N.min n3)
    --: N (In (Up3 minX_) (Up5 maxX_))

  - To enforce a new minimum, too → [`toIn`](#toIn)

-}
toAtMost :
    N (In min upperLimitMax)
    ->
        (N (In min max_)
         -> N (In min upperLimitMax)
        )
toAtMost upperLimit =
    \n ->
        Basics.min (n |> toInt) (upperLimit |> toInt)
            |> LimitedIn
                (Range
                    { min = n |> min
                    , max = upperLimit |> max
                    }
                )


{-| **Cap** the [`N`](#N) to `>=` a given new lower limit

    between5And12 |> N.toAtLeast n10
    --: N (In (Up10 x_) (Fixed N12))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15
        |> N.toAtLeast n10
        --: N (In (Up10 x_) (Fixed N15))
        |> N.toInt
    --> 15

Don't know both maxima? → [`toAtLeastMin`](#toAtLeastMin)

-}
toAtLeast :
    N (In minNew (Up minNewMaxToMax_ To max))
    ->
        (N (In min_ (Fixed max))
         -> N (In minNew (Fixed max))
        )
toAtLeast lowerLimit =
    \n ->
        Basics.max (n |> toInt) (lowerLimit |> toInt)
            |> LimitedIn
                (Range
                    { min = lowerLimit |> min
                    , max = n |> max
                    }
                )


{-| Multiply by a given [`n`](#N) `≥ 1`.
which means `x * n ≥ x`

    atLeast5 |> N.multiplyBy n2
    --: N (Min (Up5 x_))

    atLeast2 |> N.multiplyBy n5
    --: N (Min (Up2 x_))

-}
multiplyBy :
    N (In (Fixed (Add1 multiplicandMinMinus1_)) multiplicandMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
multiplyBy multiplicand =
    \n ->
        (n |> toInt)
            * (multiplicand |> toInt)
            |> LimitedIn
                (Range
                    { min = n |> min
                    , max = fixedInfinity
                    }
                )


{-| Divide (`//`) by an [`N`](#N) `d ≥ 1`

  - → `/ 0` is impossible
  - → `x / d <= x`

.

    atMost7
        |> N.divideBy n3
        --: N (In (Up0 minX_) (Up7 maxX_))
        |> N.toInt

-}
divideBy :
    N (In (Fixed (Add1 divisorMinMinus1_)) divisorMax_)
    ->
        (N (In min_ max)
         -> N (In (Up0 minX_) max)
        )
divideBy divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> LimitedIn
                (Range
                    { min = n0 |> min
                    , max = n |> max
                    }
                )


{-| The remainder after dividing by an [`N`](#N) `d ≥ 1`.
We know `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In (Up0 minX_) (Up2 maxX_))

-}
remainderBy :
    N
        (In
            (Fixed (Add1 divisorMinMinus1_))
            (Up divMaxX To (Add1 divisorMaxPlusXMinus1))
        )
    ->
        (N range_
         ->
            N
                (In
                    (Up0 remainderMinX_)
                    (Up divMaxX To divisorMaxPlusXMinus1)
                )
        )
remainderBy divisor =
    \n ->
        (n |> toInt) |> intModBy divisor


{-| [`N`](#N) Raised to a given power `p ≥ 1`
→ `x ^ p ≥ x`

    atLeast5 |> N.toPower n2
    --: N (Min (Up5 x_))

    atLeast2 |> N.toPower n5
    --: N (Min (Up2 x_))

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
                (Range
                    { min = n |> min
                    , max = fixedInfinity
                    }
                )


{-| Set the minimum lower

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N3)`

    [ atLeast3
    , atLeast4 |> N.minTo n3
    ]

-}
minTo :
    N (In minNew (Up minNewMaxToMin_ To min))
    ->
        (N (In (Fixed min) max)
         -> N (In minNew max)
        )
minTo newMinimum =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (Range
                    { min = newMinimum |> min
                    , max = n |> max
                    }
                )


{-| On `N (In min max)`'s type,
allow `max` to go [up to infinity](#Infinity) to get a `N (Min min)`

    between3And10 |> N.maxToInfinity
    --: N (Min (Up3 x_))

Use it to unify different types of number minimum constraints like

    [ atLeast1, between1And10 ]

elm complains:

> But all the previous elements in the list are: `N (Min (Up1 x_))`

    [ atLeast1
    , between1And10 |> N.maxToInfinity
    ]

-}
maxToInfinity : N (In min max_) -> N (Min min)
maxToInfinity =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (Range
                    { min = n |> min
                    , max = fixedInfinity
                    }
                )


{-| Make it fit into functions with require a higher maximum

You should type arguments and stored types as broad as possible

    onlyAtMost18 : N (In min_ (Up maxTo18_ To N18)) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the `n` in `onlyAtMost19`:

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.maxTo n18)

-}
maxTo :
    N (In (Fixed maxNewMin) maxNew)
    ->
        (N (In min (Up maxToMaxNewMin_ To maxNewMin))
         -> N (In min maxNew)
        )
maxTo maximumNew =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (Range
                    { min = n |> min
                    , max = maximumNew |> max
                    }
                )


{-| Have a specific maximum in mind? → [`N.maxTo`](#maxTo)

Want to increase the upper bound by a fixed amount? → [`maxAdd`](#maxAdd)

-}
maxAdd :
    N
        (In
            increaseMin_
            (Up maxPlusX To maxIncreasedPlusX)
        )
    ->
        (N (In min (Up maxX To maxPlusX))
         -> N (In min (Up maxX To maxIncreasedPlusX))
        )
maxAdd maxRelativeIncrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (Range
                    { min = n |> min
                    , max =
                        (n |> max)
                            |> differenceAdd
                                (maxRelativeIncrease |> max)
                    }
                )


{-| Have a specific minimum in mind? → [`N.minTo`](#minTo)

Want to decrease the lower bound by a fixed amount? → [`minSubtract`](#minSubtract)

-}
minSubtract :
    N
        (In
            maxIncreasedMin_
            (Down minPlusX To minDecreasedPlusX)
        )
    ->
        (N (In (Up x To minPlusX) max)
         -> N (In (Up x To minDecreasedPlusX) max)
        )
minSubtract minRelativeDecrease =
    \n ->
        (n |> toInt)
            |> LimitedIn
                (Range
                    { min =
                        (n |> min)
                            |> differenceSubtract
                                (minRelativeDecrease |> max)
                    , max = n |> max
                    }
                )


{-| The error result of comparing [`N`](#N)s

  - `Above`: greater than what it's compared against
  - `Below`: less than what it's compared against

Values exist for each condition

-}
type BelowOrAbove below above
    = Below below
    | Above above


{-| Drop the range constraints
to feed another library with its `Int` representation
-}
toInt : N range_ -> Int
toInt =
    \(LimitedIn _ int) -> int


{-| Drop the range constraints
to feed another library with its `Float` representation

Equivalent to

    toInt |> toFloat

-}
toFloat : N range_ -> Float
toFloat =
    \n -> n |> toInt |> Basics.toFloat


{-| Drop the range constraints
to feed another library with its `String` representation

Equivalent to

    toInt |> String.fromInt

-}
toString : N range_ -> String
toString =
    \n -> n |> toInt |> String.fromInt



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

    toy : { age : N (In min_ (Up17 maxX_)) } -> Toy

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
                comparedAgainst |> Ok

            GT ->
                (n |> toInt)
                    |> LimitedIn
                        (Range
                            { min =
                                (comparedAgainst |> min)
                                    |> differenceAdd (n1 |> min)
                            , max = n |> max
                            }
                        )
                    |> Above
                    |> Err

            LT ->
                (n |> toInt)
                    |> LimitedIn
                        (Range
                            { min = n |> min
                            , max =
                                (comparedAgainst |> max)
                                    |> differenceSubtract (n1 |> min)
                            }
                        )
                    |> Below
                    |> Err


{-| Compared to a range from a lower to an upper bound,
is the [`N`](#N) in range or [`BelowOrAbove`](#BelowOrAbove)?

    isIn3To10 : N (In min_ max_) -> Maybe (N (In (Up3 minX_) (Up10 maxX_)))
    isIn3To10 =
        N.isIn ( n3, n10 ) >> Result.toMaybe

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
                    (Range
                        { min = n |> min
                        , max =
                            (lowerLimit |> max)
                                |> differenceSubtract (n1 |> min)
                        }
                    )
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            (n |> toInt)
                |> LimitedIn
                    (Range
                        { min =
                            (upperLimit |> min)
                                |> differenceAdd (n1 |> min)
                        , max = n |> max
                        }
                    )
                |> Above
                |> Err

        else
            (n |> toInt)
                |> LimitedIn
                    (Range
                        { min = lowerLimit |> min
                        , max = upperLimit |> max
                        }
                    )
                |> Ok



--


{-| Is the [`N`](#N) below than or at least as big as a given number?

    vote :
        { age : N (In (Fixed (Add18 minMinus18_)) max_) }
        -> Vote

    tryToVote { age } =
        case age |> N.isAtLeast n18 of
            Err _ ->
                -- 😓
                Nothing

            Ok oldEnough ->
                vote { age = oldEnough } |> Just

    factorial : N (In min_ max_) -> N (Min (Up1 x_))
    factorial =
        factorialBody

    factorialBody : N (In min_ max_) -> N (Min (Up1 x_))
    factorialBody x =
        case x |> N.isAtLeast n1 of
            Err _ ->
                n1 |> N.maxToInfinity

            Ok atLeast1 ->
                factorial (atLeast1 |> N.subtractMin n1)
                    |> N.multiplyBy atLeast1

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
                    (Range
                        { min = lowerLimit |> min
                        , max = n |> max
                        }
                    )
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    (Range
                        { min = n |> min
                        , max =
                            (lowerLimit |> max)
                                |> differenceSubtract (n1 |> min)
                        }
                    )
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
                    (Range
                        { min = n |> min
                        , max = upperLimit |> max
                        }
                    )
                |> Ok

        else
            (n |> toInt)
                |> LimitedIn
                    (Range
                        { min =
                            (upperLimit |> min)
                                |> differenceAdd (n1 |> min)
                        , max = n |> max
                        }
                    )
                |> Err


{-| The minimum of both given numbers in the same range

Even though you can just use directly

    N.intToIn ( n0, n10 ) 3
        |> N.smaller (N.intToIn ( n0, n10 ) 1)
        |> N.toInt
    --> 1

    N.intToIn ( n0, n10 ) 3
        |> N.smaller (N.intToIn ( n0, n10 ) 4)
        |> N.toInt
    --> 3

this is rather supposed to be used as a primitive to build a structure maximum function:

    ArraySized.fold Up N.smaller

For clamping, try [`toAtMost`](#toAtMost) instead!

-}
smaller : N range -> N range -> N range
smaller maximum =
    \n ->
        if (n |> toInt) <= (maximum |> toInt) then
            n

        else
            maximum


{-| The maximum of both given numbers in the same range

Even though you can just use directly

    N.intToIn ( n0, n10 ) 3
        |> N.greater (N.intToIn ( n0, n10 ) 1)
        |> N.toInt
    --> 3

    N.intToIn ( n0, n10 ) 3
        |> N.greater (N.intToIn ( n0, n10 ) 4)
        |> N.toInt
    --> 4

this is rather supposed to be used as a primitive to build a structure maximum function:

    ArraySized.fold Up N.greater

For clamping, try [`toAtLeast`](#toAtLeast) instead!

-}
greater : N range -> N range -> N range
greater minimum =
    \n ->
        if (n |> toInt) >= (minimum |> toInt) then
            n

        else
            minimum



--


{-| To the [`N`](#N) without a known maximum-constraint,
add a number that (only) has [information on how to add](#Up) the minima

    atLeast70 |> N.addMin n7
    --: N (Min (Up77 x_))

    n7 |> N.addMin atLeast70
    --: N (Min (Up77 x_))

Use [`add`](#add) if both maxima are known [difference](#Up)s as well

If the added minimum is [`Fixed`](#Fixed), supply the [`N.minTo`](#minTo) manually
to re-enable adding both minimum types!

    atLeast5 |> N.addMin (atLeastFixed2 |> N.min n2)
    --: N (Min (Up7 x_))

-}
addMin :
    N
        (In
            (Up minPlusX To sumMinPlusX)
            addedMax_
        )
    ->
        (N (In (Up minX To minPlusX) max_)
         -> N (Min (Up minX To sumMinPlusX))
        )
addMin toAdd =
    \n ->
        ((n |> toInt) + (toAdd |> toInt))
            |> LimitedIn
                (Range
                    { min =
                        (n |> min)
                            |> differenceAdd (toAdd |> min)
                    , max = fixedInfinity
                    }
                )


{-| From the [`N`](#N) in a range subtract another [`N`](#N) in a range

    n6
        |> N.subtract n5
        --: N (In (Fixed N1) (Up1 x_))
        |> N.toValue
    --> n1 |> N.toValue

One of the [`N`](#N)s has no maximum constraint? → [`N.subtractMin`](#subtractMin)

-}
subtract :
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
subtract toSubtract =
    \n ->
        (n |> toInt)
            - (toSubtract |> toInt)
            |> LimitedIn
                (Range
                    { min =
                        (n |> min)
                            |> differenceSubtract (toSubtract |> max)
                    , max =
                        (n |> max)
                            |> differenceSubtract (toSubtract |> min)
                    }
                )


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#In)

    atLeast7 |> N.subtractMin n2
    --: N (Min (Fixed N5))

    atLeast6 |> N.subtractMin between0And5
    --: N (Min (Fixed N1))

    between6And12 |> N.subtractMin between1And5
    --: N (In (Fixed min_) (Up12 maxX_))

Use [`N.subtract`](#subtract) if you want to subtract an [`N`](#N) in a range

-}
subtractMin :
    N
        (In
            subtractedDifference0_
            (Down min To differenceMin)
        )
    ->
        (N (In (Fixed min) max)
         -> N (In (Fixed differenceMin) max)
        )
subtractMin subtrahend =
    \n ->
        (n |> toInt)
            - (subtrahend |> toInt)
            |> LimitedIn
                (Range
                    { min =
                        (n |> min)
                            |> differenceSubtract
                                (subtrahend |> max)
                    , max = n |> max
                    }
                )



-- # internals


{-| Its [limits](#In)
containing both its [`min`](#min)
and its [`max`](#max)
-}
range : N range -> range
range =
    \(LimitedIn rangeLimits _) -> rangeLimits


{-| The smallest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
min : N (In min maximum_) -> min
min =
    \n ->
        let
            (Range rangeInternal) =
                n |> range
        in
        rangeInternal.min


{-| The greatest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
max : N (In min_ max) -> max
max =
    \n ->
        let
            (Range rangeInternal) =
                n |> range
        in
        rangeInternal.max


{-| Create an [`N`](#N) with the value = minimum = maximum of a given difference

    N.intToIn ( n3, n6 ) 5
        |> N.min
        |> N.exactly
        |> N.max
        |> N.differenceToInt
    --> 3

See [`differenceToInt`](#differenceToInt)

-}
exactly :
    Up low To high
    -> N (In (Up low To high) (Up low To high))
exactly specificDifference =
    (specificDifference |> differenceToInt)
        |> LimitedIn
            (Range
                { min = specificDifference
                , max = specificDifference
                }
            )


{-| A [difference](#Up) represented as an `Int` `>= 0`

    N.intToIn ( n3, n6 ) 5
        |> N.max
        |> N.differenceToInt
    --> 6

This enables for example [`exactly`](#exactly)

-}
differenceToInt : Up low_ To high_ -> Int
differenceToInt =
    \(Difference difference) ->
        difference.toInt



--


{-| Increase a [natural number](#N0OrAdd1),
like shown in a given [difference](#Up)
-}
addDifference : Up low To high -> (low -> high)
addDifference =
    \(Difference differenceOperation) ->
        differenceOperation.up


{-| Decrease the [natural number](#N0OrAdd1),
like shown in a given [difference](#Down)
-}
subtractDifference : Down high To low -> (high -> low)
subtractDifference =
    \(Difference differenceOperation) ->
        differenceOperation.down


{-| Chain the [difference](#Up) [`Up`](#Up) to a higher [natural number](#N0OrAdd1)
-}
differenceAdd :
    Up middle To high
    ->
        (Up low To middle
         -> Up low To high
        )
differenceAdd differenceMiddleToHigh =
    \diffLowToMiddle ->
        Difference
            { up =
                \difference ->
                    difference
                        |> addDifference diffLowToMiddle
                        |> addDifference differenceMiddleToHigh
            , down =
                \difference ->
                    difference
                        |> subtractDifference differenceMiddleToHigh
                        |> subtractDifference diffLowToMiddle
            , toInt =
                (diffLowToMiddle |> differenceToInt)
                    + (differenceMiddleToHigh |> differenceToInt)
            }


{-| Chain the [difference](#Up) [`Down`](#Down) to a lower [natural number](#N0OrAdd1)
-}
differenceSubtract :
    Down high To middle
    ->
        (Up low To high
         -> Up low To middle
        )
differenceSubtract differenceMiddleToHigh =
    \diffLowToHigh ->
        Difference
            { up =
                \difference ->
                    difference
                        |> addDifference diffLowToHigh
                        |> subtractDifference differenceMiddleToHigh
            , down =
                \difference ->
                    difference
                        |> addDifference differenceMiddleToHigh
                        |> subtractDifference diffLowToHigh
            , toInt =
                (diffLowToHigh |> differenceToInt)
                    - (differenceMiddleToHigh |> differenceToInt)
            }


{-| The specific natural number `0`
-}
n0 : N (In (Up0 minX_) (Up0 maxX_))
n0 =
    0
        |> LimitedIn
            (Range { min = up0, max = up0 })


up0 : Up0 x_
up0 =
    Difference
        { up = identity
        , down = identity
        , toInt = 0
        }



--


{-| The specific natural number `1`
-}
n1 : N (In (Up1 minX_) (Up1 maxX_))
n1 =
    1
        |> LimitedIn
            (Range { min = up1, max = up1 })


up1 : Up1 x_
up1 =
    Difference
        { up = Add1
        , down =
            \n0Never ->
                case n0Never of
                    Add1 predecessor ->
                        predecessor

                    N0 possible ->
                        possible |> never
        , toInt = 1
        }


{-| The [`N`](#N) `2`
-}
n2 : N (In (Up2 minX_) (Up2 maxX_))
n2 =
    n1 |> add n1


{-| The [`N`](#N) `3`
-}
n3 : N (In (Up3 minX_) (Up3 maxX_))
n3 =
    n2 |> add n1


{-| The [`N`](#N) `4`
-}
n4 : N (In (Up4 minX_) (Up4 maxX_))
n4 =
    n3 |> add n1


{-| The [`N`](#N) `5`
-}
n5 : N (In (Up5 minX_) (Up5 maxX_))
n5 =
    n4 |> add n1


{-| The [`N`](#N) `6`
-}
n6 : N (In (Up6 minX_) (Up6 maxX_))
n6 =
    n5 |> add n1


{-| The [`N`](#N) `7`
-}
n7 : N (In (Up7 minX_) (Up7 maxX_))
n7 =
    n6 |> add n1


{-| The [`N`](#N) `8`
-}
n8 : N (In (Up8 minX_) (Up8 maxX_))
n8 =
    n7 |> add n1


{-| The [`N`](#N) `9`
-}
n9 : N (In (Up9 minX_) (Up9 maxX_))
n9 =
    n8 |> add n1


{-| The [`N`](#N) `10`
-}
n10 : N (In (Up10 minX_) (Up10 maxX_))
n10 =
    n9 |> add n1


{-| The [`N`](#N) `11`
-}
n11 : N (In (Up11 minX_) (Up11 maxX_))
n11 =
    n10 |> add n1


{-| The [`N`](#N) `12`
-}
n12 : N (In (Up12 minX_) (Up12 maxX_))
n12 =
    n11 |> add n1


{-| The [`N`](#N) `13`
-}
n13 : N (In (Up13 minX_) (Up13 maxX_))
n13 =
    n12 |> add n1


{-| The [`N`](#N) `14`
-}
n14 : N (In (Up14 minX_) (Up14 maxX_))
n14 =
    n13 |> add n1


{-| The [`N`](#N) `15`
-}
n15 : N (In (Up15 minX_) (Up15 maxX_))
n15 =
    n14 |> add n1


{-| The [`N`](#N) `16`
-}
n16 : N (In (Up16 minX_) (Up16 maxX_))
n16 =
    n15 |> add n1



--


{-| Base type of [`N0`](#N0), [`Add1 n`](#Add1) following [`allowable-state`](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/):

  - Is the parameter `possiblyOrNever` set to `Never` like in

        type alias Add1 n =
            N0aOrAdd1 Never n

    `N0` is impossible to construct

  - Is the parameter `possiblyOrNever` set to `Possibly` like in

        type alias N0 =
            N0OrAdd1 Possibly Never

    `N0` is a possible value

-}
type N0OrAdd1 n0PossiblyOrNever successorMinus1
    = N0 n0PossiblyOrNever
    | Add1 successorMinus1


{-| Transfer the knowledge about whether [`n0`](#n0) is a possible value

    trySubtracting1 :
        N (In (Fixed (N0OrAdd1 n0PossiblyOrNever minMinus1)) max)
        -> Emptiable (N (In (Fixed minMinus1) max)) possiblyOrNever
    trySubtracting1 =
        \n ->
            case n |> N.isAtLeast1 of
                Err possiblyOrNever ->
                    Emptiable.Empty possiblyOrNever

                Ok atLeast1 ->
                    atLeast1 |> N.sub n1

    stackRepeat :
        element
        -> N (In (Fixed (N0OrAdd1 possiblyOrNever minMinus1_)) max_)
        -> Emptiable (Stacked element) possiblyOrNever
    stackRepeat toRepeat length =
        case length |> N.isAtLeast1 of
            Err possiblyOrNever ->
                Emptiable.Empty possiblyOrNever

            Ok lengthAtLeast1 ->
                Stack.topBelow
                    toRepeat
                    (List.repeat
                        (lengthAtLeast1 |> N.sub n1 |> N.toInt)
                        toRepeat
                    )

    stackLength :
        Emptiable (Stacked element) possiblyOrNever
        -> N (Min (Fixed (N0OrAdd1 possiblyOrNever N0)))
    stackLength =
        \stack ->
            case stack of
                Emptiable.Empty possiblyOrNever ->
                    -- adapt the variable minimum
                    n0 |> N.min0Adapt (\_ -> possiblyOrNever) |> N.maxToInfinity

                Emptiable.Filled (TopBelow ( _, belowTop )) ->
                    belowTop
                        |> List.length
                        |> N.intToAtLeast n0
                        |> N.add n1
                        -- downgrade the minimum
                        |> N.min0Adapt never

using [`N.min0Adapt`](#min0Adapt)

Cool, right?

-}
isAtLeast1 :
    N (In (Fixed (N0OrAdd1 n0PossiblyOrNever minMinus1)) max)
    ->
        Result
            n0PossiblyOrNever
            (N (In (Fixed (Add1 minMinus1)) max))
isAtLeast1 =
    \n ->
        case n |> min |> fixedToNumber of
            N0 possiblyOrNever ->
                possiblyOrNever |> Err

            Add1 successor ->
                n
                    |> toInt
                    |> LimitedIn
                        (Range
                            { min =
                                Difference
                                    { up = \_ -> successor |> Add1
                                    , down = \_ -> N0 Possible
                                    , toInt = n |> min |> differenceToInt
                                    }
                            , max = n |> max
                            }
                        )
                    |> Ok


{-| Change the `possiblyOrNever` type for the case that its [`min`](#min) is 0

`never` allows you to adapt any variable,
`\_ -> yourVariablePossiblyOrNever` swaps it for your given variable

    stackLength :
        Emptiable (Stacked element) possiblyOrNever
        -> N (Min (Fixed (N0OrAdd1 possiblyOrNever N0)))
    stackLength =
        \stack ->
            case stack of
                Emptiable.Empty possiblyOrNever ->
                    -- adapt the variable minimum
                    n0 |> N.min0Adapt (\_ -> possiblyOrNever) |> N.maxToInfinity

                Emptiable.Filled (TopBelow ( _, belowTop )) ->
                    belowTop
                        |> List.length
                        |> N.intToAtLeast n0
                        |> N.add n1
                        -- downgrade the minimum
                        |> N.min0Adapt never

using [`isAtLeast1`](#isAtLeast1).

with `(\_ -> Possible)` it's just a worse version of [`minSubtract`](#minSubtract)
that might be useful in ultra rare situations

    minSubtract1IfPossible :
        N (In (Fixed (N0OrAdd1 possiblyOrNever minMinus1)) max)
        -> N (In (Fixed (N0OrAdd1 Possibly minMinus1)) max)
    minSubtract1IfPossible =
        N.min0Adapt (\_ -> Possibly)

-}
min0Adapt :
    (possiblyOrNever -> adaptedPossiblyOrNever)
    -> N (In (Fixed (N0OrAdd1 possiblyOrNever minMinus1)) max)
    -> N (In (Fixed (N0OrAdd1 adaptedPossiblyOrNever minMinus1)) max)
min0Adapt n0PossiblyOrNeverAdapt =
    \n ->
        n
            |> toInt
            |> LimitedIn
                (Range
                    { min = n |> min |> fixed0Adapt n0PossiblyOrNeverAdapt
                    , max = n |> max
                    }
                )


{-| Change the `possiblyOrNever` type
for the case that its [`N0OrAdd1`](#N0OrAdd1) representation is [`N0`](#N0OrAdd1)
-}
fixed0Adapt :
    (possiblyOrNever -> adaptedPossiblyOrNever)
    -> Fixed (N0OrAdd1 possiblyOrNever endMinus1)
    -> Fixed (N0OrAdd1 adaptedPossiblyOrNever endMinus1)
fixed0Adapt n0PossiblyOrNeverAdapt =
    \(Difference difference) ->
        Difference
            { up =
                \start ->
                    start
                        |> difference.up
                        |> number0Adapt n0PossiblyOrNeverAdapt
            , down = \_ -> N0 Possible
            , toInt = difference.toInt
            }


{-| Change the `possiblyOrNever` type
for the case that the [`N0OrAdd1`](#N0OrAdd1) is [`N0`](#N0OrAdd1)
-}
number0Adapt :
    (n0PossiblyOrNever -> adaptedN0PossiblyOrNever)
    -> N0OrAdd1 n0PossiblyOrNever minus1
    -> N0OrAdd1 adaptedN0PossiblyOrNever minus1
number0Adapt n0PossiblyOrNeverAdapt =
    \n ->
        case n of
            Add1 minus1 ->
                minus1 |> Add1

            N0 possiblyOrNever ->
                N0 (possiblyOrNever |> n0PossiblyOrNeverAdapt)


{-| The [natural number](#N0OrAdd1) `1 +` a given `n`
-}
type alias Add1 n =
    N0OrAdd1 Never n


{-| The [natural number](#N0OrAdd1) `2 +` a given `n`
-}
type alias Add2 n =
    N0OrAdd1 Never (N0OrAdd1 Never n)


{-| The [natural number](#N0OrAdd1) `3 +` a given `n`
-}
type alias Add3 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))


{-| The [natural number](#N0OrAdd1) `4 +` a given `n`
-}
type alias Add4 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))


{-| The [natural number](#N0OrAdd1) `5 +` a given `n`
-}
type alias Add5 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))


{-| The [natural number](#N0OrAdd1) `6 +` a given `n`
-}
type alias Add6 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))


{-| The [natural number](#N0OrAdd1) `7 +` a given `n`
-}
type alias Add7 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))))


{-| The [natural number](#N0OrAdd1) `8 +` a given `n`
-}
type alias Add8 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))))


{-| The [natural number](#N0OrAdd1) `9 +` a given `n`
-}
type alias Add9 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))))))


{-| The [natural number](#N0OrAdd1) `10 +` a given `n`
-}
type alias Add10 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))))))


{-| The [natural number](#N0OrAdd1) `11 +` a given `n`
-}
type alias Add11 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))))))))


{-| The [natural number](#N0OrAdd1) `12 +` a given `n`
-}
type alias Add12 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))))))))


{-| The [natural number](#N0OrAdd1) `13 +` a given `n`
-}
type alias Add13 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))))))))))


{-| The [natural number](#N0OrAdd1) `14 +` a given `n`
-}
type alias Add14 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))))))))))


{-| The [natural number](#N0OrAdd1) `15 +` a given `n`
-}
type alias Add15 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n))))))))))))))


{-| The [natural number](#N0OrAdd1) `16 +` a given `n`
-}
type alias Add16 n =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never n)))))))))))))))


{-| The [natural number](#N0OrAdd1) `0`
-}
type alias N0 =
    N0OrAdd1 Possibly Never


{-| The [natural number](#N0OrAdd1) `1`
-}
type alias N1 =
    N0OrAdd1 Never (N0OrAdd1 Possibly Never)


{-| The [natural number](#N0OrAdd1) `2`
-}
type alias N2 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))


{-| The [natural number](#N0OrAdd1) `3`
-}
type alias N3 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))


{-| The [natural number](#N0OrAdd1) `4`
-}
type alias N4 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))


{-| The [natural number](#N0OrAdd1) `5`
-}
type alias N5 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))


{-| The [natural number](#N0OrAdd1) `6`
-}
type alias N6 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))


{-| The [natural number](#N0OrAdd1) `7`
-}
type alias N7 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))))


{-| The [natural number](#N0OrAdd1) `8`
-}
type alias N8 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))))


{-| The [natural number](#N0OrAdd1) `9`
-}
type alias N9 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))))))


{-| The [natural number](#N0OrAdd1) `10`
-}
type alias N10 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))))))


{-| The [natural number](#N0OrAdd1) `11`
-}
type alias N11 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))))))))


{-| The [natural number](#N0OrAdd1) `12`
-}
type alias N12 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))))))))


{-| The [natural number](#N0OrAdd1) `13`
-}
type alias N13 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))))))))))


{-| The [natural number](#N0OrAdd1) `14`
-}
type alias N14 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))))))))))


{-| The [natural number](#N0OrAdd1) `15`
-}
type alias N15 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never)))))))))))))))


{-| The [natural number](#N0OrAdd1) `16`
-}
type alias N16 =
    N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Possibly Never))))))))))))))))


{-| `0` as the difference `Up x To x`
-}
type alias Up0 x =
    Up x To x


{-| `1` as the difference `Up x To (N0OrAdd1 Possibly x)`
-}
type alias Up1 x =
    Up x To (N0OrAdd1 Never x)


{-| `2` as the difference `Up x To (Add2 x)`
-}
type alias Up2 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never x))


{-| `3` as the difference `Up x To (Add3 x)`
-}
type alias Up3 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))


{-| `4` as the difference `Up x To (Add4 x)`
-}
type alias Up4 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))


{-| `5` as the difference `Up x To (Add5 x)`
-}
type alias Up5 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))


{-| `6` as the difference `Up x To (Add6 x)`
-}
type alias Up6 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))


{-| `7` as the difference `Up x To (Add7 x)`
-}
type alias Up7 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))))


{-| `8` as the difference `Up x To (Add8 x)`
-}
type alias Up8 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))))


{-| `9` as the difference `Up x To (Add9 x)`
-}
type alias Up9 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))))))


{-| `10` as the difference `Up x To (Add10 x)`
-}
type alias Up10 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))))))


{-| `11` as the difference `Up x To (Add11 x)`
-}
type alias Up11 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))))))))


{-| `12` as the difference `Up x To (Add12 x)`
-}
type alias Up12 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))))))))


{-| `13` as the difference `Up x To (Add13 x)`
-}
type alias Up13 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))))))))))


{-| `14` as the difference `Up x To (Add14 x)`
-}
type alias Up14 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))))))))))


{-| `15` as the difference `Up x To (Add15 x)`
-}
type alias Up15 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x)))))))))))))))


{-| `16` as the difference `Up x To (Add16 x)`
-}
type alias Up16 x =
    Up x To (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never (N0OrAdd1 Never x))))))))))))))))
