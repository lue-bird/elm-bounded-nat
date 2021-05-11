module InNat exposing
    ( atMost, atLeast
    , is, isInRange, isAtLeast, isAtMost
    , add, sub, addIn, subIn
    , value
    , serialize
    )

{-| Operations when you know the `maximum` of the `Nat (ArgIn minimum maximum ifN_)`.

For example for the argument in

    toHexChar : Nat (ArgIn min_ Nat15 ifN_) -> Char

you should use `InNat` operations.

If the maximum isn't known, use the operations in `MinNat`.


# create


## clamp

@docs atMost, atLeast


## compare

@docs is, isInRange, isAtLeast, isAtMost


# modify

@docs add, sub, addIn, subIn


# drop information

@docs value


# extra

@docs serialize

-}

import I as Internal
import N exposing (Nat1Plus, Nat2Plus)
import Nat exposing (ArgIn, AtMostOrAbove(..), BelowOrAtLeast(..), BelowOrInOrAboveRange(..), In, Is, LessOrEqualOrGreater(..), N, Nat, To)
import Serialize
import Typed exposing (val, val2)



-- ## create
-- ### clamp


{-| **Cap** the `Nat` to at most a number.

    between5And15
        |> InNat.atMost nat10 { lowest = nat5 }
    --> : Nat (In Nat5 (Nat10Plus a_))

`lowest` can be a number <= the minimum.

-}
atMost :
    Nat (ArgIn minNewMax atLeastNewMax newMaxIfN_)
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
    -> Nat (ArgIn min max ifN_)
    -> Nat (In lowest atLeastNewMax)
atMost higherUpperBound lowest =
    Internal.atMost higherUpperBound lowest


{-| If the `Nat` is less than a `Nat`, return that number instead.

    nat5 |> InNat.atLeast nat10
    --> Nat 10

    nat15 |> InNat.atLeast nat10
    --> Nat 15

-}
atLeast :
    Nat (ArgIn newMin max lowerIfN_)
    -> Nat (ArgIn min_ max ifN_)
    -> Nat (In newMin max)
atLeast lowerBound =
    Internal.atLeast lowerBound



-- ## compare


{-| Is the `Nat` `BelowOrAtLeast` as big as a given number?

`lowest` can be a number <= the minimum.

    vote :
        { age : Nat (ArgIn (Nat18Plus orOlder) max ifN_) }
        -> Vote

    tryToVote { age } =
        case age |> InNat.isAtLeast nat18 { lowest = nat0 } of
            Nat.Below _ ->
                --😓
                Nothing

            Nat.EqualOrGreater age ->
                Just (vote { age = age })

-}
isAtLeast :
    Nat
        (N
            lowerBound
            (Nat1Plus atLeastLowerBoundMinus1)
            (Is atLeastRange_ To max)
            is_
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest
                    (Is lowestToMin To min)
                    (Is (Nat1Plus lowestToLowerBound_) To lowerBound)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        BelowOrAtLeast
            (Nat (In lowest atLeastLowerBoundMinus1))
            (Nat (In lowerBound max))
isAtLeast lowerBound lowest =
    \inNat ->
        if val2 (>=) inNat lowerBound then
            EqualOrGreater (Internal.newRange inNat)

        else
            Below (Internal.newRange inNat)


{-| Is the `Nat` `AtMostOrAbove` a given number?

`lowest` can be a number <= the minimum.

    goToU18Party : { age : Nat (ArgIn min Nat17 ifN_) } -> Snack

    tryToGoToU18Party { age } =
        case age |> InNat.isAtMost nat17 { lowest = nat0 } of
            Nat.EqualOrLess age ->
                Just (goToU18Party { age = age })

            Nat.Above ->
                Nothing

-}
isAtMost :
    Nat
        (N
            upperBound
            atLeastUpperBound
            (Is (Nat1Plus greaterRange_) To max)
            is_
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToUpperBound_ To upperBound)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        AtMostOrAbove
            (Nat (In lowest atLeastUpperBound))
            (Nat (In (Nat1Plus upperBound) max))
isAtMost upperBound lowest =
    \inNat ->
        if val inNat <= (upperBound |> val) then
            EqualOrLess (Internal.newRange inNat)

        else
            Above (Internal.newRange inNat)


{-| Is the `Nat` `LessOrEqualOrGreater` than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> InNat.is nat18 { lowest = nat0 } of
            Nat.Less age ->
                toy { age = age }

            Nat.Greater age ->
                experience { age = age }

            Nat.Equal () ->
                bigPresent

    toy : { age : Nat (ArgIn min Nat17 ifN_) } -> Toy

    experience :
        { age : Nat (ArgIn (Nat19Plus orOlder) max ifN_) }
        -> Experience

-}
is :
    Nat
        (N
            value
            (Nat1Plus atLeastValueMinus1)
            (Is valueToMax_ To max)
            is_
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToValue_ To value)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        LessOrEqualOrGreater
            (Nat (In lowest atLeastValueMinus1))
            ()
            (Nat (In (Nat2Plus valueMinus1) max))
is valueToCompareAgainst lowest =
    \inNat ->
        case val2 compare inNat valueToCompareAgainst of
            EQ ->
                Equal ()

            GT ->
                Greater (Internal.newRange inNat)

            LT ->
                Less (Internal.newRange inNat)


{-| Compared to a range from a lower to an upper bound, is the `Nat` `BelowOrInOrAboveRange`?

`lowest` can be a number <= the minimum.

    justIfBetween3And10 nat =
        case nat |> InNat.isInRange nat3 nat10 { lowest = nat0 } of
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
        (N
            lowerBound
            (Nat1Plus atLeastLowerBoundMinus1)
            (Is lowerBoundToUpperBound_ To upperBound)
            lowerBoundIs_
        )
    ->
        Nat
            (N
                upperBound
                atLeastUpperBound
                (Is upperBoundToMax_ To max)
                upperBoundIs_
            )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToLowerBound_ To lowerBound)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        BelowOrInOrAboveRange
            (Nat (In lowest atLeastLowerBoundMinus1))
            (Nat (In lowerBound atLeastUpperBound))
            (Nat (In (Nat1Plus upperBound) max))
isInRange lowerBound upperBound lowest =
    \inNat ->
        if val2 (<) inNat lowerBound then
            BelowRange (Internal.newRange inNat)

        else if val2 (>) inNat upperBound then
            AboveRange (Internal.newRange inNat)

        else
            InRange (Internal.newRange inNat)



-- ## modify


{-| Add a `Nat (In ...)`.

The first 2 arguments are

  - the minimum added value

  - the maximum added value

```
between3And10
    |> InNat.addIn nat1 nat12 between1And12
--> : Nat (In Nat4 (Nat22Plus a_))
```

-}
addIn :
    Nat (N minAdded atLeastMinAdded_ (Is min To sumMin) minAddedIs_)
    -> Nat (N maxAdded atLeastMaxAdded_ (Is max To sumMax) maxAddedIs_)
    -> Nat (ArgIn minAdded maxAdded addedIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In sumMin sumMax)
addIn minAdded maxAdded inNatToAdd =
    Internal.add inNatToAdd


{-| Add a `Nat (N ...)`.

    between70And100
        |> InNat.add nat7
    --> : Nat (In Nat77 (Nat107Plus a_))

-}
add :
    Nat
        (N
            added
            atLeastAdded_
            (Is min To sumMin)
            (Is max To sumMax)
        )
    -> Nat (ArgIn min max ifN_)
    -> Nat (In sumMin sumMax)
add nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract a `Nat (ArgIn ...)`.

The first 2 arguments are

  - the minimum subtracted value

  - the maximum subtracted value

```
between6And12
    |> InNat.subIn nat1 nat5 between1And5
--> : Nat (In Nat1 (Nat5Plus a_))
```

-}
subIn :
    Nat
        (N
            minSubbed
            atLeastMinSubbed_
            (Is differenceMax To max)
            minSubbedIs_
        )
    ->
        Nat
            (N
                maxSubbed
                atLeastMaxSubbed_
                (Is differenceMin To min)
                maxSubbedIs_
            )
    -> Nat (ArgIn minSubbed maxSubbed subbedIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin differenceMax)
