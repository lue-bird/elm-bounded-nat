module MinNat exposing
    ( is, isAtLeast, isAtMost, atLeast
    , sub, add, subMax, addMin
    , value
    , serialize
    )

{-| 2 situations where you use these operations instead of the ones in [`Nat`](Nat) or [`InNat`](InNat):

1.  Your value is of type `Nat (Min ...)`

        nat3 |> Nat.mul nat3
        --> Nat (Min Nat3)

2.  The maximum is a type variable

        divideBy : Nat (ArgIn (Nat1Plus minMinus1) max ifN_) -> --...
        divideBy atLeast1 =
            --...


# compare

@docs is, isAtLeast, isAtMost, atLeast


# modify

@docs sub, add, subMax, addMin


# drop information

@docs value


# extra

@docs serialize

-}

import I as Internal
import InNat
import N exposing (Nat1Plus, Nat2Plus)
import NNats exposing (nat0)
import Nat exposing (ArgIn, AtMostOrAbove(..), BelowOrAtLeast(..), In, Is, LessOrEqualOrGreater(..), Min, N, Nat, To)
import Serialize
import Typed exposing (val, val2)



-- # modify


{-| Add a `Nat` that isn't a `Nat (N ...)`. The second argument is the minimum added value.

    atLeast5 |> MinNat.addMin nat2 atLeast2
    --> : Nat (Min Nat7)

-}
addMin :
    Nat (N minAdded atLeastMinAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn minAdded maxAdded_ addedIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min sumMin)
addMin minAdded inNatToAdd =
    Internal.add inNatToAdd


{-| Add an exact `Nat (N ...)` value.

    atLeast70 |> InNat.add nat7
    --> : Nat (Min Nat77)

Use [addMin](MinNat#addMin) if you want to add a `Nat` that isn't a `Nat (N ...)`.

-}
add :
    Nat (N added_ atLeastAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (Min sumMin)
add nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract an exact `Nat (N ...)`.

    atLeast7 |> MinNat.sub nat2
    --> : Nat (Min Nat5)

Use [subMax](MinNat#subMax) if you want to subtract a `Nat` that isn't a `Nat (N ...)`.

-}
sub :
    Nat (N subbed_ atLeastSubbed_ (Is differenceMin To min) is_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin max)
sub nNatToSubtract =
    Internal.sub nNatToSubtract


{-| Subtract a `Nat` that isn't a `Nat (N ...)`. The second argument is the maximum of the subtracted `Nat`.

    atLeast6 |> MinNat.subMax nat5 between0And5
    --> : Nat (Min Nat1)

-}
subMax :
    Nat
        (N
            maxSubbed
            atLeastMaxSubbed_
            (Is differenceMin To min)
            is_
        )
    -> Nat (ArgIn minSubbed maxSubbed subbedIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin max)
subMax maxSubtracted inNatToSubtract =
    InNat.subIn
        nat0
        maxSubtracted
        (inNatToSubtract |> Nat.lowerMin nat0)



-- # compare


{-| Is the `Nat` `LessOrEqualOrGreater` than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> MinNat.is nat18 { lowest = nat0 } of
            Nat.Less age ->
                toy { age = age }

            Nat.Greater age ->
                experience { age = age }

            Nat.Equal _ ->
                bigPresent

    toy : { age : Nat (ArgIn Nat0 Nat17 ifN_) } -> Toy

    experience : { age : Nat (ArgIn Nat19 max ifN_) } -> Experience

-}
is :
    Nat
        (N
            (Nat1Plus valueMinus1)
            atLeastValue
            (Is a_ To (Nat1Plus atLeastValueMinus1))
            valueIs_
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToValueMinus1_ To valueMinus1)
                )
        }
    -> Nat (ArgIn min max_ ifN_)
    ->
        LessOrEqualOrGreater
            (Nat (In lowest atLeastValueMinus1))
            (Nat (In (Nat1Plus valueMinus1) atLeastValue))
            (Nat (Min (Nat2Plus valueMinus1)))
