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

{-| `Nat (N Nat0 ...)` to `Nat (N 160 ...)`.

Bigger `Nat (N ...)` s start to slow down compilation, so they are avoided.

See [`Nat.Bound.N`](Nat-Bound#N), [`Nat.Bound.ValueN`](Nat-Bound#ValueN) & [`NNat`](NNat) for an explanation.

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

import N exposing (..)
import T exposing (Is, Nat(..), To, ValueN)


{-| The exact `Nat` 0.
-}
nat0 : Nat (ValueN Nat0 more (Is a To a) (Is b To b))
nat0 =
    Nat 0


{-| The exact `Nat` 1.
-}
nat1 : Nat (ValueN Nat1 (Nat1Plus more) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    Nat 1


{-| The exact `Nat` 2.
-}
nat2 : Nat (ValueN Nat2 (Nat2Plus more) (Is a To (Nat2Plus a)) (Is b To (Nat2Plus b)))
nat2 =
    Nat 2


{-| The exact `Nat` 3.
-}
nat3 : Nat (ValueN Nat3 (Nat3Plus more) (Is a To (Nat3Plus a)) (Is b To (Nat3Plus b)))
nat3 =
    Nat 3


{-| The exact `Nat` 4.
-}
nat4 : Nat (ValueN Nat4 (Nat4Plus more) (Is a To (Nat4Plus a)) (Is b To (Nat4Plus b)))
nat4 =
    Nat 4


{-| The exact `Nat` 5.
-}
nat5 : Nat (ValueN Nat5 (Nat5Plus more) (Is a To (Nat5Plus a)) (Is b To (Nat5Plus b)))
nat5 =
    Nat 5


{-| The exact `Nat` 6.
-}
nat6 : Nat (ValueN Nat6 (Nat6Plus more) (Is a To (Nat6Plus a)) (Is b To (Nat6Plus b)))
nat6 =
    Nat 6


{-| The exact `Nat` 7.
-}
nat7 : Nat (ValueN Nat7 (Nat7Plus more) (Is a To (Nat7Plus a)) (Is b To (Nat7Plus b)))
nat7 =
    Nat 7


{-| The exact `Nat` 8.
-}
nat8 : Nat (ValueN Nat8 (Nat8Plus more) (Is a To (Nat8Plus a)) (Is b To (Nat8Plus b)))
nat8 =
    Nat 8


{-| The exact `Nat` 9.
-}
nat9 : Nat (ValueN Nat9 (Nat9Plus more) (Is a To (Nat9Plus a)) (Is b To (Nat9Plus b)))
nat9 =
    Nat 9


{-| The exact `Nat` 10.
-}
nat10 : Nat (ValueN Nat10 (Nat10Plus more) (Is a To (Nat10Plus a)) (Is b To (Nat10Plus b)))
nat10 =
    Nat 10


{-| The exact `Nat` 11.
-}
nat11 : Nat (ValueN Nat11 (Nat11Plus more) (Is a To (Nat11Plus a)) (Is b To (Nat11Plus b)))
nat11 =
    Nat 11


{-| The exact `Nat` 12.
-}
nat12 : Nat (ValueN Nat12 (Nat12Plus more) (Is a To (Nat12Plus a)) (Is b To (Nat12Plus b)))
nat12 =
    Nat 12


{-| The exact `Nat` 13.
-}
nat13 : Nat (ValueN Nat13 (Nat13Plus more) (Is a To (Nat13Plus a)) (Is b To (Nat13Plus b)))
nat13 =
    Nat 13


{-| The exact `Nat` 14.
-}
nat14 : Nat (ValueN Nat14 (Nat14Plus more) (Is a To (Nat14Plus a)) (Is b To (Nat14Plus b)))
nat14 =
    Nat 14


{-| The exact `Nat` 15.
-}
nat15 : Nat (ValueN Nat15 (Nat15Plus more) (Is a To (Nat15Plus a)) (Is b To (Nat15Plus b)))
nat15 =
    Nat 15


{-| The exact `Nat` 16.
-}
nat16 : Nat (ValueN Nat16 (Nat16Plus more) (Is a To (Nat16Plus a)) (Is b To (Nat16Plus b)))
nat16 =
    Nat 16


{-| The exact `Nat` 17.
-}
nat17 : Nat (ValueN Nat17 (Nat17Plus more) (Is a To (Nat17Plus a)) (Is b To (Nat17Plus b)))
nat17 =
    Nat 17


{-| The exact `Nat` 18.
-}
nat18 : Nat (ValueN Nat18 (Nat18Plus more) (Is a To (Nat18Plus a)) (Is b To (Nat18Plus b)))
nat18 =
    Nat 18


{-| The exact `Nat` 19.
-}
nat19 : Nat (ValueN Nat19 (Nat19Plus more) (Is a To (Nat19Plus a)) (Is b To (Nat19Plus b)))
nat19 =
    Nat 19


{-| The exact `Nat` 20.
-}
nat20 : Nat (ValueN Nat20 (Nat20Plus more) (Is a To (Nat20Plus a)) (Is b To (Nat20Plus b)))
nat20 =
    Nat 20


{-| The exact `Nat` 21.
-}
nat21 : Nat (ValueN Nat21 (Nat21Plus more) (Is a To (Nat21Plus a)) (Is b To (Nat21Plus b)))
nat21 =
    Nat 21


{-| The exact `Nat` 22.
-}
nat22 : Nat (ValueN Nat22 (Nat22Plus more) (Is a To (Nat22Plus a)) (Is b To (Nat22Plus b)))
nat22 =
    Nat 22


{-| The exact `Nat` 23.
-}
nat23 : Nat (ValueN Nat23 (Nat23Plus more) (Is a To (Nat23Plus a)) (Is b To (Nat23Plus b)))
nat23 =
    Nat 23


{-| The exact `Nat` 24.
-}
nat24 : Nat (ValueN Nat24 (Nat24Plus more) (Is a To (Nat24Plus a)) (Is b To (Nat24Plus b)))
nat24 =
    Nat 24


{-| The exact `Nat` 25.
-}
nat25 : Nat (ValueN Nat25 (Nat25Plus more) (Is a To (Nat25Plus a)) (Is b To (Nat25Plus b)))
nat25 =
    Nat 25


{-| The exact `Nat` 26.
-}
nat26 : Nat (ValueN Nat26 (Nat26Plus more) (Is a To (Nat26Plus a)) (Is b To (Nat26Plus b)))
nat26 =
    Nat 26


{-| The exact `Nat` 27.
-}
nat27 : Nat (ValueN Nat27 (Nat27Plus more) (Is a To (Nat27Plus a)) (Is b To (Nat27Plus b)))
nat27 =
    Nat 27


{-| The exact `Nat` 28.
-}
nat28 : Nat (ValueN Nat28 (Nat28Plus more) (Is a To (Nat28Plus a)) (Is b To (Nat28Plus b)))
nat28 =
    Nat 28


{-| The exact `Nat` 29.
-}
nat29 : Nat (ValueN Nat29 (Nat29Plus more) (Is a To (Nat29Plus a)) (Is b To (Nat29Plus b)))
nat29 =
    Nat 29


{-| The exact `Nat` 30.
-}
nat30 : Nat (ValueN Nat30 (Nat30Plus more) (Is a To (Nat30Plus a)) (Is b To (Nat30Plus b)))
nat30 =
    Nat 30


{-| The exact `Nat` 31.
-}
nat31 : Nat (ValueN Nat31 (Nat31Plus more) (Is a To (Nat31Plus a)) (Is b To (Nat31Plus b)))
nat31 =
    Nat 31


{-| The exact `Nat` 32.
-}
nat32 : Nat (ValueN Nat32 (Nat32Plus more) (Is a To (Nat32Plus a)) (Is b To (Nat32Plus b)))
nat32 =
    Nat 32


{-| The exact `Nat` 33.
-}
nat33 : Nat (ValueN Nat33 (Nat33Plus more) (Is a To (Nat33Plus a)) (Is b To (Nat33Plus b)))
nat33 =
    Nat 33


{-| The exact `Nat` 34.
-}
nat34 : Nat (ValueN Nat34 (Nat34Plus more) (Is a To (Nat34Plus a)) (Is b To (Nat34Plus b)))
nat34 =
    Nat 34


{-| The exact `Nat` 35.
-}
nat35 : Nat (ValueN Nat35 (Nat35Plus more) (Is a To (Nat35Plus a)) (Is b To (Nat35Plus b)))
nat35 =
    Nat 35


{-| The exact `Nat` 36.
-}
nat36 : Nat (ValueN Nat36 (Nat36Plus more) (Is a To (Nat36Plus a)) (Is b To (Nat36Plus b)))
nat36 =
    Nat 36


{-| The exact `Nat` 37.
-}
nat37 : Nat (ValueN Nat37 (Nat37Plus more) (Is a To (Nat37Plus a)) (Is b To (Nat37Plus b)))
nat37 =
    Nat 37


{-| The exact `Nat` 38.
-}
nat38 : Nat (ValueN Nat38 (Nat38Plus more) (Is a To (Nat38Plus a)) (Is b To (Nat38Plus b)))
nat38 =
    Nat 38


{-| The exact `Nat` 39.
-}
nat39 : Nat (ValueN Nat39 (Nat39Plus more) (Is a To (Nat39Plus a)) (Is b To (Nat39Plus b)))
nat39 =
    Nat 39


{-| The exact `Nat` 40.
-}
nat40 : Nat (ValueN Nat40 (Nat40Plus more) (Is a To (Nat40Plus a)) (Is b To (Nat40Plus b)))
nat40 =
    Nat 40


{-| The exact `Nat` 41.
-}
nat41 : Nat (ValueN Nat41 (Nat41Plus more) (Is a To (Nat41Plus a)) (Is b To (Nat41Plus b)))
nat41 =
    Nat 41


{-| The exact `Nat` 42.
-}
nat42 : Nat (ValueN Nat42 (Nat42Plus more) (Is a To (Nat42Plus a)) (Is b To (Nat42Plus b)))
nat42 =
    Nat 42


{-| The exact `Nat` 43.
-}
nat43 : Nat (ValueN Nat43 (Nat43Plus more) (Is a To (Nat43Plus a)) (Is b To (Nat43Plus b)))
nat43 =
    Nat 43


{-| The exact `Nat` 44.
-}
nat44 : Nat (ValueN Nat44 (Nat44Plus more) (Is a To (Nat44Plus a)) (Is b To (Nat44Plus b)))
nat44 =
    Nat 44


{-| The exact `Nat` 45.
-}
nat45 : Nat (ValueN Nat45 (Nat45Plus more) (Is a To (Nat45Plus a)) (Is b To (Nat45Plus b)))
nat45 =
    Nat 45


{-| The exact `Nat` 46.
-}
nat46 : Nat (ValueN Nat46 (Nat46Plus more) (Is a To (Nat46Plus a)) (Is b To (Nat46Plus b)))
nat46 =
    Nat 46


{-| The exact `Nat` 47.
-}
nat47 : Nat (ValueN Nat47 (Nat47Plus more) (Is a To (Nat47Plus a)) (Is b To (Nat47Plus b)))
nat47 =
    Nat 47


{-| The exact `Nat` 48.
-}
nat48 : Nat (ValueN Nat48 (Nat48Plus more) (Is a To (Nat48Plus a)) (Is b To (Nat48Plus b)))
nat48 =
    Nat 48


{-| The exact `Nat` 49.
-}
nat49 : Nat (ValueN Nat49 (Nat49Plus more) (Is a To (Nat49Plus a)) (Is b To (Nat49Plus b)))
nat49 =
    Nat 49


{-| The exact `Nat` 50.
-}
nat50 : Nat (ValueN Nat50 (Nat50Plus more) (Is a To (Nat50Plus a)) (Is b To (Nat50Plus b)))
nat50 =
    Nat 50


{-| The exact `Nat` 51.
-}
nat51 : Nat (ValueN Nat51 (Nat51Plus more) (Is a To (Nat51Plus a)) (Is b To (Nat51Plus b)))
nat51 =
    Nat 51


{-| The exact `Nat` 52.
-}
nat52 : Nat (ValueN Nat52 (Nat52Plus more) (Is a To (Nat52Plus a)) (Is b To (Nat52Plus b)))
nat52 =
    Nat 52


{-| The exact `Nat` 53.
-}
nat53 : Nat (ValueN Nat53 (Nat53Plus more) (Is a To (Nat53Plus a)) (Is b To (Nat53Plus b)))
nat53 =
    Nat 53


{-| The exact `Nat` 54.
-}
nat54 : Nat (ValueN Nat54 (Nat54Plus more) (Is a To (Nat54Plus a)) (Is b To (Nat54Plus b)))
nat54 =
    Nat 54


{-| The exact `Nat` 55.
-}
nat55 : Nat (ValueN Nat55 (Nat55Plus more) (Is a To (Nat55Plus a)) (Is b To (Nat55Plus b)))
nat55 =
    Nat 55


{-| The exact `Nat` 56.
-}
nat56 : Nat (ValueN Nat56 (Nat56Plus more) (Is a To (Nat56Plus a)) (Is b To (Nat56Plus b)))
nat56 =
    Nat 56


{-| The exact `Nat` 57.
-}
nat57 : Nat (ValueN Nat57 (Nat57Plus more) (Is a To (Nat57Plus a)) (Is b To (Nat57Plus b)))
nat57 =
    Nat 57


{-| The exact `Nat` 58.
-}
nat58 : Nat (ValueN Nat58 (Nat58Plus more) (Is a To (Nat58Plus a)) (Is b To (Nat58Plus b)))
nat58 =
    Nat 58


{-| The exact `Nat` 59.
-}
nat59 : Nat (ValueN Nat59 (Nat59Plus more) (Is a To (Nat59Plus a)) (Is b To (Nat59Plus b)))
nat59 =
    Nat 59


{-| The exact `Nat` 60.
-}
nat60 : Nat (ValueN Nat60 (Nat60Plus more) (Is a To (Nat60Plus a)) (Is b To (Nat60Plus b)))
nat60 =
    Nat 60


{-| The exact `Nat` 61.
-}
nat61 : Nat (ValueN Nat61 (Nat61Plus more) (Is a To (Nat61Plus a)) (Is b To (Nat61Plus b)))
nat61 =
    Nat 61


{-| The exact `Nat` 62.
-}
nat62 : Nat (ValueN Nat62 (Nat62Plus more) (Is a To (Nat62Plus a)) (Is b To (Nat62Plus b)))
nat62 =
    Nat 62


{-| The exact `Nat` 63.
-}
nat63 : Nat (ValueN Nat63 (Nat63Plus more) (Is a To (Nat63Plus a)) (Is b To (Nat63Plus b)))
nat63 =
    Nat 63


{-| The exact `Nat` 64.
-}
nat64 : Nat (ValueN Nat64 (Nat64Plus more) (Is a To (Nat64Plus a)) (Is b To (Nat64Plus b)))
nat64 =
    Nat 64


{-| The exact `Nat` 65.
-}
nat65 : Nat (ValueN Nat65 (Nat65Plus more) (Is a To (Nat65Plus a)) (Is b To (Nat65Plus b)))
nat65 =
    Nat 65


{-| The exact `Nat` 66.
-}
nat66 : Nat (ValueN Nat66 (Nat66Plus more) (Is a To (Nat66Plus a)) (Is b To (Nat66Plus b)))
nat66 =
    Nat 66


{-| The exact `Nat` 67.
-}
nat67 : Nat (ValueN Nat67 (Nat67Plus more) (Is a To (Nat67Plus a)) (Is b To (Nat67Plus b)))
nat67 =
    Nat 67


{-| The exact `Nat` 68.
-}
nat68 : Nat (ValueN Nat68 (Nat68Plus more) (Is a To (Nat68Plus a)) (Is b To (Nat68Plus b)))
nat68 =
    Nat 68


{-| The exact `Nat` 69.
-}
nat69 : Nat (ValueN Nat69 (Nat69Plus more) (Is a To (Nat69Plus a)) (Is b To (Nat69Plus b)))
nat69 =
    Nat 69


{-| The exact `Nat` 70.
-}
nat70 : Nat (ValueN Nat70 (Nat70Plus more) (Is a To (Nat70Plus a)) (Is b To (Nat70Plus b)))
nat70 =
    Nat 70


{-| The exact `Nat` 71.
-}
nat71 : Nat (ValueN Nat71 (Nat71Plus more) (Is a To (Nat71Plus a)) (Is b To (Nat71Plus b)))
nat71 =
    Nat 71


{-| The exact `Nat` 72.
-}
nat72 : Nat (ValueN Nat72 (Nat72Plus more) (Is a To (Nat72Plus a)) (Is b To (Nat72Plus b)))
nat72 =
    Nat 72


{-| The exact `Nat` 73.
-}
nat73 : Nat (ValueN Nat73 (Nat73Plus more) (Is a To (Nat73Plus a)) (Is b To (Nat73Plus b)))
nat73 =
    Nat 73


{-| The exact `Nat` 74.
-}
nat74 : Nat (ValueN Nat74 (Nat74Plus more) (Is a To (Nat74Plus a)) (Is b To (Nat74Plus b)))
nat74 =
    Nat 74


{-| The exact `Nat` 75.
-}
nat75 : Nat (ValueN Nat75 (Nat75Plus more) (Is a To (Nat75Plus a)) (Is b To (Nat75Plus b)))
nat75 =
    Nat 75


{-| The exact `Nat` 76.
-}
nat76 : Nat (ValueN Nat76 (Nat76Plus more) (Is a To (Nat76Plus a)) (Is b To (Nat76Plus b)))
nat76 =
    Nat 76


{-| The exact `Nat` 77.
-}
nat77 : Nat (ValueN Nat77 (Nat77Plus more) (Is a To (Nat77Plus a)) (Is b To (Nat77Plus b)))
nat77 =
    Nat 77


{-| The exact `Nat` 78.
-}
nat78 : Nat (ValueN Nat78 (Nat78Plus more) (Is a To (Nat78Plus a)) (Is b To (Nat78Plus b)))
nat78 =
    Nat 78


{-| The exact `Nat` 79.
-}
nat79 : Nat (ValueN Nat79 (Nat79Plus more) (Is a To (Nat79Plus a)) (Is b To (Nat79Plus b)))
nat79 =
    Nat 79


{-| The exact `Nat` 80.
-}
nat80 : Nat (ValueN Nat80 (Nat80Plus more) (Is a To (Nat80Plus a)) (Is b To (Nat80Plus b)))
nat80 =
    Nat 80


{-| The exact `Nat` 81.
-}
nat81 : Nat (ValueN Nat81 (Nat81Plus more) (Is a To (Nat81Plus a)) (Is b To (Nat81Plus b)))
nat81 =
    Nat 81


{-| The exact `Nat` 82.
-}
nat82 : Nat (ValueN Nat82 (Nat82Plus more) (Is a To (Nat82Plus a)) (Is b To (Nat82Plus b)))
nat82 =
    Nat 82


{-| The exact `Nat` 83.
-}
nat83 : Nat (ValueN Nat83 (Nat83Plus more) (Is a To (Nat83Plus a)) (Is b To (Nat83Plus b)))
nat83 =
    Nat 83


{-| The exact `Nat` 84.
-}
nat84 : Nat (ValueN Nat84 (Nat84Plus more) (Is a To (Nat84Plus a)) (Is b To (Nat84Plus b)))
nat84 =
    Nat 84


{-| The exact `Nat` 85.
-}
nat85 : Nat (ValueN Nat85 (Nat85Plus more) (Is a To (Nat85Plus a)) (Is b To (Nat85Plus b)))
nat85 =
    Nat 85


{-| The exact `Nat` 86.
-}
nat86 : Nat (ValueN Nat86 (Nat86Plus more) (Is a To (Nat86Plus a)) (Is b To (Nat86Plus b)))
nat86 =
    Nat 86


{-| The exact `Nat` 87.
-}
nat87 : Nat (ValueN Nat87 (Nat87Plus more) (Is a To (Nat87Plus a)) (Is b To (Nat87Plus b)))
nat87 =
    Nat 87


{-| The exact `Nat` 88.
-}
nat88 : Nat (ValueN Nat88 (Nat88Plus more) (Is a To (Nat88Plus a)) (Is b To (Nat88Plus b)))
nat88 =
    Nat 88


{-| The exact `Nat` 89.
-}
nat89 : Nat (ValueN Nat89 (Nat89Plus more) (Is a To (Nat89Plus a)) (Is b To (Nat89Plus b)))
nat89 =
    Nat 89


{-| The exact `Nat` 90.
-}
nat90 : Nat (ValueN Nat90 (Nat90Plus more) (Is a To (Nat90Plus a)) (Is b To (Nat90Plus b)))
nat90 =
    Nat 90


{-| The exact `Nat` 91.
-}
nat91 : Nat (ValueN Nat91 (Nat91Plus more) (Is a To (Nat91Plus a)) (Is b To (Nat91Plus b)))
nat91 =
    Nat 91


{-| The exact `Nat` 92.
-}
nat92 : Nat (ValueN Nat92 (Nat92Plus more) (Is a To (Nat92Plus a)) (Is b To (Nat92Plus b)))
nat92 =
    Nat 92


{-| The exact `Nat` 93.
-}
nat93 : Nat (ValueN Nat93 (Nat93Plus more) (Is a To (Nat93Plus a)) (Is b To (Nat93Plus b)))
nat93 =
    Nat 93


{-| The exact `Nat` 94.
-}
nat94 : Nat (ValueN Nat94 (Nat94Plus more) (Is a To (Nat94Plus a)) (Is b To (Nat94Plus b)))
nat94 =
    Nat 94


{-| The exact `Nat` 95.
-}
nat95 : Nat (ValueN Nat95 (Nat95Plus more) (Is a To (Nat95Plus a)) (Is b To (Nat95Plus b)))
nat95 =
    Nat 95


{-| The exact `Nat` 96.
-}
nat96 : Nat (ValueN Nat96 (Nat96Plus more) (Is a To (Nat96Plus a)) (Is b To (Nat96Plus b)))
nat96 =
    Nat 96


{-| The exact `Nat` 97.
-}
nat97 : Nat (ValueN Nat97 (Nat97Plus more) (Is a To (Nat97Plus a)) (Is b To (Nat97Plus b)))
nat97 =
    Nat 97


{-| The exact `Nat` 98.
-}
nat98 : Nat (ValueN Nat98 (Nat98Plus more) (Is a To (Nat98Plus a)) (Is b To (Nat98Plus b)))
nat98 =
    Nat 98


{-| The exact `Nat` 99.
-}
nat99 : Nat (ValueN Nat99 (Nat99Plus more) (Is a To (Nat99Plus a)) (Is b To (Nat99Plus b)))
nat99 =
    Nat 99


{-| The exact `Nat` 100.
-}
nat100 : Nat (ValueN Nat100 (Nat100Plus more) (Is a To (Nat100Plus a)) (Is b To (Nat100Plus b)))
nat100 =
    Nat 100


{-| The exact `Nat` 101.
-}
nat101 : Nat (ValueN Nat101 (Nat101Plus more) (Is a To (Nat101Plus a)) (Is b To (Nat101Plus b)))
nat101 =
    Nat 101


{-| The exact `Nat` 102.
-}
nat102 : Nat (ValueN Nat102 (Nat102Plus more) (Is a To (Nat102Plus a)) (Is b To (Nat102Plus b)))
nat102 =
    Nat 102


{-| The exact `Nat` 103.
-}
nat103 : Nat (ValueN Nat103 (Nat103Plus more) (Is a To (Nat103Plus a)) (Is b To (Nat103Plus b)))
nat103 =
    Nat 103


{-| The exact `Nat` 104.
-}
nat104 : Nat (ValueN Nat104 (Nat104Plus more) (Is a To (Nat104Plus a)) (Is b To (Nat104Plus b)))
nat104 =
    Nat 104


{-| The exact `Nat` 105.
-}
nat105 : Nat (ValueN Nat105 (Nat105Plus more) (Is a To (Nat105Plus a)) (Is b To (Nat105Plus b)))
nat105 =
    Nat 105


{-| The exact `Nat` 106.
-}
nat106 : Nat (ValueN Nat106 (Nat106Plus more) (Is a To (Nat106Plus a)) (Is b To (Nat106Plus b)))
nat106 =
    Nat 106


{-| The exact `Nat` 107.
-}
nat107 : Nat (ValueN Nat107 (Nat107Plus more) (Is a To (Nat107Plus a)) (Is b To (Nat107Plus b)))
nat107 =
    Nat 107


{-| The exact `Nat` 108.
-}
nat108 : Nat (ValueN Nat108 (Nat108Plus more) (Is a To (Nat108Plus a)) (Is b To (Nat108Plus b)))
nat108 =
    Nat 108


{-| The exact `Nat` 109.
-}
nat109 : Nat (ValueN Nat109 (Nat109Plus more) (Is a To (Nat109Plus a)) (Is b To (Nat109Plus b)))
nat109 =
    Nat 109


{-| The exact `Nat` 110.
-}
nat110 : Nat (ValueN Nat110 (Nat110Plus more) (Is a To (Nat110Plus a)) (Is b To (Nat110Plus b)))
nat110 =
    Nat 110


{-| The exact `Nat` 111.
-}
nat111 : Nat (ValueN Nat111 (Nat111Plus more) (Is a To (Nat111Plus a)) (Is b To (Nat111Plus b)))
nat111 =
    Nat 111


{-| The exact `Nat` 112.
-}
nat112 : Nat (ValueN Nat112 (Nat112Plus more) (Is a To (Nat112Plus a)) (Is b To (Nat112Plus b)))
nat112 =
    Nat 112


{-| The exact `Nat` 113.
-}
nat113 : Nat (ValueN Nat113 (Nat113Plus more) (Is a To (Nat113Plus a)) (Is b To (Nat113Plus b)))
nat113 =
    Nat 113


{-| The exact `Nat` 114.
-}
nat114 : Nat (ValueN Nat114 (Nat114Plus more) (Is a To (Nat114Plus a)) (Is b To (Nat114Plus b)))
nat114 =
    Nat 114


{-| The exact `Nat` 115.
-}
nat115 : Nat (ValueN Nat115 (Nat115Plus more) (Is a To (Nat115Plus a)) (Is b To (Nat115Plus b)))
nat115 =
    Nat 115


{-| The exact `Nat` 116.
-}
nat116 : Nat (ValueN Nat116 (Nat116Plus more) (Is a To (Nat116Plus a)) (Is b To (Nat116Plus b)))
nat116 =
    Nat 116


{-| The exact `Nat` 117.
-}
nat117 : Nat (ValueN Nat117 (Nat117Plus more) (Is a To (Nat117Plus a)) (Is b To (Nat117Plus b)))
nat117 =
    Nat 117


{-| The exact `Nat` 118.
-}
nat118 : Nat (ValueN Nat118 (Nat118Plus more) (Is a To (Nat118Plus a)) (Is b To (Nat118Plus b)))
nat118 =
    Nat 118


{-| The exact `Nat` 119.
-}
nat119 : Nat (ValueN Nat119 (Nat119Plus more) (Is a To (Nat119Plus a)) (Is b To (Nat119Plus b)))
nat119 =
    Nat 119


{-| The exact `Nat` 120.
-}
nat120 : Nat (ValueN Nat120 (Nat120Plus more) (Is a To (Nat120Plus a)) (Is b To (Nat120Plus b)))
nat120 =
    Nat 120


{-| The exact `Nat` 121.
-}
nat121 : Nat (ValueN Nat121 (Nat121Plus more) (Is a To (Nat121Plus a)) (Is b To (Nat121Plus b)))
nat121 =
    Nat 121


{-| The exact `Nat` 122.
-}
nat122 : Nat (ValueN Nat122 (Nat122Plus more) (Is a To (Nat122Plus a)) (Is b To (Nat122Plus b)))
nat122 =
    Nat 122


{-| The exact `Nat` 123.
-}
nat123 : Nat (ValueN Nat123 (Nat123Plus more) (Is a To (Nat123Plus a)) (Is b To (Nat123Plus b)))
nat123 =
    Nat 123


{-| The exact `Nat` 124.
-}
nat124 : Nat (ValueN Nat124 (Nat124Plus more) (Is a To (Nat124Plus a)) (Is b To (Nat124Plus b)))
nat124 =
    Nat 124


{-| The exact `Nat` 125.
-}
nat125 : Nat (ValueN Nat125 (Nat125Plus more) (Is a To (Nat125Plus a)) (Is b To (Nat125Plus b)))
nat125 =
    Nat 125


{-| The exact `Nat` 126.
-}
nat126 : Nat (ValueN Nat126 (Nat126Plus more) (Is a To (Nat126Plus a)) (Is b To (Nat126Plus b)))
nat126 =
    Nat 126


{-| The exact `Nat` 127.
-}
nat127 : Nat (ValueN Nat127 (Nat127Plus more) (Is a To (Nat127Plus a)) (Is b To (Nat127Plus b)))
nat127 =
    Nat 127


{-| The exact `Nat` 128.
-}
nat128 : Nat (ValueN Nat128 (Nat128Plus more) (Is a To (Nat128Plus a)) (Is b To (Nat128Plus b)))
nat128 =
    Nat 128


{-| The exact `Nat` 129.
-}
nat129 : Nat (ValueN Nat129 (Nat129Plus more) (Is a To (Nat129Plus a)) (Is b To (Nat129Plus b)))
nat129 =
    Nat 129


{-| The exact `Nat` 130.
-}
nat130 : Nat (ValueN Nat130 (Nat130Plus more) (Is a To (Nat130Plus a)) (Is b To (Nat130Plus b)))
nat130 =
    Nat 130


{-| The exact `Nat` 131.
-}
nat131 : Nat (ValueN Nat131 (Nat131Plus more) (Is a To (Nat131Plus a)) (Is b To (Nat131Plus b)))
nat131 =
    Nat 131


{-| The exact `Nat` 132.
-}
nat132 : Nat (ValueN Nat132 (Nat132Plus more) (Is a To (Nat132Plus a)) (Is b To (Nat132Plus b)))
nat132 =
    Nat 132


{-| The exact `Nat` 133.
-}
nat133 : Nat (ValueN Nat133 (Nat133Plus more) (Is a To (Nat133Plus a)) (Is b To (Nat133Plus b)))
nat133 =
    Nat 133


{-| The exact `Nat` 134.
-}
nat134 : Nat (ValueN Nat134 (Nat134Plus more) (Is a To (Nat134Plus a)) (Is b To (Nat134Plus b)))
nat134 =
    Nat 134


{-| The exact `Nat` 135.
-}
nat135 : Nat (ValueN Nat135 (Nat135Plus more) (Is a To (Nat135Plus a)) (Is b To (Nat135Plus b)))
nat135 =
    Nat 135


{-| The exact `Nat` 136.
-}
nat136 : Nat (ValueN Nat136 (Nat136Plus more) (Is a To (Nat136Plus a)) (Is b To (Nat136Plus b)))
nat136 =
    Nat 136


{-| The exact `Nat` 137.
-}
nat137 : Nat (ValueN Nat137 (Nat137Plus more) (Is a To (Nat137Plus a)) (Is b To (Nat137Plus b)))
nat137 =
    Nat 137


{-| The exact `Nat` 138.
-}
nat138 : Nat (ValueN Nat138 (Nat138Plus more) (Is a To (Nat138Plus a)) (Is b To (Nat138Plus b)))
nat138 =
    Nat 138


{-| The exact `Nat` 139.
-}
nat139 : Nat (ValueN Nat139 (Nat139Plus more) (Is a To (Nat139Plus a)) (Is b To (Nat139Plus b)))
nat139 =
    Nat 139


{-| The exact `Nat` 140.
-}
nat140 : Nat (ValueN Nat140 (Nat140Plus more) (Is a To (Nat140Plus a)) (Is b To (Nat140Plus b)))
nat140 =
    Nat 140


{-| The exact `Nat` 141.
-}
nat141 : Nat (ValueN Nat141 (Nat141Plus more) (Is a To (Nat141Plus a)) (Is b To (Nat141Plus b)))
nat141 =
    Nat 141


{-| The exact `Nat` 142.
-}
nat142 : Nat (ValueN Nat142 (Nat142Plus more) (Is a To (Nat142Plus a)) (Is b To (Nat142Plus b)))
nat142 =
    Nat 142


{-| The exact `Nat` 143.
-}
nat143 : Nat (ValueN Nat143 (Nat143Plus more) (Is a To (Nat143Plus a)) (Is b To (Nat143Plus b)))
nat143 =
    Nat 143


{-| The exact `Nat` 144.
-}
nat144 : Nat (ValueN Nat144 (Nat144Plus more) (Is a To (Nat144Plus a)) (Is b To (Nat144Plus b)))
nat144 =
    Nat 144


{-| The exact `Nat` 145.
-}
nat145 : Nat (ValueN Nat145 (Nat145Plus more) (Is a To (Nat145Plus a)) (Is b To (Nat145Plus b)))
nat145 =
    Nat 145


{-| The exact `Nat` 146.
-}
nat146 : Nat (ValueN Nat146 (Nat146Plus more) (Is a To (Nat146Plus a)) (Is b To (Nat146Plus b)))
nat146 =
    Nat 146


{-| The exact `Nat` 147.
-}
nat147 : Nat (ValueN Nat147 (Nat147Plus more) (Is a To (Nat147Plus a)) (Is b To (Nat147Plus b)))
nat147 =
    Nat 147


{-| The exact `Nat` 148.
-}
nat148 : Nat (ValueN Nat148 (Nat148Plus more) (Is a To (Nat148Plus a)) (Is b To (Nat148Plus b)))
nat148 =
    Nat 148


{-| The exact `Nat` 149.
-}
nat149 : Nat (ValueN Nat149 (Nat149Plus more) (Is a To (Nat149Plus a)) (Is b To (Nat149Plus b)))
nat149 =
    Nat 149


{-| The exact `Nat` 150.
-}
nat150 : Nat (ValueN Nat150 (Nat150Plus more) (Is a To (Nat150Plus a)) (Is b To (Nat150Plus b)))
nat150 =
    Nat 150


{-| The exact `Nat` 151.
-}
nat151 : Nat (ValueN Nat151 (Nat151Plus more) (Is a To (Nat151Plus a)) (Is b To (Nat151Plus b)))
nat151 =
    Nat 151


{-| The exact `Nat` 152.
-}
nat152 : Nat (ValueN Nat152 (Nat152Plus more) (Is a To (Nat152Plus a)) (Is b To (Nat152Plus b)))
nat152 =
    Nat 152


{-| The exact `Nat` 153.
-}
nat153 : Nat (ValueN Nat153 (Nat153Plus more) (Is a To (Nat153Plus a)) (Is b To (Nat153Plus b)))
nat153 =
    Nat 153


{-| The exact `Nat` 154.
-}
nat154 : Nat (ValueN Nat154 (Nat154Plus more) (Is a To (Nat154Plus a)) (Is b To (Nat154Plus b)))
nat154 =
    Nat 154


{-| The exact `Nat` 155.
-}
nat155 : Nat (ValueN Nat155 (Nat155Plus more) (Is a To (Nat155Plus a)) (Is b To (Nat155Plus b)))
nat155 =
    Nat 155


{-| The exact `Nat` 156.
-}
nat156 : Nat (ValueN Nat156 (Nat156Plus more) (Is a To (Nat156Plus a)) (Is b To (Nat156Plus b)))
nat156 =
    Nat 156


{-| The exact `Nat` 157.
-}
nat157 : Nat (ValueN Nat157 (Nat157Plus more) (Is a To (Nat157Plus a)) (Is b To (Nat157Plus b)))
nat157 =
    Nat 157


{-| The exact `Nat` 158.
-}
nat158 : Nat (ValueN Nat158 (Nat158Plus more) (Is a To (Nat158Plus a)) (Is b To (Nat158Plus b)))
nat158 =
    Nat 158


{-| The exact `Nat` 159.
-}
nat159 : Nat (ValueN Nat159 (Nat159Plus more) (Is a To (Nat159Plus a)) (Is b To (Nat159Plus b)))
nat159 =
    Nat 159


{-| The exact `Nat` 160.
-}
nat160 : Nat (ValueN Nat160 (Nat160Plus more) (Is a To (Nat160Plus a)) (Is b To (Nat160Plus b)))
nat160 =
    Nat 160