subIn minSubtracted maxSubtracted inNatToSubtract =
    Internal.sub inNatToSubtract


{-| Subtract an exact `Nat (N ...)` value.

    between7And10
        |> InNat.sub nat7
    --> : Nat (In Nat0 (Nat3Plus a_))

-}
sub :
    Nat
        (N
            subbed_
            atLeastSubbed_
            (Is differenceMin To min)
            (Is differenceMax To max)
        )
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin differenceMax)
sub nNatToSubtract =
    Internal.sub nNatToSubtract



-- ## drop information


{-| Convert it to a `Nat (In min max)`.

    InNat.value nat4
    --> : Nat (In Nat4 (Nat4Plus a_))

Example

    [ in3To10, nat3 ]

Elm complains:

> But all the previous elements in the list are: `Nat (In Nat3 Nat10)`

    [ in3To10
    , nat3 |> InNat.value
    ]

-}
value : Nat (ArgIn min max ifN_) -> Nat (In min max)
value =
    Internal.newRange



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s within a lower & upper bound.

    import Serialize

    serializePercent :
        Serialize.Codec
            String
            (Nat (In Nat0 (Nat100Plus a_)))
    serializePercent =
        InNat.serialize nat0 nat100

    encode : Nat (ArgIn min_ Nat100 ifN_) -> Bytes
    encode =
        InNat.value
            >> Serialize.encodeToBytes serializePercent

    decode :
        Bytes
        ->
            Result
                (Serialize.Error String)
                (Nat (In Nat0 (Nat100Plus a_)))
    decode =
        Serialize.decodeFromBytes serializePercent

For decoded `Int`s out of the expected bounds, the `Result` is an error message.

-}
serialize :
    Nat (ArgIn minLowerBound maxLowerBound lowerBoundIfN_)
    -> Nat (ArgIn maxLowerBound maxUpperBound upperBoundIfN_)
    -> Serialize.Codec String (Nat (In minLowerBound maxUpperBound))
serialize lowerBound upperBound =
    Serialize.int
        |> Serialize.mapValid
            (\int ->
                case int |> Nat.isIntInRange lowerBound upperBound of
                    BelowRange () ->
                        Err "Int was less than the expected minimum"

                    AboveRange _ ->
                        Err "Int was greater than the expected maximum"

                    InRange inRange ->
                        Ok inRange
            )
            val
