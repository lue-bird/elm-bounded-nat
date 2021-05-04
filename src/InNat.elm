module InNat exposing
    ( atMost, atLeast
    , is, isInRange, isAtLeast, isAtMost
    , addN, subN, add, sub
    , value
    , serialize
    )

{-| Operations when you know the `maximum` of the `Nat (ArgIn minimum maximum maybeN)`.

For example for the argument in

    toHexChar : Nat (ArgIn min Nat15 maybeN) -> Char

you should use `InNat` operations.

If the maximum isn't known, use the operations in `MinNat`.


# create


## clamp

@docs atMost, atLeast


## compare

@docs is, isInRange, isAtLeast, isAtMost


# modify

@docs addN, subN, add, sub


# drop information

@docs value


# extra

@docs serialize

-}

import I as Internal
import N exposing (Nat1Plus, Nat2Plus)
import Nat exposing (ArgIn, ArgN, AtMostOrAbove(..), BelowOrAtLeast(..), BelowOrInOrAboveRange(..), In, Is, LessOrEqualOrGreater(..), Nat, To)
import Serialize
import Typed exposing (val, val2)



-- ## add information
-- ### clamp


{-| **Cap** the `Nat (ArgIn ...)` to at most a number.

    between5And15
        |> InNat.atMost nat10 { min = nat5 }
    --> : Nat (In Nat5 (Nat10Plus a))

`min` ensures that that number is at least the minimum.

-}
atMost :
    Nat (ArgIn minNewMax atLeastNewMax newMaxMaybeN)
    -> { min : Nat (ArgN min (Is minToMinNewMax To minNewMax) x) }
    -> Nat (ArgIn min max maybeN)
    -> Nat (In min atLeastNewMax)
atMost higherUpperBound min =
    Internal.atMost higherUpperBound min


{-| If the `Nat (ArgIn ...)` is less than a `Nat`, return that number instead.

    nat5 |> InNat.atLeast nat10
    --> Nat 10

    nat15 |> InNat.atLeast nat10
    --> Nat 15

-}
atLeast :
    Nat (ArgIn newMin max lowerMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In newMin max)
atLeast lowerBound =
    Internal.atLeast lowerBound



-- ## compare


{-| Is the `Nat (ArgIn ...)`

  - `EqualOrGreater` than a lower bound or

  - `Below`?

`min` ensures that the lower bound is greater than the minimum.

    vote : { age : Nat (ArgIn (Nat18Plus orOlder) max maybeN) } -> Vote

    tryToVote { age } =
        case
            (age |> Nat.lowerMin nat0)
                |> InNat.isAtLeast nat18 { min = nat0 }
        of
            Nat.Below _ ->
                --😓
                Nothing

            Nat.EqualOrGreater age ->
                Just (vote { age = age })

-}
isAtLeast :
    Nat
        (ArgN
            tried
            (Is a To (Nat1Plus atLeastTriedMinus1))
            (Is atLeastRange To max)
        )
    ->
        { min :
            Nat (ArgN min (Is (Nat1Plus lessRange) To tried) x)
        }
    -> Nat (ArgIn min max maybeN)
    ->
        BelowOrAtLeast
            (Nat (ArgIn min atLeastTriedMinus1 maybeN))
            (Nat (ArgIn tried max maybeN))
isAtLeast triedLowerBound min =
    \inNat ->
        if val2 (>=) inNat triedLowerBound then
            EqualOrGreater (Internal.newRange inNat)

        else
            Below (Internal.newRange inNat)


