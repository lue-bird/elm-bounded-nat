module MinNat exposing
    ( is, isAtLeast, isAtMost
    , subN, add, sub, addN
    )

{-| 2 situations where you use these operations instead of the ones in [`Nat`](Nat) or [`InNat`](InNat):

1.  Your value is of type `Nat (ValueMin ...)`

        nat3 |> Nat.mul nat3
        --> Nat (ValueMin Nat3)

2.  The maximum is a type variable

        divideBy : Nat (In (Nat1Plus minMinus1) max maybeN) -> --...
        divideBy atLeast1 =
            --...


### compare

@docs is, isAtLeast, isAtMost


### modify

@docs subN, add, sub, addN

-}

import InNat
import Internal
import NNats exposing (..)
import Nat exposing (Nat, toInt)
import Nat.Bound exposing (In, Is, N, To, ValueIn, ValueMin)
import TypeNats exposing (..)



-- ## modify


{-| Add a `Nat (ValueMin ...)`. The second argument is the minimum if the added `Nat (ValueMin ...)`.

    atLeast5 |> MinNat.add atLeast2 nat2
    --> is of type Nat (ValueMin Nat7)

If you have don't the minimum added value at hand, use [`InNat.addLossy`](InNat#addLossy).

-}
add :
    Nat (In addedMin addedMax addedMaybeN)
    -> Nat (N addedMin (Is min To sumMin) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin sumMin)
add inNatToAdd addedMin =
    Internal.add inNatToAdd


{-| Add a fixed `Nat (N ...)` value.

    atLeast70 |> InNat.addN nat7
    --> is of type Nat (ValueMin Nat77)

-}
addN :
    Nat (N added (Is min To sumMin) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin sumMin)
addN nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract an exact `Nat (N ...)`.

    atLeast7 |> MinNat.subN nat2
    --> is of type Nat (ValueMin Nat5)

-}
subN :
    Nat (N subbed (Is differenceMin To min) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin max)
subN nNatToSubtract =
    Internal.sub nNatToSubtract


{-| Subtract a `Nat (In ...)`. The second argument is the maximum of the subtracted `Nat (In ...)`.

    atLeast6 |> MinNat.sub in0To5 nat5
    --> is of type Nat (In Nat1 (Nat6Plus a))

If you have don't the maximum subtracted value at hand, use [`subLossy`](InNat#subLossy).

-}
sub :
    Nat (In minSubbed maxSubbed subbedMaybeN)
    -> Nat (N maxSubbed (Is differenceMin To min) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin max)
sub inNatToSubtract maxSubtracted =
    InNat.sub (inNatToSubtract |> Nat.lowerMin nat0)
        nat0
        maxSubtracted



-- ## compare


{-| Compare the `Nat (ValueMin ...)` to a `Nat (N ...)`. Is it `greater`, `less` or `equal`?

`min` ensures that the `Nat (N ...)` is bigger than the minimum.

    present =
        MinNat.lowerMin nat0
            >> MinNat.is nat18
                { min = nat0 }
                { less = \age -> appropriateToy { age = age }
                , greater = \age -> appropriateExperience { age = age }
                , equal = \() -> bigPresent
                }

    appropriateToy : { age : Nat (In Nat0 Nat17 maybeN) } -> Toy

    appropriateExperience : { age : Nat (In Nat19 max maybeN) } -> Experience

-}
is :
    Nat (In (Nat1Plus triedMinus1) (Nat1Plus triedMinus1PlusA) triedMaybeN)
    -> { min : Nat (N min (Is minToTriedMinus1 To triedMinus1) x) }
    ->
        { equal : () -> result
        , less : Nat (ValueIn min triedMinus1PlusA) -> result
        , greater : Nat (ValueMin (Nat2Plus triedMinus1)) -> result
        }
    -> Nat (In min max maybeN)
    -> result
is tried min cases =
    \minNat ->
        case compare (toInt minNat) (toInt tried) of
            EQ ->
                .equal cases ()

            LT ->
                .less cases (Internal.newRange minNat)

            GT ->
                .greater cases (Internal.newRange minNat)


{-| Is the `Nat (ValueMin ...)`

  - `equalOrGreater` than a `Nat` or

  - `less`?

```
factorial : MinNat min -> MinNat Nat1
factorial =
    MinNat.lowerMin nat0
        >> MinNat.isAtLeast nat1
            { min = nat0 }
            { less = \_ -> nat1 |> InNat.toMin
            , equalOrGreater =
                \atLeast1 ->
                    atLeast1
                        |> MinNat.mul
                            (factorial
                                (atLeast1 |> MinNat.subN nat1)
                            )
            }
```

-}
isAtLeast :
    Nat (In triedMin (Nat1Plus triedMinMinus1PlusA) triedMaybeN)
    -> { min : Nat (N min (Is minToTriedMin To triedMin) x) }
    ->
        { less : Nat (ValueIn min triedMinMinus1PlusA) -> result
        , equalOrGreater : Nat (ValueMin triedMin) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtLeast triedLowerLimit min cases =
    \minNat ->
        if toInt minNat >= toInt triedLowerLimit then
            .equalOrGreater cases (Internal.newRange minNat)

        else
            .less cases (minNat |> Internal.newRange)


{-| Is the `Nat (ValueMin ...)`

  - `equalOrLess` than a `Nat` or

  - `greater`?

```
goToU18Party : { age : Nat (In min Nat17 maybeN) } -> List Snack

tryToGoToU18Party =
    MinNat.lowerMin nat0
        >> MinNat.isAtMost nat17
            { min = nat0 }
            { equalOrLess = \age -> Just (goToU18Party { age = age })
            , greater = Nothing
            }
```

-}
isAtMost :
    Nat (In atMostMin atMostMinPlusA atMostMaybeN)
    -> { min : Nat (N min (Is minToAtMostMin To atMostMin) x) }
    ->
        { equalOrLess : Nat (ValueIn min atMostMinPlusA) -> result
        , greater : Nat (ValueMin atMostMin) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtMost triedUpperLimit min cases =
    \minNat ->
        if toInt minNat <= toInt triedUpperLimit then
            .equalOrLess cases (minNat |> Internal.newRange)

        else
            .greater cases (Internal.newRange minNat)
