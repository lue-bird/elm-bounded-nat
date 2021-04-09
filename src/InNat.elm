module InNat exposing
    ( atMost, atLeast
    , is, isInRange, isAtLeast, isAtMost
    , addN, subN, add, sub
    )

{-| Operations when you know the `maximum` of the `Nat (In minimum maximum maybeN)`.

For example for the argument in

    toHexChar : Nat (In min Nat15 maybeN) -> Char

you should use `InNat` operations.

If the maximum isn't known, use the operations in `MinNat`.


## add information


### clamp

@docs atMost, atLeast


### compare

@docs is, isInRange, isAtLeast, isAtMost


## modify

@docs addN, subN, add, sub

-}

import Internal
import N exposing (Nat1Plus, Nat2Plus)
import Nat exposing (Nat, bi, toInt)
import Nat.Bound exposing (..)



-- ## add information
-- ### clamp


{-| **Cap** the `Nat (In ...)` to at most a number.

    between5And15
        |> InNat.atMost nat10 { min = nat5 }
    --> is of type Nat (ValueIn Nat5 (Nat10Plus a))

`min` ensures that that number is at least the minimum.

-}
atMost :
    Nat (In minNewMax atLeastNewMax newMaxMaybeN)
    -> { min : Nat (N min (Is minToMinNewMax To minNewMax) x) }
    -> Nat (In min max maybeN)
    -> Nat (ValueIn min atLeastNewMax)
atMost higherLimit min =
    Internal.map (Basics.min (higherLimit |> toInt))


{-| If the `Nat (In ...)` is less than a number, return that number instead.

    nat5 |> InNat.atLeast nat10
    --> Nat 10

    nat15 |> InNat.atLeast nat10
    --> Nat 15

-}
atLeast :
    Nat (In newMin max lowerMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn newMin max)
atLeast lowerLimit =
    Internal.map (max (toInt lowerLimit))



-- ## compare


