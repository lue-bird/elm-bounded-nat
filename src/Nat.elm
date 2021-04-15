module Nat exposing
    ( Nat
    , In, Only
    , N, Is, To
    , ValueMin, ValueIn, ValueN, ValueOnly
    , abs, range, random
    , intAtLeast, intInRange
    , isIntInRange, isIntAtLeast, theGreater, theSmaller
    , toPower, remainderBy, mul, div
    , lowerMin, toMin
    , maxIs
    )

{-|

@docs Nat


## bounds


### function argument

@docs In, Only


#### N

@docs N, Is, To


### value / return type

@docs ValueMin, ValueIn, ValueN, ValueOnly


## create

@docs abs, range, random


### clamp

@docs intAtLeast, intInRange


### compare

@docs isIntInRange, isIntAtLeast, theGreater, theSmaller


## modify

@docs toPower, remainderBy, mul, div


## drop information

@docs lowerMin, toMin


## restore information

@docs maxIs

-}

import I as Internal exposing (NatTag)
import N exposing (Nat0, Nat1Plus)
import Random
import Val exposing (Checked, Public, Val, val, val2)


{-| A **bounded** natural number (`>= 0`).


## value / return types

    -- >= 4
    Nat (ValueMin Nat4)

    -- 2 <= nat <= 12
    Nat (ValueIn Nat2 Nat12)

    -- = 3, & 3, described as a difference
    Nat
        (ValueN Nat3
            (Nat3Plus more)
            (Is a To (Nat3Plus a))
            (Is b To (Nat3Plus b))
        )


## function argument types

    -- >= 4
    Nat (In (Nat4Plus minMinus4) max maybeN)

    -- 4 <= nat <= 15
    Nat (In (Nat4Plus minMinus4) Nat15 maybeN)

    -- An exact number nTo15 away from 15
    Nat (N n (Is nTo15 To Nat15) x)

    -- any, just >= 0
    Nat range

-}
type alias Nat range =
    Val Checked (NatTag range) Public Int



-- ## bounds


{-| `ValueIn minimum maximum`: A value somewhere within a minimum & maximum. We don't know the exact value, though.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

To be used as a return type, **not** as a function argument.

A number between 3 and 5

    Nat (ValueIn Nat3 (Nat5Plus a))

-}
type alias ValueIn minimum maximum =
    In minimum maximum Internal.NotN


{-| `In minimum maximum maybeN`: Somewhere within a minimum & maximum.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Note: maximum >= minimum for every existing `Nat (In min max ...)`:

    percent : Nat (In min Nat100 maybeN) -> Percent

→ `min <= Nat100`

If you want a number where you just care about the minimum, leave the `max` as a type _variable_.

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

Any natural number:

    Nat (In min max maybeN)

A number, at least 5:

    Nat (In (Nat5Plus minMinus5) max maybeN)

  - `max` could be a maximum value if there is one

  - `maybeN` could contain extra information for `N ...` if the number was exact

-}
type alias In minimum maximum maybeN =
    Internal.In minimum maximum maybeN


{-| Only **value / return types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> Nat (ValueIn Nat0 ??)

This is where to use `Min`.

    abs : Int -> Nat (Min Nat0)

A number, which is at least 5 is be of type

    Nat (ValueMin Nat5)

Every `ValueMin min` is of type `In min ...`.

-}
type alias ValueMin minimum =
    ValueIn minimum Internal.Infinity


{-| Just the exact number.

Only useful as a function **argument** type.

Every `In NatXYZ (NatXYZPlus a) maybeN` is a `Only NatXYZ maybeN`.

    byte : Arr (Only maybeN Nat8) Bit -> Byte

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-bounded-array/latest/) must have _exact 8_ `Bit`s.

`Only` is useful for [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-bounded-array/latest/)s,
but you will never need it in combination with `Nat`s.

-}
type alias Only n maybeN =
    In n n maybeN


