module InNat exposing
    ( atMost, atLeast
    , is, isInRange, isAtLeast, isAtMost
    , addN, subN, add, sub
    )

{-| Operations when you know the `maximum` of the `Nat (In minimum maximum maybeN)`.

For example for the argument in

    toHexChar : Nat (In min Nat15 maybeN) -> Char

you should use `InNat` operations.

In many situations however, the maximum might not be known. Those operations are in `MinNat`, as they apply for `Nat (ValueMin ...)`s as well.


## add information


### clamp

@docs atMost, atLeast


### compare

@docs is, isInRange, isAtLeast, isAtMost


## modify

@docs addN, subN, add, sub

-}

import Internal
import NNats exposing (..)
import Nat exposing (Nat, bi, toInt)
import Nat.Bound exposing (..)
import TypeNats exposing (..)



-- ## add information
-- ### clamp


{-| **Cap** the `Nat (In ...)` to at most a number.

    nat5 |> NNat.toIn
        |> InNat.atMost nat10 { min = nat5 }
    --> InNat 5

    nat15 |> NNat.toIn |> InNat.lowerMin nat5
        |> InNat.atMost nat10 { min = nat5 }
    --> Nat 10

`min` ensures that that number is at least the minimum.

-}
atMost :
    Nat (In minNewMax newMaxPlusA newMaxMaybeN)
    -> { min : Nat (N min (Is minToMinNewMax To minNewMax) x) }
    -> Nat (In min max maybeN)
    -> Nat (ValueIn min newMaxPlusA)
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
vote : { age : Nat (In (Nat18Plus orOlder) max) } -> Vote

tryToVote =
    InNat.lowerMin nat0
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
        { less : Nat (ValueIn min atLeastTriedMinus1) -> result
        , equalOrGreater : Nat (ValueIn tried max) -> result
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
goToU18Party : { age : Nat (In min Nat17) } -> List Snack

tryToGoToU18Party =
    InNat.lowerMin nat0
        >> InNat.isAtMost nat17
            { min = nat0 }
            { equalOrLess = \age -> Just (goToU18Party { age 0 age })
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
        { equalOrLess : Nat (ValueIn min atLeastTried) -> result
        , greater : Nat (ValueIn tried max) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtMost triedUpperLimit min cases =
    \inNat ->
        if toInt inNat <= (triedUpperLimit |> toInt) then
            .equalOrLess cases (Internal.newRange inNat)

        else
            .greater cases (Internal.newRange inNat)


{-| Compare the `Nat (In ...)` to a `Nat (N ...)`. Is it `greater`, `less` or `equal`?

`min` ensures that the `Nat (N ...)` is bigger than the minimum.

    present =
        InNat.lowerMin nat0
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
            (Is a To (Nat1Plus triedPlusAMinus1))
        )
    -> { min : Nat (N min (Is minToTried To tried) x) }
    ->
        { equal : () -> result
        , less : Nat (ValueIn min triedPlusAMinus1) -> result
        , greater : Nat (ValueIn (Nat2Plus triedMinus1) max) -> result
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
    InNat.lowerMin nat0
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
                (Is a To (Nat1Plus firstMinus1PlusA))
            )
    , last :
        Nat
            (N
                last
                (Is lastToMax To max)
                (Is a To lastPlusA)
            )
    }
    -> { min : Nat (N min (Is minToFirst To first) x) }
    ->
        { inRange : Nat (ValueIn first lastPlusA) -> result
        , less : Nat (ValueIn min firstMinus1PlusA) -> result
        , greater : Nat (ValueIn (Nat1Plus last) max) -> result
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

    NNat.toIn nat3
        |> InNat.add between1And12 nat1 nat12
    --> of type Nat (In Nat4 (Nat15Plus a))

-}
add :
    Nat (In addedMin addedMax addedMaybeMax)
    -> Nat (N addedMin (Is min To sumMin) x)
    -> Nat (N addedMax (Is max To sumMax) y)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn sumMin sumMax)
add inNatToAdd addedMin addedMax =
    Internal.add inNatToAdd


{-| Add a fixed `Nat (N ...)` value.

    nat70 |> NNat.toIn
        |> InNat.addN nat7
    --> is of type Nat (In Nat77 (Nat77Plus a))

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

    in6To12
    |> InNat.sub in1And5 nat1 nat5
    --> is of type Nat (In Nat1 (Nat5Plus a))

-}
sub :
    Nat (In minSubbed maxSubbed subbedMaybeN)
    -> Nat (N minSubbed (Is differenceMax To max) x)
    -> Nat (N maxSubbed (Is differenceMin To min) y)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin differenceMax)
sub inNatToSubtract minSubtracted maxSubtracted =
    Internal.sub inNatToSubtract


{-| Subtract a fixed `Nat` value.

    nat7 |> NNat.toIn
        |> InNat.subN nat7
    --> is of type Nat (In Nat0 a)

**Use [`MinNat.subN`](MinNat#subN) if the maximum value is `Infinity`**.

-}
subN :
    Nat (N sub (Is differenceMin To min) (Is differenceMax To max))
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin differenceMax)
subN nNatToSubtract =
    Internal.sub nNatToSubtract
