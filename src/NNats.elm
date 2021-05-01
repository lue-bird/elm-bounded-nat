module NNats exposing
    ( nat0, nat1, nat10, nat100, nat101, nat102, nat103, nat104, nat105, nat106, nat107
    , nat108, nat109, nat11, nat110, nat111, nat112, nat113, nat114, nat115, nat116
    , nat117, nat118, nat119, nat12, nat120, nat121, nat122, nat123, nat124, nat125
    , nat126, nat127, nat128, nat129, nat13, nat130, nat131, nat132, nat133, nat134
    , nat135, nat136, nat137, nat138, nat139, nat14, nat140, nat141, nat142, nat143
    , nat144, nat145, nat146, nat147, nat148, nat149, nat15, nat150, nat151, nat152
    , nat153, nat154, nat155, nat156, nat157, nat158, nat159, nat16, nat160, nat17, nat18
    , nat19, nat2, nat20, nat21, nat22, nat23, nat24, nat25, nat26, nat27, nat28, nat29, nat3
    , nat30, nat31, nat32, nat33, nat34, nat35, nat36, nat37, nat38, nat39, nat4, nat40, nat41
    , nat42, nat43, nat44, nat45, nat46, nat47, nat48, nat49, nat5, nat50, nat51, nat52, nat53
    , nat54, nat55, nat56, nat57, nat58, nat59, nat6, nat60, nat61, nat62, nat63, nat64, nat65
    , nat66, nat67, nat68, nat69, nat7, nat70, nat71, nat72, nat73, nat74, nat75, nat76, nat77
    , nat78, nat79, nat8, nat80, nat81, nat82, nat83, nat84, nat85, nat86, nat87, nat88, nat89
    , nat9, nat90, nat91, nat92, nat93, nat94, nat95, nat96, nat97, nat98, nat99
    )

