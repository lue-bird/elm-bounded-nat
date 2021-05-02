module I exposing
    ( Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn
    , add, sub, newRange
    , isIntInRange, isIntAtLeast, atLeast, atMost
    , intInRange
    , mul, toPower, remainderBy, div
    , random, range
    , nat0, nat1, nat10, nat100, nat101, nat102, nat103, nat104, nat105, nat106, nat107, nat108, nat109, nat11, nat110, nat111, nat112, nat113, nat114, nat115, nat116, nat117, nat118, nat119, nat12, nat120, nat121, nat122, nat123, nat124, nat125, nat126, nat127, nat128, nat129, nat13, nat130, nat131, nat132, nat133, nat134, nat135, nat136, nat137, nat138, nat139, nat14, nat140, nat141, nat142, nat143, nat144, nat145, nat146, nat147, nat148, nat149, nat15, nat150, nat151, nat152, nat153, nat154, nat155, nat156, nat157, nat158, nat159, nat16, nat160, nat17, nat18, nat19, nat2, nat20, nat21, nat22, nat23, nat24, nat25, nat26, nat27, nat28, nat29, nat3, nat30, nat31, nat32, nat33, nat34, nat35, nat36, nat37, nat38, nat39, nat4, nat40, nat41, nat42, nat43, nat44, nat45, nat46, nat47, nat48, nat49, nat5, nat50, nat51, nat52, nat53, nat54, nat55, nat56, nat57, nat58, nat59, nat6, nat60, nat61, nat62, nat63, nat64, nat65, nat66, nat67, nat68, nat69, nat7, nat70, nat71, nat72, nat73, nat74, nat75, nat76, nat77, nat78, nat79, nat8, nat80, nat81, nat82, nat83, nat84, nat85, nat86, nat87, nat88, nat89, nat9, nat90, nat91, nat92, nat93, nat94, nat95, nat96, nat97, nat98, nat99
    , abs
    )

{-| The internals of this package. Only this package can mark `Int`s as `Nat`s.

For performance reasons, the names are shortened, so that [`NNats`](NNats)'s compiling performance is better.


## types

@docs Differences, Infinity, Is, Nat, NatTag, NotN, To, N, ArgIn


## not fully type-safe

@docs add, sub, newRange


## compare

@docs isIntInRange, isIntAtLeast, atLeast, atMost


## clamp

@docs intInRange


## modify

@docs mul, toPower, remainderBy, div


## other

@docs random, range


## NNats

@docs nat0, nat1, nat10, nat100, nat101, nat102, nat103, nat104, nat105, nat106, nat107, nat108, nat109, nat11, nat110, nat111, nat112, nat113, nat114, nat115, nat116, nat117, nat118, nat119, nat12, nat120, nat121, nat122, nat123, nat124, nat125, nat126, nat127, nat128, nat129, nat13, nat130, nat131, nat132, nat133, nat134, nat135, nat136, nat137, nat138, nat139, nat14, nat140, nat141, nat142, nat143, nat144, nat145, nat146, nat147, nat148, nat149, nat15, nat150, nat151, nat152, nat153, nat154, nat155, nat156, nat157, nat158, nat159, nat16, nat160, nat17, nat18, nat19, nat2, nat20, nat21, nat22, nat23, nat24, nat25, nat26, nat27, nat28, nat29, nat3, nat30, nat31, nat32, nat33, nat34, nat35, nat36, nat37, nat38, nat39, nat4, nat40, nat41, nat42, nat43, nat44, nat45, nat46, nat47, nat48, nat49, nat5, nat50, nat51, nat52, nat53, nat54, nat55, nat56, nat57, nat58, nat59, nat6, nat60, nat61, nat62, nat63, nat64, nat65, nat66, nat67, nat68, nat69, nat7, nat70, nat71, nat72, nat73, nat74, nat75, nat76, nat77, nat78, nat79, nat8, nat80, nat81, nat82, nat83, nat84, nat85, nat86, nat87, nat88, nat89, nat9, nat90, nat91, nat92, nat93, nat94, nat95, nat96, nat97, nat98, nat99

-}

import N exposing (..)
import Random
import Typed exposing (Checked, Public, Typed, isChecked, map, tag, val, val2)


type alias Nat range =
    Typed Checked (NatTag range) Public Int


type NatTag range
    = Nat


type Is a to b
    = Is Never


type To
    = To Never


type ArgIn minimum maximum maybeN
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


type alias ArgN n asADifference asAnotherDifference =
    N n n asADifference asAnotherDifference


type alias Differences a b =
    D a b


type D aDifference bDifference
    = D Never



-- ## not fully type-safe


add : Nat addedRange -> Nat range -> Nat sumRange
add natToAdd =
    val2 (+) natToAdd >> tag >> isChecked Nat


sub : Nat subtractedRange -> Nat range -> Nat differenceRange
sub natToSubtract =
    val2 (\toSub x -> x - toSub) natToSubtract >> tag >> isChecked Nat


newRange : Nat min -> Nat newMin
newRange =
    val >> tag >> isChecked Nat



-- ## compare


isIntInRange :
    Nat (ArgIn minFirst last firstMaybeN)
    -> Nat (ArgIn last maxLast lastMaybeN)
    ->
        { less : () -> result
        , greater : Nat (Min (Nat1Plus last)) -> result
        , inRange : Nat (In minFirst maxLast) -> result
        }
    -> Int
    -> result
