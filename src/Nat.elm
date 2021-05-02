module Nat exposing
    ( Nat
    , ArgIn, ArgOnly
    , ArgN, Is, To
    , Min, In, N, Only
    , abs, range, random
    , intAtLeast, intInRange
    , isIntInRange, isIntAtLeast, theGreater, theSmaller
    , toPower, remainderBy, mul, div
    , lowerMin
    , restoreMax
    )

{-|

@docs Nat


# bounds


## argument type

@docs ArgIn, ArgOnly


### N

@docs ArgN, Is, To


## value / return type

@docs Min, In, N, Only


# create

@docs abs, range, random


## clamp

@docs intAtLeast, intInRange


## compare

@docs isIntInRange, isIntAtLeast, theGreater, theSmaller


# modify

@docs toPower, remainderBy, mul, div


# drop information

@docs lowerMin


# restore information

@docs restoreMax

-}

import I as Internal exposing (NatTag)
import N exposing (Nat0, Nat160Plus, Nat1Plus)
import Random
import Typed exposing (Checked, Public, Typed, val2)


{-| A **bounded** natural number (`>= 0`).


## value / return types

    -- >= 4
    Nat (Min Nat4)

    -- 2 <= nat <= 12
    Nat (In Nat2 Nat12)

    -- = 3, & 3, described as a difference
    Nat
        (N Nat3
            (Nat3Plus more)
            (Is a To (Nat3Plus a))
            (Is b To (Nat3Plus b))
        )


## function argument types

    -- >= 4
    Nat (ArgIn (Nat4Plus minMinus4) max maybeN)

    -- 4 <= nat <= 15
    Nat (ArgIn (Nat4Plus minMinus4) Nat15 maybeN)

    -- An exact number nTo15 away from 15
    Nat (ArgN n (Is nTo15 To Nat15) x)

    -- any, just >= 0
    Nat range

-}
type alias Nat range =
    Typed Checked (NatTag range) Public Int



-- ## bounds


{-| `In minimum maximum`: A value somewhere within a minimum & maximum. We don't know the exact value, though.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    Nat (In Nat3 (Nat5Plus a))

-}
type alias In minimum maximum =
    ArgIn minimum maximum Internal.NotN


{-| `ArgIn minimum maximum maybeN`: Somewhere within a minimum & maximum.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Note: maximum >= minimum for every existing `Nat (ArgIn min max ...)`:

    percent : Nat (ArgIn min Nat100 maybeN) -> Percent

→ `min <= Nat100`

If you want a number where you just care about the minimum, leave the `max` as a type _variable_.

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

Any natural number:

    Nat (ArgIn min max maybeN)

A number, at least 5:

    Nat (ArgIn (Nat5Plus minMinus5) max maybeN)

  - `max` could be a maximum value if there is one

  - `maybeN` could contain extra information if the argument is a `Nat (N ...)`

-}
type alias ArgIn minimum maximum maybeN =
    Internal.ArgIn minimum maximum maybeN


{-| Only **value / return types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> Nat (In Nat0 ??)

This is where to use `Min`.

    abs : Int -> Nat (Min Nat0)

A number >= 5 for example:

    Nat (Min Nat5)

Every `Min min` is of type `ArgIn min ...`.

-}
type alias Min minimum =
    In minimum Internal.Infinity


