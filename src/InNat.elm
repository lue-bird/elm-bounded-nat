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
import Nat exposing (ArgIn, ArgN, In, Is, Nat, To)
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

  - `equalOrGreater` than a lower bound or

  - `less`?

`min` ensures that the lower bound is greater than the minimum.

    vote : { age : Nat (ArgIn (Nat18Plus orOlder) max maybeN) } -> Vote

    tryToVote =
        Nat.lowerMin nat0
            >> InNat.isAtLeast nat18
                { min = nat0 }
                { less = Nothing --😓
                , equalOrGreater = \age -> Just (vote { age = age })
                }

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
    ->
        { less : Nat (ArgIn min atLeastTriedMinus1 maybeN) -> result
        , equalOrGreater : Nat (ArgIn tried max maybeN) -> result
        }
    -> Nat (ArgIn min max maybeN)
    -> result
isAtLeast triedLowerBound min cases =
    \inNat ->
        if val2 (>=) inNat triedLowerBound then
            .equalOrGreater cases (Internal.newRange inNat)

        else
            .less cases (Internal.newRange inNat)


{-| Is the `Nat (ArgIn ...)`

  - `equalOrLess` than an upper bound or

  - `greater`?

`min` ensures that the upper bound is greater than the minimum.

    goToU18Party : { age : Nat (ArgIn min Nat17 maybeN) } -> Snack

    tryToGoToU18Party =
        Nat.lowerMin nat0
            >> InNat.isAtMost nat17
                { min = nat0 }
                { equalOrLess =
                    \age -> Just (goToU18Party { age = age })
                , greater = Nothing
                }

-}
isAtMost :
    Nat
        (ArgN
            tried
            (Is a To atLeastTried)
            (Is (Nat1Plus greaterRange) To max)
        )
    -> { min : Nat (ArgN min (Is minToTried To tried) x) }
    ->
        { equalOrLess : Nat (ArgIn min atLeastTried maybeN) -> result
        , greater : Nat (ArgIn (Nat1Plus tried) max maybeN) -> result
        }
    -> Nat (ArgIn min max maybeN)
    -> result
isAtMost triedUpperBound min cases =
    \inNat ->
        if val inNat <= (triedUpperBound |> val) then
            .equalOrLess cases (Internal.newRange inNat)

        else
            .greater cases (Internal.newRange inNat)


{-| Compare the `Nat (ArgIn ...)` to an exact `Nat (ArgN ...)`.
Is it `greater`, `less` or `equal`?

`min` ensures that the `Nat (ArgN ...)` is greater than the minimum.

    present =
        Nat.lowerMin nat0
            >> InNat.is nat18
                { min = nat0 }
                { less = \age -> toy { age = age }
                , greater = \age -> experience { age = age }
                , equal = \() -> bigPresent
                }

    toy : { age : Nat (ArgIn min Nat17 maybeN) } -> Toy

    experience :
        { age : Nat (ArgIn (Nat19Plus orOlder) max maybeN) }
        -> Experience

-}
is :
    Nat
        (ArgN
            tried
            (Is triedToMax To max)
            (Is a To (Nat1Plus atLeastTriedMinus1))
        )
    -> { min : Nat (ArgN min (Is minToTried To tried) x) }
    ->
        { equal : () -> result
        , less : Nat (ArgIn min atLeastTriedMinus1 maybeN) -> result
        , greater : Nat (ArgIn (Nat2Plus triedMinus1) max maybeN) -> result
        }
    -> Nat (ArgIn min max maybeN)
    -> result
is tried min cases =
    \inNat ->
        case val2 compare inNat tried of
            EQ ->
                .equal cases ()

            GT ->
                .greater cases (Internal.newRange inNat)

            LT ->
                .less cases (Internal.newRange inNat)


{-| Compared to a range from a lower to an upper bound, is the `Nat (ArgIn ...)`

  - `inRange`

  - `greater` than the upper bound or

  - `less` than the lower bound?

`min` ensures that the lower bound is greater than the minimum.

    justIfBetween3And10 =
        Nat.lowerMin nat0
            >> InNat.isInRange nat3 nat10
                { min = nat0 }
                { less = \_ -> Nothing
                , greater = \_ -> Nothing
                , inRange = Just
                }

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
    ->
        { inRange : Nat (ArgIn lowerBound atLeastUpperBound maybeN) -> result
        , less : Nat (ArgIn min atLeastLowerBoundMinus1 maybeN) -> result
        , greater : Nat (ArgIn (Nat1Plus upperBound) max maybeN) -> result
        }
    -> Nat (ArgIn min max maybeN)
    -> result
isInRange lowerBound upperBound min cases =
    \inNat ->
        if val2 (<) inNat lowerBound then
            .less cases (Internal.newRange inNat)

        else if val2 (>) inNat upperBound then
            .greater cases (Internal.newRange inNat)

        else
            .inRange cases (Internal.newRange inNat)



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


{-| Add a fixed `Nat (ArgN ...)` value.

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

    nat4 |> InNat.value
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