{-| Is the `Nat (ArgIn ...)`

  - `EqualOrLess` than an upper bound or

  - `Above`?

`min` ensures that the upper bound is greater than the minimum.

    goToU18Party : { age : Nat (ArgIn min Nat17 maybeN) } -> Snack

    tryToGoToU18Party { age } =
        case
            (age |> Nat.lowerMin nat0)
                |> InNat.isAtMost nat17 { min = nat0 }
        of
            Nat.EqualOrLess age ->
                Just (goToU18Party { age = age })

            Nat.Above ->
                Nothing

-}
isAtMost :
    Nat
        (ArgN
            upperBound
            (Is a To atLeastUpperBound)
            (Is (Nat1Plus greaterRange) To max)
        )
    -> { min : Nat (ArgN min (Is minToUpperBound To upperBound) x) }
    -> Nat (ArgIn min max maybeN)
    ->
        AtMostOrAbove
            (Nat (ArgIn min atLeastUpperBound maybeN))
            (Nat (ArgIn (Nat1Plus upperBound) max maybeN))
isAtMost upperBound min =
    \inNat ->
        if val inNat <= (upperBound |> val) then
            EqualOrLess (Internal.newRange inNat)

        else
            Above (Internal.newRange inNat)


{-| Is the `Nat (ArgIn ...)` `Greater`, `Less` or `Equal` than a value?

`min` ensures that the `Nat (ArgN ...)` is greater than the minimum.

    giveAPresent { age } =
        case
            (age |> Nat.lowerMin nat0)
                |> InNat.is nat18 { min = nat0 }
        of
            Nat.Less age ->
                toy { age = age }

            Nat.Greater age ->
                experience { age = age }

            Nat.Equal () ->
                bigPresent

    toy : { age : Nat (ArgIn min Nat17 maybeN) } -> Toy

    experience :
        { age : Nat (ArgIn (Nat19Plus orOlder) max maybeN) }
        -> Experience

-}
is :
    Nat
        (ArgN
            value
            (Is valueToMax To max)
            (Is a To (Nat1Plus atLeastValueMinus1))
        )
    -> { min : Nat (ArgN min (Is minToValue To value) x) }
    -> Nat (ArgIn min max maybeN)
    ->
        LessOrEqualOrGreater
            (Nat (ArgIn min atLeastValueMinus1 maybeN))
            ()
            (Nat (ArgIn (Nat2Plus valueMinus1) max maybeN))
is valueToCompareAgainst min =
    \inNat ->
        case val2 compare inNat valueToCompareAgainst of
            EQ ->
                Equal ()

            GT ->
                Greater (Internal.newRange inNat)

            LT ->
                Less (Internal.newRange inNat)


{-| Compared to a range from a lower to an upper bound, is the `Nat (ArgIn ...)`

  - `InRange`

  - `AboveRange`: greater than the upper bound or

  - `BelowRange`: less than the lower bound?

`min` ensures that the lower bound is greater than the minimum.

    justIfBetween3And10 nat =
        case
            (nat |> Nat.lowerMin nat0)
                |> InNat.isInRange nat3 nat10 { min = nat0 }
        of
            Nat.InRange ->
                Just

            _ ->
                Nothing

    justIfBetween3And10 nat9
    --> Just (Nat 9)

    justIfBetween3And10 nat123
    --> Nothing

-}
isInRange :
    Nat
        (ArgN
            lowerBound
            (Is lowerBoundToUpperBound To upperBound)
            (Is lowerBoundA To (Nat1Plus atLeastLowerBoundMinus1))
        )
    ->
        Nat
            (ArgN
                upperBound
                (Is upperBoundToMax To max)
                (Is upperBoundA To atLeastUpperBound)
            )
    -> { min : Nat (ArgN min (Is minToLowerBound To lowerBound) x) }
    -> Nat (ArgIn min max maybeN)
    ->
        BelowOrInOrAboveRange
            (Nat (ArgIn min atLeastLowerBoundMinus1 maybeN))
            (Nat (ArgIn lowerBound atLeastUpperBound maybeN))
            (Nat (ArgIn (Nat1Plus upperBound) max maybeN))
isInRange lowerBound upperBound min =
    \inNat ->
        if val2 (<) inNat lowerBound then
            BelowRange (Internal.newRange inNat)

        else if val2 (>) inNat upperBound then
            AboveRange (Internal.newRange inNat)

        else
            InRange (Internal.newRange inNat)