{-| `Nat (ArgN Nat0 ...)` to `Nat (ArgN 160 ...)`.

Bigger `Nat (ArgN ...)` s start to slow down compilation, so they are avoided.

See [`Nat.Bound.N`](Nat-Bound#N), [`Nat.Bound.N`](Nat-Bound#N) & [`NNat`](NNat) for an explanation.

@docs nat0, nat1, nat10, nat100, nat101, nat102, nat103, nat104, nat105, nat106, nat107
@docs nat108, nat109, nat11, nat110, nat111, nat112, nat113, nat114, nat115, nat116
@docs nat117, nat118, nat119, nat12, nat120, nat121, nat122, nat123, nat124, nat125
@docs nat126, nat127, nat128, nat129, nat13, nat130, nat131, nat132, nat133, nat134
@docs nat135, nat136, nat137, nat138, nat139, nat14, nat140, nat141, nat142, nat143
@docs nat144, nat145, nat146, nat147, nat148, nat149, nat15, nat150, nat151, nat152
@docs nat153, nat154, nat155, nat156, nat157, nat158, nat159, nat16, nat160, nat17, nat18
@docs nat19, nat2, nat20, nat21, nat22, nat23, nat24, nat25, nat26, nat27, nat28, nat29, nat3
@docs nat30, nat31, nat32, nat33, nat34, nat35, nat36, nat37, nat38, nat39, nat4, nat40, nat41
@docs nat42, nat43, nat44, nat45, nat46, nat47, nat48, nat49, nat5, nat50, nat51, nat52, nat53
@docs nat54, nat55, nat56, nat57, nat58, nat59, nat6, nat60, nat61, nat62, nat63, nat64, nat65
@docs nat66, nat67, nat68, nat69, nat7, nat70, nat71, nat72, nat73, nat74, nat75, nat76, nat77
@docs nat78, nat79, nat8, nat80, nat81, nat82, nat83, nat84, nat85, nat86, nat87, nat88, nat89
@docs nat9, nat90, nat91, nat92, nat93, nat94, nat95, nat96, nat97, nat98, nat99

-}

import I exposing (Is, N, Nat, To)
import N exposing (..)


{-| The exact `Nat` 0.
-}
nat0 : Nat (N Nat0 orMore (Is a To a) (Is b To b))
nat0 =
    I.nat0


{-| The exact `Nat` 1.
-}
nat1 : Nat (N Nat1 (Nat1Plus orMore) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    I.nat1


{-| The exact `Nat` 2.
-}
nat2 : Nat (N Nat2 (Nat2Plus orMore) (Is a To (Nat2Plus a)) (Is b To (Nat2Plus b)))
nat2 =
    I.nat2


{-| The exact `Nat` 3.
-}
nat3 : Nat (N Nat3 (Nat3Plus orMore) (Is a To (Nat3Plus a)) (Is b To (Nat3Plus b)))
nat3 =
    I.nat3


{-| The exact `Nat` 4.
-}
nat4 : Nat (N Nat4 (Nat4Plus orMore) (Is a To (Nat4Plus a)) (Is b To (Nat4Plus b)))
nat4 =
    I.nat4


{-| The exact `Nat` 5.
-}
nat5 : Nat (N Nat5 (Nat5Plus orMore) (Is a To (Nat5Plus a)) (Is b To (Nat5Plus b)))
nat5 =
    I.nat5


{-| The exact `Nat` 6.
-}
nat6 : Nat (N Nat6 (Nat6Plus orMore) (Is a To (Nat6Plus a)) (Is b To (Nat6Plus b)))
nat6 =
    I.nat6


{-| The exact `Nat` 7.
-}
nat7 : Nat (N Nat7 (Nat7Plus orMore) (Is a To (Nat7Plus a)) (Is b To (Nat7Plus b)))
nat7 =
    I.nat7


{-| The exact `Nat` 8.
-}
nat8 : Nat (N Nat8 (Nat8Plus orMore) (Is a To (Nat8Plus a)) (Is b To (Nat8Plus b)))
nat8 =
    I.nat8


{-| The exact `Nat` 9.
-}
nat9 : Nat (N Nat9 (Nat9Plus orMore) (Is a To (Nat9Plus a)) (Is b To (Nat9Plus b)))
nat9 =
    I.nat9


{-| The exact `Nat` 10.
-}
nat10 : Nat (N Nat10 (Nat10Plus orMore) (Is a To (Nat10Plus a)) (Is b To (Nat10Plus b)))
nat10 =
    I.nat10


{-| The exact `Nat` 11.
-}
nat11 : Nat (N Nat11 (Nat11Plus orMore) (Is a To (Nat11Plus a)) (Is b To (Nat11Plus b)))
nat11 =
    I.nat11


{-| The exact `Nat` 12.
-}
nat12 : Nat (N Nat12 (Nat12Plus orMore) (Is a To (Nat12Plus a)) (Is b To (Nat12Plus b)))
nat12 =
    I.nat12


{-| The exact `Nat` 13.
-}
nat13 : Nat (N Nat13 (Nat13Plus orMore) (Is a To (Nat13Plus a)) (Is b To (Nat13Plus b)))
nat13 =
    I.nat13


{-| The exact `Nat` 14.
-}
nat14 : Nat (N Nat14 (Nat14Plus orMore) (Is a To (Nat14Plus a)) (Is b To (Nat14Plus b)))
nat14 =
    I.nat14


{-| The exact `Nat` 15.
-}
nat15 : Nat (N Nat15 (Nat15Plus orMore) (Is a To (Nat15Plus a)) (Is b To (Nat15Plus b)))
nat15 =
    I.nat15


{-| The exact `Nat` 16.
-}
nat16 : Nat (N Nat16 (Nat16Plus orMore) (Is a To (Nat16Plus a)) (Is b To (Nat16Plus b)))
nat16 =
    I.nat16


{-| The exact `Nat` 17.
-}
nat17 : Nat (N Nat17 (Nat17Plus orMore) (Is a To (Nat17Plus a)) (Is b To (Nat17Plus b)))
nat17 =
    I.nat17


{-| The exact `Nat` 18.
-}
nat18 : Nat (N Nat18 (Nat18Plus orMore) (Is a To (Nat18Plus a)) (Is b To (Nat18Plus b)))
nat18 =
    I.nat18


{-| The exact `Nat` 19.
-}
nat19 : Nat (N Nat19 (Nat19Plus orMore) (Is a To (Nat19Plus a)) (Is b To (Nat19Plus b)))
nat19 =
    I.nat19


{-| The exact `Nat` 20.
-}
nat20 : Nat (N Nat20 (Nat20Plus orMore) (Is a To (Nat20Plus a)) (Is b To (Nat20Plus b)))
nat20 =
    I.nat20


{-| The exact `Nat` 21.
-}
nat21 : Nat (N Nat21 (Nat21Plus orMore) (Is a To (Nat21Plus a)) (Is b To (Nat21Plus b)))
nat21 =
    I.nat21


{-| The exact `Nat` 22.
-}
nat22 : Nat (N Nat22 (Nat22Plus orMore) (Is a To (Nat22Plus a)) (Is b To (Nat22Plus b)))
nat22 =
    I.nat22


{-| The exact `Nat` 23.
-}
nat23 : Nat (N Nat23 (Nat23Plus orMore) (Is a To (Nat23Plus a)) (Is b To (Nat23Plus b)))
nat23 =
    I.nat23


{-| The exact `Nat` 24.
-}
nat24 : Nat (N Nat24 (Nat24Plus orMore) (Is a To (Nat24Plus a)) (Is b To (Nat24Plus b)))
nat24 =
    I.nat24


{-| The exact `Nat` 25.
-}
nat25 : Nat (N Nat25 (Nat25Plus orMore) (Is a To (Nat25Plus a)) (Is b To (Nat25Plus b)))
nat25 =
    I.nat25


{-| The exact `Nat` 26.
-}
nat26 : Nat (N Nat26 (Nat26Plus orMore) (Is a To (Nat26Plus a)) (Is b To (Nat26Plus b)))
nat26 =
    I.nat26


{-| The exact `Nat` 27.
-}
nat27 : Nat (N Nat27 (Nat27Plus orMore) (Is a To (Nat27Plus a)) (Is b To (Nat27Plus b)))
nat27 =
    I.nat27


{-| The exact `Nat` 28.
-}
nat28 : Nat (N Nat28 (Nat28Plus orMore) (Is a To (Nat28Plus a)) (Is b To (Nat28Plus b)))
nat28 =
    I.nat28


{-| The exact `Nat` 29.
-}
nat29 : Nat (N Nat29 (Nat29Plus orMore) (Is a To (Nat29Plus a)) (Is b To (Nat29Plus b)))
nat29 =
    I.nat29


{-| The exact `Nat` 30.
-}
nat30 : Nat (N Nat30 (Nat30Plus orMore) (Is a To (Nat30Plus a)) (Is b To (Nat30Plus b)))
nat30 =
    I.nat30


{-| The exact `Nat` 31.
-}
nat31 : Nat (N Nat31 (Nat31Plus orMore) (Is a To (Nat31Plus a)) (Is b To (Nat31Plus b)))
nat31 =
    I.nat31


{-| The exact `Nat` 32.
-}
nat32 : Nat (N Nat32 (Nat32Plus orMore) (Is a To (Nat32Plus a)) (Is b To (Nat32Plus b)))
nat32 =
    I.nat32


{-| The exact `Nat` 33.
-}
nat33 : Nat (N Nat33 (Nat33Plus orMore) (Is a To (Nat33Plus a)) (Is b To (Nat33Plus b)))
nat33 =
    I.nat33


{-| The exact `Nat` 34.
-}
nat34 : Nat (N Nat34 (Nat34Plus orMore) (Is a To (Nat34Plus a)) (Is b To (Nat34Plus b)))
nat34 =
    I.nat34


{-| The exact `Nat` 35.
-}
nat35 : Nat (N Nat35 (Nat35Plus orMore) (Is a To (Nat35Plus a)) (Is b To (Nat35Plus b)))
nat35 =
    I.nat35


{-| The exact `Nat` 36.
-}
nat36 : Nat (N Nat36 (Nat36Plus orMore) (Is a To (Nat36Plus a)) (Is b To (Nat36Plus b)))
nat36 =
    I.nat36


{-| The exact `Nat` 37.
-}
nat37 : Nat (N Nat37 (Nat37Plus orMore) (Is a To (Nat37Plus a)) (Is b To (Nat37Plus b)))
nat37 =
    I.nat37


{-| The exact `Nat` 38.
-}
nat38 : Nat (N Nat38 (Nat38Plus orMore) (Is a To (Nat38Plus a)) (Is b To (Nat38Plus b)))
nat38 =
    I.nat38


{-| The exact `Nat` 39.
-}
nat39 : Nat (N Nat39 (Nat39Plus orMore) (Is a To (Nat39Plus a)) (Is b To (Nat39Plus b)))
nat39 =
    I.nat39


{-| The exact `Nat` 40.
-}
nat40 : Nat (N Nat40 (Nat40Plus orMore) (Is a To (Nat40Plus a)) (Is b To (Nat40Plus b)))
nat40 =
    I.nat40


{-| The exact `Nat` 41.
-}
nat41 : Nat (N Nat41 (Nat41Plus orMore) (Is a To (Nat41Plus a)) (Is b To (Nat41Plus b)))
nat41 =
    I.nat41


{-| The exact `Nat` 42.
-}
nat42 : Nat (N Nat42 (Nat42Plus orMore) (Is a To (Nat42Plus a)) (Is b To (Nat42Plus b)))
nat42 =
    I.nat42


{-| The exact `Nat` 43.
-}
nat43 : Nat (N Nat43 (Nat43Plus orMore) (Is a To (Nat43Plus a)) (Is b To (Nat43Plus b)))
nat43 =
    I.nat43


{-| The exact `Nat` 44.
-}
nat44 : Nat (N Nat44 (Nat44Plus orMore) (Is a To (Nat44Plus a)) (Is b To (Nat44Plus b)))
nat44 =
    I.nat44


{-| The exact `Nat` 45.
-}
nat45 : Nat (N Nat45 (Nat45Plus orMore) (Is a To (Nat45Plus a)) (Is b To (Nat45Plus b)))
nat45 =
    I.nat45


{-| The exact `Nat` 46.
-}
nat46 : Nat (N Nat46 (Nat46Plus orMore) (Is a To (Nat46Plus a)) (Is b To (Nat46Plus b)))
nat46 =
    I.nat46


{-| The exact `Nat` 47.
-}
nat47 : Nat (N Nat47 (Nat47Plus orMore) (Is a To (Nat47Plus a)) (Is b To (Nat47Plus b)))
nat47 =
    I.nat47


{-| The exact `Nat` 48.
-}
nat48 : Nat (N Nat48 (Nat48Plus orMore) (Is a To (Nat48Plus a)) (Is b To (Nat48Plus b)))
nat48 =
    I.nat48


{-| The exact `Nat` 49.
-}
nat49 : Nat (N Nat49 (Nat49Plus orMore) (Is a To (Nat49Plus a)) (Is b To (Nat49Plus b)))
nat49 =
    I.nat49


{-| The exact `Nat` 50.
-}
nat50 : Nat (N Nat50 (Nat50Plus orMore) (Is a To (Nat50Plus a)) (Is b To (Nat50Plus b)))
nat50 =
    I.nat50


{-| The exact `Nat` 51.
-}
nat51 : Nat (N Nat51 (Nat51Plus orMore) (Is a To (Nat51Plus a)) (Is b To (Nat51Plus b)))
nat51 =
    I.nat51


{-| The exact `Nat` 52.
-}
nat52 : Nat (N Nat52 (Nat52Plus orMore) (Is a To (Nat52Plus a)) (Is b To (Nat52Plus b)))
nat52 =
    I.nat52


{-| The exact `Nat` 53.
-}
nat53 : Nat (N Nat53 (Nat53Plus orMore) (Is a To (Nat53Plus a)) (Is b To (Nat53Plus b)))
nat53 =
    I.nat53


{-| The exact `Nat` 54.
-}
nat54 : Nat (N Nat54 (Nat54Plus orMore) (Is a To (Nat54Plus a)) (Is b To (Nat54Plus b)))
nat54 =
    I.nat54


{-| The exact `Nat` 55.
-}
nat55 : Nat (N Nat55 (Nat55Plus orMore) (Is a To (Nat55Plus a)) (Is b To (Nat55Plus b)))
nat55 =
    I.nat55


{-| The exact `Nat` 56.
-}
nat56 : Nat (N Nat56 (Nat56Plus orMore) (Is a To (Nat56Plus a)) (Is b To (Nat56Plus b)))
nat56 =
    I.nat56


{-| The exact `Nat` 57.
-}
nat57 : Nat (N Nat57 (Nat57Plus orMore) (Is a To (Nat57Plus a)) (Is b To (Nat57Plus b)))
nat57 =
    I.nat57


{-| The exact `Nat` 58.
-}
nat58 : Nat (N Nat58 (Nat58Plus orMore) (Is a To (Nat58Plus a)) (Is b To (Nat58Plus b)))
nat58 =
    I.nat58


{-| The exact `Nat` 59.
-}
nat59 : Nat (N Nat59 (Nat59Plus orMore) (Is a To (Nat59Plus a)) (Is b To (Nat59Plus b)))
nat59 =
    I.nat59


{-| The exact `Nat` 60.
-}
nat60 : Nat (N Nat60 (Nat60Plus orMore) (Is a To (Nat60Plus a)) (Is b To (Nat60Plus b)))
nat60 =
    I.nat60


{-| The exact `Nat` 61.
-}
nat61 : Nat (N Nat61 (Nat61Plus orMore) (Is a To (Nat61Plus a)) (Is b To (Nat61Plus b)))
nat61 =
    I.nat61


{-| The exact `Nat` 62.
-}
nat62 : Nat (N Nat62 (Nat62Plus orMore) (Is a To (Nat62Plus a)) (Is b To (Nat62Plus b)))
nat62 =
    I.nat62


{-| The exact `Nat` 63.
-}
nat63 : Nat (N Nat63 (Nat63Plus orMore) (Is a To (Nat63Plus a)) (Is b To (Nat63Plus b)))
nat63 =
    I.nat63


{-| The exact `Nat` 64.
-}
nat64 : Nat (N Nat64 (Nat64Plus orMore) (Is a To (Nat64Plus a)) (Is b To (Nat64Plus b)))
nat64 =
    I.nat64


{-| The exact `Nat` 65.
-}
nat65 : Nat (N Nat65 (Nat65Plus orMore) (Is a To (Nat65Plus a)) (Is b To (Nat65Plus b)))
nat65 =
    I.nat65


{-| The exact `Nat` 66.
-}
nat66 : Nat (N Nat66 (Nat66Plus orMore) (Is a To (Nat66Plus a)) (Is b To (Nat66Plus b)))
nat66 =
    I.nat66


{-| The exact `Nat` 67.
-}
nat67 : Nat (N Nat67 (Nat67Plus orMore) (Is a To (Nat67Plus a)) (Is b To (Nat67Plus b)))
nat67 =
    I.nat67


{-| The exact `Nat` 68.
-}
nat68 : Nat (N Nat68 (Nat68Plus orMore) (Is a To (Nat68Plus a)) (Is b To (Nat68Plus b)))
nat68 =
    I.nat68


{-| The exact `Nat` 69.
-}
nat69 : Nat (N Nat69 (Nat69Plus orMore) (Is a To (Nat69Plus a)) (Is b To (Nat69Plus b)))
nat69 =
    I.nat69


{-| The exact `Nat` 70.
-}
nat70 : Nat (N Nat70 (Nat70Plus orMore) (Is a To (Nat70Plus a)) (Is b To (Nat70Plus b)))
nat70 =
    I.nat70


{-| The exact `Nat` 71.
-}
nat71 : Nat (N Nat71 (Nat71Plus orMore) (Is a To (Nat71Plus a)) (Is b To (Nat71Plus b)))
nat71 =
    I.nat71


{-| The exact `Nat` 72.
-}
nat72 : Nat (N Nat72 (Nat72Plus orMore) (Is a To (Nat72Plus a)) (Is b To (Nat72Plus b)))
nat72 =
    I.nat72


{-| The exact `Nat` 73.
-}
nat73 : Nat (N Nat73 (Nat73Plus orMore) (Is a To (Nat73Plus a)) (Is b To (Nat73Plus b)))
nat73 =
    I.nat73


{-| The exact `Nat` 74.
-}
nat74 : Nat (N Nat74 (Nat74Plus orMore) (Is a To (Nat74Plus a)) (Is b To (Nat74Plus b)))
nat74 =
    I.nat74


{-| The exact `Nat` 75.
-}
nat75 : Nat (N Nat75 (Nat75Plus orMore) (Is a To (Nat75Plus a)) (Is b To (Nat75Plus b)))
nat75 =
    I.nat75


{-| The exact `Nat` 76.
-}
nat76 : Nat (N Nat76 (Nat76Plus orMore) (Is a To (Nat76Plus a)) (Is b To (Nat76Plus b)))
nat76 =
    I.nat76


{-| The exact `Nat` 77.
-}
nat77 : Nat (N Nat77 (Nat77Plus orMore) (Is a To (Nat77Plus a)) (Is b To (Nat77Plus b)))
nat77 =
    I.nat77


{-| The exact `Nat` 78.
-}
nat78 : Nat (N Nat78 (Nat78Plus orMore) (Is a To (Nat78Plus a)) (Is b To (Nat78Plus b)))
nat78 =
    I.nat78


{-| The exact `Nat` 79.
-}
nat79 : Nat (N Nat79 (Nat79Plus orMore) (Is a To (Nat79Plus a)) (Is b To (Nat79Plus b)))
nat79 =
    I.nat79


{-| The exact `Nat` 80.
-}
nat80 : Nat (N Nat80 (Nat80Plus orMore) (Is a To (Nat80Plus a)) (Is b To (Nat80Plus b)))
nat80 =
    I.nat80


{-| The exact `Nat` 81.
-}
nat81 : Nat (N Nat81 (Nat81Plus orMore) (Is a To (Nat81Plus a)) (Is b To (Nat81Plus b)))
nat81 =
    I.nat81


{-| The exact `Nat` 82.
-}
nat82 : Nat (N Nat82 (Nat82Plus orMore) (Is a To (Nat82Plus a)) (Is b To (Nat82Plus b)))
nat82 =
    I.nat82


{-| The exact `Nat` 83.
-}
nat83 : Nat (N Nat83 (Nat83Plus orMore) (Is a To (Nat83Plus a)) (Is b To (Nat83Plus b)))
nat83 =
    I.nat83


{-| The exact `Nat` 84.
-}
nat84 : Nat (N Nat84 (Nat84Plus orMore) (Is a To (Nat84Plus a)) (Is b To (Nat84Plus b)))
nat84 =
    I.nat84


{-| The exact `Nat` 85.
-}
nat85 : Nat (N Nat85 (Nat85Plus orMore) (Is a To (Nat85Plus a)) (Is b To (Nat85Plus b)))
nat85 =
    I.nat85


{-| The exact `Nat` 86.
-}
nat86 : Nat (N Nat86 (Nat86Plus orMore) (Is a To (Nat86Plus a)) (Is b To (Nat86Plus b)))
nat86 =
    I.nat86


{-| The exact `Nat` 87.
-}
nat87 : Nat (N Nat87 (Nat87Plus orMore) (Is a To (Nat87Plus a)) (Is b To (Nat87Plus b)))
nat87 =
    I.nat87


{-| The exact `Nat` 88.
-}
nat88 : Nat (N Nat88 (Nat88Plus orMore) (Is a To (Nat88Plus a)) (Is b To (Nat88Plus b)))
nat88 =
    I.nat88


{-| The exact `Nat` 89.
-}
nat89 : Nat (N Nat89 (Nat89Plus orMore) (Is a To (Nat89Plus a)) (Is b To (Nat89Plus b)))
nat89 =
    I.nat89


{-| The exact `Nat` 90.
-}
nat90 : Nat (N Nat90 (Nat90Plus orMore) (Is a To (Nat90Plus a)) (Is b To (Nat90Plus b)))
nat90 =
    I.nat90


{-| The exact `Nat` 91.
-}
nat91 : Nat (N Nat91 (Nat91Plus orMore) (Is a To (Nat91Plus a)) (Is b To (Nat91Plus b)))
nat91 =
    I.nat91


{-| The exact `Nat` 92.
-}
nat92 : Nat (N Nat92 (Nat92Plus orMore) (Is a To (Nat92Plus a)) (Is b To (Nat92Plus b)))
nat92 =
    I.nat92


{-| The exact `Nat` 93.
-}
nat93 : Nat (N Nat93 (Nat93Plus orMore) (Is a To (Nat93Plus a)) (Is b To (Nat93Plus b)))
nat93 =
    I.nat93


{-| The exact `Nat` 94.
-}
nat94 : Nat (N Nat94 (Nat94Plus orMore) (Is a To (Nat94Plus a)) (Is b To (Nat94Plus b)))
nat94 =
    I.nat94


{-| The exact `Nat` 95.
-}
nat95 : Nat (N Nat95 (Nat95Plus orMore) (Is a To (Nat95Plus a)) (Is b To (Nat95Plus b)))
nat95 =
    I.nat95


{-| The exact `Nat` 96.
-}
nat96 : Nat (N Nat96 (Nat96Plus orMore) (Is a To (Nat96Plus a)) (Is b To (Nat96Plus b)))
nat96 =
    I.nat96


{-| The exact `Nat` 97.
-}
nat97 : Nat (N Nat97 (Nat97Plus orMore) (Is a To (Nat97Plus a)) (Is b To (Nat97Plus b)))
nat97 =
    I.nat97


{-| The exact `Nat` 98.
-}
nat98 : Nat (N Nat98 (Nat98Plus orMore) (Is a To (Nat98Plus a)) (Is b To (Nat98Plus b)))
nat98 =
    I.nat98


{-| The exact `Nat` 99.
-}
nat99 : Nat (N Nat99 (Nat99Plus orMore) (Is a To (Nat99Plus a)) (Is b To (Nat99Plus b)))
nat99 =
    I.nat99


{-| The exact `Nat` 100.
-}
nat100 : Nat (N Nat100 (Nat100Plus orMore) (Is a To (Nat100Plus a)) (Is b To (Nat100Plus b)))
nat100 =
    I.nat100


{-| The exact `Nat` 101.
-}
nat101 : Nat (N Nat101 (Nat101Plus orMore) (Is a To (Nat101Plus a)) (Is b To (Nat101Plus b)))
nat101 =
    I.nat101


{-| The exact `Nat` 102.
-}
nat102 : Nat (N Nat102 (Nat102Plus orMore) (Is a To (Nat102Plus a)) (Is b To (Nat102Plus b)))
nat102 =
    I.nat102


{-| The exact `Nat` 103.
-}
nat103 : Nat (N Nat103 (Nat103Plus orMore) (Is a To (Nat103Plus a)) (Is b To (Nat103Plus b)))
nat103 =
    I.nat103


{-| The exact `Nat` 104.
-}
nat104 : Nat (N Nat104 (Nat104Plus orMore) (Is a To (Nat104Plus a)) (Is b To (Nat104Plus b)))
nat104 =
    I.nat104


{-| The exact `Nat` 105.
-}
nat105 : Nat (N Nat105 (Nat105Plus orMore) (Is a To (Nat105Plus a)) (Is b To (Nat105Plus b)))
nat105 =
    I.nat105


{-| The exact `Nat` 106.
-}
nat106 : Nat (N Nat106 (Nat106Plus orMore) (Is a To (Nat106Plus a)) (Is b To (Nat106Plus b)))
nat106 =
    I.nat106


{-| The exact `Nat` 107.
-}
nat107 : Nat (N Nat107 (Nat107Plus orMore) (Is a To (Nat107Plus a)) (Is b To (Nat107Plus b)))
nat107 =
    I.nat107


{-| The exact `Nat` 108.
-}
nat108 : Nat (N Nat108 (Nat108Plus orMore) (Is a To (Nat108Plus a)) (Is b To (Nat108Plus b)))
nat108 =
    I.nat108


{-| The exact `Nat` 109.
-}
nat109 : Nat (N Nat109 (Nat109Plus orMore) (Is a To (Nat109Plus a)) (Is b To (Nat109Plus b)))
nat109 =
    I.nat109


{-| The exact `Nat` 110.
-}
nat110 : Nat (N Nat110 (Nat110Plus orMore) (Is a To (Nat110Plus a)) (Is b To (Nat110Plus b)))
nat110 =
    I.nat110


{-| The exact `Nat` 111.
-}
nat111 : Nat (N Nat111 (Nat111Plus orMore) (Is a To (Nat111Plus a)) (Is b To (Nat111Plus b)))
nat111 =
    I.nat111


{-| The exact `Nat` 112.
-}
nat112 : Nat (N Nat112 (Nat112Plus orMore) (Is a To (Nat112Plus a)) (Is b To (Nat112Plus b)))
nat112 =
    I.nat112


{-| The exact `Nat` 113.
-}
nat113 : Nat (N Nat113 (Nat113Plus orMore) (Is a To (Nat113Plus a)) (Is b To (Nat113Plus b)))
nat113 =
    I.nat113


{-| The exact `Nat` 114.
-}
nat114 : Nat (N Nat114 (Nat114Plus orMore) (Is a To (Nat114Plus a)) (Is b To (Nat114Plus b)))
nat114 =
    I.nat114


{-| The exact `Nat` 115.
-}
nat115 : Nat (N Nat115 (Nat115Plus orMore) (Is a To (Nat115Plus a)) (Is b To (Nat115Plus b)))
nat115 =
    I.nat115


{-| The exact `Nat` 116.
-}
nat116 : Nat (N Nat116 (Nat116Plus orMore) (Is a To (Nat116Plus a)) (Is b To (Nat116Plus b)))
nat116 =
    I.nat116


{-| The exact `Nat` 117.
-}
nat117 : Nat (N Nat117 (Nat117Plus orMore) (Is a To (Nat117Plus a)) (Is b To (Nat117Plus b)))
nat117 =
    I.nat117


{-| The exact `Nat` 118.
-}
nat118 : Nat (N Nat118 (Nat118Plus orMore) (Is a To (Nat118Plus a)) (Is b To (Nat118Plus b)))
nat118 =
    I.nat118


{-| The exact `Nat` 119.
-}
nat119 : Nat (N Nat119 (Nat119Plus orMore) (Is a To (Nat119Plus a)) (Is b To (Nat119Plus b)))
nat119 =
    I.nat119


{-| The exact `Nat` 120.
-}
nat120 : Nat (N Nat120 (Nat120Plus orMore) (Is a To (Nat120Plus a)) (Is b To (Nat120Plus b)))
nat120 =
    I.nat120


{-| The exact `Nat` 121.
-}
nat121 : Nat (N Nat121 (Nat121Plus orMore) (Is a To (Nat121Plus a)) (Is b To (Nat121Plus b)))
nat121 =
    I.nat121


{-| The exact `Nat` 122.
-}
nat122 : Nat (N Nat122 (Nat122Plus orMore) (Is a To (Nat122Plus a)) (Is b To (Nat122Plus b)))
nat122 =
    I.nat122


{-| The exact `Nat` 123.
-}
nat123 : Nat (N Nat123 (Nat123Plus orMore) (Is a To (Nat123Plus a)) (Is b To (Nat123Plus b)))
nat123 =
    I.nat123


{-| The exact `Nat` 124.
-}
nat124 : Nat (N Nat124 (Nat124Plus orMore) (Is a To (Nat124Plus a)) (Is b To (Nat124Plus b)))
nat124 =
    I.nat124


{-| The exact `Nat` 125.
-}
nat125 : Nat (N Nat125 (Nat125Plus orMore) (Is a To (Nat125Plus a)) (Is b To (Nat125Plus b)))
nat125 =
    I.nat125


{-| The exact `Nat` 126.
-}
nat126 : Nat (N Nat126 (Nat126Plus orMore) (Is a To (Nat126Plus a)) (Is b To (Nat126Plus b)))
nat126 =
    I.nat126


{-| The exact `Nat` 127.
-}
nat127 : Nat (N Nat127 (Nat127Plus orMore) (Is a To (Nat127Plus a)) (Is b To (Nat127Plus b)))
nat127 =
    I.nat127


{-| The exact `Nat` 128.
-}
nat128 : Nat (N Nat128 (Nat128Plus orMore) (Is a To (Nat128Plus a)) (Is b To (Nat128Plus b)))
nat128 =
    I.nat128


{-| The exact `Nat` 129.
-}
nat129 : Nat (N Nat129 (Nat129Plus orMore) (Is a To (Nat129Plus a)) (Is b To (Nat129Plus b)))
nat129 =
    I.nat129


{-| The exact `Nat` 130.
-}
nat130 : Nat (N Nat130 (Nat130Plus orMore) (Is a To (Nat130Plus a)) (Is b To (Nat130Plus b)))
nat130 =
    I.nat130


{-| The exact `Nat` 131.
-}
nat131 : Nat (N Nat131 (Nat131Plus orMore) (Is a To (Nat131Plus a)) (Is b To (Nat131Plus b)))
nat131 =
    I.nat131


{-| The exact `Nat` 132.
-}
nat132 : Nat (N Nat132 (Nat132Plus orMore) (Is a To (Nat132Plus a)) (Is b To (Nat132Plus b)))
nat132 =
    I.nat132


{-| The exact `Nat` 133.
-}
nat133 : Nat (N Nat133 (Nat133Plus orMore) (Is a To (Nat133Plus a)) (Is b To (Nat133Plus b)))
nat133 =
    I.nat133


{-| The exact `Nat` 134.
-}
nat134 : Nat (N Nat134 (Nat134Plus orMore) (Is a To (Nat134Plus a)) (Is b To (Nat134Plus b)))
nat134 =
    I.nat134


{-| The exact `Nat` 135.
-}
nat135 : Nat (N Nat135 (Nat135Plus orMore) (Is a To (Nat135Plus a)) (Is b To (Nat135Plus b)))
nat135 =
    I.nat135


{-| The exact `Nat` 136.
-}
nat136 : Nat (N Nat136 (Nat136Plus orMore) (Is a To (Nat136Plus a)) (Is b To (Nat136Plus b)))
nat136 =
    I.nat136


{-| The exact `Nat` 137.
-}
nat137 : Nat (N Nat137 (Nat137Plus orMore) (Is a To (Nat137Plus a)) (Is b To (Nat137Plus b)))
nat137 =
    I.nat137


{-| The exact `Nat` 138.
-}
nat138 : Nat (N Nat138 (Nat138Plus orMore) (Is a To (Nat138Plus a)) (Is b To (Nat138Plus b)))
nat138 =
    I.nat138


{-| The exact `Nat` 139.
-}
nat139 : Nat (N Nat139 (Nat139Plus orMore) (Is a To (Nat139Plus a)) (Is b To (Nat139Plus b)))
nat139 =
    I.nat139


{-| The exact `Nat` 140.
-}
nat140 : Nat (N Nat140 (Nat140Plus orMore) (Is a To (Nat140Plus a)) (Is b To (Nat140Plus b)))
nat140 =
    I.nat140


{-| The exact `Nat` 141.
-}
nat141 : Nat (N Nat141 (Nat141Plus orMore) (Is a To (Nat141Plus a)) (Is b To (Nat141Plus b)))
nat141 =
    I.nat141


{-| The exact `Nat` 142.
-}
nat142 : Nat (N Nat142 (Nat142Plus orMore) (Is a To (Nat142Plus a)) (Is b To (Nat142Plus b)))
nat142 =
    I.nat142


{-| The exact `Nat` 143.
-}
nat143 : Nat (N Nat143 (Nat143Plus orMore) (Is a To (Nat143Plus a)) (Is b To (Nat143Plus b)))
nat143 =
    I.nat143


{-| The exact `Nat` 144.
-}
nat144 : Nat (N Nat144 (Nat144Plus orMore) (Is a To (Nat144Plus a)) (Is b To (Nat144Plus b)))
nat144 =
    I.nat144


{-| The exact `Nat` 145.
-}
nat145 : Nat (N Nat145 (Nat145Plus orMore) (Is a To (Nat145Plus a)) (Is b To (Nat145Plus b)))
nat145 =
    I.nat145


{-| The exact `Nat` 146.
-}
nat146 : Nat (N Nat146 (Nat146Plus orMore) (Is a To (Nat146Plus a)) (Is b To (Nat146Plus b)))
nat146 =
    I.nat146


{-| The exact `Nat` 147.
-}
nat147 : Nat (N Nat147 (Nat147Plus orMore) (Is a To (Nat147Plus a)) (Is b To (Nat147Plus b)))
nat147 =
    I.nat147


{-| The exact `Nat` 148.
-}
nat148 : Nat (N Nat148 (Nat148Plus orMore) (Is a To (Nat148Plus a)) (Is b To (Nat148Plus b)))
nat148 =
    I.nat148


{-| The exact `Nat` 149.
-}
nat149 : Nat (N Nat149 (Nat149Plus orMore) (Is a To (Nat149Plus a)) (Is b To (Nat149Plus b)))
nat149 =
    I.nat149


{-| The exact `Nat` 150.
-}
nat150 : Nat (N Nat150 (Nat150Plus orMore) (Is a To (Nat150Plus a)) (Is b To (Nat150Plus b)))
nat150 =
    I.nat150


{-| The exact `Nat` 151.
-}
nat151 : Nat (N Nat151 (Nat151Plus orMore) (Is a To (Nat151Plus a)) (Is b To (Nat151Plus b)))
nat151 =
    I.nat151


{-| The exact `Nat` 152.
-}
nat152 : Nat (N Nat152 (Nat152Plus orMore) (Is a To (Nat152Plus a)) (Is b To (Nat152Plus b)))
nat152 =
    I.nat152


{-| The exact `Nat` 153.
-}
nat153 : Nat (N Nat153 (Nat153Plus orMore) (Is a To (Nat153Plus a)) (Is b To (Nat153Plus b)))
nat153 =
    I.nat153


{-| The exact `Nat` 154.
-}
nat154 : Nat (N Nat154 (Nat154Plus orMore) (Is a To (Nat154Plus a)) (Is b To (Nat154Plus b)))
nat154 =
    I.nat154


{-| The exact `Nat` 155.
-}
nat155 : Nat (N Nat155 (Nat155Plus orMore) (Is a To (Nat155Plus a)) (Is b To (Nat155Plus b)))
nat155 =
    I.nat155


{-| The exact `Nat` 156.
-}
nat156 : Nat (N Nat156 (Nat156Plus orMore) (Is a To (Nat156Plus a)) (Is b To (Nat156Plus b)))
nat156 =
    I.nat156


{-| The exact `Nat` 157.
-}
nat157 : Nat (N Nat157 (Nat157Plus orMore) (Is a To (Nat157Plus a)) (Is b To (Nat157Plus b)))
nat157 =
    I.nat157


{-| The exact `Nat` 158.
-}
nat158 : Nat (N Nat158 (Nat158Plus orMore) (Is a To (Nat158Plus a)) (Is b To (Nat158Plus b)))
nat158 =
    I.nat158


{-| The exact `Nat` 159.
-}
nat159 : Nat (N Nat159 (Nat159Plus orMore) (Is a To (Nat159Plus a)) (Is b To (Nat159Plus b)))
nat159 =
    I.nat159


{-| The exact `Nat` 160.
-}
nat160 : Nat (N Nat160 (Nat160Plus orMore) (Is a To (Nat160Plus a)) (Is b To (Nat160Plus b)))
nat160 =
    I.nat160
