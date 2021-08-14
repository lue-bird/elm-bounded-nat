module I exposing
    ( Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn
    , Z, S
    , nat1
    , isIntInRange, isIntAtLeast, minIs, minIsAtLeast, minIsAtMost, inIsAtLeast, inIsAtMost, inIs, inIsInRange
    , BelowOrInOrAboveRange(..), LessOrEqualOrGreater(..), AtMostOrAbove(..), BelowOrAtLeast(..)
    , atLeast, atMost, intInRange
    , mul, toPower, remainderBy, div
    , nNatAdd, minAdd, minAddMin, inAdd, inAddIn
    , nNatSub, inSub, inSubIn, minSub
    , abs, random, range
    , lowerMin, toInNat, toMinNat
    , restoreMax
    )

{-| The internals of this package. Only this package can mark `Int`s as `Nat`s.

For performance reasons, the names are shortened, so that [`NNats`](NNats)'s compiling performance is better.


# types

@docs Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn


## Nat types

@docs Z, S


# NNat

@docs nat1


# compare

@docs isIntInRange, isIntAtLeast, minIs, minIsAtLeast, minIsAtMost, inIsAtLeast, inIsAtMost, inIs, inIsInRange


## comparison result

@docs BelowOrInOrAboveRange, LessOrEqualOrGreater, AtMostOrAbove, BelowOrAtLeast


## clamp

@docs atLeast, atMost, intInRange


# modify

@docs mul, toPower, remainderBy, div


## add

@docs nNatAdd, minAdd, minAddMin, inAdd, inAddIn


## subtract

@docs nNatSub, inSub, inSubIn, minSub


# create

@docs abs, random, range


# drop information

@docs lowerMin, toInNat, toMinNat


# restore

@docs restoreMax

-}

import Random
import Typed exposing (Checked, Public, Tagged, Typed, isChecked, map, tag, val, val2)


type alias NatAs whoCanCreate range =
    Typed whoCanCreate (NatTag range) Public Int


type alias Nat range =
    NatAs Checked range


type NatTag range
    = Nat


type Is a to b
    = Is Never


type To
    = To Never


type ArgIn minimum maximum ifN
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


type D aDifference bDifference
    = D Never



-- ## not type-safe


{-| Calls to this functions are unsafe.
Should not be exposed in the future so that all unsafe operations are located here!
-}
newRange : Nat range_ -> NatAs Tagged newRange_
newRange =
    val >> tag



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


minIs :
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
minIs valueToCompareAgainst =
    \_ minNat ->
        case val2 compare minNat valueToCompareAgainst of
            LT ->
                Less (minNat |> newRange |> isChecked Nat)

            EQ ->
                Equal (valueToCompareAgainst |> toInNat)

            GT ->
                Greater (minNat |> newRange |> isChecked Nat)


minIsAtLeast :
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
minIsAtLeast lowerBound =
    \_ minNat ->
        if val2 (>=) minNat lowerBound then
            EqualOrGreater (minNat |> newRange |> isChecked Nat)

        else
            Below (minNat |> newRange |> isChecked Nat)


minIsAtMost :
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
minIsAtMost upperBound =
    \_ minNat ->
        if val2 (<=) minNat upperBound then
            EqualOrLess (minNat |> newRange |> isChecked Nat)

        else
            Above (minNat |> newRange |> isChecked Nat)


inIsAtLeast :
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
inIsAtLeast lowerBound =
    \_ inNat ->
        if val2 (>=) inNat lowerBound then
            EqualOrGreater (inNat |> newRange |> isChecked Nat)

        else
            Below (inNat |> newRange |> isChecked Nat)


inIsAtMost :
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
inIsAtMost upperBound =
    \_ inNat ->
        if val inNat <= (upperBound |> val) then
            EqualOrLess (inNat |> newRange |> isChecked Nat)

        else
            Above (inNat |> newRange |> isChecked Nat)


inIs :
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
inIs valueToCompareAgainst =
    \_ inNat ->
        case val2 compare inNat valueToCompareAgainst of
            EQ ->
                Equal (valueToCompareAgainst |> toInNat)

            GT ->
                Greater (inNat |> newRange |> isChecked Nat)

            LT ->
                Less (inNat |> newRange |> isChecked Nat)


inIsInRange :
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
inIsInRange lowerBound upperBound =
    \_ inNat ->
        if val2 (<) inNat lowerBound then
            BelowRange (inNat |> newRange |> isChecked Nat)

        else if val2 (>) inNat upperBound then
            AboveRange (inNat |> newRange |> isChecked Nat)

        else
            InRange (inNat |> newRange |> isChecked Nat)