isIntInRange lowerBound upperBound cases int =
    if int < val lowerBound then
        .less cases ()

    else if int > val upperBound then
        .greater cases (tag int |> isChecked Nat)

    else
        .inRange cases (tag int |> isChecked Nat)


intInRange :
    Nat (ArgIn min firstMax lowerMaybeN)
    -> Nat (ArgIn firstMax max upperMaybeN)
    -> Int
    -> Nat (In min max)
intInRange lowerBound upperBound =
    Basics.min (val upperBound)
        >> Basics.max (val lowerBound)
        >> tag
        >> isChecked Nat


isIntAtLeast :
    Nat (ArgIn min max maybeN)
    -> Int
    -> Maybe (Nat (Min min))
isIntAtLeast minimum int =
    if int >= val minimum then
        Just (tag int |> isChecked Nat)

    else
        Nothing


atMost :
    Nat (ArgIn minNewMax atLeastNewMax newMaxMaybeN)
    -> { min : Nat (ArgN min (Is minToMinNewMax To minNewMax) x) }
    -> Nat (ArgIn min max maybeN)
    -> Nat (In min atLeastNewMax)
atMost higherBound min =
    map (Basics.min (val higherBound)) >> isChecked Nat


atLeast :
    Nat (ArgIn newMin max lowerMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In newMin max)
atLeast lowerBound =
    map (max (val lowerBound)) >> isChecked Nat


abs : Int -> Nat (Min Nat0)
abs int =
    Basics.abs int |> tag |> isChecked Nat


range :
    Nat (ArgIn firstMin lastMin firstMaybeN)
    -> Nat (ArgIn lastMin lastMax lastMaybeN)
    -> List (Nat (In firstMin lastMax))
range first last =
    val2 List.range first last
        |> List.map (tag >> isChecked Nat)


random :
    Nat (ArgIn firstMin lastMin firstMaybeN)
    -> Nat (ArgIn lastMin lastMax lastMaybeN)
    -> Random.Generator (Nat (In firstMin lastMax))
random min max =
    val2 Random.int min max
        |> Random.map (tag >> isChecked Nat)



-- ## modify


mul :
    Nat (ArgIn (Nat1Plus minMultipliedMinus1) maxMultiplied multipliedMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min min)
mul natToMultiply =
    val2 (*) natToMultiply >> tag >> isChecked Nat