{-| Just the exact number.

Only useful as a **value & return** type.

    repeatOnly :
        Nat (Only n maybeN)
        -> element
        -> Arr (ValueOnly n) element

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-bounded-array/latest/) must has _exactly `n`_ `element`s.

`ValueOnly` is useful for [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-bounded-array/latest/)s,
but you will never need it in combination with `Nat`s.

-}
type alias ValueOnly n =
    ValueIn n n


{-| No special meaning.

    Is a To b

→ distance `b - a`.

-}
type alias To =
    Internal.To


{-| `Is a To b`: an exact value as the diffference `b - a`.

    N Nat5
        (Nat5Plus more)
        (Is myAge To sistersAge)
        (Is mothersAge To fathersAge)

  - `myAge + 5 = sistersAge`
  - `mothersAge + 5 = fathersAge`

-}
type alias Is a to b =
    Internal.Is a to b


{-| Expect an exact value.
[`InNat.addN`](InNat#addN) for example also uses the knowledge that the number is exact to describe the number as differences between other type variables.

    addN :
        Nat
            (N
                added
                (Is min To sumMin)
                (Is max To sumMax)
            )
        -> Nat (In min max)
        -> Nat (In sumMin sumMax)

You can just ignore the second difference if you don't need it ([`MinNat.addN`](MinNat#addN)).

    addN :
        Nat (N added (Is min To sumMin) x)
        -> Nat (In min max maybeN)
        -> Nat (ValueMin sumMin)

-}
type alias N n asADifference asAnotherDifference =
    ValueN n n asADifference asAnotherDifference


{-| The most detailed description of an exact value.

Don't use this as a function argument.

-}
type alias ValueN n atLeastN asADifference asAnotherDifference =
    In n atLeastN (Internal.Differences asADifference asAnotherDifference)


{-| The absolute value of an `Int`, which is `>= Nat0`.

    Nat.abs 16 --> Nat 16

    Nat.abs -4 --> Nat 4

Really only use this if you want the absolute value.

    badLength list =
        List.length >> Nat.abs

    goodLength =
        List.foldl
            (\_ ->
                MinNat.addN nat1
                    >> Nat.lowerMin nat0
            )
            (nat0 |> Nat.toMin)

If something like this isn't possible, use [`MinNat.intAtLeast`](MinNat#intAtLeast)!

-}
abs : Int -> Nat (ValueMin Nat0)
abs int =
    Internal.abs int


{-| `Nat (ValueIn ...)`s from a first to a last value.

    from3To10 : List (Nat (ValueIn Nat3 (Nat10Plus a)))
    from3To10 =
        Nat.range nat3 nat10

    from3ToAtLeast10 : List (Nat (ValueMin Nat3))
    from3ToAtLeast10 =
        Nat.range nat3 atLeast10

The resulting `List` always has at least 1 element.

With [Arr.range](https://package.elm-lang.org/packages/lue-bird/elm-bounded-array/latest/Arr#range) the type even knows the length! Try it.

-}
range :
    Nat (In firstMin lastMin firstMaybeN)
    -> Nat (In lastMin lastMax lastMaybeN)
    -> List (Nat (ValueIn firstMin lastMax))
range first last =
    Internal.range first last


{-| Generate a random `Nat (ValueIn ...)` in a range.
-}
random :
    Nat (In firstMin lastMin firstMaybeN)
    -> Nat (In lastMin lastMax lastMaybeN)
    -> Random.Generator (Nat (ValueIn firstMin lastMax))
random min max =
    Internal.random min max


{-| The greater of 2 `Nat`s.

    Nat.theGreater between1And3 (nat4 |> Nat.lowerMin nat1)
    --> Nat 4

-}
theGreater : Nat range -> Nat range -> Nat range
theGreater a b =
    if val2 (>) a b then
        a

    else
        b


{-| The smaller of 2 `Nat`s.

    Nat.theSmaller nat3 (nat4 |> Nat.lowerMin nat3)
    --> Nat 3

-}
theSmaller : Nat range -> Nat range -> Nat range
theSmaller a b =
    if val2 (<) a b then
        a

    else
        b


{-| Compared to a range `first` to `last`, is the `Int`

  - `inRange`

  - `greater` than the `last` or

  - `less` than the `first`?

```
rejectOrAcceptUserInt =
    Nat.isIntInRange nat1 nat100
        { less = Err "must be >= 1"
        , greater = \_-> Err "must be <= 100"
        , inRange = Ok
        }

rejectOrAcceptUserInt 0
--> Err "must be >= 1"
```

-}
isIntInRange :
    { first : Nat (In minFirst last firstMaybeN)
    , last : Nat (In last lastPlusA lastMaybeN)
    }
    ->
        { less : () -> result
        , greater : Nat (ValueMin (Nat1Plus last)) -> result
        , inRange : Nat (ValueIn minFirst lastPlusA) -> result
        }
    -> Int
    -> result
isIntInRange interval cases int =
    Internal.isIntInRange interval cases int


{-| A `Nat (ValueIn ...)` from an `Int`, **clamped** between a minimum & maximum.

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

```
clampBetween3And12 =
    Nat.intInRange nat3 nat12

9 |> clampBetween3And12 --> Nat 9

0 |> clampBetween3And12 --> Nat 3

99 |> clampBetween3And12 --> Nat 12
```

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`isIntInRange`](InNat#isIntInRange).

-}
intInRange :
    Nat (In min firstMax lowerMaybeN)
    -> Nat (In firstMax max upperMaybeN)
    -> Int
    -> Nat (ValueIn min max)
intInRange lowerLimit upperLimit =
    Internal.intInRange lowerLimit upperLimit


{-| If the `Int >= a minimum`, `Just` the `Nat (ValueMin minimum)`, else `Nothing`.

    4 |> Nat.isIntAtLeast nat5 --> Nothing

    1234 |> Nat.isIntAtLeast nat5 --> Just (Nat 1234)

-}
isIntAtLeast :
    Nat (In min max lowerMaybeN)
    -> Int
    -> Maybe (Nat (ValueMin min))
isIntAtLeast minimum int =
    Internal.isIntAtLeast minimum int


{-| A `Nat (ValueMin ...)` from an `Int`; if the `Int < minimum`, `minimum` is returned.

    9 |> Nat.intAtLeast nat3
    --> Nat 9

    0 |> Nat.intAtLeast nat3
    --> Nat 3

You can also use this if you know an `Int` must be at least `minimum`.

But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ ->
                MinNat.addN nat1
                    >> Nat.lowerMin nat0
            )
            (nat0 |> Nat.toMin)

If you want to handle the case `< minimum` yourself, use [`Nat.isIntAtLeast`](Nat#isIntAtLeast).

-}
intAtLeast :
    Nat (In min max lowerMaybeN)
    -> Int
    -> Nat (ValueMin min)
intAtLeast minimum =
    isIntAtLeast minimum
        >> Maybe.withDefault (toMin minimum)



-- ## modify


{-| Multiply by a `Nat >= 1`.
we know that if `a >= 1`, `x * a >= x`.

    atLeast5  |> Nat.mul nat2
    --> Nat 10 of type Nat (ValueMin Nat5)

    atLeast2 |> Nat.mul nat5
    --> Nat 10 of type Nat (ValueMin Nat2)

The maximum value of both factors can be `Infinity`.

-}
mul :
    Nat (In (Nat1Plus minMultipliedMinus1) maxMultiplied multipliedMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin min)
mul natToMultiply =
    Internal.mul natToMultiply


{-| Divide (`//`) by a `Nat >= 1`.

  - `/ 0` is impossible

  - `x / d` is at most x

```
atMost7
    |> Nat.div nat3
--> Nat 2 of type Nat (ValueIn Nat0 (Nat7Plus a))
```

-}
div :
    Nat (In (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn Nat0 max)
div divNat =
    Internal.div divNat


{-| The remainder after division.

  - `% 0` is impossible
  - `x % d` is at most `x`

```
atMost7 |> Nat.remainderBy nat3
--> Nat 1 of type Nat (In Nat0 (Nat7Plus a))
```

-}
remainderBy :
    Nat (In (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn Nat0 max)
remainderBy divNat =
    Internal.remainderBy divNat


{-| The `Nat ^ a Nat >= 1`.
We know that if `a >= 1  →  x ^ a >= x`

    atLeast5 |> Nat.toPower nat2
    --> Nat 25 of type Nat (ValueMin Nat5)

    atLeast2 |> Nat.toPower nat5
    --> Nat 25 of type Nat (ValueMin Nat2)

-}
toPower :
    Nat (In (Nat1Plus powMinMinus1) powMax powMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin min)
toPower power =
    Internal.toPower power



-- ## drop information


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `Nat (ValueMin Nat3)`

    [ atLeast3
    , atLeast4 |> Nat.lowerMin nat3
    ]

-}
lowerMin :
    Nat (In lowerMin min lowerMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn lowerMin max)
lowerMin =
    \_ -> Internal.newRange


{-| Convert a `Nat (In min ...)` to a `Nat (ValueMin min)`.

    between3And10 |> Nat.toMin
    --> is of type Nat (ValueMin Nat4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `Nat (ValueMin Nat1)`

    [ atLeast1
    , between1And10 |> Nat.toMin
    ]

-}
toMin : Nat (In min max maybeN) -> Nat (ValueMin min)
toMin =
    Internal.newRange


{-| Make it fit into functions with require a higher maximum.

You should design type annotations as general as possible.

    onlyAtMost18 : Nat (In min Nat18 maybeN)

    onlyAtMost18 between3And8 --fine

But once you implement `onlyAtMost18`, you might use the value in `onlyAtMost19`.

    onlyAtMost18 value =
        -- onlyAtMost19 value --error :(
        onlyAtMost19
            (value |> Nat.maxIs nat18 {- works :) -})

[`lowerMin`](Nat#lowerMin) is also handy in those situations.

-}
maxIs :
    Nat (N max (Is a To atLeastMax) x)
    -> Nat (In min max maybeN)
    -> Nat (In min atLeastMax maybeN)
maxIs =
    \_ -> Internal.newRange



-- ### I don't know if either operation is really needed


{-| Subtract a `Nat (In ..)` without calculating

  - the new minimum, the lowest value it could be after subtracting is 0
  - the new maximum, the highest value it could be after subtracting is the old max

```
in6To12 |> Nat.subLossy between1And5
--> is of type Nat (ValueIn Nat0 Nat12)

atLeast6 |> Nat.subLossy between1And5
--> is of type Nat (ValueMin Nat0)
```

  - if you know the minimum subtracted value, use [`MinNat.sub`](MinNat#sub).

  - if you also know the maximum subtracted value, use [`InNat.sub`](InNat#sub).

-}
subLossy :
    Nat (In minSubbed min subbedMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn Nat0 max)
subLossy natToSubtract =
    Internal.sub natToSubtract


{-| Add a `Nat (In ...)`, but

  - keep the current minimum, instead of computing the exact value

  - use `Infinity` as the maximum instead of computing the exact value

    atLeast5 |> Nat.addLossy atLeast2
    --> is of type Nat (ValueMin Nat5)

    atLeast2 |> Nat.addLossy atLeast5
    --> is of type Nat (ValueMin Nat2)

  - if you know the minimum added value, use [`MinNat.add`](MinNat#add).

  - if you also know the minimum added value, use [`InNat.add`](InNat#add).

-}
addLossy :
    Nat (In minAdded maxAdded addedMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin min)
addLossy natToAdd =
    Internal.add natToAdd