is valueToCompareAgainst lowest =
    \minNat ->
        case val2 compare minNat valueToCompareAgainst of
            LT ->
                Less (Internal.newRange minNat)

            EQ ->
                Equal (valueToCompareAgainst |> InNat.value)

            GT ->
                Greater (Internal.newRange minNat)


{-| Is the `Nat` `BelowOrAtLeast` a given number?

    factorial : Nat (ArgIn min_ max_ ifN_) -> Nat (Min Nat1)
    factorial =
        factorialBody

    factorialBody : -- as in factorial
    factorialBody =
        case x |> MinNat.isAtLeast nat1 { lowest = nat0 } of
            Nat.Below _ ->
                MinNat.value nat1

            Nat.EqualOrGreater atLeast1 ->
                Nat.mul atLeast1
                    (factorial
                        (atLeast1 |> MinNat.sub nat1)
                    )

-}
isAtLeast :
    Nat
        (ArgIn
            minLowerBound
            (Nat1Plus maxLowerBoundMinus1)
            lowerBoundIfN_
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is lowestToMinLowerBound_ To minLowerBound)
                )
        }
    -> Nat (ArgIn min max_ ifN_)
    ->
        BelowOrAtLeast
            (Nat (In lowest maxLowerBoundMinus1))
            (Nat (Min minLowerBound))
isAtLeast lowerBound lowest =
    \minNat ->
        if val2 (>=) minNat lowerBound then
            EqualOrGreater (Internal.newRange minNat)

        else
            Below (Internal.newRange minNat)


{-| Is the `Nat` `AtMostOrAbove` a given number?

    goToU18Party : { age : Nat (ArgIn min_ Nat17 ifN_) } -> Snack

    tryToGoToU18Party { age } =
        case age |> MinNat.isAtMost nat17 { lowest = nat0 } of
            EqualOrLess age ->
                Just (goToU18Party { age = age })

            Greater _ ->
                Nothing

-}
isAtMost :
    Nat (ArgIn minUpperBound maxUpperBound upperBoundIfN_)
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToAtMostMin_ To minUpperBound)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        AtMostOrAbove
            (Nat (In lowest maxUpperBound))
            (Nat (Min (Nat1Plus minUpperBound)))
isAtMost upperBound lowest =
    \minNat ->
        if val2 (<=) minNat upperBound then
            EqualOrLess (Internal.newRange minNat)

        else
            Above (Internal.newRange minNat)


{-| Return the given number if the `Nat` is less.

    nat5 |> MinNat.atLeast nat10
    --> Nat 10 : Nat (Min Nat10)

    atLeast5 |> MinNat.atLeast nat10
    --> : Nat (Min Nat10)

-}
atLeast :
    Nat (ArgIn minNewMin newMin_ lowerIfN_)
    -> Nat (ArgIn min_ max_ ifN_)
    -> Nat (Min minNewMin)
atLeast lowerBound =
    value >> Internal.atLeast (value lowerBound)



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
value : Nat (ArgIn min max_ ifN_) -> Nat (Min min)
value =
    Internal.minValue



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s with a lower bound.

    import Serialize

    serializeNaturalNumber :
        Serialize.Codec
            String
            (Nat (Min Nat0))
    serializeNaturalNumber =
        MinNat.serialize nat0

    encode : Nat (ArgIn min max ifN_) -> Bytes
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
    Nat (ArgIn minLowerBound maxLowerBound_ lowerBoundIfN_)
    -> Serialize.Codec String (Nat (Min minLowerBound))
serialize lowerBound =
    Serialize.int
        |> Serialize.mapValid
            (\decodedInt ->
                decodedInt
                    |> Internal.isIntAtLeast lowerBound
                    |> Result.fromMaybe
                        ("The int "
                            ++ String.fromInt decodedInt
                            ++ " was less than the required minimum "
                            ++ String.fromInt (val lowerBound)
                        )
            )
            val