div :
    Nat (ArgIn (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In Nat0 max)
div divNat =
    map (\x -> x // val divNat) >> isChecked Nat


remainderBy :
    Nat (ArgIn (Nat1Plus divMinMinus1) divMax divMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (In Nat0 divMax)
remainderBy divNat =
    val2 Basics.remainderBy divNat >> tag >> isChecked Nat


toPower :
    Nat (ArgIn (Nat1Plus powMinMinus1) powMax powMaybeN)
    -> Nat (ArgIn min max maybeN)
    -> Nat (Min min)
toPower power =
    map (\x -> x ^ val power) >> isChecked Nat



-- ## NNats


nat0 : Nat (N Nat0 atLeast0 (Is a To a) (Is b To b))
nat0 =
    tag 0 |> isChecked Nat


nat1 : Nat (N Nat1 (Nat1Plus atLeast1) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    tag 1 |> isChecked Nat


nat2 : Nat (N Nat2 (Nat2Plus atLeast2) (Is a To (Nat2Plus a)) (Is b To (Nat2Plus b)))
nat2 =
    tag 2 |> isChecked Nat


nat3 : Nat (N Nat3 (Nat3Plus atLeast3) (Is a To (Nat3Plus a)) (Is b To (Nat3Plus b)))
nat3 =
    tag 3 |> isChecked Nat


nat4 : Nat (N Nat4 (Nat4Plus atLeast4) (Is a To (Nat4Plus a)) (Is b To (Nat4Plus b)))
nat4 =
    tag 4 |> isChecked Nat


nat5 : Nat (N Nat5 (Nat5Plus atLeast5) (Is a To (Nat5Plus a)) (Is b To (Nat5Plus b)))
nat5 =
    tag 5 |> isChecked Nat


nat6 : Nat (N Nat6 (Nat6Plus atLeast6) (Is a To (Nat6Plus a)) (Is b To (Nat6Plus b)))
nat6 =
    tag 6 |> isChecked Nat


nat7 : Nat (N Nat7 (Nat7Plus atLeast7) (Is a To (Nat7Plus a)) (Is b To (Nat7Plus b)))
nat7 =
    tag 7 |> isChecked Nat


nat8 : Nat (N Nat8 (Nat8Plus atLeast8) (Is a To (Nat8Plus a)) (Is b To (Nat8Plus b)))
nat8 =
    tag 8 |> isChecked Nat


nat9 : Nat (N Nat9 (Nat9Plus atLeast9) (Is a To (Nat9Plus a)) (Is b To (Nat9Plus b)))
nat9 =
    tag 9 |> isChecked Nat


nat10 : Nat (N Nat10 (Nat10Plus atLeast10) (Is a To (Nat10Plus a)) (Is b To (Nat10Plus b)))
nat10 =
    tag 10 |> isChecked Nat


nat11 : Nat (N Nat11 (Nat11Plus atLeast11) (Is a To (Nat11Plus a)) (Is b To (Nat11Plus b)))
nat11 =
    tag 11 |> isChecked Nat


nat12 : Nat (N Nat12 (Nat12Plus atLeast12) (Is a To (Nat12Plus a)) (Is b To (Nat12Plus b)))
nat12 =
    tag 12 |> isChecked Nat


nat13 : Nat (N Nat13 (Nat13Plus atLeast13) (Is a To (Nat13Plus a)) (Is b To (Nat13Plus b)))
nat13 =
    tag 13 |> isChecked Nat


nat14 : Nat (N Nat14 (Nat14Plus atLeast14) (Is a To (Nat14Plus a)) (Is b To (Nat14Plus b)))
nat14 =
    tag 14 |> isChecked Nat


nat15 : Nat (N Nat15 (Nat15Plus atLeast15) (Is a To (Nat15Plus a)) (Is b To (Nat15Plus b)))
nat15 =
    tag 15 |> isChecked Nat


nat16 : Nat (N Nat16 (Nat16Plus atLeast16) (Is a To (Nat16Plus a)) (Is b To (Nat16Plus b)))
nat16 =
    tag 16 |> isChecked Nat


nat17 : Nat (N Nat17 (Nat17Plus atLeast17) (Is a To (Nat17Plus a)) (Is b To (Nat17Plus b)))
nat17 =
    tag 17 |> isChecked Nat


nat18 : Nat (N Nat18 (Nat18Plus atLeast18) (Is a To (Nat18Plus a)) (Is b To (Nat18Plus b)))
nat18 =
    tag 18 |> isChecked Nat


nat19 : Nat (N Nat19 (Nat19Plus atLeast19) (Is a To (Nat19Plus a)) (Is b To (Nat19Plus b)))
nat19 =
    tag 19 |> isChecked Nat


nat20 : Nat (N Nat20 (Nat20Plus atLeast20) (Is a To (Nat20Plus a)) (Is b To (Nat20Plus b)))
nat20 =
    tag 20 |> isChecked Nat


nat21 : Nat (N Nat21 (Nat21Plus atLeast21) (Is a To (Nat21Plus a)) (Is b To (Nat21Plus b)))
nat21 =
    tag 21 |> isChecked Nat


nat22 : Nat (N Nat22 (Nat22Plus atLeast22) (Is a To (Nat22Plus a)) (Is b To (Nat22Plus b)))
nat22 =
    tag 22 |> isChecked Nat


nat23 : Nat (N Nat23 (Nat23Plus atLeast23) (Is a To (Nat23Plus a)) (Is b To (Nat23Plus b)))
nat23 =
    tag 23 |> isChecked Nat


nat24 : Nat (N Nat24 (Nat24Plus atLeast24) (Is a To (Nat24Plus a)) (Is b To (Nat24Plus b)))
nat24 =
    tag 24 |> isChecked Nat


nat25 : Nat (N Nat25 (Nat25Plus atLeast25) (Is a To (Nat25Plus a)) (Is b To (Nat25Plus b)))
nat25 =
    tag 25 |> isChecked Nat


nat26 : Nat (N Nat26 (Nat26Plus atLeast26) (Is a To (Nat26Plus a)) (Is b To (Nat26Plus b)))
nat26 =
    tag 26 |> isChecked Nat


nat27 : Nat (N Nat27 (Nat27Plus atLeast27) (Is a To (Nat27Plus a)) (Is b To (Nat27Plus b)))
nat27 =
    tag 27 |> isChecked Nat


nat28 : Nat (N Nat28 (Nat28Plus atLeast28) (Is a To (Nat28Plus a)) (Is b To (Nat28Plus b)))
nat28 =
    tag 28 |> isChecked Nat


nat29 : Nat (N Nat29 (Nat29Plus atLeast29) (Is a To (Nat29Plus a)) (Is b To (Nat29Plus b)))
nat29 =
    tag 29 |> isChecked Nat


nat30 : Nat (N Nat30 (Nat30Plus atLeast30) (Is a To (Nat30Plus a)) (Is b To (Nat30Plus b)))
nat30 =
    tag 30 |> isChecked Nat


nat31 : Nat (N Nat31 (Nat31Plus atLeast31) (Is a To (Nat31Plus a)) (Is b To (Nat31Plus b)))
nat31 =
    tag 31 |> isChecked Nat


nat32 : Nat (N Nat32 (Nat32Plus atLeast32) (Is a To (Nat32Plus a)) (Is b To (Nat32Plus b)))
nat32 =
    tag 32 |> isChecked Nat


nat33 : Nat (N Nat33 (Nat33Plus atLeast33) (Is a To (Nat33Plus a)) (Is b To (Nat33Plus b)))
nat33 =
    tag 33 |> isChecked Nat


nat34 : Nat (N Nat34 (Nat34Plus atLeast34) (Is a To (Nat34Plus a)) (Is b To (Nat34Plus b)))
nat34 =
    tag 34 |> isChecked Nat


nat35 : Nat (N Nat35 (Nat35Plus atLeast35) (Is a To (Nat35Plus a)) (Is b To (Nat35Plus b)))
nat35 =
    tag 35 |> isChecked Nat


nat36 : Nat (N Nat36 (Nat36Plus atLeast36) (Is a To (Nat36Plus a)) (Is b To (Nat36Plus b)))
nat36 =
    tag 36 |> isChecked Nat


nat37 : Nat (N Nat37 (Nat37Plus atLeast37) (Is a To (Nat37Plus a)) (Is b To (Nat37Plus b)))
nat37 =
    tag 37 |> isChecked Nat


nat38 : Nat (N Nat38 (Nat38Plus atLeast38) (Is a To (Nat38Plus a)) (Is b To (Nat38Plus b)))
nat38 =
    tag 38 |> isChecked Nat


nat39 : Nat (N Nat39 (Nat39Plus atLeast39) (Is a To (Nat39Plus a)) (Is b To (Nat39Plus b)))
nat39 =
    tag 39 |> isChecked Nat


nat40 : Nat (N Nat40 (Nat40Plus atLeast40) (Is a To (Nat40Plus a)) (Is b To (Nat40Plus b)))
nat40 =
    tag 40 |> isChecked Nat


nat41 : Nat (N Nat41 (Nat41Plus atLeast41) (Is a To (Nat41Plus a)) (Is b To (Nat41Plus b)))
nat41 =
    tag 41 |> isChecked Nat


nat42 : Nat (N Nat42 (Nat42Plus atLeast42) (Is a To (Nat42Plus a)) (Is b To (Nat42Plus b)))
nat42 =
    tag 42 |> isChecked Nat


nat43 : Nat (N Nat43 (Nat43Plus atLeast43) (Is a To (Nat43Plus a)) (Is b To (Nat43Plus b)))
nat43 =
    tag 43 |> isChecked Nat


nat44 : Nat (N Nat44 (Nat44Plus atLeast44) (Is a To (Nat44Plus a)) (Is b To (Nat44Plus b)))
nat44 =
    tag 44 |> isChecked Nat


nat45 : Nat (N Nat45 (Nat45Plus atLeast45) (Is a To (Nat45Plus a)) (Is b To (Nat45Plus b)))
nat45 =
    tag 45 |> isChecked Nat


nat46 : Nat (N Nat46 (Nat46Plus atLeast46) (Is a To (Nat46Plus a)) (Is b To (Nat46Plus b)))
nat46 =
    tag 46 |> isChecked Nat


nat47 : Nat (N Nat47 (Nat47Plus atLeast47) (Is a To (Nat47Plus a)) (Is b To (Nat47Plus b)))
nat47 =
    tag 47 |> isChecked Nat


nat48 : Nat (N Nat48 (Nat48Plus atLeast48) (Is a To (Nat48Plus a)) (Is b To (Nat48Plus b)))
nat48 =
    tag 48 |> isChecked Nat


nat49 : Nat (N Nat49 (Nat49Plus atLeast49) (Is a To (Nat49Plus a)) (Is b To (Nat49Plus b)))
nat49 =
    tag 49 |> isChecked Nat


nat50 : Nat (N Nat50 (Nat50Plus atLeast50) (Is a To (Nat50Plus a)) (Is b To (Nat50Plus b)))
nat50 =
    tag 50 |> isChecked Nat


nat51 : Nat (N Nat51 (Nat51Plus atLeast51) (Is a To (Nat51Plus a)) (Is b To (Nat51Plus b)))
nat51 =
    tag 51 |> isChecked Nat


nat52 : Nat (N Nat52 (Nat52Plus atLeast52) (Is a To (Nat52Plus a)) (Is b To (Nat52Plus b)))
nat52 =
    tag 52 |> isChecked Nat


nat53 : Nat (N Nat53 (Nat53Plus atLeast53) (Is a To (Nat53Plus a)) (Is b To (Nat53Plus b)))
nat53 =
    tag 53 |> isChecked Nat


nat54 : Nat (N Nat54 (Nat54Plus atLeast54) (Is a To (Nat54Plus a)) (Is b To (Nat54Plus b)))
nat54 =
    tag 54 |> isChecked Nat


nat55 : Nat (N Nat55 (Nat55Plus atLeast55) (Is a To (Nat55Plus a)) (Is b To (Nat55Plus b)))
nat55 =
    tag 55 |> isChecked Nat


nat56 : Nat (N Nat56 (Nat56Plus atLeast56) (Is a To (Nat56Plus a)) (Is b To (Nat56Plus b)))
nat56 =
    tag 56 |> isChecked Nat


nat57 : Nat (N Nat57 (Nat57Plus atLeast57) (Is a To (Nat57Plus a)) (Is b To (Nat57Plus b)))
nat57 =
    tag 57 |> isChecked Nat


nat58 : Nat (N Nat58 (Nat58Plus atLeast58) (Is a To (Nat58Plus a)) (Is b To (Nat58Plus b)))
nat58 =
    tag 58 |> isChecked Nat


nat59 : Nat (N Nat59 (Nat59Plus atLeast59) (Is a To (Nat59Plus a)) (Is b To (Nat59Plus b)))
nat59 =
    tag 59 |> isChecked Nat


nat60 : Nat (N Nat60 (Nat60Plus atLeast60) (Is a To (Nat60Plus a)) (Is b To (Nat60Plus b)))
nat60 =
    tag 60 |> isChecked Nat


nat61 : Nat (N Nat61 (Nat61Plus atLeast61) (Is a To (Nat61Plus a)) (Is b To (Nat61Plus b)))
nat61 =
    tag 61 |> isChecked Nat


nat62 : Nat (N Nat62 (Nat62Plus atLeast62) (Is a To (Nat62Plus a)) (Is b To (Nat62Plus b)))
nat62 =
    tag 62 |> isChecked Nat


nat63 : Nat (N Nat63 (Nat63Plus atLeast63) (Is a To (Nat63Plus a)) (Is b To (Nat63Plus b)))
nat63 =
    tag 63 |> isChecked Nat


nat64 : Nat (N Nat64 (Nat64Plus atLeast64) (Is a To (Nat64Plus a)) (Is b To (Nat64Plus b)))
nat64 =
    tag 64 |> isChecked Nat


nat65 : Nat (N Nat65 (Nat65Plus atLeast65) (Is a To (Nat65Plus a)) (Is b To (Nat65Plus b)))
nat65 =
    tag 65 |> isChecked Nat


nat66 : Nat (N Nat66 (Nat66Plus atLeast66) (Is a To (Nat66Plus a)) (Is b To (Nat66Plus b)))
nat66 =
    tag 66 |> isChecked Nat


nat67 : Nat (N Nat67 (Nat67Plus atLeast67) (Is a To (Nat67Plus a)) (Is b To (Nat67Plus b)))
nat67 =
    tag 67 |> isChecked Nat


nat68 : Nat (N Nat68 (Nat68Plus atLeast68) (Is a To (Nat68Plus a)) (Is b To (Nat68Plus b)))
nat68 =
    tag 68 |> isChecked Nat


nat69 : Nat (N Nat69 (Nat69Plus atLeast69) (Is a To (Nat69Plus a)) (Is b To (Nat69Plus b)))
nat69 =
    tag 69 |> isChecked Nat


nat70 : Nat (N Nat70 (Nat70Plus atLeast70) (Is a To (Nat70Plus a)) (Is b To (Nat70Plus b)))
nat70 =
    tag 70 |> isChecked Nat


nat71 : Nat (N Nat71 (Nat71Plus atLeast71) (Is a To (Nat71Plus a)) (Is b To (Nat71Plus b)))
nat71 =
    tag 71 |> isChecked Nat


nat72 : Nat (N Nat72 (Nat72Plus atLeast72) (Is a To (Nat72Plus a)) (Is b To (Nat72Plus b)))
nat72 =
    tag 72 |> isChecked Nat


nat73 : Nat (N Nat73 (Nat73Plus atLeast73) (Is a To (Nat73Plus a)) (Is b To (Nat73Plus b)))
nat73 =
    tag 73 |> isChecked Nat


nat74 : Nat (N Nat74 (Nat74Plus atLeast74) (Is a To (Nat74Plus a)) (Is b To (Nat74Plus b)))
nat74 =
    tag 74 |> isChecked Nat


nat75 : Nat (N Nat75 (Nat75Plus atLeast75) (Is a To (Nat75Plus a)) (Is b To (Nat75Plus b)))
nat75 =
    tag 75 |> isChecked Nat


nat76 : Nat (N Nat76 (Nat76Plus atLeast76) (Is a To (Nat76Plus a)) (Is b To (Nat76Plus b)))
nat76 =
    tag 76 |> isChecked Nat


nat77 : Nat (N Nat77 (Nat77Plus atLeast77) (Is a To (Nat77Plus a)) (Is b To (Nat77Plus b)))
nat77 =
    tag 77 |> isChecked Nat


nat78 : Nat (N Nat78 (Nat78Plus atLeast78) (Is a To (Nat78Plus a)) (Is b To (Nat78Plus b)))
nat78 =
    tag 78 |> isChecked Nat


nat79 : Nat (N Nat79 (Nat79Plus atLeast79) (Is a To (Nat79Plus a)) (Is b To (Nat79Plus b)))
nat79 =
    tag 79 |> isChecked Nat


nat80 : Nat (N Nat80 (Nat80Plus atLeast80) (Is a To (Nat80Plus a)) (Is b To (Nat80Plus b)))
nat80 =
    tag 80 |> isChecked Nat


nat81 : Nat (N Nat81 (Nat81Plus atLeast81) (Is a To (Nat81Plus a)) (Is b To (Nat81Plus b)))
nat81 =
    tag 81 |> isChecked Nat


nat82 : Nat (N Nat82 (Nat82Plus atLeast82) (Is a To (Nat82Plus a)) (Is b To (Nat82Plus b)))
nat82 =
    tag 82 |> isChecked Nat


nat83 : Nat (N Nat83 (Nat83Plus atLeast83) (Is a To (Nat83Plus a)) (Is b To (Nat83Plus b)))
nat83 =
    tag 83 |> isChecked Nat


nat84 : Nat (N Nat84 (Nat84Plus atLeast84) (Is a To (Nat84Plus a)) (Is b To (Nat84Plus b)))
nat84 =
    tag 84 |> isChecked Nat


nat85 : Nat (N Nat85 (Nat85Plus atLeast85) (Is a To (Nat85Plus a)) (Is b To (Nat85Plus b)))
nat85 =
    tag 85 |> isChecked Nat


nat86 : Nat (N Nat86 (Nat86Plus atLeast86) (Is a To (Nat86Plus a)) (Is b To (Nat86Plus b)))
nat86 =
    tag 86 |> isChecked Nat


nat87 : Nat (N Nat87 (Nat87Plus atLeast87) (Is a To (Nat87Plus a)) (Is b To (Nat87Plus b)))
nat87 =
    tag 87 |> isChecked Nat


nat88 : Nat (N Nat88 (Nat88Plus atLeast88) (Is a To (Nat88Plus a)) (Is b To (Nat88Plus b)))
nat88 =
    tag 88 |> isChecked Nat


nat89 : Nat (N Nat89 (Nat89Plus atLeast89) (Is a To (Nat89Plus a)) (Is b To (Nat89Plus b)))
nat89 =
    tag 89 |> isChecked Nat


nat90 : Nat (N Nat90 (Nat90Plus atLeast90) (Is a To (Nat90Plus a)) (Is b To (Nat90Plus b)))
nat90 =
    tag 90 |> isChecked Nat


nat91 : Nat (N Nat91 (Nat91Plus atLeast91) (Is a To (Nat91Plus a)) (Is b To (Nat91Plus b)))
nat91 =
    tag 91 |> isChecked Nat


nat92 : Nat (N Nat92 (Nat92Plus atLeast92) (Is a To (Nat92Plus a)) (Is b To (Nat92Plus b)))
nat92 =
    tag 92 |> isChecked Nat


nat93 : Nat (N Nat93 (Nat93Plus atLeast93) (Is a To (Nat93Plus a)) (Is b To (Nat93Plus b)))
nat93 =
    tag 93 |> isChecked Nat


nat94 : Nat (N Nat94 (Nat94Plus atLeast94) (Is a To (Nat94Plus a)) (Is b To (Nat94Plus b)))
nat94 =
    tag 94 |> isChecked Nat


nat95 : Nat (N Nat95 (Nat95Plus atLeast95) (Is a To (Nat95Plus a)) (Is b To (Nat95Plus b)))
nat95 =
    tag 95 |> isChecked Nat


nat96 : Nat (N Nat96 (Nat96Plus atLeast96) (Is a To (Nat96Plus a)) (Is b To (Nat96Plus b)))
nat96 =
    tag 96 |> isChecked Nat


nat97 : Nat (N Nat97 (Nat97Plus atLeast97) (Is a To (Nat97Plus a)) (Is b To (Nat97Plus b)))
nat97 =
    tag 97 |> isChecked Nat


nat98 : Nat (N Nat98 (Nat98Plus atLeast98) (Is a To (Nat98Plus a)) (Is b To (Nat98Plus b)))
nat98 =
    tag 98 |> isChecked Nat


nat99 : Nat (N Nat99 (Nat99Plus atLeast99) (Is a To (Nat99Plus a)) (Is b To (Nat99Plus b)))
nat99 =
    tag 99 |> isChecked Nat


nat100 : Nat (N Nat100 (Nat100Plus atLeast100) (Is a To (Nat100Plus a)) (Is b To (Nat100Plus b)))
nat100 =
    tag 100 |> isChecked Nat


nat101 : Nat (N Nat101 (Nat101Plus atLeast101) (Is a To (Nat101Plus a)) (Is b To (Nat101Plus b)))
nat101 =
    tag 101 |> isChecked Nat


nat102 : Nat (N Nat102 (Nat102Plus atLeast102) (Is a To (Nat102Plus a)) (Is b To (Nat102Plus b)))
nat102 =
    tag 102 |> isChecked Nat


nat103 : Nat (N Nat103 (Nat103Plus atLeast103) (Is a To (Nat103Plus a)) (Is b To (Nat103Plus b)))
nat103 =
    tag 103 |> isChecked Nat


nat104 : Nat (N Nat104 (Nat104Plus atLeast104) (Is a To (Nat104Plus a)) (Is b To (Nat104Plus b)))
nat104 =
    tag 104 |> isChecked Nat


nat105 : Nat (N Nat105 (Nat105Plus atLeast105) (Is a To (Nat105Plus a)) (Is b To (Nat105Plus b)))
nat105 =
    tag 105 |> isChecked Nat


nat106 : Nat (N Nat106 (Nat106Plus atLeast106) (Is a To (Nat106Plus a)) (Is b To (Nat106Plus b)))
nat106 =
    tag 106 |> isChecked Nat


nat107 : Nat (N Nat107 (Nat107Plus atLeast107) (Is a To (Nat107Plus a)) (Is b To (Nat107Plus b)))
nat107 =
    tag 107 |> isChecked Nat


nat108 : Nat (N Nat108 (Nat108Plus atLeast108) (Is a To (Nat108Plus a)) (Is b To (Nat108Plus b)))
nat108 =
    tag 108 |> isChecked Nat


nat109 : Nat (N Nat109 (Nat109Plus atLeast109) (Is a To (Nat109Plus a)) (Is b To (Nat109Plus b)))
nat109 =
    tag 109 |> isChecked Nat


nat110 : Nat (N Nat110 (Nat110Plus atLeast110) (Is a To (Nat110Plus a)) (Is b To (Nat110Plus b)))
nat110 =
    tag 110 |> isChecked Nat


nat111 : Nat (N Nat111 (Nat111Plus atLeast111) (Is a To (Nat111Plus a)) (Is b To (Nat111Plus b)))
nat111 =
    tag 111 |> isChecked Nat


nat112 : Nat (N Nat112 (Nat112Plus atLeast112) (Is a To (Nat112Plus a)) (Is b To (Nat112Plus b)))
nat112 =
    tag 112 |> isChecked Nat


nat113 : Nat (N Nat113 (Nat113Plus atLeast113) (Is a To (Nat113Plus a)) (Is b To (Nat113Plus b)))
nat113 =
    tag 113 |> isChecked Nat


nat114 : Nat (N Nat114 (Nat114Plus atLeast114) (Is a To (Nat114Plus a)) (Is b To (Nat114Plus b)))
nat114 =
    tag 114 |> isChecked Nat


nat115 : Nat (N Nat115 (Nat115Plus atLeast115) (Is a To (Nat115Plus a)) (Is b To (Nat115Plus b)))
nat115 =
    tag 115 |> isChecked Nat


nat116 : Nat (N Nat116 (Nat116Plus atLeast116) (Is a To (Nat116Plus a)) (Is b To (Nat116Plus b)))
nat116 =
    tag 116 |> isChecked Nat


nat117 : Nat (N Nat117 (Nat117Plus atLeast117) (Is a To (Nat117Plus a)) (Is b To (Nat117Plus b)))
nat117 =
    tag 117 |> isChecked Nat


nat118 : Nat (N Nat118 (Nat118Plus atLeast118) (Is a To (Nat118Plus a)) (Is b To (Nat118Plus b)))
nat118 =
    tag 118 |> isChecked Nat


nat119 : Nat (N Nat119 (Nat119Plus atLeast119) (Is a To (Nat119Plus a)) (Is b To (Nat119Plus b)))
nat119 =
    tag 119 |> isChecked Nat


nat120 : Nat (N Nat120 (Nat120Plus atLeast120) (Is a To (Nat120Plus a)) (Is b To (Nat120Plus b)))
nat120 =
    tag 120 |> isChecked Nat


nat121 : Nat (N Nat121 (Nat121Plus atLeast121) (Is a To (Nat121Plus a)) (Is b To (Nat121Plus b)))
nat121 =
    tag 121 |> isChecked Nat


nat122 : Nat (N Nat122 (Nat122Plus atLeast122) (Is a To (Nat122Plus a)) (Is b To (Nat122Plus b)))
nat122 =
    tag 122 |> isChecked Nat


nat123 : Nat (N Nat123 (Nat123Plus atLeast123) (Is a To (Nat123Plus a)) (Is b To (Nat123Plus b)))
nat123 =
    tag 123 |> isChecked Nat


nat124 : Nat (N Nat124 (Nat124Plus atLeast124) (Is a To (Nat124Plus a)) (Is b To (Nat124Plus b)))
nat124 =
    tag 124 |> isChecked Nat


nat125 : Nat (N Nat125 (Nat125Plus atLeast125) (Is a To (Nat125Plus a)) (Is b To (Nat125Plus b)))
nat125 =
    tag 125 |> isChecked Nat


nat126 : Nat (N Nat126 (Nat126Plus atLeast126) (Is a To (Nat126Plus a)) (Is b To (Nat126Plus b)))
nat126 =
    tag 126 |> isChecked Nat


nat127 : Nat (N Nat127 (Nat127Plus atLeast127) (Is a To (Nat127Plus a)) (Is b To (Nat127Plus b)))
nat127 =
    tag 127 |> isChecked Nat


nat128 : Nat (N Nat128 (Nat128Plus atLeast128) (Is a To (Nat128Plus a)) (Is b To (Nat128Plus b)))
nat128 =
    tag 128 |> isChecked Nat


nat129 : Nat (N Nat129 (Nat129Plus atLeast129) (Is a To (Nat129Plus a)) (Is b To (Nat129Plus b)))
nat129 =
    tag 129 |> isChecked Nat


nat130 : Nat (N Nat130 (Nat130Plus atLeast130) (Is a To (Nat130Plus a)) (Is b To (Nat130Plus b)))
nat130 =
    tag 130 |> isChecked Nat


nat131 : Nat (N Nat131 (Nat131Plus atLeast131) (Is a To (Nat131Plus a)) (Is b To (Nat131Plus b)))
nat131 =
    tag 131 |> isChecked Nat


nat132 : Nat (N Nat132 (Nat132Plus atLeast132) (Is a To (Nat132Plus a)) (Is b To (Nat132Plus b)))
nat132 =
    tag 132 |> isChecked Nat


nat133 : Nat (N Nat133 (Nat133Plus atLeast133) (Is a To (Nat133Plus a)) (Is b To (Nat133Plus b)))
nat133 =
    tag 133 |> isChecked Nat


nat134 : Nat (N Nat134 (Nat134Plus atLeast134) (Is a To (Nat134Plus a)) (Is b To (Nat134Plus b)))
nat134 =
    tag 134 |> isChecked Nat


nat135 : Nat (N Nat135 (Nat135Plus atLeast135) (Is a To (Nat135Plus a)) (Is b To (Nat135Plus b)))
nat135 =
    tag 135 |> isChecked Nat


nat136 : Nat (N Nat136 (Nat136Plus atLeast136) (Is a To (Nat136Plus a)) (Is b To (Nat136Plus b)))
nat136 =
    tag 136 |> isChecked Nat


nat137 : Nat (N Nat137 (Nat137Plus atLeast137) (Is a To (Nat137Plus a)) (Is b To (Nat137Plus b)))
nat137 =
    tag 137 |> isChecked Nat


nat138 : Nat (N Nat138 (Nat138Plus atLeast138) (Is a To (Nat138Plus a)) (Is b To (Nat138Plus b)))
nat138 =
    tag 138 |> isChecked Nat


nat139 : Nat (N Nat139 (Nat139Plus atLeast139) (Is a To (Nat139Plus a)) (Is b To (Nat139Plus b)))
nat139 =
    tag 139 |> isChecked Nat


nat140 : Nat (N Nat140 (Nat140Plus atLeast140) (Is a To (Nat140Plus a)) (Is b To (Nat140Plus b)))
nat140 =
    tag 140 |> isChecked Nat


nat141 : Nat (N Nat141 (Nat141Plus atLeast141) (Is a To (Nat141Plus a)) (Is b To (Nat141Plus b)))
nat141 =
    tag 141 |> isChecked Nat


nat142 : Nat (N Nat142 (Nat142Plus atLeast142) (Is a To (Nat142Plus a)) (Is b To (Nat142Plus b)))
nat142 =
    tag 142 |> isChecked Nat


nat143 : Nat (N Nat143 (Nat143Plus atLeast143) (Is a To (Nat143Plus a)) (Is b To (Nat143Plus b)))
nat143 =
    tag 143 |> isChecked Nat


nat144 : Nat (N Nat144 (Nat144Plus atLeast144) (Is a To (Nat144Plus a)) (Is b To (Nat144Plus b)))
nat144 =
    tag 144 |> isChecked Nat


nat145 : Nat (N Nat145 (Nat145Plus atLeast145) (Is a To (Nat145Plus a)) (Is b To (Nat145Plus b)))
nat145 =
    tag 145 |> isChecked Nat


nat146 : Nat (N Nat146 (Nat146Plus atLeast146) (Is a To (Nat146Plus a)) (Is b To (Nat146Plus b)))
nat146 =
    tag 146 |> isChecked Nat


nat147 : Nat (N Nat147 (Nat147Plus atLeast147) (Is a To (Nat147Plus a)) (Is b To (Nat147Plus b)))
nat147 =
    tag 147 |> isChecked Nat


nat148 : Nat (N Nat148 (Nat148Plus atLeast148) (Is a To (Nat148Plus a)) (Is b To (Nat148Plus b)))
nat148 =
    tag 148 |> isChecked Nat


nat149 : Nat (N Nat149 (Nat149Plus atLeast149) (Is a To (Nat149Plus a)) (Is b To (Nat149Plus b)))
nat149 =
    tag 149 |> isChecked Nat


nat150 : Nat (N Nat150 (Nat150Plus atLeast150) (Is a To (Nat150Plus a)) (Is b To (Nat150Plus b)))
nat150 =
    tag 150 |> isChecked Nat


nat151 : Nat (N Nat151 (Nat151Plus atLeast151) (Is a To (Nat151Plus a)) (Is b To (Nat151Plus b)))
nat151 =
    tag 151 |> isChecked Nat


nat152 : Nat (N Nat152 (Nat152Plus atLeast152) (Is a To (Nat152Plus a)) (Is b To (Nat152Plus b)))
nat152 =
    tag 152 |> isChecked Nat


nat153 : Nat (N Nat153 (Nat153Plus atLeast153) (Is a To (Nat153Plus a)) (Is b To (Nat153Plus b)))
nat153 =
    tag 153 |> isChecked Nat


nat154 : Nat (N Nat154 (Nat154Plus atLeast154) (Is a To (Nat154Plus a)) (Is b To (Nat154Plus b)))
nat154 =
    tag 154 |> isChecked Nat


nat155 : Nat (N Nat155 (Nat155Plus atLeast155) (Is a To (Nat155Plus a)) (Is b To (Nat155Plus b)))
nat155 =
    tag 155 |> isChecked Nat


nat156 : Nat (N Nat156 (Nat156Plus atLeast156) (Is a To (Nat156Plus a)) (Is b To (Nat156Plus b)))
nat156 =
    tag 156 |> isChecked Nat


nat157 : Nat (N Nat157 (Nat157Plus atLeast157) (Is a To (Nat157Plus a)) (Is b To (Nat157Plus b)))
nat157 =
    tag 157 |> isChecked Nat


nat158 : Nat (N Nat158 (Nat158Plus atLeast158) (Is a To (Nat158Plus a)) (Is b To (Nat158Plus b)))
nat158 =
    tag 158 |> isChecked Nat


nat159 : Nat (N Nat159 (Nat159Plus atLeast159) (Is a To (Nat159Plus a)) (Is b To (Nat159Plus b)))
nat159 =
    tag 159 |> isChecked Nat


nat160 : Nat (N Nat160 (Nat160Plus atLeast160) (Is a To (Nat160Plus a)) (Is b To (Nat160Plus b)))
nat160 =
    tag 160 |> isChecked Nat
