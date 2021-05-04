module MinNat exposing
    ( is, isAtLeast, isAtMost
    , subN, add, sub, addN
    , value
    , serialize
    )

{-| 2 situations where you use these operations instead of the ones in [`Nat`](Nat) or [`InNat`](InNat):

1.  Your value is of type `Nat (Min ...)`

        nat3 |> Nat.mul nat3
        --> Nat (Min Nat3)

2.  The maximum is a type variable

        divideBy : Nat (ArgIn (Nat1Plus minMinus1) max maybeN) -> --...
        divideBy atLeast1 =
            --...


# compare

@docs is, isAtLeast, isAtMost


# modify

@docs subN, add, sub, addN


# drop information

@docs value


# extra

@docs serialize

-}

import I as Internal
import InNat
import N exposing (Nat1Plus, Nat2Plus)
import NNats exposing (nat0)
import Nat exposing (ArgIn, ArgN, AtMostOrAbove(..), BelowOrAtLeast(..), In, Is, LessOrEqualOrGreater(..), Min, Nat, To)
import Serialize
import Typed exposing (val, val2)



-- ## modify


{-| Add a `Nat (ArgIn ...)`. The second argument is the minimum added value.

    atLeast5 |> MinNat.add atLeast2 nat2
    --> : Nat (Min Nat7)

-}
add :
    Nat (ArgIn minAdded maxAdded addedMaybeN)
    -> Nat (ArgN minAdded (Is min To sumMin) x)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min sumMin)
add inNatToAdd minAdded =
    Internal.add inNatToAdd


{-| Add a fixed `Nat (ArgN ...)` value.

    atLeast70 |> InNat.addN nat7
    --> : Nat (Min Nat77)

-}
addN :
    Nat (ArgN added (Is min To sumMin) x)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min sumMin)
addN nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract an exact `Nat (ArgN ...)`.

    atLeast7 |> MinNat.subN nat2
    --> : Nat (Min Nat5)

-}
subN :
    Nat (ArgN subbed (Is differenceMin To min) x)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In differenceMin max)
subN nNatToSubtract =
    Internal.sub nNatToSubtract


{-| Subtract a `Nat (ArgIn ...)`. The second argument is the maximum of the subtracted `Nat (ArgIn ...)`.

    atLeast6 |> MinNat.sub between0And5 nat5
    --> : Nat (Min Nat1)

If you have don't the maximum subtracted value at hand, use [`subLossy`](InNat#subLossy).

-}
sub :
    Nat (ArgIn minSubbed maxSubbed subbedMaybeN)
    -> Nat (ArgN maxSubbed (Is differenceMin To min) x)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In differenceMin max)
sub inNatToSubtract maxSubtracted =
    InNat.sub (inNatToSubtract |> Nat.lowerMin nat0)
        nat0
        maxSubtracted



-- ## compare


{-| Compare the `Nat` to a `Nat (ArgN ...)`. Is it `Greater`, `Less` or `Equal`?

`min` ensures that the `Nat (ArgN ...)` is greater than the minimum.

    giveAPresent { age } =
        case
            (age |> Nat.lowerMin nat0)
                |> MinNat.is nat18 { min = nat0 }
        of
            Nat.Less age ->
                toy { age = age }

            Nat.Greater age ->
                experience { age = age }

            Nat.Equal () ->
                bigPresent

    toy : { age : Nat (ArgIn Nat0 Nat17 maybeN) } -> Toy

    experience : { age : Nat (ArgIn Nat19 max maybeN) } -> Experience

-}
is :
    Nat (ArgN (Nat1Plus triedMinus1) (Is a To (Nat1Plus triedMinus1PlusA)) x)
    -> { min : Nat (ArgN min (Is minToTriedMinus1 To triedMinus1) y) }
    -> Nat (ArgIn min max maybeN)
    ->
        LessOrEqualOrGreater
            (Nat (ArgIn min triedMinus1PlusA maybeN))
            ()
            (Nat (Min (Nat2Plus triedMinus1)))
