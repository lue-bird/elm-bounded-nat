module InNat exposing
    ( atMost, atLeast
    , is, isInRange, isAtLeast, isAtMost
    , addN, subN, add, sub
    , value
    , serialize
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


## drop information

@docs value


## extra

@docs serialize

-}

import I as Internal
import N exposing (Nat1Plus, Nat2Plus)
import Nat exposing (In, Is, N, Nat, To, ValueIn)
import Serialize
import Typed exposing (val, val2)



-- ## add information
-- ### clamp


{-| **Cap** the `Nat (In ...)` to at most a number.

    between5And15
        |> InNat.atMost nat10 { min = nat5 }
    --> : Nat (ValueIn Nat5 (Nat10Plus a))

`min` ensures that that number is at least the minimum.

-}
atMost :
    Nat (In minNewMax atLeastNewMax newMaxMaybeN)
    -> { min : Nat (N min (Is minToMinNewMax To minNewMax) x) }
    -> Nat (In min max maybeN)
    -> Nat (ValueIn min atLeastNewMax)
atMost higherUpperBound min =
    Internal.atMost higherUpperBound min


{-| If the `Nat (In ...)` is less than a `Nat`, return that number instead.

    nat5 |> InNat.atLeast nat10
    --> Nat 10

    nat15 |> InNat.atLeast nat10
    --> Nat 15

-}
atLeast :
    Nat (In newMin max lowerMaybeN)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn newMin max)
atLeast lowerBound =
    Internal.atLeast lowerBound



-- ## compare


{-| Is the `Nat (In ...)`

  - `equalOrGreater` than a lower bound or

  - `less`?

`min` ensures that the lower bound is greater than the minimum.

    vote : { age : Nat (In (Nat18Plus orOlder) max maybeN) } -> Vote

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
isAtLeast triedLowerBound min cases =
    \inNat ->
        if val2 (>=) inNat triedLowerBound then
            .equalOrGreater cases (Internal.newRange inNat)

        else
            .less cases (Internal.newRange inNat)


{-| Is the `Nat (In ...)`

  - `equalOrLess` than an upper bound or

  - `greater`?

`min` ensures that the upper bound is greater than the minimum.

    goToU18Party : { age : Nat (In min Nat17 maybeN) } -> Snack

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
isAtMost triedUpperBound min cases =
    \inNat ->
        if val inNat <= (triedUpperBound |> val) then
            .equalOrLess cases (Internal.newRange inNat)

        else
            .greater cases (Internal.newRange inNat)


{-| Compare the `Nat (In ...)` to an exact `Nat (N ...)`.
Is it `greater`, `less` or `equal`?

`min` ensures that the `Nat (N ...)` is greater than the minimum.

    present =
        Nat.lowerMin nat0
            >> InNat.is nat18
                { min = nat0 }
                { less = \age -> toy { age = age }
                , greater = \age -> experience { age = age }
                , equal = \() -> bigPresent
                }

    toy : { age : Nat (In min Nat17 maybeN) } -> Toy

    experience :
        { age : Nat (In (Nat19Plus orOlder) max maybeN) }
        -> Experience

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
        case val2 compare inNat tried of
            EQ ->
                .equal cases ()

            GT ->
                .greater cases (Internal.newRange inNat)

            LT ->
                .less cases (Internal.newRange inNat)


{-| Compared to a range from a lower to an upper bound, is the `Nat (In ...)`

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
        (N
            lowerBound
            (Is lowerBoundToUpperBound To upperBound)
            (Is lowerBoundA To (Nat1Plus atLeastLowerBoundMinus1))
        )
    ->
        Nat
            (N
                upperBound
                (Is upperBoundToMax To max)
                (Is upperBoundA To atLeastUpperBound)
            )
    -> { min : Nat (N min (Is minToLowerBound To lowerBound) x) }
    ->
        { inRange : Nat (In lowerBound atLeastUpperBound maybeN) -> result
        , less : Nat (In min atLeastLowerBoundMinus1 maybeN) -> result
        , greater : Nat (In (Nat1Plus upperBound) max maybeN) -> result
        }
    -> Nat (In min max maybeN)
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


{-| Add a `Nat (In ...)`.

    between3And10
        |> InNat.add between1And12 nat1 nat12
    --> : Nat (ValueIn Nat4 (Nat22Plus a))

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
    --> : Nat (In Nat77 (Nat107Plus a))

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
--> : Nat (ValueIn Nat1 (Nat5Plus a))
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
    --> : Nat (ValueIn Nat0 (Nat3Plus a))

-}
subN :
    Nat (N sub (Is differenceMin To min) (Is differenceMax To max))
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin differenceMax)
subN nNatToSubtract =
    Internal.sub nNatToSubtract



-- ## drop information


{-| Convert it to a `Nat (ValueIn min max)`.

    nat4 |> InNat.value
    --> : Nat (ValueIn Nat4 (Nat4Plus a))

Example

    [ in3To10, nat3 ]

Elm complains:

> But all the previous elements in the list are: `Nat (ValueIn Nat3 Nat10)`

    [ in3To10
    , nat3 |> InNat.value
    ]

-}
value : Nat (In min max maybeN) -> Nat (ValueIn min max)
value =
    Internal.newRange



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s with a lower bound.

    import Serialize

    serializePercent :
        Serialize.Codec
            String
            (Nat (ValueIn Nat0 (Nat100Plus a)))
    serializePercent =
        InNat.serialize nat0 nat100

    encode : Nat (In min Nat100 maybeN) -> Bytes
    encode =
        InNat.value
            >> Serialize.encodeToBytes serializePercent

    decode : Bytes -> Result (Serialize.Error String) (Nat (ValueIn Nat0 (Nat100Plus a)))
    decode =
        Serialize.decodeFromBytes serializePercent

For decoded `Int`s lower than minimum expected value, the `Result` is an error message.

-}
serialize :
    Nat (In minLowerBound maxLowerBound lowerBoundMaybeN)
    -> Nat (In maxLowerBound maxUpperBound upperBoundMaybeN)
    -> Serialize.Codec String (Nat (ValueIn minLowerBound maxUpperBound))
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