{-| Is the `Nat (In ...)`

  - `equalOrGreater` than a `Nat` or

  - `less`?

```
vote : { age : Nat (In (Nat18Plus orOlder) max maybeN) } -> Vote

tryToVote =
    Nat.lowerMin nat0
        >> InNat.isAtLeast nat18
            { min = nat0 }
            { less = Nothing --😓
            , equalOrGreater = \age -> Just (vote { age = age })
            }
```

-}
isAtLeast :
    Nat
        (N
            tried
            (Is a To (Nat1Plus atLeastTriedMinus1))
            (Is atLeastRange To max)
        )
    ->
        { min :
            Nat (N min (Is (Nat1Plus lessRange) To tried) x)
        }
    ->
        { less : Nat (In min atLeastTriedMinus1 maybeN) -> result
        , equalOrGreater : Nat (In tried max maybeN) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtLeast triedLowerLimit min cases =
    \inNat ->
        if bi (>=) inNat triedLowerLimit then
            .equalOrGreater cases (Internal.newRange inNat)

        else
            .less cases (Internal.newRange inNat)


{-| Is the `Nat (In ...)`

  - `equalOrLess` than a `Nat` or

  - `greater`?

```
goToU18Party : { age : Nat (In min Nat17 maybeN) } -> List Snack

tryToGoToU18Party =
    Nat.lowerMin nat0
        >> InNat.isAtMost nat17
            { min = nat0 }
            { equalOrLess =
                \age -> Just (goToU18Party { age = age })
            , greater = Nothing
            }
```

-}
isAtMost :
    Nat
        (N
            tried
            (Is a To atLeastTried)
            (Is (Nat1Plus greaterRange) To max)
        )
    -> { min : Nat (N min (Is minToTried To tried) x) }
    ->
        { equalOrLess : Nat (In min atLeastTried maybeN) -> result
        , greater : Nat (In (Nat1Plus tried) max maybeN) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtMost triedUpperLimit min cases =
    \inNat ->
        if toInt inNat <= (triedUpperLimit |> toInt) then
            .equalOrLess cases (Internal.newRange inNat)

        else
            .greater cases (Internal.newRange inNat)


{-| Compare the `Nat (In ...)` to an exact `Nat (N ...)`. Is it `greater`, `less` or `equal`?

`min` ensures that the `Nat (N ...)` is bigger than the minimum.

    present =
        Nat.lowerMin nat0
            >> InNat.is nat18
                { min = nat0 }
                { less = \age -> appropriateToy { age = age }
                , greater = \age -> appropriateExperience { age = age }
                , equal = \() -> bigPresent
                }

    appropriateToy : { age : Nat (In Nat0 Nat17) } -> Toy

    appropriateExperience : { age : Nat (In Nat19 max) } -> Experience

-}
is :
    Nat
        (N
            tried
            (Is triedToMax To max)
            (Is a To (Nat1Plus atLeastTriedMinus1))
        )
    -> { min : Nat (N min (Is minToTried To tried) x) }
    ->
        { equal : () -> result
        , less : Nat (In min atLeastTriedMinus1 maybeN) -> result
        , greater : Nat (In (Nat2Plus triedMinus1) max maybeN) -> result
        }
    -> Nat (In min max maybeN)
    -> result
is tried min cases =
    \inNat ->
        case bi compare inNat tried of
            EQ ->
                .equal cases ()

            GT ->
                .greater cases (Internal.newRange inNat)

            LT ->
                .less cases (Internal.newRange inNat)


{-| Compared to a range `first` to `last`, is the `Nat (In ...)`

  - `inRange`

  - `greater` than the `last` or

  - `less` than the `first`?

```
justIfBetween3And10 =
    Nat.lowerMin nat0
        >> InNat.isInRange { first = nat3, last = nat10 }
            { min = nat0 }
            { less = \_ -> Nothing
            , greater = \_ -> Nothing
            , inRange = Just
            }

justIfBetween3And10 nat9
--> Just (Nat 9)

justIfBetween3And10 nat123
--> Nothing
```

-}
isInRange :
    { first :
        Nat
            (N
                first
                (Is firstToLast To last)
                (Is firstA To (Nat1Plus atLeastFirstMinus1))
            )
    , last :
        Nat
            (N
                last
                (Is lastToMax To max)
                (Is lastA To atLeastLast)
            )
    }
    -> { min : Nat (N min (Is minToFirst To first) x) }
    ->
        { inRange : Nat (In first atLeastLast maybeN) -> result
        , less : Nat (In min atLeastFirstMinus1 maybeN) -> result
        , greater : Nat (In (Nat1Plus last) max maybeN) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isInRange interval min cases =
    \inNat ->
        if bi (<) inNat (.first interval) then
            .less cases (Internal.newRange inNat)

        else if bi (>) inNat (.last interval) then
            .greater cases (Internal.newRange inNat)

        else
            .inRange cases (Internal.newRange inNat)



-- ## modify


{-| Add a `Nat (In ...)`.

    between3And10
        |> InNat.add between1And12 nat1 nat12
    --> is of type Nat (ValueIn Nat4 (Nat22Plus a))

-}
add :
    Nat (In minAdded maxAdded addedMaybeMax)
    -> Nat (N minAdded (Is min To sumMin) x)
    -> Nat (N maxAdded (Is max To sumMax) y)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn sumMin sumMax)
add inNatToAdd minAdded maxAdded =
    Internal.add inNatToAdd


{-| Add a fixed `Nat (N ...)` value.

    between70And100
        |> InNat.addN nat7
    --> is of type Nat (In Nat77 (Nat107Plus a))

-}
addN :
    Nat (N added (Is min To sumMin) (Is max To sumMax))
    -> Nat (In min max maybeN)
    -> Nat (ValueIn sumMin sumMax)
addN nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract a `Nat (In ...)`.

The 2 following arguments are

  - the minimum subtracted value

  - the maximum subtracted value

```
between6And12
    |> InNat.sub between1And5 nat1 nat5
--> is of type Nat (ValueIn Nat1 (Nat5Plus a))
```

-}
sub :
    Nat (In minSubbed maxSubbed subbedMaybeN)
    -> Nat (N minSubbed (Is differenceMax To max) x)
    -> Nat (N maxSubbed (Is differenceMin To min) y)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin differenceMax)
sub inNatToSubtract minSubtracted maxSubtracted =
    Internal.sub inNatToSubtract


{-| Subtract an exact `Nat (N ...)` value.

    between7And10
        |> InNat.subN nat7
    --> is of type Nat (ValueIn Nat0 (Nat3Plus a))

**Use [`MinNat.subN`](MinNat#subN) if the maximum value is not known**.

-}
subN :
    Nat (N sub (Is differenceMin To min) (Is differenceMax To max))
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin differenceMax)
subN nNatToSubtract =
    Internal.sub nNatToSubtract
