module N exposing
    ( N
    , In, Min, Infinity(..), Exactly
    , On, Up(..), To(..), Down
    , inRandom, inFuzz, inFuzzUniform
    , N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16
    , Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16
    , Up0, Up1, Up2, Up3, Up4, Up5, Up6, Up7, Up8, Up9, Up10, Up11, Up12, Up13, Up14, Up15, Up16
    , n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
    , intToAbsolute, intModBy, intToAtLeast, intToIn
    , intIsAtLeast, intIsIn
    , add, addMin
    , subtract, subtractMin
    , toPower, remainderBy, multiplyBy, divideBy
    , toAtLeastMin, toIn
    , isAtLeast, isAtMost
    , BelowOrAbove(..), is, isIn
    , greater, smaller
    , toInt, toFloat, toString
    , inToNumber, inToOn
    , minToNumber, minToOn
    , maxToNumber, maxToOn
    , minTo, minSubtract, minEndsSubtract
    , maxTo, maxToInfinity, maxAdd, maxEndsSubtract
    , isAtLeast1
    , min0Adapt, minAtLeast1Never
    , range, min, max
    , differenceAdd, differenceSubtract
    , addDifference, subtractDifference
    , N0OrAdd1(..)
    , inRange, minRange, exactlyRange
    , rangeMin, rangeMax
    , rangeAdd, rangeSubtract, rangeMinSubtract, rangeMaxAdd, rangeMinEndsSubtract, rangeMaxEndsSubtract
    , number0Adapt, numberFrom1Map
    , on0Adapt, onFrom1Map
    , rangeIsAtLeast1, rangeMin0Adapt, rangeMinAtLeast1Never
    , onToNumber, toOn
    , rangeInToNumber, rangeInToOn
    , rangeMinToNumber, rangeMinToOn
    , rangeMaxToNumber, rangeMaxToOn
    )