-- ## comparison result


type AtMostOrAbove equalOrLess above
    = EqualOrLess equalOrLess
    | Above above


type BelowOrAtLeast below equalOrGreater
    = Below below
    | EqualOrGreater equalOrGreater


type LessOrEqualOrGreater less equal greater
    = Less less
    | Equal equal
    | Greater greater


type BelowOrInOrAboveRange below inRange above
    = BelowRange below
    | InRange inRange
    | AboveRange above



-- ## clamp


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


intInRange :
    Nat (ArgIn minLowerBound minUpperBound lowerBoundIfN_)
    -> Nat (ArgIn minUpperBound maxUpperBound upperBoundIfN_)
    -> Int
    -> Nat (In minLowerBound maxUpperBound)
intInRange lowerBound upperBound int =
    case isIntInRange lowerBound upperBound int of
        InRange inRange ->
            inRange

        BelowRange _ ->
            lowerBound |> newRange |> isChecked Nat

        AboveRange _ ->
            upperBound |> lowerMin lowerBound



-- # create


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


add : Nat addedRange_ -> Nat range_ -> Nat sumRange_
add natToAdd =
    val2 (+) natToAdd >> tag >> isChecked Nat


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


minAddMin :
    Nat (N minAdded atLeastMinAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn minAdded maxAdded_ addedIfN_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min sumMin)
minAddMin minAdded inNatToAdd =
    add inNatToAdd


minAdd :
    Nat (N added_ atLeastAdded_ (Is min To sumMin) is_)
    -> Nat (ArgIn min max_ ifN_)
    -> Nat (Min sumMin)
minAdd nNatToAdd =
    add nNatToAdd


inAddIn :
    Nat (N minAdded atLeastMinAdded_ (Is min To sumMin) minAddedIs_)
    -> Nat (N maxAdded atLeastMaxAdded_ (Is max To sumMax) maxAddedIs_)
    -> Nat (ArgIn minAdded maxAdded addedIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In sumMin sumMax)
inAddIn minAdded maxAdded inNatToAdd =
    add inNatToAdd


{-| Add a `Nat (N ...)`.

    between70And100
        |> InNat.add nat7
    --> : Nat (In Nat77 (Nat107Plus a_))

Use [addIn](InNat#addIn) if you want to add a `Nat` that isn't a `Nat (N ...)`.

-}
inAdd :
    Nat
        (N
            added_
            atLeastAdded_
            (Is min To sumMin)
            (Is max To sumMax)
        )
    -> Nat (ArgIn min max ifN_)
    -> Nat (In sumMin sumMax)
inAdd nNatToAdd =
    add nNatToAdd


sub : Nat subtractedRange_ -> Nat range_ -> Nat differenceRange_
sub natToSubtract =
    val2 (\toSub x -> x - toSub) natToSubtract
        >> tag
        >> isChecked Nat


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


inSubIn :
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
inSubIn minSubtracted maxSubtracted inNatToSubtract =
    sub inNatToSubtract


inSub :
    Nat
        (N
            subbed_
            atLeastSubbed_
            (Is differenceMin To min)
            (Is differenceMax To max)
        )
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin differenceMax)
inSub nNatToSubtract =
    sub nNatToSubtract


minSub :
    Nat (N subbed_ atLeastSubbed_ (Is differenceMin To min) is_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In differenceMin max)
minSub nNatToSubtract =
    sub nNatToSubtract



-- ## drop information


lowerMin :
    Nat (ArgIn newMin min lowerIfN_)
    -> Nat (ArgIn min max ifN_)
    -> Nat (In newMin max)
lowerMin =
    \_ -> newRange >> isChecked Nat


toInNat : Nat (ArgIn min max ifN_) -> Nat (In min max)
toInNat =
    newRange >> isChecked Nat


toMinNat : Nat (ArgIn min max_ ifN_) -> Nat (Min min)
toMinNat =
    newRange >> isChecked Nat



-- ## restore


restoreMax :
    Nat (ArgIn max newMax newMaxIfN_)
    -> Nat (ArgIn min max ifN)
    -> Nat (ArgIn min newMax ifN)
restoreMax =
    \_ -> newRange >> isChecked Nat



-- ## Nat types


type S n
    = S Never


type Z
    = Z Never


type alias Nat1Plus n =
    S n


type alias Nat0 =
    Z


type alias Nat1 =
    Nat1Plus Z


type alias Nat2Plus n =
    S (Nat1Plus n)



-- # NNat


nat1 : Nat (N Nat1 (Nat1Plus a_) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    tag 1 |> isChecked Nat
