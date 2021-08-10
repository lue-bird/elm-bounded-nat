module Nat exposing
    ( Nat
    , Min, In, Only
    , N, Is, To
    , ArgIn
    , abs, range, random
    , isIntInRange, isIntAtLeast, theGreater, theSmaller
    , AtMostOrAbove(..), BelowOrAtLeast(..), BelowOrInOrAboveRange(..), LessOrEqualOrGreater(..)
    , intAtLeast, intInRange, atMost
    , toPower, remainderBy, mul, div
    , lowerMin, toIn, toMin
    , restoreMax
    )

{-|

@docs Nat


# bounds


## value / return type

@docs Min, In, Only


### n

@docs N, Is, To


## argument-only types

@docs ArgIn


# create

@docs abs, range, random


# compare

@docs isIntInRange, isIntAtLeast, theGreater, theSmaller


## comparison result

@docs AtMostOrAbove, BelowOrAtLeast, BelowOrInOrAboveRange, LessOrEqualOrGreater


## clamp

@docs intAtLeast, intInRange, atMost


# modify

@docs toPower, remainderBy, mul, div


# drop information

@docs lowerMin, toIn, toMin


# restore information

@docs restoreMax

-}

import I as Internal exposing (NatTag)
import Nats exposing (Nat0, Nat1Plus)
import Random
import Typed exposing (Checked, Public, Typed, val2)


{-| A **bounded** natural number (`>= 0`).


### argument-only type

    -- >= 4
    Nat (ArgIn (Nat4Plus minMinus4) max ifN_)

    -- 4 <= nat <= 15
    Nat (ArgIn (Nat4Plus minMinus4) Nat15 ifN_)

    -- any, just >= 0
    Nat range


### value types

    -- >= 4
    Nat (Min Nat4)

    -- 2 <= nat <= 12
    Nat (In Nat2 (Nat12Plus a_))


### storage types

Like what to store in the `Model` for example.

    -- >= 4
    Nat (Min Nat4)

    -- 2 <= nat <= 12
    Nat (In Nat2 Nat12)


### n

    -- = 3, & 3, described as 2 differences
    Nat
        (N Nat3
            (Nat3Plus orMore_)
            (Is a To (Nat3Plus a))
            (Is b To (Nat3Plus b))
        )

    -- An exact number nTo15 away from 15
    Nat (N n atLeastN_ (Is nTo15 To Nat15) is_)

-}
type alias Nat range =
    Typed Checked (NatTag range) Public Int



-- ## bounds


{-| `In minimum maximum`: A value somewhere within a `minimum` & `maximum`. We don't know the exact value, though.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Do **not** use it as an argument type.

A number between 3 and 5

    Nat (In Nat3 (Nat5Plus a_))

-}
type alias In minimum maximum =
    ArgIn minimum maximum Internal.NotN


{-| `ArgIn minimum maximum ifN_`: An argument somewhere within a `minimum` & `maximum`.

       ↓ minimum   ↓ maximum
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓] ⨯ ⨯ ⨯...

Note: `max` >= `min` for every existing `Nat (ArgIn min max ...)`:

    percent : Nat (ArgIn min_ Nat100 ifN_) -> Percent

→ `min <= Nat100`

If you want a number where you just care about the minimum, leave the `max` as a type _variable_.

       ↓ minimum    ↓ maximum or  →
    ⨯ [✓ ✓ ✓ ✓ ✓ ✓ ✓...

Any natural number:

    Nat (ArgIn min_ max_ ifN_)

A number, at least 5:

    Nat (ArgIn (Nat5Plus minMinus5_) max_ ifN_)

  - `max_` could be a maximum value if there is one

  - `ifN_` could contain extra information if the argument is a `Nat (N ...)`

-}
type alias ArgIn minimum maximum ifN_ =
    Internal.ArgIn minimum maximum ifN_


{-| Only **value / return types should be `Min`**.

Sometimes, you simply cannot compute a maximum.

    abs : Int -> Nat (In Nat0 ??)

This is where to use `Min`.

    abs : Int -> Nat (Min Nat0)

A number >= 5 for example:

    Nat (Min Nat5)

Every `Min min` is of type `In min`.

-}
type alias Min minimum =
    In minimum Internal.Infinity


{-| Expect an exact number.

Only useful as an **argument & storage** type in combination with [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/)s,
not with `Nat`s.

    byte : Arr (Only Nat8) Bit -> Byte

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 8_ `Bit`s.

    type alias TicTacToeBoard =
        Arr
            (Only Nat3)
            (Arr (Only Nat3) TicTacToField)

→ A given [`Arr`](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/) must have _exactly 3 by 3_ `TicTacToeField`s.

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
        (Nat5Plus a_)
        (Is myAge To sistersAge)
        (Is mothersAge To fathersAge)

  - `myAge + 5 = sistersAge`
  - `mothersAge + 5 = fathersAge`

-}
type alias Is a to b =
    Internal.Is a to b