is valueToCompareAgainst min =
    \minNat ->
        case val2 compare minNat valueToCompareAgainst of
            LT ->
                Less (Internal.newRange minNat)

            EQ ->
                Equal ()

            GT ->
                Greater (Internal.newRange minNat)


{-| Is the `Nat`

  - `EqualOrGreater` than a `Nat` or

  - `Below` a lower bound?

```
factorial : Nat (ArgIn min max maybeN) -> Nat (Min Nat1)
factorial =
    let
        factorialBody x =
            case x |> MinNat.isAtLeast nat1 { min = nat0 } of
                Nat.Below _ ->
                    MinNat.value nat1

                Nat.EqualOrGreater atLeast1 ->
                    Nat.mul atLeast1
                        (factorial
                            (atLeast1 |> MinNat.subN nat1)
                        )
    in
    Nat.lowerMin nat0 >> factorialBody
```

-}
isAtLeast :
    Nat (ArgN lowerBound (Is a To (Nat1Plus lowerBoundMinus1PlusA)) x)
    -> { min : Nat (ArgN min (Is minToTriedMin To lowerBound) y) }
    -> Nat (ArgIn min max maybeN)
    ->
        BelowOrAtLeast
            (Nat (ArgIn min lowerBoundMinus1PlusA maybeN))
            (Nat (Min lowerBound))
isAtLeast lowerBound min =
    \minNat ->
        if val2 (>=) minNat lowerBound then
            EqualOrGreater (Internal.newRange minNat)

        else
            Below (Internal.newRange minNat)


{-| Is the `Nat`

  - `EqualOrLess` than a `Nat` or

  - `Above`?

```
goToU18Party : { age : Nat (ArgIn min Nat17 maybeN) } -> Snack

tryToGoToU18Party { age } =
    case
        (age |> Nat.lowerMin nat0)
            |> MinNat.isAtMost nat17 { min = nat0 }
    of
        EqualOrLess age ->
            Just (goToU18Party { age = age })

        Greater _ ->
            Nothing
```

-}
isAtMost :
    Nat (ArgN upperBound (Is a To upperBoundPlusA) x)
    -> { min : Nat (ArgN min (Is minToAtMostMin To upperBound) y) }
    -> Nat (ArgIn min max maybeN)
    ->
        AtMostOrAbove
            (Nat (ArgIn min upperBoundPlusA maybeN))
            (Nat (Min (Nat1Plus upperBound)))
isAtMost upperBound min =
    \minNat ->
        if val2 (<=) minNat upperBound then
            EqualOrLess (Internal.newRange minNat)

        else
            Above (Internal.newRange minNat)



-- ## drop information


{-| Convert a `Nat (ArgIn min ...)` to a `Nat (Min min)`.

    between3And10 |> MinNat.value
    --> : Nat (Min Nat4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `Nat (Min Nat1)`

    [ atLeast1
    , between1And10 |> MinNat.value
    ]

-}
value : Nat (ArgIn min max maybeN) -> Nat (Min min)
value =
    Internal.newRange



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s with a lower bound.

    import Serialize

    serializeNaturalNumber :
        Serialize.Codec
            String
            (Nat (Min Nat0))
    serializeNaturalNumber =
        MinNat.serialize nat0

    encode : Nat (ArgIn min max maybeN) -> Bytes
    encode =
        MinNat.value
            >> Serialize.encodeToBytes serializeNaturalNumber

    decode :
        Bytes
        -> Result (Serialize.Error String) (Nat (Min Nat0))
    decode =
        Serialize.decodeFromBytes serializeNaturalNumber

-}
serialize :
    Nat (ArgIn minLowerBound maxLowerBound lowerBoundMaybeN)
    -> Serialize.Codec String (Nat (Min minLowerBound))
serialize lowerBound =
    Serialize.int
        |> Serialize.mapValid
            (Internal.isIntAtLeast lowerBound
                >> Result.fromMaybe "Int was less than the required minimum"
            )
            val
