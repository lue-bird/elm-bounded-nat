module I exposing
    ( Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn
    , isIntInRange, isIntAtLeast, atLeast, atMost
    , BelowOrInOrAboveRange(..)
    , mul, toPower, remainderBy, div, nNatAdd, nNatSub
    , abs, random, range
    , toMinNat, toInNat
    , serializeValid
    , add, sub, newRange
    , Z, S
    , nat0, nat1
    )

{-| The internals of this package. Only this package can mark `Int`s as `Nat`s.

For performance reasons, the names are shortened, so that [`NNats`](NNats)'s compiling performance is better.


## types

@docs Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn


## compare

@docs isIntInRange, isIntAtLeast, atLeast, atMost


### comparison result

@docs BelowOrInOrAboveRange


## modify

@docs mul, toPower, remainderBy, div, nNatAdd, nNatSub


## create

@docs abs, random, range


## drop information

@docs toMinNat, toInNat


## extra

@docs serializeValid


## not type-safe

@docs add, sub, newRange


## Nat types

@docs Z, S


## NNats

@docs nat0, nat1

-}

import Random
import Serialize exposing (Codec)
import Typed exposing (Checked, Public, Typed, isChecked, map, tag, val, val2)


type alias Nat range =
    Typed Checked (NatTag range) Public Int


type NatTag range_
    = Nat


type Is a_ to_ b_
    = Is Never


type To
    = To Never


type ArgIn minimum_ maximum_ ifN_
    = ArgIn Never


type alias Min minimum =
    In minimum Infinity


type Infinity
    = Infinity Never


type alias In minimum maximum =
    ArgIn minimum maximum NotN


type NotN
    = NotN Never


type alias N n atLeastN asADifference asAnotherDifference =
    ArgIn n atLeastN (D asADifference asAnotherDifference)


type alias Differences a b =
    D a b


type D aDifference_ bDifference_
    = D Never



-- ## not type-safe


add : Nat addedRange_ -> Nat range_ -> Nat sumRange_
add natToAdd =
    val2 (+) natToAdd >> tag >> isChecked Nat


sub : Nat subtractedRange_ -> Nat range_ -> Nat differenceRange_
sub natToSubtract =
    val2 (\toSub x -> x - toSub) natToSubtract
        >> tag
        >> isChecked Nat


newRange : Nat min_ -> Nat newMin_
newRange =
    val >> tag >> isChecked Nat



-- ## compare


isIntInRange :
    Nat (ArgIn minLowerBound minUpperBound lowerBoundIfN_)
    -> Nat (ArgIn minUpperBound maxUpperBound upperBoundIfN_)
    -> Int
    ->
        BelowOrInOrAboveRange
            Int
            (Nat (In minLowerBound maxUpperBound))
            (Nat (Min (Nat1Plus maxUpperBound)))
isIntInRange lowerBound upperBound int =
    if int < val lowerBound then
        BelowRange int

    else if int > val upperBound then
        AboveRange (tag int |> isChecked Nat)

    else
        InRange (tag int |> isChecked Nat)


isIntAtLeast :
    Nat (ArgIn min max_ ifN_)
    -> Int
    -> Maybe (Nat (Min min))
isIntAtLeast minimum int =
    if int >= val minimum then
        Just (tag int |> isChecked Nat)

    else
        Nothing


atMost :
    Nat (ArgIn minNewMax atLeastNewMax newMaxIfN_)
    ->
        { lowest :
            Nat
                (N
                    lowest
                    atLeastLowest_
                    (Is lowestToMin_ To min)
                    (Is minToMinNewMax_ To minNewMax)
                )
        }
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (In lowest atLeastNewMax)
atMost higherBound =
    \_ ->
        map (min (val higherBound))
            >> isChecked Nat


atLeast :
    Nat (ArgIn newMin max lowerIfN_)
    -> Nat (ArgIn min_ max ifN_)
    -> Nat (In newMin max)
atLeast lowerBound =
    map (max (val lowerBound)) >> isChecked Nat



-- ### comparison result


type BelowOrInOrAboveRange below inRange above
    = BelowRange below
    | InRange inRange
    | AboveRange above



