module MinNat exposing
    ( is, isAtLeast, isAtMost
    , subN, add, sub, addN
    , value
    , serialize
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


## drop information

@docs value


## extra

@docs serialize

-}

import I as Internal
import InNat
import N exposing (Nat1Plus, Nat2Plus)
import NNats exposing (nat0)
import Nat exposing (In, Is, N, Nat, To, ValueIn, ValueMin)
import Serialize
import Typed exposing (val, val2)



-- ## modify


{-| Add a `Nat (In ...)`. The second argument is the minimum added value.

    atLeast5 |> MinNat.add atLeast2 nat2
    --> : Nat (ValueMin Nat7)

-}
add :
    Nat (In minAdded maxAdded addedMaybeN)
    -> Nat (N minAdded (Is min To sumMin) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin sumMin)
add inNatToAdd minAdded =
    Internal.add inNatToAdd


{-| Add a fixed `Nat (N ...)` value.

    atLeast70 |> InNat.addN nat7
    --> : Nat (ValueMin Nat77)

-}
addN :
    Nat (N added (Is min To sumMin) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueMin sumMin)
addN nNatToAdd =
    Internal.add nNatToAdd


{-| Subtract an exact `Nat (N ...)`.

    atLeast7 |> MinNat.subN nat2
    --> : Nat (ValueMin Nat5)

-}
subN :
    Nat (N subbed (Is differenceMin To min) x)
    -> Nat (In min max maybeN)
    -> Nat (ValueIn differenceMin max)
subN nNatToSubtract =
    Internal.sub nNatToSubtract


{-| Subtract a `Nat (In ...)`. The second argument is the maximum of the subtracted `Nat (In ...)`.

    atLeast6 |> MinNat.sub between0And5 nat5
    --> : Nat (ValueMin Nat1)

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

`min` ensures that the `Nat (N ...)` is greater than the minimum.

    present =
        Nat.lowerMin nat0
            >> MinNat.is nat18
                { min = nat0 }
                { less = \age -> toy { age = age }
                , greater = \age -> experience { age = age }
                , equal = \() -> bigPresent
                }

    toy : { age : Nat (In Nat0 Nat17 maybeN) } -> Toy

    experience : { age : Nat (In Nat19 max maybeN) } -> Experience

-}
is :
    Nat (N (Nat1Plus triedMinus1) (Is a To (Nat1Plus triedMinus1PlusA)) x)
    -> { min : Nat (N min (Is minToTriedMinus1 To triedMinus1) y) }
    ->
        { equal : () -> result
        , less : Nat (In min triedMinus1PlusA maybeN) -> result
        , greater : Nat (ValueMin (Nat2Plus triedMinus1)) -> result
        }
    -> Nat (In min max maybeN)
    -> result
is tried min cases =
    \minNat ->
        case val2 compare minNat tried of
            EQ ->
                .equal cases ()

            LT ->
                .less cases (minNat |> Internal.newRange)

            GT ->
                .greater cases (minNat |> Internal.newRange)


{-| Is the `Nat (ValueMin ...)`

  - `equalOrGreater` than a `Nat` or

  - `less`?

```
factorial : Nat (In min max maybeN) -> Nat (ValueMin Nat1)
factorial =
    Nat.lowerMin nat0
        >> MinNat.isAtLeast nat1
            { min = nat0 }
            { less = \_ -> nat1 |> MinNat.value
            , equalOrGreater =
                \atLeast1 ->
                    atLeast1
                        |> Nat.mul
                            (factorial
                                (atLeast1 |> MinNat.subN nat1)
                            )
            }
```

-}
isAtLeast :
    Nat (N lowerBound (Is a To (Nat1Plus lowerBoundMinus1PlusA)) x)
    -> { min : Nat (N min (Is minToTriedMin To lowerBound) y) }
    ->
        { less : Nat (In min lowerBoundMinus1PlusA maybeN) -> result
        , equalOrGreater : Nat (ValueMin lowerBound) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtLeast triedLowerBound min cases =
    \minNat ->
        if val2 (>=) minNat triedLowerBound then
            .equalOrGreater cases (minNat |> Internal.newRange)

        else
            .less cases (minNat |> Internal.newRange)


{-| Is the `Nat (ValueMin ...)`

  - `equalOrLess` than a `Nat` or

  - `greater`?

```
goToU18Party : { age : Nat (In min Nat17 maybeN) } -> List Snack

tryToGoToU18Party =
    Nat.lowerMin nat0
        >> MinNat.isAtMost nat17
            { min = nat0 }
            { equalOrLess = \age -> Just (goToU18Party { age = age })
            , greater = Nothing
            }
```

-}
isAtMost :
    Nat (N upperBound (Is a To upperBoundPlusA) x)
    -> { min : Nat (N min (Is minToAtMostMin To upperBound) y) }
    ->
        { equalOrLess : Nat (In min upperBoundPlusA maybeN) -> result
        , greater : Nat (ValueMin (Nat1Plus upperBound)) -> result
        }
    -> Nat (In min max maybeN)
    -> result
isAtMost upperBound min cases =
    \minNat ->
        if val2 (<=) minNat upperBound then
            .equalOrLess cases (minNat |> Internal.newRange)

        else
            .greater cases (minNat |> Internal.newRange)



-- ## drop information


{-| Convert a `Nat (In min ...)` to a `Nat (ValueMin min)`.

    between3And10 |> MinNat.value
    --> : Nat (ValueMin Nat4)

There is **only 1 situation you should use this.**

To make these the same type.

    [ atLeast1, between1And10 ]

Elm complains:

> But all the previous elements in the list are: `Nat (ValueMin Nat1)`

    [ atLeast1
    , between1And10 |> MinNat.value
    ]

-}
value : Nat (In min max maybeN) -> Nat (ValueMin min)
value =
    Internal.newRange



-- ## extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s with a lower bound.

    import Serialize

    serializeNaturalNumber :
        Serialize.Codec
            String
            (Nat (ValueMin Nat0))
    serializeNaturalNumber =
        MinNat.serialize nat0

    encode : Nat (In min max maybeN) -> Bytes
    encode =
        MinNat.value
            >> Serialize.encodeToBytes serializeNaturalNumber

    decode :
        Bytes
        -> Result (Serialize.Error String) (Nat (ValueMin Nat0))
    decode =
        Serialize.decodeFromBytes serializeNaturalNumber

-}
serialize :
    Nat (In minLowerBound maxLowerBound lowerBoundMaybeN)
    -> Serialize.Codec String (Nat (ValueMin minLowerBound))
serialize lowerBound =
    Serialize.int
        |> Serialize.mapValid
            (Internal.isIntAtLeast lowerBound
                >> Result.fromMaybe "Int was less than the required minimum"
            )
            val