{-| Expect an exact number.

Only useful as an **argument** / storage type.

Every `ArgIn NatXYZ (NatXYZPlus a) maybeN` is a `ArgOnly NatXYZ maybeN`.

    byte : Arr (ArgOnly Nat8 maybeN) Bit -> Byte

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exact 8_ `Bit`s.

`ArgOnly` is useful for [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
but you will never need it in combination with `Nat`s.

-}
type alias ArgOnly n maybeN =
    ArgIn n n maybeN


{-| Just the exact number.

    repeatOnly :
        Nat (ArgOnly n maybeN)
        -> element
        -> Arr (Only n) element

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly `n`_ `element`s.

`Only` is useful for [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
but you will never need it in combination with `Nat`s.

-}
type alias Only n =
    In n n


{-| Only at type-level in [Is](Nat#Is).

    Is a To b

→ distance `b - a`.

-}
type alias To =
    Internal.To


{-| `Is a To b`: an exact value as the diffference `b - a`.

    N Nat5
        (Is myAge To sistersAge)
        (Is mothersAge To fathersAge)

  - `myAge + 5 = sistersAge`
  - `mothersAge + 5 = fathersAge`

-}
type alias Is a to b =
    Internal.Is a to b


{-| Expect an exact value.
[`InNat.addN`](InNat#addN) for example uses this knowledg to describe the number as differences between other type variables.

    addN :
        Nat
            (ArgN
                added
                (Is min To sumMin)
                (Is max To sumMax)
            )
        -> Nat (ArgIn min max maybeN)
        -> Nat (In sumMin sumMax)

You can just ignore the second difference if you don't need it ([`MinNat.addN`](MinNat#addN)).

    addN :
        Nat (ArgN added (Is min To sumMin) x)
        -> Nat (ArgIn min max maybeN)
        -> Nat (Min sumMin)

-}
type alias ArgN n asADifference asAnotherDifference =
    N n n asADifference asAnotherDifference


{-| The most detailed description of an exact value.

Don't use this as a function argument.

-}
type alias N n atLeastN asADifference asAnotherDifference =
    ArgIn n atLeastN (Internal.Differences asADifference asAnotherDifference)


{-| The absolute value of an `Int`, which is `>= 0`.

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
            (nat0 |> MinNat.value)

If something like this isn't possible, use [`MinNat.intAtLeast`](MinNat#intAtLeast)!

-}
abs : Int -> Nat (Min Nat0)
abs int =
    Internal.abs int


{-| `Nat (In ...)`s from a first to last value.

    from3To10 : List (Nat (In Nat3 (Nat10Plus a)))
    from3To10 =
        Nat.range nat3 nat10

    from3ToAtLeast10 : List (Nat (Min Nat3))
    from3ToAtLeast10 =
        Nat.range nat3 atLeast10

The resulting `List` always has at least 1 element.

With [Arr.range](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/Arr#range) the type even knows the length! Try it.

-}
range :
    Nat (ArgIn firstMin lastMin firstMaybeN)
    -> Nat (ArgIn lastMin lastMax lastMaybeN)
    -> List (Nat (In firstMin lastMax))
range first last =
    Internal.range first last


{-| Generate a random `Nat (In ...)` in a range.
-}
random :
    Nat (ArgIn lowerBoundMin upperBoundMin lowerBoundMaybeN)
    -> Nat (ArgIn upperBoundMin upperBoundMax upperBoundMaybeN)
    -> Random.Generator (Nat (In lowerBoundMin upperBoundMax))
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


{-| Compared to a range from a lower to an upper bound, is the `Int`

  - `inRange`

  - `greater` than the upper bound or

  - `less` than the lower bound?

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
    Nat (ArgIn minLowerBound upperBound lowerBoundMaybeN)
    -> Nat (ArgIn upperBound upperBoundPlusA upperBoundMaybeN)
    ->
        { less : () -> result
        , greater : Nat (Min (Nat1Plus upperBound)) -> result
        , inRange : Nat (In minLowerBound upperBoundPlusA) -> result
        }
    -> Int
    -> result
isIntInRange lowerBound upperBound cases int =
    Internal.isIntInRange lowerBound upperBound cases int


{-| A `Nat (In ...)` from an `Int`, **clamped** between a minimum & maximum.

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
    Nat (ArgIn min lowerBoundMax lowerMaybeN)
    -> Nat (ArgIn lowerBoundMax max upperMaybeN)
    -> Int
    -> Nat (In min max)
intInRange lowerBound upperBound =
    Internal.intInRange lowerBound upperBound


{-| If the `Int >= a minimum`, `Just` the `Nat (Min minimum)`, else `Nothing`.

    4 |> Nat.isIntAtLeast nat5 --> Nothing

    1234 |> Nat.isIntAtLeast nat5 --> Just (Nat 1234)

-}
isIntAtLeast :
    Nat (ArgIn min max lowerMaybeN)
    -> Int
    -> Maybe (Nat (Min min))
isIntAtLeast minimum int =
    Internal.isIntAtLeast minimum int


{-| A `Nat (Min ...)` from an `Int`; if the `Int < minimum`, `minimum` is returned.

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
            (nat0 |> MinNat.value)

If you want to handle the case `< minimum` yourself, use [`Nat.isIntAtLeast`](Nat#isIntAtLeast).

-}
intAtLeast :
    Nat (ArgIn min max lowerMaybeN)
    -> Int
    -> Nat (Min min)
intAtLeast minimum =
    isIntAtLeast minimum
        >> Maybe.withDefault (Internal.newRange minimum)



-- ## modify


{-| Multiply by a `Nat >= 1`.
we know that if `a >= 1`, `x * a >= x`.

    atLeast5  |> Nat.mul nat2
    --> Nat 10 : Nat (Min Nat5)

    atLeast2 |> Nat.mul nat5
    --> Nat 10 : Nat (Min Nat2)

The maximum value of both factors can be `Infinity`.

-}
mul :
    Nat (ArgIn (Nat1Plus minMultipliedMinus1) maxMultiplied multipliedMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min min)
mul natToMultiply =
    Internal.mul natToMultiply


{-| Divide (`//`) by a `Nat >= 1`.

  - `/ 0` is impossible

  - `x / d` is at most x

```
atMost7
    |> Nat.div nat3
--> Nat 2 : Nat (In Nat0 (Nat7Plus a))
```

-}
div :
    Nat (ArgIn (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In Nat0 max)
div divNat =
    Internal.div divNat


{-| The remainder after division.

  - `% 0` is impossible
  - `x % d` is at most `d`

```
atMost7 |> Nat.remainderBy nat3
--> Nat 1 : Nat (ArgIn Nat0 (Nat3Plus a))
```

In theory, `x % d` should be at most `d - 1`, but this can't be expressed well by the type.

-}
remainderBy :
    Nat (ArgIn (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In Nat0 divMax)
remainderBy divNat =
    Internal.remainderBy divNat


{-| The `Nat ^ a Nat >= 1`.
We know that if `a >= 1  →  x ^ a >= x`

    atLeast5 |> Nat.toPower nat2
    --> Nat 25 : Nat (Min Nat5)

    atLeast2 |> Nat.toPower nat5
    --> Nat 25 : Nat (Min Nat2)

-}
toPower :
    Nat (ArgIn (Nat1Plus powMinMinus1) powMax powMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min min)
toPower power =
    Internal.toPower power



-- ## drop information


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `Nat (Min Nat3)`

    [ atLeast3
    , atLeast4 |> Nat.lowerMin nat3
    ]

-}
lowerMin :
    Nat (ArgIn lowerMin min lowerMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In lowerMin max)
lowerMin =
    \_ -> Internal.newRange


{-| Make it fit into functions with require a higher maximum.

You should design type annotations as general as possible.

    onlyAtMost18 : Nat (ArgIn min Nat18 maybeN)

    onlyAtMost18 between3And8 --fine

But once you implement `onlyAtMost18`, you might use the value in `onlyAtMost19`.

    onlyAtMost18 value =
        -- onlyAtMost19 value --error :(
        onlyAtMost19
            (value |> Nat.restoreMax nat18 {- works :) -})

[`lowerMin`](Nat#lowerMin) is also handy in those situations.

-}
restoreMax :
    Nat (ArgN max (Is a To atLeastMax) x)
    -> Nat (ArgIn min max maybeN)
    -> Nat (ArgIn min atLeastMax maybeN)
restoreMax =
    \_ -> Internal.newRange



-- ### I don't know if either operation is really needed


{-| Subtract a `Nat (ArgIn ..)` without calculating

  - the new minimum, the lowest value it could be after subtracting is 0
  - the new maximum, the highest value it could be after subtracting is the old max

```
in6To12 |> Nat.subLossy between1And5
--> : Nat (In Nat0 Nat12)

atLeast6 |> Nat.subLossy between1And5
--> : Nat (Min Nat0)
```

  - if you know the minimum subtracted value, use [`MinNat.sub`](MinNat#sub).

  - if you also know the maximum subtracted value, use [`InNat.sub`](InNat#sub).

-}
subLossy :
    Nat (ArgIn minSubbed min subbedMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In Nat0 max)
subLossy natToSubtract =
    Internal.sub natToSubtract


{-| Add a `Nat (ArgIn ...)`, but

  - keep the current minimum, instead of computing the exact value

  - use `Infinity` as the maximum instead of computing the exact value

    atLeast5 |> Nat.addLossy atLeast2
    --> : Nat (Min Nat5)

    atLeast2 |> Nat.addLossy atLeast5
    --> : Nat (Min Nat2)

  - if you know the minimum added value, use [`MinNat.add`](MinNat#add).

  - if you also know the minimum added value, use [`InNat.add`](InNat#add).

-}
addLossy :
    Nat (ArgIn minAdded maxAdded addedMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min min)
addLossy natToAdd =
    Internal.add natToAdd