{-| Natural number within a typed range

@docs N


# bounds

@docs In, Min, Infinity, Exactly
@docs On, Up, To, Down


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

type `n` [⏭ skip to last](#N16)

@docs N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16

type `n +` [⏭ skip to last](#Add16)

@docs Add1, Add2, Add3, Add4, Add5, Add6, Add7, Add8, Add9, Add10, Add11, Add12, Add13, Add14, Add15, Add16

type `Up x To (n + x)` [⏭ skip to last](#Up16)

@docs Up0, Up1, Up2, Up3, Up4, Up5, Up6, Up7, Up8, Up9, Up10, Up11, Up12, Up13, Up14, Up15, Up16

exact [⏭ skip to last](#n16)

@docs n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16


## from `Int`

@docs intToAbsolute, intModBy, intToAtLeast, intToIn


### `Int` compare

@docs intIsAtLeast, intIsIn


# alter

@docs add, addMin
@docs subtract, subtractMin
@docs toPower, remainderBy, multiplyBy, divideBy


## clamp

@docs toAtLeastMin, toIn


# compare

@docs isAtLeast, isAtMost
@docs BelowOrAbove, is, isIn
@docs greater, smaller

More advanced stuff in [section type information ) allowable-state](#allowable-state)


# transform

@docs toInt, toFloat, toString


# without internal functions

@docs inToNumber, inToOn
@docs minToNumber, minToOn
@docs maxToNumber, maxToOn


# type information

@docs minTo, minSubtract, minEndsSubtract
@docs maxTo, maxToInfinity, maxAdd, maxEndsSubtract


## allowable-state

Consider this an advanced technique for packages that use
[`allowable-state`](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/).
Any questions @lue in slack!

@docs isAtLeast1
@docs min0Adapt, minAtLeast1Never


# miss an operation?

Anything that can't be expressed with the available operations? → issue/PR


# safe internals

Internal parts you can safely access and transform

While the internally stored `Int` can't directly be guaranteed to be in bounds by elm,
the [minimum](#min) and [maximum](#max)
must be built as actual values checked by the compiler.
No shenanigans like runtime errors for impossible cases

Having those exposed can be useful when building extensions to this library like

  - [`typesafe-array`](https://dark.elm.dmy.fr/packages/lue-bird/elm-typesafe-array/latest/)
  - [`morph`](https://github.com/lue-bird/elm-morph)
  - [`bits`](https://dark.elm.dmy.fr/packages/lue-bird/elm-bits/latest/)

@docs range, min, max
@docs differenceAdd, differenceSubtract
@docs addDifference, subtractDifference

@docs N0OrAdd1


## ranges

@docs inRange, minRange, exactlyRange
@docs rangeMin, rangeMax
@docs rangeAdd, rangeSubtract, rangeMinSubtract, rangeMaxAdd, rangeMinEndsSubtract, rangeMaxEndsSubtract


## [allowable-state](https://dark.elm.dmy.fr/packages/lue-bird/elm-allowable-state/latest/)

@docs number0Adapt, numberFrom1Map
@docs on0Adapt, onFrom1Map
@docs rangeIsAtLeast1, rangeMin0Adapt, rangeMinAtLeast1Never


## safe internals without functions

@docs onToNumber, toOn
@docs rangeInToNumber, rangeInToOn
@docs rangeMinToNumber, rangeMinToOn
@docs rangeMaxToNumber, rangeMaxToOn

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
        |> N.multiplyBy n5
        --: N (Min (Up9 minX_))
        |> N.remainderBy n4
        --: N (In (Up0 minX_) (Up2 maxX_))
        |> N.inToNumber
    --: N (In N0 N3)
    --> n1 |> N.minTo n0 |> N.maxTo n3 |> N.inToNumber


### argument type

    -- ≥ 0, any limitations allowed
    N range_

    -- ≥ 4
    N (In (On (Add4 minFrom4_)) max_)

    -- 4 ≤ n ≤ 15
    N (In (On (Add4 minFrom4_)) (Up maxTo15_ To N15))

`In (On (Add4 minFrom4_)) (Up maxTo15_ To N15)` says:

  - the argument's minimum is 4 `+` some variable `= 4+0`|`4+1`|`4+2`|...
    which means it's ≥ 4
  - the argument's maximum `+` some variable `= 15`
    which means it's ≤ 15


### stored type

what to put in declared types like `Model`

    -- ≥ 4
    N (Min (On N4))

    -- 2 ≤ n ≤ 12
    N (In (On N2) (On N12))

There's also versions of this that don't contain functions internally:

    -- ≥ 4
    N (Min N4)

    -- 2 ≤ n ≤ 12
    N (In N2 N12)

more type examples at [`In`](#In), [`Min`](#Min)

-}
type N range
    = NUnsafe { range : range, int : Int }


{-| somewhere within a minimum & maximum

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...


### argument type in a range

    -- 3 ≤ n ≤ 5
    N (In (On (Add3 minFrom3_)) (Up maxTo5_ To N5))

    -- 0 ≤ n ≤ 100
    percent : N (In min_ (Up maxTo100_ To N100)) -> Percent

For every constructable value, the minimum is smaller than the maximum
(that's why [`In`](#In) is opaque)

If you want a number where you just care about the minimum, leave `max` as a type _variable_

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

    -- any natural number
    N (In min_ max_)

A number, at least 5:

    N (In (On (Add5 minFrom_)) max_)

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
        Tree (Exactly (On N2)) element

Remember: ↑ and other `... (`[`On`](#On)`...)`
are result/stored types, not argument types

---

Do not use `==` on 2 values storing a range.
It will lead to elm crashing because [difference](#Up)s are stored as functions.
Instead,

  - [compare](#compare) in _your_ code
  - convert to [a value](#without-internal-functions) for _other_ code
    that relies (or performs better) on structural `==`

-}
type In minimumAsDifference maximumAsDifference
    = RangeUnsafe
        { min : minimumAsDifference
        , max : maximumAsDifference
        }


{-| Only **stored / result types should use `Min`**

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
    N (In (On (Add5 minFrom5_)) max_)


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
        Tree (Min (On N1)) element

Remember: ↑ and other `... (`[`On`](#On)`...)`
are result/stored types, not argument types

You can just use [`Min`](#Min) `(` [`On`](#On) `...)` when you don't have disadvantages storing functions.

[Can't store functions?](#without-internal-functions)

-}
type alias Min lowestPossibleAsDifference =
    In lowestPossibleAsDifference Infinity


{-| Allow only a specific given represented number

result type:

    Exactly (On N3)

Use `Exactly  ...` without [`On`](#On)
for **storing** in a type [without internal functions](#without-internal-functions)

    Exactly N3

This is pretty useless in combination with [`N`](#N)

    -- argument type
    numberToInt : N (Exactly n) -> n -> Int
    numberToInt wellThisWasPointless _ =
        wellThisWasPointless |> N.toInt

It _is_ useful as a **stored & argument** type
in combination with [`typesafe-array`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/),

    byte : ArraySized (Exactly (On N8)) Bit -> Byte

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s

    type alias TicTacToeBoard =
        ArraySized
            (Exactly (On N3))
            (ArraySized (Exactly (On N3)) TicTacToeField)

→ A given [`ArraySized`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s

-}
type alias Exactly representation =
    In representation representation


{-| `Up low To high`: a specific number represented as the difference `high - low`
-}
type Up lowNumber toTag highNumber
    = Difference
        { up : lowNumber -> highNumber
        , down : highNumber -> lowNumber
        }


{-| "The limit is unknown".

Used in the definition of [`Min`](#Min)

    type alias Min min =
        In minimum Infinity

-}
type Infinity
    = Infinity



-- difference


{-| Increase a [number](#N0OrAdd1) by a given [difference](#Up)

    successor : n -> Add1 n
    successor =
        -- FYI: equivalent to Add1
        N.addDifference (n1 |> N.min)

    n10 |> N.min |> successor
    --> n11 |> min

-}
addDifference : Up low To high -> (low -> high)
addDifference =
    \(Difference differenceOperation) ->
        differenceOperation.up


{-| Decrease the [natural number](#N0OrAdd1) by a given [difference](#Down)

    predecessor : Add1 predecessor -> predecessor
    predecessor =
        N.subtractDifference (n1 |> N.min)

    n10 |> N.min |> predecessor
    --> n9 |> min

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
            }


{-| Chain the [difference](#Up) [`Down`](#Down) to a lower [number](#N0OrAdd1)
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
            }


{-| Create a [range](#In) with a given representation = minimum = maximum

    N.intToIn ( n3, n6 ) 5
        |> N.min
        |> N.exactlyRange
    --: In (Up3 x) (Up3 x)

-}
exactlyRange : limitRepresentation -> In limitRepresentation limitRepresentation
exactlyRange difference =
    RangeUnsafe { min = difference, max = difference }


{-| Create a [range](#In) with a given representation as the minimum
and [`Infinity`](#Infinity) as the maximum

    N.intToIn ( n3, n6 ) 5
        |> N.min
        |> N.minRange
    --: Min (Up3 x)

-}
minRange : min -> Min min
minRange =
    \lowestPossible ->
        RangeUnsafe
            { min = lowestPossible
            , max = Infinity
            }


{-| Create a [range](#In)
from the lowest possible representation of a given lower [range](#In)
to the highest possible representation of a given higher [range](#In)
-}
inRange :
    ( In minMin (Up minMaxToMaxMin_ To maxMin)
    , In (On maxMin) maxMax
    )
    -> In minMin maxMax
inRange ( lowerLimit, upperLimit ) =
    RangeUnsafe
        { min = lowerLimit |> rangeMin
        , max = upperLimit |> rangeMax
        }



-- range


rangeToRecord : In min max -> { min : min, max : max }
rangeToRecord =
    \(RangeUnsafe rangeInfo) -> rangeInfo


{-| The [range](#In)'s lowest possible representation
-}
rangeMin : In min max_ -> min
rangeMin =
    \range_ -> range_ |> rangeToRecord |> .min


{-| The [range](#In)'s highest possible representation
-}
rangeMax : In min_ max -> max
rangeMax =
    \range_ -> range_ |> rangeToRecord |> .max


{-| Subtract its minimum by a given [difference](#Up)
-}
rangeMinSubtract :
    Down minPlusX To minDecreasedPlusX
    ->
        (In (Up x To minPlusX) max
         -> In (Up x To minDecreasedPlusX) max
        )
rangeMinSubtract minRelativeDecrease =
    \range_ ->
        RangeUnsafe
            { min =
                range_
                    |> rangeMin
                    |> differenceSubtract minRelativeDecrease
            , max = range_ |> rangeMax
            }


{-| Add a given [difference](#Up) to its maximum
-}
rangeMaxAdd :
    Up maxPlusX To maxIncreasedPlusX
    ->
        (In min (Up maxX To maxPlusX)
         -> In min (Up maxX To maxIncreasedPlusX)
        )
rangeMaxAdd maxRelativeIncrease =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin
            , max =
                (range_ |> rangeMax)
                    |> differenceAdd maxRelativeIncrease
            }


{-| Add a given [difference](#Up) to its minimum and maximum
-}
rangeAdd :
    In
        (Up minPlusX To minIncreasedPlusX)
        (Up maxPlusX To maxIncreasedPlusX)
    ->
        (In (Up minX To minPlusX) (Up maxX To maxPlusX)
         ->
            In
                (Up minX To minIncreasedPlusX)
                (Up maxX To maxIncreasedPlusX)
        )
rangeAdd toSubtract =
    \range_ ->
        RangeUnsafe
            { min =
                range_
                    |> rangeMin
                    |> differenceAdd (toSubtract |> rangeMin)
            , max =
                range_
                    |> rangeMax
                    |> differenceAdd (toSubtract |> rangeMax)
            }


{-| Subtract its minimum and maximum by a given [difference](#Up)
-}
rangeSubtract :
    In
        (Down maxPlusX To maxDecreasedPlusX)
        (Down min To minDecreased)
    ->
        (In (On min) (Up maxX To maxPlusX)
         ->
            In
                (On minDecreased)
                (Up maxX To maxDecreasedPlusX)
        )
rangeSubtract toSubtract =
    \range_ ->
        RangeUnsafe
            { min =
                range_
                    |> rangeMin
                    |> differenceSubtract (toSubtract |> rangeMax)
            , max =
                range_
                    |> rangeMax
                    |> differenceSubtract (toSubtract |> rangeMin)
            }


{-| Change its minimum's `possiblyOrNever` type
for the case that the [`N0OrAdd1`](#N0OrAdd1) is [`N0`](#N0OrAdd1)
-}
rangeMin0Adapt :
    (possiblyOrNever -> adaptedPossiblyOrNever)
    -> In (On (N0OrAdd1 possiblyOrNever minFrom1)) max
    -> In (On (N0OrAdd1 adaptedPossiblyOrNever minFrom1)) max
rangeMin0Adapt n0PossiblyOrNeverAdapt =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin |> on0Adapt n0PossiblyOrNeverAdapt
            , max = range_ |> rangeMax
            }


{-| For the case that its [`min`](#min) is 1 + ..., allow adapting any variable.
This is possible because we currently have a minimum that is `Never` >= 1
-}
rangeMinAtLeast1Never :
    In (On (N0OrAdd1 possiblyOrNever Never)) max
    -> In (On (N0OrAdd1 possiblyOrNever minFrom1_)) max
rangeMinAtLeast1Never =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin |> onFrom1Map never
            , max = range_ |> rangeMax
            }


{-| Transfer the knowledge about whether [`n0`](#n0) is a possible value
-}
rangeIsAtLeast1 :
    N (In (On (N0OrAdd1 n0PossiblyOrNever minFrom1_)) max)
    -> Result n0PossiblyOrNever (In (Up1 minX_) max)
rangeIsAtLeast1 =
    \n ->
        case n |> min |> onToNumber of
            N0 possiblyOrNever ->
                case n |> isAtLeast n1 of
                    Err _ ->
                        possiblyOrNever |> Err

                    Ok atLeast1 ->
                        atLeast1 |> range |> Ok

            Add1 _ ->
                -- unsatisfying :(
                RangeUnsafe
                    { min = n1 |> min
                    , max = n |> max
                    }
                    |> Ok


{-| [`In`](#In) [`(On ...) (On ...)`](#On) → equatable [`In`](#In)
-}
rangeInToNumber : In (On min) (On max) -> In min max
rangeInToNumber =
    \range_ ->
        range_ |> rangeMinToNumber |> rangeMaxToNumber


{-| Make [range](#In)'s [`On`](#On) minimum equatable
-}
rangeMinToNumber : In (On min) max -> In min max
rangeMinToNumber =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin |> onToNumber
            , max = range_ |> rangeMax
            }


{-| Make [range](#In)'s [`On`](#On) maximum equatable
-}
rangeMaxToNumber : In min (On max) -> In min max
rangeMaxToNumber =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin
            , max = range_ |> rangeMax |> onToNumber
            }


{-| equatable [`In`](#In) → [`In`](#In) [`(On ...) (On ...)`](#On)
-}
rangeInToOn : In min max -> In (On min) (On max)
rangeInToOn =
    \range_ ->
        range_ |> rangeMinToOn |> rangeMaxToOn


{-| Make [range](#In)'s equatable minimum [`On`](#On)
-}
rangeMinToOn : In min max -> In (On min) max
rangeMinToOn =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin |> toOn
            , max = range_ |> rangeMax
            }



-- range compare


{-| Make [range](#In)'s equatable maximum [`On`](#On)
-}
rangeMaxToOn : In min max -> In min (On max)
rangeMaxToOn =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin
            , max = range_ |> rangeMax |> toOn
            }


{-| The [`N0OrAdd1`](#N0OrAdd1) represented by this [`On`](#On) [difference](#Up)

    import Possibly exposing (Possibly(..))

    N.intToIn ( n3, n10 ) 5
        |> N.min
        |> N.onToNumber
    --> N.Add1 (N.Add1 (N.Add1 (N.N0 Possible)))

useful

  - to preserve emptiness knowledge

        predecessor :
            N0OrAdd1 possiblyOrNever from1
            -> Emptiable from1 possiblyOrNever
        predecessor =
            \number ->
                case number of
                    N.N0 possiblyOrNever ->
                        Emptiable.Empty possiblyOrNever

                    N.Add1 predecessor ->
                        predecessor |> Emptiable.filled

  - as a tag

        type Element index
            = Element index

        element :
            N (Exactly (On index))
            -> Mapping (List element) (Element index) (Maybe element)
        element index =
            Typed.tag
                (Element (index |> N.min |> N.onToNumber))
                List.Extra.getAt

Can be altered with [`addDifference`](#addDifference), [`subtractDifference`](#subtractDifference).

To preserve the ability to turn the number into an `Int`, use [`onToNumber`](#onToNumber)

-}
onToNumber : On representedNumber -> representedNumber
onToNumber =
    \on_ ->
        N0 Possible |> addDifference on_


{-| equatable number → [`On`](#On)
-}
toOn : asNumber -> On asNumber
toOn =
    \number ->
        Difference
            { up = \_ -> number
            , down = \_ -> N0 Possible
            }



-- range On


{-| Number with [`On`](#On) [range](#In) → number with equatable [range](#In)

If you want an equatable `Min ...` [`N`](#N), you instead only need [`minToNumber`](#minToNumber)

-}
inToNumber : N (In (On min) (On max)) -> N (In min max)
inToNumber =
    \n ->
        n |> minToNumber |> maxToNumber


{-| [`N`](#N) with [`On`](#On) minimum
→ [`N`](#N) with equatable minimum number

You'll usually use this to convert to an equatable `Min ...` [`N`](#N)

-}
minToNumber : N (In (On min) max) -> N (In min max)
minToNumber =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range = n |> range |> rangeMinToNumber
            }


{-| [`N`](#N) with [`On`](#On) maximum
→ [`N`](#N) with equatable maximum number
-}
maxToNumber : N (In min (On max)) -> N (In min max)
maxToNumber =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range = n |> range |> rangeMaxToNumber
            }


{-| [`N`](#N) with equatable number [range](#In)
→ [`N`](#N) with [`On`](#On) [range](#In) to be [altered](#alter), [compared](#compare), ...

If you want a `Min (On ...)` [`N`](#N), you instead only need [`minToOn`](#minToOn)

-}
inToOn : N (In min max) -> N (In (On min) (On max))
inToOn =
    \n ->
        n |> minToOn |> maxToOn


{-| [`N`](#N) with equatable minimum number
→ [`N`](#N) with [`On`](#On) minimum

You'll usually use this to convert to a `Min (On ...)` [`N`](#N)

-}
minToOn : N (In min max) -> N (In (On min) max)
minToOn =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range = n |> range |> rangeMinToOn
            }


{-| [`N`](#N) with an equatable maximum number
→ [`N`](#N) with [`On`](#On) maximum
-}
maxToOn : N (In min max) -> N (In min (On max))
maxToOn =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range = n |> range |> rangeMaxToOn
            }



--


{-| `Down high To low`: a specific number represented as the difference `high - low`
-}
type alias Down high toTag low =
    Up low toTag high


{-| Just a word in a [difference type](#Up):

    Up low To high

    Down high To low

→ distance `high - low`

-}
type To
    = To Never


{-| The fixed [difference](#Up) from [`0`](#N0) to a given [number](#N0OrAdd1) `n`

You'll find this either to require a certain minimum

    entryOnlyForKids : N (In (On (Add6 minFrom6_)) (Up maxTo14_ To N14)) -> ()
    entryOnlyForKids _ =
        ()

Or in a stored type, which looks like a [result type](#result-type)
where every [`Up<n> x`](#Up) is instead [`On N<n>`](#On)

Do not use `==` on 2 numbers in a [`On`](#On) [range](#In).
It will lead to elm crashing because [difference](#Up)s are stored as functions internally.

Instead, [compare](#compare) in _your_ code
or convert to a value for _other_ code:

Not storing functions etc. in app state, events, ... enables

  - serializability, for example
      - json import/export on the debugger → doesn't work
  - calling `==`, for example
      - on hot module reloading,
        old code might end up remaining in the model
      - [lamdera](https://www.lamdera.com/) → doesn't work
      - accidental `==` call → crash

Calling `==` on a value will yield the correct result instead of crashing

[`On` is defined as a difference from 0](#On), so this independent type needed to be created

You can just use [`On`](#On) when you don't have disadvantages storing functions

-}
type alias On asNumber =
    Up N0 To asNumber


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
            |> intToAtLeast n0


{-| Perform [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic) by an [`N`](#N) `d ≥ 1`.
That means `x % d ≤ d - 1`

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
            (On (Add1 minFrom1_))
            (Up maxX To (Add1 maxFrom1PlusX))
        )
    ->
        (Int
         -> N (In (Up0 remainderMinX_) (Up maxX To maxFrom1PlusX))
        )
intModBy divisor =
    \int ->
        int
            |> Basics.modBy (divisor |> toInt)
            |> intToIn
                ( n0, divisor |> subtract n1 )


{-| Generate a random [`N`](#N) in a range

    N.inRandom ( n1, n10 )
    --: Random.Generator
    --:     (N (In (Up1 minX_) (Up10 maxX_)))

-}
inRandom :
    ( N (In minMin (Up minMaxToMaxMin_ To maxMin))
    , N (In (On maxMin) maxMax)
    )
    -> Random.Generator (N (In minMin maxMax))
inRandom ( lowestPossible, highestPossible ) =
    Random.map
        (intToIn ( lowestPossible, highestPossible ))
        (Random.int
            (lowestPossible |> toInt)
            (highestPossible |> toInt)
        )


{-| `Fuzzer` for an [`N`](#N) in a given range.
For larger ranges, smaller [`N`](#N)s are preferred

    import Fuzz

    N.inFuzz ( n3, n6 )
        |> Fuzz.map N.toInt
        |> Fuzz.examples 10
    --> [ 5, 6, 3, 3, 4, 6, 3, 6, 3, 5 ]

-}
inFuzz :
    ( N (In minMin (Up minMaxToMaxMin_ To maxMin))
    , N (In (On maxMin) maxMax)
    )
    -> Fuzzer (N (In minMin maxMax))
inFuzz ( lowestPossible, highestPossible ) =
    Fuzz.map
        (intToIn ( lowestPossible, highestPossible ))
        (Fuzz.intRange
            (lowestPossible |> toInt)
            (highestPossible |> toInt)
        )


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
    ( N (In minMin (Up minMaxToMaxMin_ To maxMin))
    , N (In (On maxMin) maxMax)
    )
    -> Fuzzer (N (In minMin maxMax))
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

    inputIntParse : Int -> Result String (N (In (Up1 minX_) (Up10 maxX_)))
    inputIntParse =
        N.intIsIn ( n1, n10 )
            >> Result.mapError
                (\outOfRange ->
                    case outOfRange of
                        N.Below _ ->
                            "≤ 0"
                        N.Above _ ->
                            "≥ 11"
                )

    0 |> inputIntParse
    --> Err "≤ 0"

-}
intIsIn :
    ( N (In minMin (Up minMaxToMaxMin_ To maxMin))
    , N
        (In
            (On maxMin)
            (Up maxMaxX To maxMaxPlusX)
        )
    )
    ->
        (Int
         ->
            Result
                (BelowOrAbove
                    Int
                    (N (Min (Up maxMaxX To (Add1 maxMaxPlusX))))
                )
                (N (In minMin (Up maxMaxX To maxMaxPlusX)))
        )
intIsIn ( lowerLimit, upperLimit ) =
    \int ->
        if int < (lowerLimit |> toInt) then
            int |> Below |> Err

        else if int > (upperLimit |> toInt) then
            NUnsafe
                { int = int
                , range =
                    (upperLimit |> max)
                        |> differenceAdd (n1 |> min)
                        |> minRange
                }
                |> Above
                |> Err

        else
            NUnsafe
                { int = int
                , range =
                    inRange ( lowerLimit |> range, upperLimit |> range )
                }
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
            NUnsafe
                { int = int
                , range = lowerLimit |> min |> minRange
                }
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
            minMin
            (Up minMaxToMaxMin_ To maxMin)
        )
    , N (In (On maxMin) maxMax)
    )
    ->
        (Int
         -> N (In minMin maxMax)
        )
intToIn ( lowerLimit, upperLimit ) =
    \int ->
        NUnsafe
            { int =
                int
                    |> Basics.max (lowerLimit |> toInt)
                    |> Basics.min (upperLimit |> toInt)
            , range =
                inRange ( lowerLimit |> range, upperLimit |> range )
            }


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
    N (In min max_)
    ->
        (Int
         -> N (Min min)
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

    between5And12 |> N.toIn ( n10, n12 )
    --: N (In (Up10 minX_) (Up12 maxX_))

    atLeast5 |> N.toIn ( n5, n10 )
    --: N (In (Up5 minX_) (Up10 maxX_))

    n15
        |> N.toIn ( n10, n15 )
        --: N (In (Up10 minX_) (Up15 max_))
        |> N.toInt
    --> 15

    N.intToAtLeast n3 12345
        |> N.toIn ( n3, N.intToIn ( n4, n5 ) 5 )
        --: N (In (Up3 minX_) (Up5 maxX_))
        |> N.toInt
    --> 5

There shouldn't be an upper limit? → [`toAtLeastMin`](#toAtLeastMin)

(The type doesn't forbid that the limits you're comparing against
are beyond the current limits)

-}
toIn :
    ( N (In minMin (Up minNewMaxToMaxNewMin_ To maxMin))
    , N (In (On maxMin) maxMax)
    )
    ->
        (N range_
         -> N (In minMin maxMax)
        )
toIn ( lowerLimit, upperLimit ) =
    \n ->
        n |> toInt |> intToIn ( lowerLimit, upperLimit )



--


{-| **Cap** the [`N`](#N) to `>=` a given new lower limit

    n5AtLeast |> N.toAtLeastMin n10
    --: N (Min (Up10 x_))

The type doesn't forbid that the lower limit you're comparing against
is below the current lower limit

    n15AtLeast |> N.toAtLeastMin n10 |> N.toInt
    --: N (Min (Up10 x_))

To clamp its maximum, too, [`toIn`](#toIn)

-}
toAtLeastMin :
    N (In min max_)
    ->
        (N range_
         -> N (Min min)
        )
toAtLeastMin lowerLimit =
    \n ->
        n
            |> toInt
            |> intIsAtLeast lowerLimit
            |> Result.withDefault (lowerLimit |> maxToInfinity)


{-| Multiply by a given [`n`](#N) `≥ 1`.
That means `x * n ≥ x`

    atLeast5 |> N.multiplyBy n2
    --: N (Min (Up5 x_))

    atLeast2 |> N.multiplyBy n5
    --: N (Min (Up2 x_))

-}
multiplyBy :
    N (In (On (Add1 multiplicandMinFrom1_)) multiplicandMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
multiplyBy multiplicand =
    \n ->
        (n |> toInt)
            * (multiplicand |> toInt)
            |> intToAtLeast n


{-| Divide (`//`) by an [`N`](#N) `d ≥ 1`
That means `x / d ≤ x`

    atMost7
        |> N.divideBy n3
        --: N (In (Up0 minX_) (Up7 maxX_))
        |> N.toInt

-}
divideBy :
    N (In (On (Add1 divisorMinFrom1_)) divisorMax_)
    ->
        (N (In (On min_) max)
         -> N (In (Up0 minX_) max)
        )
divideBy divisor =
    \n ->
        (n |> toInt)
            // (divisor |> toInt)
            |> intToIn ( n0, n )


{-| The remainder after dividing by an [`N`](#N) `d ≥ 1`.
That means `x % d ≤ d - 1`

    atMost7 |> N.remainderBy n3
    --: N (In (Up0 minX_) (Up2 maxX_))

-}
remainderBy :
    N
        (In
            (On (Add1 divisorMinFrom1_))
            (Up divMaxX To (Add1 divisorMaxFrom1PlusX))
        )
    ->
        (N range_
         ->
            N
                (In
                    (Up0 remainderMinX_)
                    (Up divMaxX To divisorMaxFrom1PlusX)
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
    N (In (On (Add1 exponentMinFrom1_)) exponentMax_)
    ->
        (N (In min max_)
         -> N (Min min)
        )
toPower exponent =
    \n ->
        (n |> toInt)
            ^ (exponent |> toInt)
            |> intToAtLeast n


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
        NUnsafe
            { int = n |> toInt
            , range = n |> min |> minRange
            }


{-| Make it fit into functions with require a higher maximum.

You should type arguments and stored types as broad as possible

    onlyAtMost18 : N (In min_ (Up maxTo18_ To N18)) -> ...

    onlyAtMost18 between3And8 -- works

But once you implement `onlyAtMost18`, you might use the `n` in `onlyAtMost19`:

    onlyAtMost18 n =
        -- onlyAtMost19 n → error
        onlyAtMost19 (n |> N.maxTo n18)

To increase its maximum by a relative amount, [`maxAdd`](#maxAdd)

-}
maxTo :
    N (In (On maxNewMin) maxNew)
    ->
        (N (In min (Up maxToMaxNewMin_ To maxNewMin))
         -> N (In min maxNew)
        )
maxTo maximumNew =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range =
                inRange ( n |> range, maximumNew |> range )
            }


{-| Increase its maximum by a given relative amount.

To set its maximum to a specific absolute value, [`N.maxTo`](#maxTo)

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
        NUnsafe
            { int = n |> toInt
            , range =
                n |> range |> rangeMaxAdd (maxRelativeIncrease |> max)
            }


{-| Set its minimum lower

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `N (Min N3)`

    [ atLeast3
    , atLeast4 |> N.minTo n3
    ]

To decrease its minimum by a relative amount, [`minSubtract`](#minSubtract)

-}
minTo :
    N (In minNew (Up minNewMaxToMin_ To min))
    ->
        (N (In (On min) max)
         -> N (In minNew max)
        )
minTo newMinimum =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range =
                inRange ( newMinimum |> range, n |> range )
            }


{-| Decrease its minimum by a given relative amount.

To set its minimum to a specific absolute value, [`minTo`](#minTo)

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
        NUnsafe
            { int = n |> toInt
            , range =
                n |> range |> rangeMinSubtract (minRelativeDecrease |> max)
            }


{-| The error result of comparing [`N`](#N)s

  - `Above`: greater than what it's compared against
  - `Below`: less than what it's compared against

Values exist for each condition

-}
type BelowOrAbove below above
    = Below below
    | Above above


toRecord : N range -> { int : Int, range : range }
toRecord =
    \(NUnsafe n) -> n


{-| Drop the range constraints
to feed another library with its `Int` representation

    n3
        |> N.add n5
        |> N.divideBy n3
        |> N.toInt
    --> 2

-}
toInt : N range_ -> Int
toInt =
    \n -> n |> toRecord |> .int


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
        { age : N (In (On (Add19 minFrom9_)) max_) }
        -> Book

(The type doesn't forbid that the number you're comparing against
is below the current minimum or above the current maximum.
→ `Err` or `Ok` values don't necessarily follow `min ≤ max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
is :
    N
        (In
            (Up minX To (Add1 vsMinFrom1PlusX))
            (Up maxX To (Add1 vsMaxFrom1PlusX))
        )
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (N (In min (Up maxX To vsMaxFrom1PlusX)))
                    (N (In (Up minX To (Add2 vsMinFrom1PlusX)) max))
                )
                (N
                    (In
                        (Up minX To (Add1 vsMinFrom1PlusX))
                        (Up maxX To (Add1 vsMaxFrom1PlusX))
                    )
                )
        )
is vs =
    \n -> n |> isIn ( vs, vs )


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
→ `Err` or `Ok` values don't necessarily follow `min ≤ max` for `N (In min max ...)`
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
            minMin
            (Up minMaxX To (Add1 minMaxFrom1PlusX))
        )
    , N
        (In
            (Up maxMinX To maxMinPlusX)
            maxMax
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
                            (Up minMaxX To minMaxFrom1PlusX)
                        )
                    )
                    (N
                        (In
                            (Up maxMinX To (Add1 maxMinPlusX))
                            max
                        )
                    )
                )
                (N (In minMin maxMax))
        )
isIn ( lowerLimit, upperLimit ) =
    \n ->
        case n |> isInRange ( lowerLimit, upperLimit ) of
            Err (Below below) ->
                NUnsafe { int = n |> toInt, range = below }
                    |> Below
                    |> Err

            Err (Above above) ->
                NUnsafe { int = n |> toInt, range = above }
                    |> Above
                    |> Err

            Ok inRangeRange ->
                NUnsafe { int = n |> toInt, range = inRangeRange }
                    |> Ok


isInRange :
    ( N (In minMin (Up minMaxX To (Add1 minMaxFrom1PlusX)))
    , N (In (Up maxMinX To maxMinPlusX) maxMax)
    )
    ->
        (N (In min max)
         ->
            Result
                (BelowOrAbove
                    (In min (Up minMaxX To minMaxFrom1PlusX))
                    (In (Up maxMinX To (Add1 maxMinPlusX)) max)
                )
                (In minMin maxMax)
        )
isInRange ( lowerLimit, upperLimit ) =
    \n ->
        if (n |> toInt) < (lowerLimit |> toInt) then
            RangeUnsafe
                { min = n |> min
                , max =
                    (lowerLimit |> max)
                        |> differenceSubtract (n1 |> min)
                }
                |> Below
                |> Err

        else if (n |> toInt) > (upperLimit |> toInt) then
            RangeUnsafe
                { min =
                    (upperLimit |> min)
                        |> differenceAdd (n1 |> min)
                , max = n |> max
                }
                |> Above
                |> Err

        else
            RangeUnsafe
                { min = lowerLimit |> min
                , max = upperLimit |> max
                }
                |> Ok


{-| Is the [`N`](#N) below than or at least as big as a given number?

    vote :
        { age : N (In (On (Add18 minFrom18_)) max_) }
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
→ `Err` or `Ok` values don't necessarily follow `min ≤ max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtLeast :
    N
        (In
            minMin
            (Up minMaxX To (Add1 minMaxFrom1PlusX))
        )
    ->
        (N (In min max)
         ->
            Result
                (N (In min (Up minMaxX To minMaxFrom1PlusX)))
                (N (In minMin max))
        )
isAtLeast lowerLimit =
    \n ->
        case n |> isAtLeastRange lowerLimit of
            Ok atLeast ->
                NUnsafe { int = n |> toInt, range = atLeast }
                    |> Ok

            Err below ->
                NUnsafe { int = n |> toInt, range = below }
                    |> Err


isAtLeastRange :
    N (In minMin (Up minMaxX To (Add1 minMaxFrom1PlusX)))
    ->
        (N (In min max)
         ->
            Result
                (In min (Up minMaxX To minMaxFrom1PlusX))
                (In minMin max)
        )
isAtLeastRange lowerLimit =
    \n ->
        if (n |> toInt) >= (lowerLimit |> toInt) then
            RangeUnsafe
                { min = lowerLimit |> min
                , max = n |> max
                }
                |> Ok

        else
            RangeUnsafe
                { min = n |> min
                , max =
                    (lowerLimit |> max)
                        |> differenceSubtract (n1 |> min)
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
→ `Err` or `Ok` values don't necessarily follow `min ≤ max` for `N (In min max ...)`
Luckily that's not a problem, since the values won't be produced anyway.)

-}
isAtMost :
    N (In (Up maxMinX To maxMinPlusX) maxMax)
    ->
        (N (In min max)
         ->
            Result
                (N (In (Up maxMinX To (Add1 maxMinPlusX)) max))
                (N (In min maxMax))
        )
isAtMost upperLimit =
    \n ->
        case n |> isAtMostRange upperLimit of
            Ok atMost ->
                NUnsafe { int = n |> toInt, range = atMost }
                    |> Ok

            Err above ->
                NUnsafe { int = n |> toInt, range = above }
                    |> Err


isAtMostRange :
    N (In (Up maxMinX To maxMinPlusX) maxMax)
    ->
        (N (In min max)
         ->
            Result
                (In (Up maxMinX To (Add1 maxMinPlusX)) max)
                (In min maxMax)
        )
isAtMostRange upperLimit =
    \n ->
        if (n |> toInt) <= (upperLimit |> toInt) then
            RangeUnsafe
                { min = n |> min
                , max = upperLimit |> max
                }
                |> Ok

        else
            RangeUnsafe
                { min =
                    (upperLimit |> min)
                        |> differenceAdd (n1 |> min)
                , max = n |> max
                }
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

For clamping, try [`toIn`](#toIn) instead!

-}
smaller : N range -> N range -> N range
smaller maximum =
    \n ->
        if (n |> toInt) <= (maximum |> toInt) then
            n

        else
            maximum



-- transform


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

this is rather supposed to be used as a primitive to build a structure maximum function

    ArraySized.fold Up N.greater

For clamping, try [`toIn`](#toIn) and [`toAtLeastMin`](#toAtLeastMin) instead!

-}
greater : N range -> N range -> N range
greater minimum =
    \n ->
        if (n |> toInt) >= (minimum |> toInt) then
            n

        else
            minimum


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
        NUnsafe
            { int = (n |> toInt) + (toAdd |> toInt)
            , range = n |> range |> rangeAdd (toAdd |> range)
            }



--


{-| To the [`N`](#N) without a known maximum-constraint,
add a number that (only) has [information on how to add](#Up) the minima

    atLeast70 |> N.addMin n7
    --: N (Min (Up77 x_))

    n7 |> N.addMin atLeast70
    --: N (Min (Up77 x_))

Use [`add`](#add) if both maxima are known [difference](#Up)s as well

If the added minimum is [`On`](#On), supply the [`N.minTo`](#minTo) manually
to re-enable adding both minimum types!

    atLeast5 |> N.addMin (atLeastOn2 |> N.minTo n2)
    --: N (Min (Up7 x_))

-}
addMin :
    N (In (Up minPlusX To sumMinPlusX) addendMax_)
    ->
        (N (In (Up minX To minPlusX) max_)
         -> N (Min (Up minX To sumMinPlusX))
        )
addMin toAdd =
    \n ->
        NUnsafe
            { int = (n |> toInt) + (toAdd |> toInt)
            , range =
                (n |> min)
                    |> differenceAdd (toAdd |> min)
                    |> minRange
            }


{-| From the [`N`](#N) in a range subtract another [`N`](#N) in a range

    n6
        |> N.subtract n5
        --: N (In (On N1) (Up1 x_))
        |> N.inToNumber
    --> n1 |> N.inToNumber

One of the [`N`](#N)s has no maximum constraint? → [`N.subtractMin`](#subtractMin)

-}
subtract :
    N
        (In
            (Down maxPlusX To differenceMaxPlusX)
            (Down min To differenceMin)
        )
    ->
        (N (In (On min) (Up maxX To maxPlusX))
         ->
            N
                (In
                    (On differenceMin)
                    (Up maxX To differenceMaxPlusX)
                )
        )
subtract toSubtract =
    \n ->
        NUnsafe
            { int = (n |> toInt) - (toSubtract |> toInt)
            , range =
                n |> range |> rangeSubtract (toSubtract |> range)
            }


{-| From an [`N`](#N) with an unknown maximum constraint,
subtract a [specific number](#In)

    atLeast7 |> N.subtractMin n2
    --: N (Min (On N5))

    atLeast6 |> N.subtractMin between0And5
    --: N (Min (On N1))

    between6And12 |> N.subtractMin between1And5
    --: N (In (On min_) (Up12 maxX_))

Use [`N.subtract`](#subtract) if you want to subtract an [`N`](#N) in a range

-}
subtractMin :
    N (In subtrahendMin_ (Down min To differenceMin))
    ->
        (N (In (On min) max)
         -> N (In (On differenceMin) max)
        )
subtractMin subtrahend =
    \n ->
        NUnsafe
            { int = (n |> toInt) - (subtrahend |> toInt)
            , range =
                n |> range |> rangeMinSubtract (subtrahend |> max)
            }


{-| Its [limits](#In)
containing both its [`min`](#min)
and its [`max`](#max)

    import Possibly exposing (Possibly(..))

    N.intIn ( n3, n5 ) 4
        --: N (In (Up3 minX_) (Up5 maxX_))
        |> N.minTo n2
        --: N (In (Up2 minX_) (Up5 maxX_))
        |> N.range
        --: In (Up2 minX_) (Up5 maxX_)
        |> N.rangeInToOn
        --: In N2 N5
        |> N.rangeMin
    --: N2
    --> N.Add1 (N.Add1 (N.N0 Possible))

-}
range : N range -> range
range =
    \n -> n |> toRecord |> .range


{-| The smallest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
min : N (In min maximum_) -> min
min =
    \n ->
        n |> range |> rangeMin


{-| The greatest allowed number promised by the range type
as its representation as a [difference](#Up)
-}
max : N (In min_ max) -> max
max =
    \n ->
        n |> range |> rangeMax


{-| The specific natural number `0`
-}
n0 : N (In (Up0 minX_) (Up0 maxX_))
n0 =
    NUnsafe { int = 0, range = range0 }


range0 : In (Up0 minX_) (Up0 maxX_)
range0 =
    RangeUnsafe { min = up0, max = up0 }



-- # internals


up0 : Up0 x_
up0 =
    Difference
        { up = identity
        , down = identity
        }


{-| The specific natural number `1`
-}
n1 : N (In (Up1 minX_) (Up1 maxX_))
n1 =
    NUnsafe { int = 1, range = range1 }


range1 : In (Up1 minX_) (Up1 maxX_)
range1 =
    RangeUnsafe { min = up1, max = up1 }



--


up1 : Up1 x_
up1 =
    Difference
        { up = Add1
        , down = numberSubtract1
        }


numberSubtract1 : Add1 from1 -> from1
numberSubtract1 =
    \n0Never ->
        case n0Never of
            Add1 predecessor ->
                predecessor

            N0 possible ->
                possible |> never



--


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


{-| Decrease the start and end of its [`min`](#min) [difference](#Up)

    n3
        --: N (In (Up3 (Add2 minX_)) (Up3 maxX_))
        |> N.minEndsSubtract n2
    --: N (In (Up5 minX_) (Up5 maxX_))

[`maxEndsSubtract`](#maxEndsSubtract) has an example of where this can be useful.

-}
minEndsSubtract :
    N (In (Down minX To minXDecreased) (Down minPlusX To minPlusXDecreased))
    ->
        (N (In (Up minX To minPlusX) max)
         -> N (In (Up minXDecreased To minPlusXDecreased) max)
        )
minEndsSubtract decrease =
    \n ->
        NUnsafe
            { range = n |> range |> rangeMinEndsSubtract (decrease |> range)
            , int = n |> toInt
            }


{-| Decrease the start and end of its [`max`](#max) [difference](#Up)

    n3
        --: N (In (Up3 minX_) (Up3 (Add2 maxX_)))
        |> N.addStart n2
    --: N (In (Up5 minX_) (Up5 maxX_))

Huh... One rare use-case is avoiding an extra type parameter:

With extra type parameter:

    {-| Gives each index a label. Access using `partIn`
    -}
    type alias Group record lastIndex count =
        { record : record
        , parts : ArraySized String (Exactly (On count))
        , lastIndex : N (In (On N0) lastIndex)
        }

    addPart :
        String
        ->
            (Group
                (N (In (On N0) (Up x To lastIndexPlusX)) -> record)
                (Up x To lastIndexPlusX)
                count
             -> Group record (Up x To (Add1 lastIndexPlusX)) (Add1 count)
            )
    addPart partName groupSoFar =
        { record = groupSoFar.record groupSoFar.lastIndex
        , parts = groupSoFar.parts |> ArraySized.push partName
        , lastIndex = groupSoFar.lastIndex |> N.add n1
        }

    partIn :
        Group record i_ (Add1 lastIndex)
        -> (record -> N (In (On N0) (Up x_ To lastIndex)))
        -> String
    partIn group field =
        group.parts |> ArraySized.element ( Up, group.record |> field )

If we change `Group record lastIndex count` to keep only one of both, we have a problem:
All indexes in the `record` are dependent on the same maximum which now is [`On`](#On).
That means that lower indexes aren't accepted by `partIn` anymore. The fix:

    addPart :
        String
        ->
            (GroupBeingBuilt
                (N (In (On N0) (Up (Add1 xFrom1) To lastIndex)) -> record)
                (Up (Add1 xFrom1) To lastIndex)
                count
             -> GroupBeingBuilt record (Up xFrom1 To lastIndex) (Add1 count)
            )
    addPart partName groupSoFar =
        { record = groupSoFar.record groupSoFar.lastIndex
        , parts = groupSoFar.parts |> ArraySized.push partName
        , lastIndex = groupSoFar.lastIndex |> N.add n1 |> N.maxEndsSubtract n1 |> N.minTo n0
        }

    type alias GroupComplete record count =
        Group record (On count) count

The really nice thing is that as we finish, the start of [minimum difference](#min) is `N0`,
which makes this an [`On`](#On)

-}
maxEndsSubtract :
    N (In (Down maxPlusX To maxPlusXDecreased) (Down maxX To maxXDecreased))
    ->
        (N (In min (Up maxX To maxPlusX))
         -> N (In min (Up maxXDecreased To maxPlusXDecreased))
        )
maxEndsSubtract decrease =
    \n ->
        NUnsafe
            { range = n |> range |> rangeMaxEndsSubtract (decrease |> range)
            , int = n |> toInt
            }


{-| Decrease the start and end of its [`rangeMin`](#rangeMin) [difference](#Up)

    n3
        |> N.range
        --: In (Up3 (Add2 minX_)) (Up3 maxX_)
        |> N.rangeMinEndsSubtract (n2 |> N.range)
    --: In (Up5 minX_) (Up5 maxX_)

See [`maxEndsSubtract`](#maxEndsSubtract) for details and examples

-}
rangeMinEndsSubtract :
    In (Down minX To minXDecreased) (Down minPlusX To minPlusXDecreased)
    ->
        (In (Up minX To minPlusX) max
         -> In (Up minXDecreased To minPlusXDecreased) max
        )
rangeMinEndsSubtract decrease =
    \range_ ->
        RangeUnsafe
            { min =
                let
                    minXToMinPlusXDecreased : Up minX To minPlusXDecreased
                    minXToMinPlusXDecreased =
                        range_
                            |> rangeMin
                            |> differenceSubtract (decrease |> rangeMax)
                in
                decrease
                    |> rangeMin
                    |> differenceAdd minXToMinPlusXDecreased
            , max = range_ |> rangeMax
            }


{-| Decrease the start and end of its [`rangeMax`](#rangeMax) [difference](#Up)

    n3
        |> N.range
        --: In (Up3 minX_) (Up3 (Add2 maxX_))
        |> N.rangeMaxEndsSubtract (n2 |> N.range)
    --: In (Up5 minX_) (Up5 maxX_)

See [`maxEndsSubtract`](#maxEndsSubtract) for details and examples

-}
rangeMaxEndsSubtract :
    In (Down maxPlusX To maxPlusXDecreased) (Down maxX To maxXDecreased)
    ->
        (In min (Up maxX To maxPlusX)
         -> In min (Up maxXDecreased To maxPlusXDecreased)
        )
rangeMaxEndsSubtract decrease =
    \range_ ->
        RangeUnsafe
            { min = range_ |> rangeMin
            , max =
                let
                    maxXToMaxPlusXDecreased : Up maxX To maxPlusXDecreased
                    maxXToMaxPlusXDecreased =
                        range_
                            |> rangeMax
                            |> differenceSubtract (decrease |> rangeMin)
                in
                decrease
                    |> rangeMax
                    |> differenceAdd maxXToMaxPlusXDecreased
            }


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
type N0OrAdd1 n0PossiblyOrNever from1
    = N0 n0PossiblyOrNever
    | Add1 from1


{-| Change the `possiblyOrNever` type
for the case that its [`N0OrAdd1`](#N0OrAdd1) representation is [`N0`](#N0OrAdd1)
-}
on0Adapt :
    (possiblyOrNever -> adaptedPossiblyOrNever)
    -> On (N0OrAdd1 possiblyOrNever from1)
    -> On (N0OrAdd1 adaptedPossiblyOrNever from1)
on0Adapt n0PossiblyOrNeverAdapt =
    \(Difference difference) ->
        Difference
            { up =
                \start ->
                    start
                        |> difference.up
                        |> number0Adapt n0PossiblyOrNeverAdapt
            , down = \_ -> N0 Possible
            }


{-| Change the type
for the case that the [`N0OrAdd1`](#N0OrAdd1) is [`Add1 from1`](#N0OrAdd1)
-}
onFrom1Map :
    (from1 -> mappedFrom1)
    -> On (N0OrAdd1 n0PossiblyOrNever from1)
    -> On (N0OrAdd1 n0PossiblyOrNever mappedFrom1)
onFrom1Map from1Map =
    \(Difference difference) ->
        Difference
            { up =
                \start ->
                    start
                        |> difference.up
                        |> numberFrom1Map from1Map
            , down = \_ -> N0 Possible
            }


{-| Change the `possiblyOrNever` type
for the case that the [`N0OrAdd1`](#N0OrAdd1) is [`N0`](#N0OrAdd1)
-}
number0Adapt :
    (n0PossiblyOrNever -> adaptedN0PossiblyOrNever)
    -> N0OrAdd1 n0PossiblyOrNever from1
    -> N0OrAdd1 adaptedN0PossiblyOrNever from1
number0Adapt n0PossiblyOrNeverAdapt =
    \n ->
        case n of
            Add1 from1 ->
                from1 |> Add1

            N0 possiblyOrNever ->
                N0 (possiblyOrNever |> n0PossiblyOrNeverAdapt)


{-| Change the type
for the case that the [`N0OrAdd1`](#N0OrAdd1) is [`Add1 from1`](#N0OrAdd1)
-}
numberFrom1Map :
    (from1 -> mappedFrom1)
    -> N0OrAdd1 n0PossiblyOrNever from1
    -> N0OrAdd1 n0PossiblyOrNever mappedFrom1
numberFrom1Map from1Map =
    \n ->
        case n of
            Add1 from1 ->
                from1 |> from1Map |> Add1

            N0 possiblyOrNever ->
                N0 possiblyOrNever


{-| Transfer the knowledge about whether [`n0`](#n0) is a possible value

    stackRepeat :
        element
        -> N (In (On (N0OrAdd1 possiblyOrNever minFrom1_)) max_)
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
        -> N (Min (On (N0OrAdd1 possiblyOrNever N0)))
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

Stack and Emptiable are part of [`emptiness-typed`](https://dark.elm.dmy.fr/packages/lue-bird/elm-emptiness-typed/latest/)

Cool, right?

-}
isAtLeast1 :
    N (In (On (N0OrAdd1 n0PossiblyOrNever minFrom1_)) max)
    -> Result n0PossiblyOrNever (N (In (Up1 minX_) max))
isAtLeast1 =
    \n ->
        case n |> rangeIsAtLeast1 of
            Err possiblyOrNever ->
                Err possiblyOrNever

            Ok atLeast1Range ->
                NUnsafe { int = n |> toInt, range = atLeast1Range }
                    |> Ok


{-| Change the `possiblyOrNever` type for the case that its [`min`](#min) is 0

`never` allows you to adapt any variable,
`\_ -> yourVariablePossiblyOrNever` swaps it for your given variable

    stackLength :
        Emptiable (Stacked element) possiblyOrNever
        -> N (Min (On (N0OrAdd1 possiblyOrNever N0)))
    stackLength =
        \stack ->
            case stack of
                Emptiable.Empty possiblyOrNever ->
                    n0
                        -- adapt the variable minimum
                        |> N.min0Adapt (\_ -> possiblyOrNever)
                        -- allow a different min - 1 type
                        |> N.minAtLeast1Never
                        |> N.maxToInfinity

                Emptiable.Filled (TopBelow ( _, belowTop )) ->
                    belowTop
                        |> List.length
                        |> N.intToAtLeast n0
                        |> N.add n1
                        -- downgrade the minimum
                        |> N.min0Adapt never

using [`isAtLeast1`](#isAtLeast1), [`minAtLeast1Never`](#minAtLeast1Never).

Stack and Emptiable are part of [`emptiness-typed`](https://dark.elm.dmy.fr/packages/lue-bird/elm-emptiness-typed/latest/)

with `(\_ -> Possible)` it's just a worse version of [`minSubtract`](#minSubtract)
that might be useful in ultra rare situations

    minSubtract1IfPossible :
        N (In (On (N0OrAdd1 possiblyOrNever minFrom1)) max)
        -> N (In (On (N0OrAdd1 Possibly minFrom1)) max)
    minSubtract1IfPossible =
        N.min0Adapt (\_ -> Possibly)

-}
min0Adapt :
    (possiblyOrNever -> adaptedPossiblyOrNever)
    -> N (In (On (N0OrAdd1 possiblyOrNever minFrom1)) max)
    -> N (In (On (N0OrAdd1 adaptedPossiblyOrNever minFrom1)) max)
min0Adapt n0PossiblyOrNeverAdapt =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range =
                n |> range |> rangeMin0Adapt n0PossiblyOrNeverAdapt
            }


{-| For the case that its [`min`](#min) is 1 + ..., allow adapting any variable.
This is possible because we currently have a minimum that is `Never` >= 1

    stackLength :
        Emptiable (Stacked element) possiblyOrNever
        -> N (Min (On (N0OrAdd1 possiblyOrNever N0)))
    stackLength =
        \stack ->
            case stack of
                Emptiable.Empty possiblyOrNever ->
                    n0
                        -- adapt the variable minimum
                        |> N.min0Adapt (\_ -> possiblyOrNever)
                        -- allow a different type for min from 1
                        |> N.minAtLeast1Never
                        |> N.maxToInfinity

                Emptiable.Filled (TopBelow ( _, belowTop )) ->
                    belowTop
                        |> List.length
                        |> N.intToAtLeast n0
                        |> N.add n1
                        -- downgrade the minimum
                        |> N.min0Adapt never

using [`isAtLeast1`](#isAtLeast1), [`min0Adapt`](#min0Adapt)

-}
minAtLeast1Never :
    N (In (On (N0OrAdd1 possiblyOrNever Never)) max)
    -> N (In (On (N0OrAdd1 possiblyOrNever minFrom1_)) max)
minAtLeast1Never =
    \n ->
        NUnsafe
            { int = n |> toInt
            , range = n |> range |> rangeMinAtLeast1Never
            }


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
