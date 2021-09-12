module MinNat exposing
    ( sub, add, subMax, addMin
    , is, isAtLeast, isAtMost
    , atLeast
    , serialize
    , Error, errorToString, generalizeError
    )

{-| In 2 situations you should use the operations in `MinNat` instead of the ones in [`InNat`](InNat):

1.  Your value is of type `Nat (Min ...)`

        nat3 |> Nat.mul nat3
        --> Nat (Min Nat3)

2.  The maximum is a type variable

        divideBy : Nat (ArgIn (Nat1Plus minMinus1_) max_ ifN_) -> ...
        divideBy atLeast1 =
            ...


# modify

@docs sub, add, subMax, addMin


# compare

@docs is, isAtLeast, isAtMost


## clamp

@docs atLeast


# transform

@docs serialize


## error

@docs Error, errorToString, generalizeError

-}

import Common exposing (fromInternalAtMostOrAbove, fromInternalBelowOrAtLeast, fromInternalLessOrEqualOrGreater, serializeValid)
import I as Internal
import InNat
import Nat exposing (ArgIn, AtMostOrAbove, BelowOrAtLeast, In, Is, LessOrEqualOrGreater, Min, N, Nat, To)
import Nats exposing (Nat0, Nat1Plus, Nat2Plus, nat0)
import Serialize exposing (Codec)



-- # modify


