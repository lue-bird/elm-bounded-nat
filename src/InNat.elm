module InNat exposing
    ( is, isInRange, isAtLeast, isAtMost
    , atLeast
    , add, sub, addIn, subIn
    , serialize
    , Error, Expectation(..), errorToString
    )

{-| If a `Nat` has a maximum (not [`NoMax`](Nat#NoMax)) you should use operations from `InNat` instead of [`MinNat`](MinNat).

For example for the argument in

    toHexChar : Nat (ArgIn min_ Nat15 ifN_) -> Char


# compare

@docs is, isInRange, isAtLeast, isAtMost


## clamp

@docs atLeast


# modify

@docs add, sub, addIn, subIn


# transform

@docs serialize


## error

@docs Error, Expectation, errorToString

-}

import Common exposing (fromInternalAtMostOrAbove, fromInternalBelowOrAtLeast, fromInternalBelowOrInOrAboveRange, fromInternalLessOrEqualOrGreater, serializeValid)
import I as Internal exposing (toMinNat)
import Nat exposing (ArgIn, AtMostOrAbove, BelowOrAtLeast, BelowOrInOrAboveRange(..), In, Is, LessOrEqualOrGreater, Min, N, Nat, To)
import Nats exposing (Nat0, Nat1Plus, Nat2Plus, nat0)
import Serialize exposing (Codec)
import Typed exposing (val)



-- # compare


{-| Is the `Nat` [`BelowOrAtLeast`](Nat#BelowOrAtLeast) as big as a given number?

`lowest` can be a number <= the minimum.

    vote :
        { age : Nat (ArgIn (Nat18Plus minMinus18_) max_ ifN_) }
        -> Vote

    tryToVote { age } =
        case age |> InNat.isAtLeast nat18 { lowest = nat0 } of
            Nat.Below _ ->
                --😓
                Nothing

            Nat.EqualOrGreater oldEnough ->
                Just (vote { age = oldEnough })

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
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is (Nat1Plus lowestToLowerBound_) To lowerBound)
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        BelowOrAtLeast
            (Nat (In lowest atLeastLowerBoundMinus1))
            (Nat (In lowerBound max))
isAtLeast lowerBound =
    \lowest ->
        Internal.inIsAtLeast lowerBound lowest
            >> fromInternalBelowOrAtLeast


{-| Is the `Nat` [`AtMostOrAbove`](Nat#AtMostOrAbove) a given number?

`lowest` can be a number <= the minimum.

    goToU18Party : { age : Nat (ArgIn min_ Nat17 ifN_) } -> Snack

    tryToGoToU18Party { age } =
        case age |> InNat.isAtMost nat17 { lowest = nat0 } of
            Nat.EqualOrLess u18 ->
                Just (goToU18Party { age = u18 })

            Nat.Above _ ->
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
isAtMost upperBound =
    \lowest ->
        Internal.inIsAtMost upperBound lowest
            >> fromInternalAtMostOrAbove


{-| Is the `Nat` [`LessOrEqualOrGreater`](Nat#LessOrEqualOrGreater) than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> InNat.is nat18 { lowest = nat0 } of
            Nat.Less younger ->
                toy { age = younger }

            Nat.Greater older ->
                book { age = older }

            Nat.Equal _ ->
                bigPresent

    toy : { age : Nat (ArgIn min_ Nat17 ifN_) } -> Toy

    book :
        { age : Nat (ArgIn (Nat19Plus minMinus19_) max_ ifN_) }
        -> Book

-}
is :
    Nat
        (N
            (Nat1Plus valueMinus1)
            atLeastValue
            (Is a_ To (Nat1Plus atLeastValueMinus1))
            (Is valueToMax_ To max)
        )
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToValue_ To (Nat1Plus valueMinus1))
                )
        }
    -> Nat (ArgIn min max ifN_)
    ->
        LessOrEqualOrGreater
            (Nat (In lowest atLeastValueMinus1))
            (Nat (In (Nat1Plus valueMinus1) atLeastValue))
            (Nat (In (Nat2Plus valueMinus1) max))
is valueToCompareAgainst =
    \lowest ->
        Internal.inIs valueToCompareAgainst lowest
            >> fromInternalLessOrEqualOrGreater


{-| Compared to a range from a lower to an upper bound, is the `Nat` [`BelowOrInOrAboveRange`](Nat#BelowOrInOrAboveRange)?

`lowest` can be a number <= the minimum.

    ifBetween3And10 nat =
        case nat |> InNat.isInRange nat3 nat10 { lowest = nat0 } of
            Nat.InRange inRange ->
                Just inRange

            _ ->
                Nothing

    ifBetween3And10 nat9
    --> Just (Nat 9)

    ifBetween3And10 nat123
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
isInRange lowerBound upperBound =
    \lowest ->
        Internal.inIsInRange lowerBound upperBound lowest
            >> fromInternalBelowOrInOrAboveRange



-- ## clamp


{-| Return the given number if the `Nat` is less.

    between5And9 |> InNat.atLeast nat10
    --> Nat 10 : Nat (In Nat10 (Nat10Plus a_))

    nat15 |> InNat.atLeast nat10
    --> Nat 15

-}
atLeast :
    Nat (ArgIn minNewMin max lowerIfN_)
    -> Nat (ArgIn min_ max ifN_)
    -> Nat (In minNewMin max)
atLeast lowerBound =
    Internal.atLeast lowerBound



-- # modify


{-| Add a `Nat` that isn't a `Nat (N ...)`.

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
    Internal.inAddIn minAdded maxAdded inNatToAdd


{-| Add a `Nat (N ...)`.

    between70And100
        |> InNat.add nat7
    --> : Nat (In Nat77 (Nat107Plus a_))

Use [addIn](#addIn) if you want to add a `Nat` that isn't a `Nat (N ...)`.

-}
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
add nNatToAdd =
    Internal.inAdd nNatToAdd


{-| Subtract a `Nat` that isn't a `Nat (N ...)`.

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
    Internal.inSubIn minSubtracted maxSubtracted inNatToSubtract


{-| Subtract an exact `Nat (N ...)` value.

    between7And10
        |> InNat.sub nat7
    --> : Nat (In Nat0 (Nat3Plus a_))

Use [subIn](InNat#subIn) if you want to subtract a `Nat` that isn't a `Nat (N ...)`.

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
    Internal.inSub nNatToSubtract



-- # extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s within a lower & upper bound.

    import Serialize exposing (Codec)

    serializePercent :
        Codec
            String
            (Nat (In Nat0 (Nat100Plus a_)))
    serializePercent =
        InNat.serialize nat0 nat100
            >> Serialize.mapError InNat.errorToString

The encode/decode functions can be extracted if needed.

    encodePercent : Nat (ArgIn min_ Nat100 ifN_) -> Bytes
    encodePercent =
        Nat.toIn
            >> Serialize.encodeToBytes serializePercent

    decodePercent :
        Bytes
        ->
            Result
                (Serialize.Error String)
                (Nat (In Nat0 (Nat100Plus a_)))
    decodePercent =
        Serialize.decodeFromBytes serializePercent

For decoded `Int`s out of the expected bounds, the `Result` is an error message.

-}
serialize :
    Nat (ArgIn minLowerBound maxLowerBound lowerBoundIfN_)
    -> Nat (ArgIn maxLowerBound maxUpperBound upperBoundIfN_)
    ->
        Codec
            Error
            (Nat (In minLowerBound maxUpperBound))
serialize lowerBound upperBound =
    serializeValid
        (\int ->
            let
                toMin0 =
                    Nat.lowerMin nat0 >> toMinNat
            in
            case int |> Nat.isIntInRange lowerBound upperBound of
                BelowRange _ ->
                    Err (ExpectAtLeast (lowerBound |> toMin0))

                AboveRange _ ->
                    Err (ExpectAtMost (upperBound |> toMin0))

                InRange inRange ->
                    Ok inRange
        )


{-| An expectation for the decoded int that hasn't been met.

  - `ExpectAtLeast` some minimum in a range
  - `ExpectAtMost` some maximum in a range

See [errorToString](InNat#errorToString) and [serialize](InNat#serialize).

-}
type Expectation
    = ExpectAtLeast (Nat (Min Nat0))
    | ExpectAtMost (Nat (Min Nat0))


{-| An error for when a decoded int is outside the expected bounds.

You can transform it into a message with [`errorToString`](InNat#errorToString).

See [`serialize`](InNat#serialize).

-}
type alias Error =
    { expected : Expectation
    , actual : Int
    }


{-| Convert an [`Error`](InNat#Error) to a readable message.

    { expected = InNat.ExpectAtLeast nat11
    , actual = 10
    }
        |> InNat.errorToString
    --> "expected an int >= 11 but the actual int was 10"

(example won't compile because `nat11` isn't of type `Nat (Min Nat0)`)

-}
errorToString : Error -> String
errorToString error =
    [ "expected an int"
    , case error.expected of
        ExpectAtLeast minimum ->
            [ ">=", val minimum |> String.fromInt ]
                |> String.join " "

        ExpectAtMost maximum ->
            [ "<=", val maximum |> String.fromInt ]
                |> String.join " "
    , "but the actual int was"
    , String.fromInt error.actual
    ]
        |> String.join " "