{-| The most detailed description of an exact value.

[`InNat.add`](InNat#add) for example uses this knowledg to describe the number as differences between other type variables.

    add :
        Nat
            (N
                added_
                atLeastAdded_
                (Is min To sumMin)
                (Is max To sumMax)
            )
        -> Nat (ArgIn min max ifN_)
        -> Nat (In sumMin sumMax)

You can just ignore the second difference if you don't need it ([`MinNat.add`](MinNat#add)).

    add :
        Nat
            (N
                added_
                atLeastAdded_
                (Is min To sumMin)
                is_
            )
        -> Nat (ArgIn min max_ ifN_)
        -> Nat (Min sumMin)

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
                MinNat.add nat1
                    >> Nat.lowerMin nat0
            )
            (nat0 |> Nat.toMin)

If something like this isn't possible, [`MinNat.intAtLeast`](MinNat#intAtLeast) is the best way!

-}
abs : Int -> Nat (Min Nat0)
abs int =
    Internal.abs int


{-| `Nat`s from a first to last value.

    Nat.range nat3 nat10
    --> : List (Nat (In Nat3 (Nat10Plus a_)))

    Nat.range nat3 atLeast10
    --> : List (Nat (Min Nat3))

The resulting `List` always has >= 1 element.

With [nats in typesafe-array](https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/Arr#nats) the type even knows the length! Try it.

-}
range :
    Nat (ArgIn firstMin lastMin firstIfN_)
    -> Nat (ArgIn lastMin lastMax lastIfN_)
    -> List (Nat (In firstMin lastMax))
range first last =
    Internal.range first last


{-| Generate a random `Nat` in a range.

    Nat.random nat1 nat10
    --> Random.Generator (Nat (In Nat1 (Nat10Plus a_)))

-}
random :
    Nat (ArgIn lowerBoundMin upperBoundMin lowerBoundIfN_)
    -> Nat (ArgIn upperBoundMin upperBoundMax upperBoundIfN_)
    -> Random.Generator (Nat (In lowerBoundMin upperBoundMax))
random lowest highest =
    Internal.random lowest highest


{-| The greater of 2 `Nat`s.

    Nat.theGreater
        between1And3
        (atLeast4 |> Nat.lowerMin nat1)
    --> : Nat (Min Nat1)

-}
theGreater : Nat range -> Nat range -> Nat range
theGreater a b =
    if val2 (>) a b then
        a

    else
        b


{-| The smaller of 2 `Nat`s.

    Nat.theSmaller
        (nat3 |> Nat.toMin)
        (atLeast4 |> Nat.lowerMin nat3)
    --> Nat 3 : Nat (Min Nat3)

-}
theSmaller : Nat range -> Nat range -> Nat range
theSmaller a b =
    if val2 (<) a b then
        a

    else
        b


{-| Compared to a range from a lower to an upper bound, is the `Int` `BelowOrInOrAboveRange`?

    rejectOrAcceptUserInt :
        Int
        -> Result String (Nat (In Nat1 (Nat100Plus a_)))
    rejectOrAcceptUserInt int =
        case int |> Nat.isIntInRange nat1 nat100 of
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
    Nat (ArgIn minLowerBound minUpperBound lowerBoundIfN_)
    -> Nat (ArgIn minUpperBound maxUpperBound upperBoundIfN_)
    -> Int
    ->
        BelowOrInOrAboveRange
            Int
            (Nat (In minLowerBound maxUpperBound))
            (Nat (Min (Nat1Plus maxUpperBound)))
isIntInRange lowerBound upperBound int =
    Internal.isIntInRange lowerBound upperBound int
        |> fromInternalBelowOrInOrAboveRange


{-| Create a `Nat (In ...)` by **clamping** an `Int` between a minimum & maximum.

  - if the `Int < minimum`, `minimum` is returned
  - if the `Int > maximum`, `maximum` is returned

```
9 |> Nat.intInRange nat3 nat12
--> Nat 9 : Nat (In Nat3 (Nat12Plus a_))

0 |> Nat.intInRange nat3 nat12
--> Nat 3 : Nat (In Nat3 (Nat12Plus a_))

99 |> Nat.intInRange nat3 nat12
--> Nat 12 : Nat (In Nat3 (Nat12Plus a_))
```

If you want to handle the cases `< minimum` & `> maximum` explicitly, use [`isIntInRange`](Nat#isIntInRange).

-}
intInRange :
    Nat (ArgIn minLowerBound minUpperBound lowerBoundIfN_)
    -> Nat (ArgIn minUpperBound maxUpperBound upperBoundIfN_)
    -> Int
    -> Nat (In minLowerBound maxUpperBound)
intInRange lowerBound upperBound int =
    case isIntInRange lowerBound upperBound int of
        InRange inRange ->
            inRange

        BelowRange _ ->
            lowerBound |> Internal.newRange

        AboveRange _ ->
            upperBound |> lowerMin lowerBound


{-| If the `Int >= a minimum`, `Just` the `Nat (Min minimum)`, else `Nothing`.

    4 |> Nat.isIntAtLeast nat5
    --> Nothing : Maybe (Nat (Min Nat5))

    1234 |> Nat.isIntAtLeast nat5
    --> Just (Nat 1234) : Maybe (Nat (Min Nat5))

-}
isIntAtLeast :
    Nat (ArgIn min max_ lowerIfN_)
    -> Int
    -> Maybe (Nat (Min min))
isIntAtLeast minimum int =
    Internal.isIntAtLeast minimum int


{-| A `Nat (Min ...)` from an `Int`; if the `Int < minimum`, `minimum` is returned.

    9 |> Nat.intAtLeast nat3
    --> Nat 9 : Nat (Min Nat3)

    0 |> Nat.intAtLeast nat3
    --> Nat 3 : Nat (Min Nat3)

You can also use this if you know an `Int` must be at least `minimum`.

But avoid it if you can do better, like

    goodLength =
        List.foldl
            (\_ ->
                MinNat.add nat1
                    >> Nat.lowerMin nat0
            )
            (Nat.toMin nat0)

If you want to handle the case `< minimum` yourself, use [`Nat.isIntAtLeast`](Nat#isIntAtLeast).

-}
intAtLeast :
    Nat (ArgIn min max_ lowerIfN_)
    -> Int
    -> Nat (Min min)
intAtLeast minimum =
    isIntAtLeast minimum
        >> Maybe.withDefault (Internal.toMinNat minimum)


{-| **Cap** the `Nat` to at most a number.

    between5And15
        |> Nat.atMost nat10 { lowest = nat5 }
    --> : Nat (In Nat5 (Nat10Plus a_))

    atLeast5 |> Nat.atMost nat10 { lowest = nat5 }
    --> : Nat (In Nat5 (Nat10Plus a_))

`lowest` can be a number <= the minimum.

-}
atMost :
    Nat (ArgIn minNewMax maxNewMax newMaxIfN_)
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is lowestToMinNewMax_ To minNewMax)
                )
        }
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (In lowest maxNewMax)
atMost higherUpperBound lowest =
    Internal.atMost higherUpperBound lowest



-- # modify


{-| Multiply by a `Nat` >= 1.
we know that if `a >= 1`, `x * a >= x`.

    atLeast5  |> Nat.mul nat2
    --> Nat 10 : Nat (Min Nat5)

    atLeast2 |> Nat.mul nat5
    --> Nat 10 : Nat (Min Nat2)

-}
mul :
    Nat (ArgIn (Nat1Plus mulMinMinus1_) mulMax_ mulIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min min)
mul natToMultiply =
    Internal.mul natToMultiply


{-| Divide (`//`) by a `Nat` >= 1.

  - `/ 0` is impossible
  - `x / d` is at most x

```
atMost7 |> Nat.div nat3
--> Nat 2 : Nat (In Nat0 (Nat7Plus a_))
```

-}
div :
    Nat (ArgIn (Nat1Plus divMinMinus1_) divMax_ divIfN_)
    -> Nat (ArgIn min_ max ifN_)
    -> Nat (In Nat0 max)
div divNat =
    Internal.div divNat


{-| The remainder after dividing by a `Nat` >= 1. `x |> remainderBy d` is at most `d`

    atMost7 |> Nat.remainderBy nat3
    --> Nat 1 : Nat (In Nat0 (Nat3Plus a_))

In theory, `x % d` should be at most `d - 1`, but this can't be expressed well by the type.

-}
remainderBy :
    Nat (ArgIn (Nat1Plus divMinMinus1_) divMax divIfN_)
    -> Nat (ArgIn min_ max_ ifN_)
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
    Nat (ArgIn (Nat1Plus powMinMinus1_) powMax_ powIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min min)
toPower power =
    Internal.toPower power



-- # drop information


{-| Set the minimum lower.

    [ atLeast3, atLeast4 ]

Elm complains:

> But all the previous elements in the list are: `Nat (Min Nat3)`

    [ atLeast3
    , atLeast4 |> Nat.lowerMin nat3
    ]

-}
lowerMin :
    Nat (ArgIn newMin min lowerIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In newMin max)
lowerMin =
    \_ -> Internal.newRange


{-| Convert it to a `Nat (In min max)`.

    Nat.toIn nat4
    --> : Nat (In Nat4 (Nat4Plus a_))

Example

    [ in3To10, nat3 ]

Elm complains:

> But all the previous elements in the list are: `Nat (In Nat3 Nat10)`

    [ in3To10
    , nat3 |> Nat.toIn
    ]

-}
toIn : Nat (ArgIn min max ifN_) -> Nat (In min max)
toIn =
    Internal.toInNat


{-| Convert a `Nat (ArgIn min ...)` to a `Nat (Min min)`.

    between3And10 |> Nat.toMin
    --> : Nat (Min Nat4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `Nat (Min Nat1)`

    [ atLeast1
    , between1And10 |> Nat.toMin
    ]

-}
toMin : Nat (ArgIn min max_ ifN_) -> Nat (Min min)
toMin =
    Internal.toMinNat



-- # restore information


{-| Make it fit into functions with require a higher maximum.

You should design type annotations as general as possible.

    onlyAtMost18 : Nat (ArgIn min_ Nat18 ifN_)

    onlyAtMost18 between3And8 -- fine

But once you implement `onlyAtMost18`, you might use the value in `onlyAtMost19`.

    onlyAtMost18 value =
        -- onlyAtMost19 value → error
        onlyAtMost19 (value |> Nat.restoreMax nat18)

-}
restoreMax :
    Nat (ArgIn max newMax newMaxIfN_)
    -> Nat (ArgIn min max ifN)
    -> Nat (ArgIn min newMax ifN)
restoreMax =
    \_ -> Internal.newRange



-- # comparison


{-| **Should not be exposed**
-}
fromInternalBelowOrInOrAboveRange :
    Internal.BelowOrInOrAboveRange lt inRange gt
    -> BelowOrInOrAboveRange lt inRange gt
fromInternalBelowOrInOrAboveRange compared =
    case compared of
        Internal.BelowRange lt ->
            BelowRange lt

        Internal.InRange inRange ->
            InRange inRange

        Internal.AboveRange gt ->
            AboveRange gt


{-| The result of comparing a `Nat` to another `Nat`.

  - `EqualOrGreater`: >= that `Nat`

  - `Below`: < that `Nat`

Values exist for each condition.

-}
type BelowOrAtLeast below equalOrGreater
    = Below below
    | EqualOrGreater equalOrGreater


{-| The result of comparing a `Nat` to another `Nat`.

  - `EqualOrLess`: <= that `Nat`

  - `Above`: > that `Nat`

Values exist for each condition.

-}
type AtMostOrAbove equalOrLess above
    = EqualOrLess equalOrLess
    | Above above


{-| The result of comparing a `Nat` to another `Nat`.

  - `Equal` to that `Nat`

  - `Less` than that `Nat`

  - `Greater` than that `Nat`

Values exist for each condition.

-}
type LessOrEqualOrGreater less equal greater
    = Less less
    | Equal equal
    | Greater greater


{-| The result of comparing a `Nat` to a range from a lower to an upper bound.

  - `InRange`
  - `AboveRange`: greater than the upper bound
  - `BelowRange`: less than the lower bound?

Values exist for each condition.

-}
type BelowOrInOrAboveRange below inRange above
    = BelowRange below
    | InRange inRange
    | AboveRange above



{- I don't know if these lossy operations are really needed


   {-| Subtract a `Nat (In ..)` without calculating

     - the new minimum, the lowest value it could be after subtracting is 0
     - the new maximum, the highest value it could be after subtracting is the old max

   ```
   in6To12 |> Nat.subLossy between1And5
   --> : Nat (In Nat0 Nat12)

   atLeast6 |> Nat.subLossy between1And5
   --> : Nat (Min Nat0)
   ```

     - if you know the maximum subtracted value, use [`MinNat.subMax`](MinNat#subMax).

     - if you also know the minimum subtracted value, use [`InNat.subIn`](InNat#subIn).

   -}
   subLossy :
       Nat (ArgIn minSubbed_ min subbedIfN_)
       -> Nat (ArgIn min max ifN_)
       -> Nat (In Nat0 max)
   subLossy natToSubtract =
       Internal.sub natToSubtract


   {-| Add a `Nat (In ...)`, but

     - keep the current minimum, instead of computing the exact value

     - use `Min` as the result instead of computing the maximum

       atLeast5 |> Nat.addLossy atLeast2
       --> : Nat (Min Nat5)

       atLeast2 |> Nat.addLossy atLeast5
       --> : Nat (Min Nat2)

     - if you know the minimum added value, use [`MinNat.addMin`](MinNat#addMin).

     - if you also know the minimum added value, use [`InNat.addIn`](InNat#addIn).

   -}
   addLossy :
       Nat (ArgIn minAdded_ maxAdded_ addedIfN_)
       -> Nat (ArgIn min max_ ifN_)
       -> Nat (Min min)
   addLossy natToAdd =
       Internal.add natToAdd

-}