{-| Add a `Nat`. The second argument is the minimum added value. Use [`add`](MinNat#add) to add exact numbers.

    atLeast5 |> MinNat.addMin nat2 atLeast2
    --> : Nat (Min Nat7)

-}
addMin :
    Nat (N minAdded atLeastMinAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn minAdded maxAdded_ addedIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min sumMin)
addMin minAdded inNatToAdd =
    Internal.minAddMin minAdded inNatToAdd


{-| Add an exact `Nat (N ...)` value.

    atLeast70 |> InNat.add nat7
    --> : Nat (Min Nat77)

Use [addMin](MinNat#addMin) if you want to add a `Nat` that isn't a `Nat (N ...)`.

-}
add :
    Nat (N added_ atLeastAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min sumMin)
add nNatToAdd =
    Internal.minAdd nNatToAdd


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
    Internal.minSub nNatToSubtract


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
    -> Nat (ArgIn minSubbed_ maxSubbed subbedIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin max)
subMax maxSubtracted inNatToSubtract =
    InNat.subIn
        nat0
        maxSubtracted
        (inNatToSubtract |> Nat.lowerMin nat0)



-- # compare


{-| Is the `Nat` [`LessOrEqualOrGreater`](Nat#LessOrEqualOrGreater) than a given number?

`lowest` can be a number <= the minimum.

    giveAPresent { age } =
        case age |> MinNat.is nat18 { lowest = nat0 } of
            Nat.Less younger ->
                toy { age = younger }

            Nat.Greater older ->
                book { age = older }

            Nat.Equal _ ->
                bigPresent

    toy : { age : Nat (ArgIn min_ Nat17 ifN_) } -> Toy

    book :
        { age : Nat (ArgIn (Nat19 minMinus19_) max_ ifN_) }
        -> Book

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
is valueToCompareAgainst =
    \lowest ->
        Internal.minIs valueToCompareAgainst lowest
            >> fromInternalLessOrEqualOrGreater


{-| Is the `Nat` [`BelowOrAtLeast`](Nat#BelowOrAtLeast) a given number?

    factorial : Nat (ArgIn min_ max_ ifN_) -> Nat (Min Nat1)
    factorial =
        factorialBody

    factorialBody : Nat (ArgIn min_ max_ ifN_) -> Nat (Min Nat1)
    factorialBody =
        case x |> MinNat.isAtLeast nat1 { lowest = nat0 } of
            Nat.Below _ ->
                Nat.toMin nat1

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
isAtLeast lowerBound =
    \lowest ->
        Internal.minIsAtLeast lowerBound lowest
            >> fromInternalBelowOrAtLeast


{-| Is the `Nat` [`AtMostOrAbove`](Nat#AtMostOrAbove) a given number?

    goToU18Party : { age : Nat (ArgIn min_ Nat17 ifN_) } -> Snack

    tryToGoToU18Party { age } =
        case age |> MinNat.isAtMost nat17 { lowest = nat0 } of
            EqualOrLess u18 ->
                Just (goToU18Party { age = u18 })

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
    -> Nat (ArgIn min max_ ifN_)
    ->
        AtMostOrAbove
            (Nat (In lowest maxUpperBound))
            (Nat (Min (Nat1Plus minUpperBound)))
isAtMost upperBound =
    \lowest ->
        Internal.minIsAtMost upperBound lowest
            >> fromInternalAtMostOrAbove



-- ## clamp


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
    Nat.toMin
        >> Internal.atLeast
            (lowerBound |> Nat.toMin)



-- # extra


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Nat`s with a lower bound.

    import Serialize exposing (Codec)

    serializeNaturalNumber : Codec String (Nat (Min Nat0))
    serializeNaturalNumber =
        MinNat.serialize nat0
            -- if we just want a simple error string
            |> Serialize.mapError MinNat.errorToString

The encode/decode functions can be extracted if needed.

    encodeNaturalNumber : Nat (ArgIn min_ max_ ifN_) -> Bytes
    encodeNaturalNumber =
        Nat.lowerMin nat0
            >> Nat.toMin
            >> Serialize.encodeToBytes serializeNaturalNumber

    decodeNaturalNumber :
        Bytes
        -> Result (Serialize.Error String) (Nat (Min Nat0))
    decodeNaturalNumber =
        Serialize.decodeFromBytes serializeNaturalNumber

-}
serialize :
    Nat (ArgIn minLowerBound maxLowerBound_ lowerBoundIfN_)
    -> Codec Error (Nat (Min minLowerBound))
serialize lowerBound =
    serializeValid
        (Internal.isIntAtLeast lowerBound
            >> Result.fromMaybe
                { atLeast =
                    lowerBound
                        |> Nat.lowerMin nat0
                        |> Nat.toMin
                }
        )


{-| An error for when a decoded int is less than the expected minimum. You can transform it into

  - a message: [`errorToString`](MinNat#errorToString)
  - an [`InNat.Error`](InNat#Error): [`generalizeError`](MinNat#generalizeError)

See [`serialize`](MinNat#serialize).

-}
type alias Error =
    { expected : { atLeast : Nat (Min Nat0) }
    , actual : Int
    }


{-| Use the same error type as `InNat`.

    import Serialize exposing (Codec)

    Serialize.mapError MinNat.generalizeError
    --> : Codec MinNat.Error a -> Codec InNat.Error a

Use this if you serialize `InNat` together with `MinNat`:

    Serialize.tuple
        (MinNat.serialize nat0)
        (InNat.serialize nat0 nat99)
    --> error : `Codec`s have different custom errors

    Serialize.tuple
        (MinNat.serialize nat0
            |> Serialize.mapError MinNat.generalizeError
        )
        (InNat.serialize nat0 nat99)
    --> Codec
    -->     InNat.Error
    -->     ( Nat (Min Nat0), Nat (In Nat0 (Nat99Plus a_)) )

Note: there's also [`errorToString`](MinNat#errorToString).

-}
generalizeError : Error -> InNat.Error
generalizeError error =
    { expected =
        error.expected.atLeast
            |> InNat.ExpectAtLeast
    , actual = error.actual
    }


{-| Convert an [`Error`](MinNat#Error) to a readable message.

    { expected = { atLeast = nat11 }
    , actual = 10
    }
        |> MinNat.errorToString
    --> "expected an int >= 11 but the actual int was 10"

(example won't compile because `nat11` isn't of type `Nat (Min Nat0)`)

Equivalent to

    error
        |> MinNat.generalizeError
        |> InNat.errorToString

-}
errorToString : Error -> String
errorToString error =
    error
        |> generalizeError
        |> InNat.errorToString