-- ## modify


{-| Add a `Nat (ArgIn ...)`.

    between3And10
        |> InNat.add between1And12 nat1 nat12
    --> : Nat (In Nat4 (Nat22Plus a))

-}
add :
    Nat (ArgIn minAdded maxAdded addedMaybeMax)
    -> Nat (ArgN minAdded (Is min To sumMin) x)
    -> Nat (ArgN maxAdded (Is max To sumMax) y)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In sumMin sumMax)
add inNatToAdd minAdded maxAdded =
    Internal.add inNatToAdd


{-| Add a `Nat (ArgN ...)`.

    between70And100
        |> InNat.addN nat7
    --> : Nat (In Nat77 (Nat107Plus a))

-}
addN :
    Nat (ArgN added (Is min To sumMin) (Is max To sumMax))
    -> Nat (ArgIn min max maybeN)
    -> Nat (In sumMin sumMax)
addN nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract a `Nat (ArgIn ...)`.

The 2 following arguments are

  - the minimum subtracted value

  - the maximum subtracted value

```
between6And12
    |> InNat.sub between1And5 nat1 nat5
--> : Nat (In Nat1 (Nat5Plus a))
```

-}
sub :
    Nat (ArgIn minSubbed maxSubbed subbedMaybeN)
    -> Nat (ArgN minSubbed (Is differenceMax To max) x)
    -> Nat (ArgN maxSubbed (Is differenceMin To min) y)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In differenceMin differenceMax)
sub inNatToSubtract minSubtracted maxSubtracted =
    Internal.sub inNatToSubtract


{-| Subtract an exact `Nat (ArgN ...)` value.

    between7And10
        |> InNat.subN nat7
    --> : Nat (In Nat0 (Nat3Plus a))

-}
subN :
    Nat (ArgN sub (Is differenceMin To min) (Is differenceMax To max))
    -> Nat (ArgIn min max maybeN)
    -> Nat (In differenceMin differenceMax)
subN nNatToSubtract =
    Internal.sub nNatToSubtract



-- ## drop information


{-| Convert it to a `Nat (In min max)`.

    InNat.value nat4
    --> : Nat (In Nat4 (Nat4Plus a))

Example

    [ in3To10, nat3 ]

Elm complains:

> But all the previous elements in the list are: `Nat (In Nat3 Nat10)`

    [ in3To10
    , nat3 |> InNat.value
    ]

-}
value : Nat (ArgIn min max maybeN) -> Nat (In min max)
value =
    Internal.newRange



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s within a lower & upper bound.

    import Serialize

    serializePercent :
        Serialize.Codec
            String
            (Nat (In Nat0 (Nat100Plus a)))
    serializePercent =
        InNat.serialize nat0 nat100

    encode : Nat (ArgIn min Nat100 maybeN) -> Bytes
    encode =
        InNat.value
            >> Serialize.encodeToBytes serializePercent

    decode :
        Bytes
        ->
            Result
                (Serialize.Error String)
                (Nat (In Nat0 (Nat100Plus a)))
    decode =
        Serialize.decodeFromBytes serializePercent

For decoded `Int`s out of the expected bounds, the `Result` is an error message.

-}
serialize :
    Nat (ArgIn minLowerBound maxLowerBound lowerBoundMaybeN)
    -> Nat (ArgIn maxLowerBound maxUpperBound upperBoundMaybeN)
    -> Serialize.Codec String (Nat (In minLowerBound maxUpperBound))
serialize lowerBound upperBound =
    Serialize.int
        |> Serialize.mapValid
            (Internal.isIntInRange
                lowerBound
                upperBound
                { less =
                    \() ->
                        Err "Int was less than the expected minimum"
                , greater =
                    \_ ->
                        Err "Int was greatrer than the expected maximum"
                , inRange = Ok
                }
            )
            val
