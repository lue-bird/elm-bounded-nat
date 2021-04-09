module Nat exposing
    ( Nat
    , abs, range, random
    , intAtLeast, intInRange
    , isIntInRange, isIntAtLeast, theGreater, theSmaller
    , toPower, remainderBy, mul, div
    , toInt, bi
    , lowerMin, toMin
    , maxIs
    )

{-|

@docs Nat


## create

@docs abs, range, random


### clamp

@docs intAtLeast, intInRange


### compare

@docs isIntInRange, isIntAtLeast, theGreater, theSmaller


## modify

@docs toPower, remainderBy, mul, div


## transform

@docs toInt, bi


## drop information

@docs lowerMin, toMin


## restore information

@docs maxIs

-}

import Internal
import N exposing (Nat0, Nat1Plus)
import Nat.Bound exposing (In, Is, N, To, ValueIn, ValueMin)
import Random
import T as Internal


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
    Internal.Nat range


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
    Basics.abs int |> Internal.Nat


{-| `Nat (ValueIn ...)`s from a first to a last value.

    from3To10 : List (Nat (ValueIn Nat3 (Nat10Plus a)))
    from3To10 =
        Nat.range nat3 nat10

    from3ToAtLeast10 : List (Nat (ValueMin Nat3))
    from3ToAtLeast10 =
        Nat.range nat3 atLeast10

The resulting `List` always has at least 1 element.

-}
range :
    Nat (In firstMin lastMin firstMaybeN)
    -> Nat (In lastMin lastMax lastMaybeN)
    -> List (Nat (ValueIn firstMin lastMax))
range first last =
    bi List.range first last
        |> List.map Internal.Nat


{-| Generate a random `Nat (ValueIn ...)` in a range.
-}
random :
    Nat (In firstMin lastMin firstMaybeN)
    -> Nat (In lastMin lastMax lastMaybeN)
    -> Random.Generator (Nat (ValueIn firstMin lastMax))
random min max =
    bi Random.int min max
        |> Random.map Internal.Nat


{-| Convert a `Nat` to an `Int`.

    nat4 |> Nat.toInt --> 4
    between4And10 |> Nat.toInt
    atLeast4 |> Nat.toInt

    compareNats : Nat range -> Nat range -> Order
    compareNats a b =
        compare (Nat.toInt a) (Nat.toInt b)

-}
toInt : Nat range -> Int
toInt =
    Internal.toInt


{-| The greater of 2 `Nat`s.

    Nat.theGreater between1And3 (nat4 |> Nat.lowerMin nat1)
    --> Nat 4

-}
theGreater : Nat range -> Nat range -> Nat range
theGreater a b =
    if bi (>) a b then
        a

    else
        b


{-| The smaller of 2 `Nat`s.

    Nat.theSmaller nat3 (nat4 |> Nat.lowerMin nat3)
    --> Nat 3

-}
theSmaller : Nat range -> Nat range -> Nat range
theSmaller a b =
    if bi (<) a b then
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
    Nat (In min firstMax maybeN)
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
    Nat (In min max maybeN)
    -> Int
    -> Maybe (Nat (ValueMin min))
isIntAtLeast minimum int =
    if int >= toInt minimum then
        Just (Internal.Nat int)

    else
        Nothing


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
    Nat (In min max maybeN)
    -> Int
    -> Nat (ValueMin min)
intAtLeast minimum =
    isIntAtLeast minimum
        >> Maybe.withDefault (toMin minimum)


{-| Use the `Int` values of two `Nat`s to return a result.

    Nat.bi (>=) nat5 nat4 --> True

    Nat.bi (>=) nat5 nat40 --> False

Note, that you must give the `Nat`s in the same order you would give `Int`s.

Don't overuse this.

-}
bi :
    (Int -> Int -> result)
    -> Nat aRange
    -> Nat bRange
    -> result
bi op a b =
    op (toInt a) (toInt b)



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
    Internal.map ((*) (toInt natToMultiply))


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
    Internal.map (\x -> x // toInt divNat)


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
    Internal.map (Basics.remainderBy (divNat |> toInt))


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
    Internal.map (\x -> x ^ toInt power)



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


{-| Convert an exact `Nat (In min ...)` to a `Nat (ValueMin min)`.

    in4To10 |> Nat.toMin
    --> is of type Nat (ValueMin Nat4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, in1To10 ]

Elm complains:

> But all the previous elements in the list are: `Nat (ValueMin Nat1)`

    [ atLeast1
    , in1To10 |> Nat.toMin
    ]

-}
toMin : Nat (In min max maybeN) -> Nat (ValueMin min)
toMin =
    Internal.toMin


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