-- ## create


abs : Int -> Nat (Min Nat0)
abs int =
    Basics.abs int |> tag |> isChecked Nat


range :
    Nat (ArgIn firstMin lastMin firstIfN_)
    -> Nat (ArgIn lastMin lastMax lastIfN_)
    -> List (Nat (In firstMin lastMax))
range first last =
    val2 List.range first last
        |> List.map (tag >> isChecked Nat)


random :
    Nat (ArgIn firstMin lastMin firstIfN_)
    -> Nat (ArgIn lastMin lastMax lastIfN_)
    -> Random.Generator (Nat (In firstMin lastMax))
random min max =
    val2 Random.int min max
        |> Random.map (tag >> isChecked Nat)



-- ## modify


mul :
    Nat (ArgIn (Nat1Plus minMultipliedMinus1_) maxMultiplied_ multipliedIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min min)
mul natToMultiply =
    val2 (*) natToMultiply >> tag >> isChecked Nat


div :
    Nat (ArgIn (Nat1Plus divMinMinus1_) divMax_ divIfN_)
    -> Nat (ArgIn min_ max ifN_)
    -> Nat (In Nat0 max)
div divNat =
    map (\x -> x // val divNat) >> isChecked Nat


remainderBy :
    Nat (ArgIn (Nat1Plus divMinMinus1_) divMax divIfN_)
    -> Nat (ArgIn min_ max_ ifN_)
    -> Nat (In Nat0 divMax)
remainderBy divNat =
    val2 Basics.remainderBy divNat >> tag >> isChecked Nat


toPower :
    Nat (ArgIn (Nat1Plus powMinMinus1_) powMax_ powIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min min)
toPower power =
    map (\x -> x ^ val power) >> isChecked Nat


nNatAdd :
    ( Nat (N added atLeastFirstAdded_ (Is n To sum) (Is atLeastN To atLeastSum))
    , Nat
        (N
            added
            atLeastSecondAdded_
            (Is aPlusN To aPlusSum)
            (Is bPlusN To bPlusSum)
        )
    )
    -> Nat (N n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    -> Nat (N sum atLeastSum (Is a To aPlusSum) (Is b To bPlusSum))
nNatAdd nNatToAdd =
    add (nNatToAdd |> Tuple.first)


nNatSub :
    ( Nat
        (N
            subbed
            atLeastFirstSubbed_
            (Is difference To n)
            (Is atLeastDifference To atLeastN)
        )
    , Nat
        (N
            subbed
            atLeastSecondSubbed_
            (Is aPlusDifference To aPlusN)
            (Is bPlusDifference To bPlusN)
        )
    )
    -> Nat (N n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    ->
        Nat
            (N
                difference
                atLeastDifference
                (Is a To aPlusDifference)
                (Is b To bPlusDifference)
            )
nNatSub nNatToSubtract =
    sub (nNatToSubtract |> Tuple.first)



-- ## drop information


toMinNat : Nat (ArgIn min max_ ifN_) -> Nat (Min min)
toMinNat =
    newRange


toInNat : Nat (ArgIn min max ifN_) -> Nat (In min max)
toInNat =
    newRange



-- ## extra


serializeValid :
    (Int -> Result expected (Nat range))
    ->
        Codec
            { expected : expected
            , actual : Int
            }
            (Nat range)
serializeValid mapValid =
    Serialize.int
        |> Serialize.mapValid
            (\int ->
                mapValid int
                    |> Result.mapError
                        (\expected ->
                            { expected = expected
                            , actual = int
                            }
                        )
            )
            val



-- ## Nat types


type S n_
    = S Never


type Z
    = Z Never


type alias Nat1Plus n =
    S n


type alias Nat0 =
    Z


type alias Nat1 =
    Nat1Plus Z



-- ## NNats


nat0 : Nat (N Nat0 a_ (Is a To a) (Is b To b))
nat0 =
    tag 0 |> isChecked Nat


nat1 : Nat (N Nat1 (Nat1Plus a_) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    tag 1 |> isChecked Nat
