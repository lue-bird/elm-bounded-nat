module Internal exposing
    ( add, sub
    , isIntInRange, isIntAtLeast
    , intInRange
    , toIn, toMin
    , map, newRange, toInt
    )

{-|


## presets

@docs add, sub


## compare

@docs isIntInRange, isIntAtLeast


## clamp

@docs intInRange


## drop information

@docs toIn, toMin

-}

import Nat.Bound exposing (In, ValueIn, ValueMin)
import T exposing (Nat(..))
import TypeNats exposing (..)


toInt : Nat range -> Int
toInt =
    \(Nat int) -> int


map : (Int -> Int) -> Nat range -> Nat mappedRange
map update =
    toInt >> update >> Nat


newRange : Nat min -> Nat newMin
newRange =
    toInt >> Nat


toMin : Nat (In min max maybeN) -> Nat (ValueMin min)
toMin =
    newRange


toIn : Nat (In min max maybeN) -> Nat (ValueIn min max)
toIn =
    newRange



-- ## compare


isIntInRange :
    { first : Nat (In minFirst last firstMaybeN)
    , last : Nat (In last maxLast lastMaybeN)
    }
    ->
        { less : () -> result
        , greater : Nat (ValueMin (Nat1Plus last)) -> result
        , inRange : Nat (ValueIn minFirst maxLast) -> result
        }
    -> Int
    -> result
isIntInRange interval cases int =
    if int < toInt (.first interval) then
        .less cases ()

    else if int > toInt (.last interval) then
        .greater cases (int |> Nat)

    else
        .inRange cases (int |> Nat)


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
    Nat (In min firstMax lowerMaybeN)
    -> Nat (In firstMax max upperMaybeN)
    -> Int
    -> Nat (ValueIn min max)
intInRange lowerLimit upperLimit =
    Basics.min (upperLimit |> toInt)
        >> Basics.max (lowerLimit |> toInt)
        >> Nat


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
        Just (Nat int)

    else
        Nothing



-- ## presets


add : Nat addedRange -> Nat range -> Nat sumRange
add natToAdd =
    map ((+) (toInt natToAdd))


sub : Nat subtractedRange -> Nat range -> Nat differenceRange
sub natToSubtract =
    map (\x -> x - toInt natToSubtract)
