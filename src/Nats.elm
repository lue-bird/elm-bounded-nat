module Nats exposing
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
    , Nat100Plus, Nat101Plus, Nat102Plus, Nat103Plus, Nat104Plus, Nat105Plus
    , Nat106Plus, Nat107Plus, Nat108Plus, Nat109Plus, Nat10Plus, Nat110Plus
    , Nat111Plus, Nat112Plus, Nat113Plus, Nat114Plus, Nat115Plus, Nat116Plus
    , Nat117Plus, Nat118Plus, Nat119Plus, Nat11Plus, Nat120Plus, Nat121Plus
    , Nat122Plus, Nat123Plus, Nat124Plus, Nat125Plus, Nat126Plus, Nat127Plus
    , Nat128Plus, Nat129Plus, Nat12Plus, Nat130Plus, Nat131Plus, Nat132Plus
    , Nat133Plus, Nat134Plus, Nat135Plus, Nat136Plus, Nat137Plus, Nat138Plus
    , Nat139Plus, Nat13Plus, Nat140Plus, Nat141Plus, Nat142Plus, Nat143Plus
    , Nat144Plus, Nat145Plus, Nat146Plus, Nat147Plus, Nat148Plus, Nat149Plus
    , Nat14Plus, Nat150Plus, Nat151Plus, Nat152Plus, Nat153Plus, Nat154Plus
    , Nat155Plus, Nat156Plus, Nat157Plus, Nat158Plus, Nat159Plus, Nat15Plus
    , Nat160Plus, Nat16Plus, Nat17Plus, Nat18Plus, Nat19Plus, Nat1Plus, Nat20Plus
    , Nat21Plus, Nat22Plus, Nat23Plus, Nat24Plus, Nat25Plus, Nat26Plus, Nat27Plus
    , Nat28Plus, Nat29Plus, Nat2Plus, Nat30Plus, Nat31Plus, Nat32Plus, Nat33Plus
    , Nat34Plus, Nat35Plus, Nat36Plus, Nat37Plus, Nat38Plus, Nat39Plus, Nat3Plus
    , Nat40Plus, Nat41Plus, Nat42Plus, Nat43Plus, Nat44Plus, Nat45Plus, Nat46Plus
    , Nat47Plus, Nat48Plus, Nat49Plus, Nat4Plus, Nat50Plus, Nat51Plus, Nat52Plus
    , Nat53Plus, Nat54Plus, Nat55Plus, Nat56Plus, Nat57Plus, Nat58Plus, Nat59Plus
    , Nat5Plus, Nat60Plus, Nat61Plus, Nat62Plus, Nat63Plus, Nat64Plus, Nat65Plus
    , Nat66Plus, Nat67Plus, Nat68Plus, Nat69Plus, Nat6Plus, Nat70Plus, Nat71Plus
    , Nat72Plus, Nat73Plus, Nat74Plus, Nat75Plus, Nat76Plus, Nat77Plus, Nat78Plus
    , Nat79Plus, Nat7Plus, Nat80Plus, Nat81Plus, Nat82Plus, Nat83Plus, Nat84Plus
    , Nat85Plus, Nat86Plus, Nat87Plus, Nat88Plus, Nat89Plus, Nat8Plus, Nat90Plus
    , Nat91Plus, Nat92Plus, Nat93Plus, Nat94Plus, Nat95Plus, Nat96Plus, Nat97Plus
    , Nat98Plus, Nat99Plus, Nat9Plus
    , Nat0, Nat1, Nat10, Nat100, Nat101, Nat102, Nat103, Nat104, Nat105, Nat106, Nat107
    , Nat108, Nat109, Nat11, Nat110, Nat111, Nat112, Nat113, Nat114, Nat115, Nat116
    , Nat117, Nat118, Nat119, Nat12, Nat120, Nat121, Nat122, Nat123, Nat124, Nat125
    , Nat126, Nat127, Nat128, Nat129, Nat13, Nat130, Nat131, Nat132, Nat133, Nat134
    , Nat135, Nat136, Nat137, Nat138, Nat139, Nat14, Nat140, Nat141, Nat142, Nat143
    , Nat144, Nat145, Nat146, Nat147, Nat148, Nat149, Nat15, Nat150, Nat151, Nat152
    , Nat153, Nat154, Nat155, Nat156, Nat157, Nat158, Nat159, Nat16, Nat160, Nat17, Nat18
    , Nat19, Nat2, Nat20, Nat21, Nat22, Nat23, Nat24, Nat25, Nat26, Nat27, Nat28, Nat29, Nat3
    , Nat30, Nat31, Nat32, Nat33, Nat34, Nat35, Nat36, Nat37, Nat38, Nat39, Nat4, Nat40, Nat41
    , Nat42, Nat43, Nat44, Nat45, Nat46, Nat47, Nat48, Nat49, Nat5, Nat50, Nat51, Nat52, Nat53
    , Nat54, Nat55, Nat56, Nat57, Nat58, Nat59, Nat6, Nat60, Nat61, Nat62, Nat63, Nat64, Nat65
    , Nat66, Nat67, Nat68, Nat69, Nat7, Nat70, Nat71, Nat72, Nat73, Nat74, Nat75, Nat76, Nat77
    , Nat78, Nat79, Nat8, Nat80, Nat81, Nat82, Nat83, Nat84, Nat85, Nat86, Nat87, Nat88, Nat89
    , Nat9, Nat90, Nat91, Nat92, Nat93, Nat94, Nat95, Nat96, Nat97, Nat98, Nat99
    )

{-|


## [numbers](#numbers)

`nat0 : Nat (N Nat0 ...)` to `nat160 : Nat (N Nat160 ...)`.

See [`Nat.N`](Nat#N), [`Nat.N`](Nat#N) & [`NNat`](NNat) for an explanation.

##[types](#types)

Express exact natural numbers in a type.

    onlyExact1 : Nat (Only Nat1) -> Cake

  - `takesOnlyExact1 nat10` is a compile-time error

```
add2 : Nat (Only n) -> Nat (Only (Nat2Plus n))
```

  - `add2 nat2` is of type `Nat (Only Nat4)`


## limits

If type aliases expand too much

    big : Nat (Only (Nat160Plus (Nat160Plus (Nat160Plus Nat160))))

  - compilation is a bit slower (but following compilations are fast again)

  - (`elm-stuff` can corrupt)

  - **tools that analyse the types are slow**


# numbers

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


# types


## plus n

@docs Nat100Plus, Nat101Plus, Nat102Plus, Nat103Plus, Nat104Plus, Nat105Plus
@docs Nat106Plus, Nat107Plus, Nat108Plus, Nat109Plus, Nat10Plus, Nat110Plus
@docs Nat111Plus, Nat112Plus, Nat113Plus, Nat114Plus, Nat115Plus, Nat116Plus
@docs Nat117Plus, Nat118Plus, Nat119Plus, Nat11Plus, Nat120Plus, Nat121Plus
@docs Nat122Plus, Nat123Plus, Nat124Plus, Nat125Plus, Nat126Plus, Nat127Plus
@docs Nat128Plus, Nat129Plus, Nat12Plus, Nat130Plus, Nat131Plus, Nat132Plus
@docs Nat133Plus, Nat134Plus, Nat135Plus, Nat136Plus, Nat137Plus, Nat138Plus
@docs Nat139Plus, Nat13Plus, Nat140Plus, Nat141Plus, Nat142Plus, Nat143Plus
@docs Nat144Plus, Nat145Plus, Nat146Plus, Nat147Plus, Nat148Plus, Nat149Plus
@docs Nat14Plus, Nat150Plus, Nat151Plus, Nat152Plus, Nat153Plus, Nat154Plus
@docs Nat155Plus, Nat156Plus, Nat157Plus, Nat158Plus, Nat159Plus, Nat15Plus
@docs Nat160Plus, Nat16Plus, Nat17Plus, Nat18Plus, Nat19Plus, Nat1Plus, Nat20Plus
@docs Nat21Plus, Nat22Plus, Nat23Plus, Nat24Plus, Nat25Plus, Nat26Plus, Nat27Plus
@docs Nat28Plus, Nat29Plus, Nat2Plus, Nat30Plus, Nat31Plus, Nat32Plus, Nat33Plus
@docs Nat34Plus, Nat35Plus, Nat36Plus, Nat37Plus, Nat38Plus, Nat39Plus, Nat3Plus
@docs Nat40Plus, Nat41Plus, Nat42Plus, Nat43Plus, Nat44Plus, Nat45Plus, Nat46Plus
@docs Nat47Plus, Nat48Plus, Nat49Plus, Nat4Plus, Nat50Plus, Nat51Plus, Nat52Plus
@docs Nat53Plus, Nat54Plus, Nat55Plus, Nat56Plus, Nat57Plus, Nat58Plus, Nat59Plus
@docs Nat5Plus, Nat60Plus, Nat61Plus, Nat62Plus, Nat63Plus, Nat64Plus, Nat65Plus
@docs Nat66Plus, Nat67Plus, Nat68Plus, Nat69Plus, Nat6Plus, Nat70Plus, Nat71Plus
@docs Nat72Plus, Nat73Plus, Nat74Plus, Nat75Plus, Nat76Plus, Nat77Plus, Nat78Plus
@docs Nat79Plus, Nat7Plus, Nat80Plus, Nat81Plus, Nat82Plus, Nat83Plus, Nat84Plus
@docs Nat85Plus, Nat86Plus, Nat87Plus, Nat88Plus, Nat89Plus, Nat8Plus, Nat90Plus
@docs Nat91Plus, Nat92Plus, Nat93Plus, Nat94Plus, Nat95Plus, Nat96Plus, Nat97Plus
@docs Nat98Plus, Nat99Plus, Nat9Plus


## exact

@docs Nat0, Nat1, Nat10, Nat100, Nat101, Nat102, Nat103, Nat104, Nat105, Nat106, Nat107
@docs Nat108, Nat109, Nat11, Nat110, Nat111, Nat112, Nat113, Nat114, Nat115, Nat116
@docs Nat117, Nat118, Nat119, Nat12, Nat120, Nat121, Nat122, Nat123, Nat124, Nat125
@docs Nat126, Nat127, Nat128, Nat129, Nat13, Nat130, Nat131, Nat132, Nat133, Nat134
@docs Nat135, Nat136, Nat137, Nat138, Nat139, Nat14, Nat140, Nat141, Nat142, Nat143
@docs Nat144, Nat145, Nat146, Nat147, Nat148, Nat149, Nat15, Nat150, Nat151, Nat152
@docs Nat153, Nat154, Nat155, Nat156, Nat157, Nat158, Nat159, Nat16, Nat160, Nat17, Nat18
@docs Nat19, Nat2, Nat20, Nat21, Nat22, Nat23, Nat24, Nat25, Nat26, Nat27, Nat28, Nat29, Nat3
@docs Nat30, Nat31, Nat32, Nat33, Nat34, Nat35, Nat36, Nat37, Nat38, Nat39, Nat4, Nat40, Nat41
@docs Nat42, Nat43, Nat44, Nat45, Nat46, Nat47, Nat48, Nat49, Nat5, Nat50, Nat51, Nat52, Nat53
@docs Nat54, Nat55, Nat56, Nat57, Nat58, Nat59, Nat6, Nat60, Nat61, Nat62, Nat63, Nat64, Nat65
@docs Nat66, Nat67, Nat68, Nat69, Nat7, Nat70, Nat71, Nat72, Nat73, Nat74, Nat75, Nat76, Nat77
@docs Nat78, Nat79, Nat8, Nat80, Nat81, Nat82, Nat83, Nat84, Nat85, Nat86, Nat87, Nat88, Nat89
@docs Nat9, Nat90, Nat91, Nat92, Nat93, Nat94, Nat95, Nat96, Nat97, Nat98, Nat99

-}

import I exposing (Is, N, Nat, S, To, Z, nNatAdd)


{-| The exact `Nat` 0.
-}
nat0 : Nat (N Nat0 a_ (Is a To a) (Is b To b))
nat0 =
    I.nat0


{-| The exact `Nat` 1.
-}
nat1 : Nat (N Nat1 (Nat1Plus a_) (Is a To (Nat1Plus a)) (Is b To (Nat1Plus b)))
nat1 =
    I.nat1


{-| The exact `Nat` 2.
-}
nat2 : Nat (N Nat2 (Nat2Plus a_) (Is a To (Nat2Plus a)) (Is b To (Nat2Plus b)))
nat2 =
    nat1 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 3.
-}
nat3 : Nat (N Nat3 (Nat3Plus a_) (Is a To (Nat3Plus a)) (Is b To (Nat3Plus b)))
nat3 =
    nat2 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 4.
-}
nat4 : Nat (N Nat4 (Nat4Plus a_) (Is a To (Nat4Plus a)) (Is b To (Nat4Plus b)))
nat4 =
    nat3 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 5.
-}
nat5 : Nat (N Nat5 (Nat5Plus a_) (Is a To (Nat5Plus a)) (Is b To (Nat5Plus b)))
nat5 =
    nat4 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 6.
-}
nat6 : Nat (N Nat6 (Nat6Plus a_) (Is a To (Nat6Plus a)) (Is b To (Nat6Plus b)))
nat6 =
    nat5 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 7.
-}
nat7 : Nat (N Nat7 (Nat7Plus a_) (Is a To (Nat7Plus a)) (Is b To (Nat7Plus b)))
nat7 =
    nat6 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 8.
-}
nat8 : Nat (N Nat8 (Nat8Plus a_) (Is a To (Nat8Plus a)) (Is b To (Nat8Plus b)))
nat8 =
    nat7 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 9.
-}
nat9 : Nat (N Nat9 (Nat9Plus a_) (Is a To (Nat9Plus a)) (Is b To (Nat9Plus b)))
nat9 =
    nat8 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 10.
-}
nat10 : Nat (N Nat10 (Nat10Plus a_) (Is a To (Nat10Plus a)) (Is b To (Nat10Plus b)))
nat10 =
    nat9 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 11.
-}
nat11 : Nat (N Nat11 (Nat11Plus a_) (Is a To (Nat11Plus a)) (Is b To (Nat11Plus b)))
nat11 =
    nat10 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 12.
-}
nat12 : Nat (N Nat12 (Nat12Plus a_) (Is a To (Nat12Plus a)) (Is b To (Nat12Plus b)))
nat12 =
    nat11 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 13.
-}
nat13 : Nat (N Nat13 (Nat13Plus a_) (Is a To (Nat13Plus a)) (Is b To (Nat13Plus b)))
nat13 =
    nat12 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 14.
-}
nat14 : Nat (N Nat14 (Nat14Plus a_) (Is a To (Nat14Plus a)) (Is b To (Nat14Plus b)))
nat14 =
    nat13 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 15.
-}
nat15 : Nat (N Nat15 (Nat15Plus a_) (Is a To (Nat15Plus a)) (Is b To (Nat15Plus b)))
nat15 =
    nat14 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 16.
-}
nat16 : Nat (N Nat16 (Nat16Plus a_) (Is a To (Nat16Plus a)) (Is b To (Nat16Plus b)))
nat16 =
    nat15 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 17.
-}
nat17 : Nat (N Nat17 (Nat17Plus a_) (Is a To (Nat17Plus a)) (Is b To (Nat17Plus b)))
nat17 =
    nat16 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 18.
-}
nat18 : Nat (N Nat18 (Nat18Plus a_) (Is a To (Nat18Plus a)) (Is b To (Nat18Plus b)))
nat18 =
    nat17 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 19.
-}
nat19 : Nat (N Nat19 (Nat19Plus a_) (Is a To (Nat19Plus a)) (Is b To (Nat19Plus b)))
nat19 =
    nat18 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 20.
-}
nat20 : Nat (N Nat20 (Nat20Plus a_) (Is a To (Nat20Plus a)) (Is b To (Nat20Plus b)))
nat20 =
    nat19 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 21.
-}
nat21 : Nat (N Nat21 (Nat21Plus a_) (Is a To (Nat21Plus a)) (Is b To (Nat21Plus b)))
nat21 =
    nat20 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 22.
-}
nat22 : Nat (N Nat22 (Nat22Plus a_) (Is a To (Nat22Plus a)) (Is b To (Nat22Plus b)))
nat22 =
    nat21 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 23.
-}
nat23 : Nat (N Nat23 (Nat23Plus a_) (Is a To (Nat23Plus a)) (Is b To (Nat23Plus b)))
nat23 =
    nat22 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 24.
-}
nat24 : Nat (N Nat24 (Nat24Plus a_) (Is a To (Nat24Plus a)) (Is b To (Nat24Plus b)))
nat24 =
    nat23 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 25.
-}
nat25 : Nat (N Nat25 (Nat25Plus a_) (Is a To (Nat25Plus a)) (Is b To (Nat25Plus b)))
nat25 =
    nat24 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 26.
-}
nat26 : Nat (N Nat26 (Nat26Plus a_) (Is a To (Nat26Plus a)) (Is b To (Nat26Plus b)))
nat26 =
    nat25 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 27.
-}
nat27 : Nat (N Nat27 (Nat27Plus a_) (Is a To (Nat27Plus a)) (Is b To (Nat27Plus b)))
nat27 =
    nat26 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 28.
-}
nat28 : Nat (N Nat28 (Nat28Plus a_) (Is a To (Nat28Plus a)) (Is b To (Nat28Plus b)))
nat28 =
    nat27 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 29.
-}
nat29 : Nat (N Nat29 (Nat29Plus a_) (Is a To (Nat29Plus a)) (Is b To (Nat29Plus b)))
nat29 =
    nat28 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 30.
-}
nat30 : Nat (N Nat30 (Nat30Plus a_) (Is a To (Nat30Plus a)) (Is b To (Nat30Plus b)))
nat30 =
    nat29 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 31.
-}
nat31 : Nat (N Nat31 (Nat31Plus a_) (Is a To (Nat31Plus a)) (Is b To (Nat31Plus b)))
nat31 =
    nat30 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 32.
-}
nat32 : Nat (N Nat32 (Nat32Plus a_) (Is a To (Nat32Plus a)) (Is b To (Nat32Plus b)))
nat32 =
    nat31 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 33.
-}
nat33 : Nat (N Nat33 (Nat33Plus a_) (Is a To (Nat33Plus a)) (Is b To (Nat33Plus b)))
nat33 =
    nat32 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 34.
-}
nat34 : Nat (N Nat34 (Nat34Plus a_) (Is a To (Nat34Plus a)) (Is b To (Nat34Plus b)))
nat34 =
    nat33 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 35.
-}
nat35 : Nat (N Nat35 (Nat35Plus a_) (Is a To (Nat35Plus a)) (Is b To (Nat35Plus b)))
nat35 =
    nat34 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 36.
-}
nat36 : Nat (N Nat36 (Nat36Plus a_) (Is a To (Nat36Plus a)) (Is b To (Nat36Plus b)))
nat36 =
    nat35 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 37.
-}
nat37 : Nat (N Nat37 (Nat37Plus a_) (Is a To (Nat37Plus a)) (Is b To (Nat37Plus b)))
nat37 =
    nat36 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 38.
-}
nat38 : Nat (N Nat38 (Nat38Plus a_) (Is a To (Nat38Plus a)) (Is b To (Nat38Plus b)))
nat38 =
    nat37 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 39.
-}
nat39 : Nat (N Nat39 (Nat39Plus a_) (Is a To (Nat39Plus a)) (Is b To (Nat39Plus b)))
nat39 =
    nat38 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 40.
-}
nat40 : Nat (N Nat40 (Nat40Plus a_) (Is a To (Nat40Plus a)) (Is b To (Nat40Plus b)))
nat40 =
    nat39 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 41.
-}
nat41 : Nat (N Nat41 (Nat41Plus a_) (Is a To (Nat41Plus a)) (Is b To (Nat41Plus b)))
nat41 =
    nat40 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 42.
-}
nat42 : Nat (N Nat42 (Nat42Plus a_) (Is a To (Nat42Plus a)) (Is b To (Nat42Plus b)))
nat42 =
    nat41 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 43.
-}
nat43 : Nat (N Nat43 (Nat43Plus a_) (Is a To (Nat43Plus a)) (Is b To (Nat43Plus b)))
nat43 =
    nat42 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 44.
-}
nat44 : Nat (N Nat44 (Nat44Plus a_) (Is a To (Nat44Plus a)) (Is b To (Nat44Plus b)))
nat44 =
    nat43 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 45.
-}
nat45 : Nat (N Nat45 (Nat45Plus a_) (Is a To (Nat45Plus a)) (Is b To (Nat45Plus b)))
nat45 =
    nat44 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 46.
-}
nat46 : Nat (N Nat46 (Nat46Plus a_) (Is a To (Nat46Plus a)) (Is b To (Nat46Plus b)))
nat46 =
    nat45 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 47.
-}
nat47 : Nat (N Nat47 (Nat47Plus a_) (Is a To (Nat47Plus a)) (Is b To (Nat47Plus b)))
nat47 =
    nat46 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 48.
-}
nat48 : Nat (N Nat48 (Nat48Plus a_) (Is a To (Nat48Plus a)) (Is b To (Nat48Plus b)))
nat48 =
    nat47 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 49.
-}
nat49 : Nat (N Nat49 (Nat49Plus a_) (Is a To (Nat49Plus a)) (Is b To (Nat49Plus b)))
nat49 =
    nat48 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 50.
-}
nat50 : Nat (N Nat50 (Nat50Plus a_) (Is a To (Nat50Plus a)) (Is b To (Nat50Plus b)))
nat50 =
    nat49 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 51.
-}
nat51 : Nat (N Nat51 (Nat51Plus a_) (Is a To (Nat51Plus a)) (Is b To (Nat51Plus b)))
nat51 =
    nat50 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 52.
-}
nat52 : Nat (N Nat52 (Nat52Plus a_) (Is a To (Nat52Plus a)) (Is b To (Nat52Plus b)))
nat52 =
    nat51 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 53.
-}
nat53 : Nat (N Nat53 (Nat53Plus a_) (Is a To (Nat53Plus a)) (Is b To (Nat53Plus b)))
nat53 =
    nat52 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 54.
-}
nat54 : Nat (N Nat54 (Nat54Plus a_) (Is a To (Nat54Plus a)) (Is b To (Nat54Plus b)))
nat54 =
    nat53 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 55.
-}
nat55 : Nat (N Nat55 (Nat55Plus a_) (Is a To (Nat55Plus a)) (Is b To (Nat55Plus b)))
nat55 =
    nat54 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 56.
-}
nat56 : Nat (N Nat56 (Nat56Plus a_) (Is a To (Nat56Plus a)) (Is b To (Nat56Plus b)))
nat56 =
    nat55 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 57.
-}
nat57 : Nat (N Nat57 (Nat57Plus a_) (Is a To (Nat57Plus a)) (Is b To (Nat57Plus b)))
nat57 =
    nat56 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 58.
-}
nat58 : Nat (N Nat58 (Nat58Plus a_) (Is a To (Nat58Plus a)) (Is b To (Nat58Plus b)))
nat58 =
    nat57 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 59.
-}
nat59 : Nat (N Nat59 (Nat59Plus a_) (Is a To (Nat59Plus a)) (Is b To (Nat59Plus b)))
nat59 =
    nat58 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 60.
-}
nat60 : Nat (N Nat60 (Nat60Plus a_) (Is a To (Nat60Plus a)) (Is b To (Nat60Plus b)))
nat60 =
    nat59 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 61.
-}
nat61 : Nat (N Nat61 (Nat61Plus a_) (Is a To (Nat61Plus a)) (Is b To (Nat61Plus b)))
nat61 =
    nat60 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 62.
-}
nat62 : Nat (N Nat62 (Nat62Plus a_) (Is a To (Nat62Plus a)) (Is b To (Nat62Plus b)))
nat62 =
    nat61 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 63.
-}
nat63 : Nat (N Nat63 (Nat63Plus a_) (Is a To (Nat63Plus a)) (Is b To (Nat63Plus b)))
nat63 =
    nat62 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 64.
-}
nat64 : Nat (N Nat64 (Nat64Plus a_) (Is a To (Nat64Plus a)) (Is b To (Nat64Plus b)))
nat64 =
    nat63 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 65.
-}
nat65 : Nat (N Nat65 (Nat65Plus a_) (Is a To (Nat65Plus a)) (Is b To (Nat65Plus b)))
nat65 =
    nat64 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 66.
-}
nat66 : Nat (N Nat66 (Nat66Plus a_) (Is a To (Nat66Plus a)) (Is b To (Nat66Plus b)))
nat66 =
    nat65 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 67.
-}
nat67 : Nat (N Nat67 (Nat67Plus a_) (Is a To (Nat67Plus a)) (Is b To (Nat67Plus b)))
nat67 =
    nat66 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 68.
-}
nat68 : Nat (N Nat68 (Nat68Plus a_) (Is a To (Nat68Plus a)) (Is b To (Nat68Plus b)))
nat68 =
    nat67 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 69.
-}
nat69 : Nat (N Nat69 (Nat69Plus a_) (Is a To (Nat69Plus a)) (Is b To (Nat69Plus b)))
nat69 =
    nat68 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 70.
-}
nat70 : Nat (N Nat70 (Nat70Plus a_) (Is a To (Nat70Plus a)) (Is b To (Nat70Plus b)))
nat70 =
    nat69 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 71.
-}
nat71 : Nat (N Nat71 (Nat71Plus a_) (Is a To (Nat71Plus a)) (Is b To (Nat71Plus b)))
nat71 =
    nat70 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 72.
-}
nat72 : Nat (N Nat72 (Nat72Plus a_) (Is a To (Nat72Plus a)) (Is b To (Nat72Plus b)))
nat72 =
    nat71 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 73.
-}
nat73 : Nat (N Nat73 (Nat73Plus a_) (Is a To (Nat73Plus a)) (Is b To (Nat73Plus b)))
nat73 =
    nat72 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 74.
-}
nat74 : Nat (N Nat74 (Nat74Plus a_) (Is a To (Nat74Plus a)) (Is b To (Nat74Plus b)))
nat74 =
    nat73 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 75.
-}
nat75 : Nat (N Nat75 (Nat75Plus a_) (Is a To (Nat75Plus a)) (Is b To (Nat75Plus b)))
nat75 =
    nat74 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 76.
-}
nat76 : Nat (N Nat76 (Nat76Plus a_) (Is a To (Nat76Plus a)) (Is b To (Nat76Plus b)))
nat76 =
    nat75 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 77.
-}
nat77 : Nat (N Nat77 (Nat77Plus a_) (Is a To (Nat77Plus a)) (Is b To (Nat77Plus b)))
nat77 =
    nat76 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 78.
-}
nat78 : Nat (N Nat78 (Nat78Plus a_) (Is a To (Nat78Plus a)) (Is b To (Nat78Plus b)))
nat78 =
    nat77 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 79.
-}
nat79 : Nat (N Nat79 (Nat79Plus a_) (Is a To (Nat79Plus a)) (Is b To (Nat79Plus b)))
nat79 =
    nat78 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 80.
-}
nat80 : Nat (N Nat80 (Nat80Plus a_) (Is a To (Nat80Plus a)) (Is b To (Nat80Plus b)))
nat80 =
    nat79 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 81.
-}
nat81 : Nat (N Nat81 (Nat81Plus a_) (Is a To (Nat81Plus a)) (Is b To (Nat81Plus b)))
nat81 =
    nat80 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 82.
-}
nat82 : Nat (N Nat82 (Nat82Plus a_) (Is a To (Nat82Plus a)) (Is b To (Nat82Plus b)))
nat82 =
    nat81 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 83.
-}
nat83 : Nat (N Nat83 (Nat83Plus a_) (Is a To (Nat83Plus a)) (Is b To (Nat83Plus b)))
nat83 =
    nat82 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 84.
-}
nat84 : Nat (N Nat84 (Nat84Plus a_) (Is a To (Nat84Plus a)) (Is b To (Nat84Plus b)))
nat84 =
    nat83 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 85.
-}
nat85 : Nat (N Nat85 (Nat85Plus a_) (Is a To (Nat85Plus a)) (Is b To (Nat85Plus b)))
nat85 =
    nat84 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 86.
-}
nat86 : Nat (N Nat86 (Nat86Plus a_) (Is a To (Nat86Plus a)) (Is b To (Nat86Plus b)))
nat86 =
    nat85 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 87.
-}
nat87 : Nat (N Nat87 (Nat87Plus a_) (Is a To (Nat87Plus a)) (Is b To (Nat87Plus b)))
nat87 =
    nat86 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 88.
-}
nat88 : Nat (N Nat88 (Nat88Plus a_) (Is a To (Nat88Plus a)) (Is b To (Nat88Plus b)))
nat88 =
    nat87 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 89.
-}
nat89 : Nat (N Nat89 (Nat89Plus a_) (Is a To (Nat89Plus a)) (Is b To (Nat89Plus b)))
nat89 =
    nat88 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 90.
-}
nat90 : Nat (N Nat90 (Nat90Plus a_) (Is a To (Nat90Plus a)) (Is b To (Nat90Plus b)))
nat90 =
    nat89 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 91.
-}
nat91 : Nat (N Nat91 (Nat91Plus a_) (Is a To (Nat91Plus a)) (Is b To (Nat91Plus b)))
nat91 =
    nat90 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 92.
-}
nat92 : Nat (N Nat92 (Nat92Plus a_) (Is a To (Nat92Plus a)) (Is b To (Nat92Plus b)))
nat92 =
    nat91 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 93.
-}
nat93 : Nat (N Nat93 (Nat93Plus a_) (Is a To (Nat93Plus a)) (Is b To (Nat93Plus b)))
nat93 =
    nat92 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 94.
-}
nat94 : Nat (N Nat94 (Nat94Plus a_) (Is a To (Nat94Plus a)) (Is b To (Nat94Plus b)))
nat94 =
    nat93 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 95.
-}
nat95 : Nat (N Nat95 (Nat95Plus a_) (Is a To (Nat95Plus a)) (Is b To (Nat95Plus b)))
nat95 =
    nat94 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 96.
-}
nat96 : Nat (N Nat96 (Nat96Plus a_) (Is a To (Nat96Plus a)) (Is b To (Nat96Plus b)))
nat96 =
    nat95 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 97.
-}
nat97 : Nat (N Nat97 (Nat97Plus a_) (Is a To (Nat97Plus a)) (Is b To (Nat97Plus b)))
nat97 =
    nat96 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 98.
-}
nat98 : Nat (N Nat98 (Nat98Plus a_) (Is a To (Nat98Plus a)) (Is b To (Nat98Plus b)))
nat98 =
    nat97 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 99.
-}
nat99 : Nat (N Nat99 (Nat99Plus a_) (Is a To (Nat99Plus a)) (Is b To (Nat99Plus b)))
nat99 =
    nat98 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 100.
-}
nat100 : Nat (N Nat100 (Nat100Plus a_) (Is a To (Nat100Plus a)) (Is b To (Nat100Plus b)))
nat100 =
    nat99 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 101.
-}
nat101 : Nat (N Nat101 (Nat101Plus a_) (Is a To (Nat101Plus a)) (Is b To (Nat101Plus b)))
nat101 =
    nat100 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 102.
-}
nat102 : Nat (N Nat102 (Nat102Plus a_) (Is a To (Nat102Plus a)) (Is b To (Nat102Plus b)))
nat102 =
    nat101 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 103.
-}
nat103 : Nat (N Nat103 (Nat103Plus a_) (Is a To (Nat103Plus a)) (Is b To (Nat103Plus b)))
nat103 =
    nat102 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 104.
-}
nat104 : Nat (N Nat104 (Nat104Plus a_) (Is a To (Nat104Plus a)) (Is b To (Nat104Plus b)))
nat104 =
    nat103 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 105.
-}
nat105 : Nat (N Nat105 (Nat105Plus a_) (Is a To (Nat105Plus a)) (Is b To (Nat105Plus b)))
nat105 =
    nat104 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 106.
-}
nat106 : Nat (N Nat106 (Nat106Plus a_) (Is a To (Nat106Plus a)) (Is b To (Nat106Plus b)))
nat106 =
    nat105 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 107.
-}
nat107 : Nat (N Nat107 (Nat107Plus a_) (Is a To (Nat107Plus a)) (Is b To (Nat107Plus b)))
nat107 =
    nat106 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 108.
-}
nat108 : Nat (N Nat108 (Nat108Plus a_) (Is a To (Nat108Plus a)) (Is b To (Nat108Plus b)))
nat108 =
    nat107 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 109.
-}
nat109 : Nat (N Nat109 (Nat109Plus a_) (Is a To (Nat109Plus a)) (Is b To (Nat109Plus b)))
nat109 =
    nat108 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 110.
-}
nat110 : Nat (N Nat110 (Nat110Plus a_) (Is a To (Nat110Plus a)) (Is b To (Nat110Plus b)))
nat110 =
    nat109 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 111.
-}
nat111 : Nat (N Nat111 (Nat111Plus a_) (Is a To (Nat111Plus a)) (Is b To (Nat111Plus b)))
nat111 =
    nat110 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 112.
-}
nat112 : Nat (N Nat112 (Nat112Plus a_) (Is a To (Nat112Plus a)) (Is b To (Nat112Plus b)))
nat112 =
    nat111 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 113.
-}
nat113 : Nat (N Nat113 (Nat113Plus a_) (Is a To (Nat113Plus a)) (Is b To (Nat113Plus b)))
nat113 =
    nat112 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 114.
-}
nat114 : Nat (N Nat114 (Nat114Plus a_) (Is a To (Nat114Plus a)) (Is b To (Nat114Plus b)))
nat114 =
    nat113 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 115.
-}
nat115 : Nat (N Nat115 (Nat115Plus a_) (Is a To (Nat115Plus a)) (Is b To (Nat115Plus b)))
nat115 =
    nat114 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 116.
-}
nat116 : Nat (N Nat116 (Nat116Plus a_) (Is a To (Nat116Plus a)) (Is b To (Nat116Plus b)))
nat116 =
    nat115 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 117.
-}
nat117 : Nat (N Nat117 (Nat117Plus a_) (Is a To (Nat117Plus a)) (Is b To (Nat117Plus b)))
nat117 =
    nat116 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 118.
-}
nat118 : Nat (N Nat118 (Nat118Plus a_) (Is a To (Nat118Plus a)) (Is b To (Nat118Plus b)))
nat118 =
    nat117 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 119.
-}
nat119 : Nat (N Nat119 (Nat119Plus a_) (Is a To (Nat119Plus a)) (Is b To (Nat119Plus b)))
nat119 =
    nat118 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 120.
-}
nat120 : Nat (N Nat120 (Nat120Plus a_) (Is a To (Nat120Plus a)) (Is b To (Nat120Plus b)))
nat120 =
    nat119 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 121.
-}
nat121 : Nat (N Nat121 (Nat121Plus a_) (Is a To (Nat121Plus a)) (Is b To (Nat121Plus b)))
nat121 =
    nat120 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 122.
-}
nat122 : Nat (N Nat122 (Nat122Plus a_) (Is a To (Nat122Plus a)) (Is b To (Nat122Plus b)))
nat122 =
    nat121 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 123.
-}
nat123 : Nat (N Nat123 (Nat123Plus a_) (Is a To (Nat123Plus a)) (Is b To (Nat123Plus b)))
nat123 =
    nat122 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 124.
-}
nat124 : Nat (N Nat124 (Nat124Plus a_) (Is a To (Nat124Plus a)) (Is b To (Nat124Plus b)))
nat124 =
    nat123 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 125.
-}
nat125 : Nat (N Nat125 (Nat125Plus a_) (Is a To (Nat125Plus a)) (Is b To (Nat125Plus b)))
nat125 =
    nat124 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 126.
-}
nat126 : Nat (N Nat126 (Nat126Plus a_) (Is a To (Nat126Plus a)) (Is b To (Nat126Plus b)))
nat126 =
    nat125 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 127.
-}
nat127 : Nat (N Nat127 (Nat127Plus a_) (Is a To (Nat127Plus a)) (Is b To (Nat127Plus b)))
nat127 =
    nat126 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 128.
-}
nat128 : Nat (N Nat128 (Nat128Plus a_) (Is a To (Nat128Plus a)) (Is b To (Nat128Plus b)))
nat128 =
    nat127 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 129.
-}
nat129 : Nat (N Nat129 (Nat129Plus a_) (Is a To (Nat129Plus a)) (Is b To (Nat129Plus b)))
nat129 =
    nat128 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 130.
-}
nat130 : Nat (N Nat130 (Nat130Plus a_) (Is a To (Nat130Plus a)) (Is b To (Nat130Plus b)))
nat130 =
    nat129 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 131.
-}
nat131 : Nat (N Nat131 (Nat131Plus a_) (Is a To (Nat131Plus a)) (Is b To (Nat131Plus b)))
nat131 =
    nat130 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 132.
-}
nat132 : Nat (N Nat132 (Nat132Plus a_) (Is a To (Nat132Plus a)) (Is b To (Nat132Plus b)))
nat132 =
    nat131 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 133.
-}
nat133 : Nat (N Nat133 (Nat133Plus a_) (Is a To (Nat133Plus a)) (Is b To (Nat133Plus b)))
nat133 =
    nat132 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 134.
-}
nat134 : Nat (N Nat134 (Nat134Plus a_) (Is a To (Nat134Plus a)) (Is b To (Nat134Plus b)))
nat134 =
    nat133 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 135.
-}
nat135 : Nat (N Nat135 (Nat135Plus a_) (Is a To (Nat135Plus a)) (Is b To (Nat135Plus b)))
nat135 =
    nat134 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 136.
-}
nat136 : Nat (N Nat136 (Nat136Plus a_) (Is a To (Nat136Plus a)) (Is b To (Nat136Plus b)))
nat136 =
    nat135 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 137.
-}
nat137 : Nat (N Nat137 (Nat137Plus a_) (Is a To (Nat137Plus a)) (Is b To (Nat137Plus b)))
nat137 =
    nat136 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 138.
-}
nat138 : Nat (N Nat138 (Nat138Plus a_) (Is a To (Nat138Plus a)) (Is b To (Nat138Plus b)))
nat138 =
    nat137 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 139.
-}
nat139 : Nat (N Nat139 (Nat139Plus a_) (Is a To (Nat139Plus a)) (Is b To (Nat139Plus b)))
nat139 =
    nat138 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 140.
-}
nat140 : Nat (N Nat140 (Nat140Plus a_) (Is a To (Nat140Plus a)) (Is b To (Nat140Plus b)))
nat140 =
    nat139 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 141.
-}
nat141 : Nat (N Nat141 (Nat141Plus a_) (Is a To (Nat141Plus a)) (Is b To (Nat141Plus b)))
nat141 =
    nat140 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 142.
-}
nat142 : Nat (N Nat142 (Nat142Plus a_) (Is a To (Nat142Plus a)) (Is b To (Nat142Plus b)))
nat142 =
    nat141 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 143.
-}
nat143 : Nat (N Nat143 (Nat143Plus a_) (Is a To (Nat143Plus a)) (Is b To (Nat143Plus b)))
nat143 =
    nat142 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 144.
-}
nat144 : Nat (N Nat144 (Nat144Plus a_) (Is a To (Nat144Plus a)) (Is b To (Nat144Plus b)))
nat144 =
    nat143 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 145.
-}
nat145 : Nat (N Nat145 (Nat145Plus a_) (Is a To (Nat145Plus a)) (Is b To (Nat145Plus b)))
nat145 =
    nat144 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 146.
-}
nat146 : Nat (N Nat146 (Nat146Plus a_) (Is a To (Nat146Plus a)) (Is b To (Nat146Plus b)))
nat146 =
    nat145 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 147.
-}
nat147 : Nat (N Nat147 (Nat147Plus a_) (Is a To (Nat147Plus a)) (Is b To (Nat147Plus b)))
nat147 =
    nat146 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 148.
-}
nat148 : Nat (N Nat148 (Nat148Plus a_) (Is a To (Nat148Plus a)) (Is b To (Nat148Plus b)))
nat148 =
    nat147 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 149.
-}
nat149 : Nat (N Nat149 (Nat149Plus a_) (Is a To (Nat149Plus a)) (Is b To (Nat149Plus b)))
nat149 =
    nat148 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 150.
-}
nat150 : Nat (N Nat150 (Nat150Plus a_) (Is a To (Nat150Plus a)) (Is b To (Nat150Plus b)))
nat150 =
    nat149 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 151.
-}
nat151 : Nat (N Nat151 (Nat151Plus a_) (Is a To (Nat151Plus a)) (Is b To (Nat151Plus b)))
nat151 =
    nat150 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 152.
-}
nat152 : Nat (N Nat152 (Nat152Plus a_) (Is a To (Nat152Plus a)) (Is b To (Nat152Plus b)))
nat152 =
    nat151 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 153.
-}
nat153 : Nat (N Nat153 (Nat153Plus a_) (Is a To (Nat153Plus a)) (Is b To (Nat153Plus b)))
nat153 =
    nat152 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 154.
-}
nat154 : Nat (N Nat154 (Nat154Plus a_) (Is a To (Nat154Plus a)) (Is b To (Nat154Plus b)))
nat154 =
    nat153 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 155.
-}
nat155 : Nat (N Nat155 (Nat155Plus a_) (Is a To (Nat155Plus a)) (Is b To (Nat155Plus b)))
nat155 =
    nat154 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 156.
-}
nat156 : Nat (N Nat156 (Nat156Plus a_) (Is a To (Nat156Plus a)) (Is b To (Nat156Plus b)))
nat156 =
    nat155 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 157.
-}
nat157 : Nat (N Nat157 (Nat157Plus a_) (Is a To (Nat157Plus a)) (Is b To (Nat157Plus b)))
nat157 =
    nat156 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 158.
-}
nat158 : Nat (N Nat158 (Nat158Plus a_) (Is a To (Nat158Plus a)) (Is b To (Nat158Plus b)))
nat158 =
    nat157 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 159.
-}
nat159 : Nat (N Nat159 (Nat159Plus a_) (Is a To (Nat159Plus a)) (Is b To (Nat159Plus b)))
nat159 =
    nat158 |> nNatAdd ( nat1, nat1 )


{-| The exact `Nat` 160.
-}
nat160 : Nat (N Nat160 (Nat160Plus a_) (Is a To (Nat160Plus a)) (Is b To (Nat160Plus b)))
nat160 =
    nat159 |> nNatAdd ( nat1, nat1 )


{-| 1 + some natural number `n`.
-}
type alias Nat1Plus n =
    S n


{-| 2 + some natural number `n`.
-}
type alias Nat2Plus n =
    S (S n)


{-| 3 + some natural number `n`.
-}
type alias Nat3Plus n =
    S (S (S n))


{-| 4 + some natural number `n`.
-}
type alias Nat4Plus n =
    S (S (S (S n)))


{-| 5 + some natural number `n`.
-}
type alias Nat5Plus n =
    S (S (S (S (S n))))


{-| 6 + some natural number `n`.
-}
type alias Nat6Plus n =
    S (S (S (S (S (S n)))))


{-| 7 + some natural number `n`.
-}
type alias Nat7Plus n =
    S (S (S (S (S (S (S n))))))


{-| 8 + some natural number `n`.
-}
type alias Nat8Plus n =
    S (S (S (S (S (S (S (S n)))))))


{-| 9 + some natural number `n`.
-}
type alias Nat9Plus n =
    S (S (S (S (S (S (S (S (S n))))))))


{-| 10 + some natural number `n`.
-}
type alias Nat10Plus n =
    S (S (S (S (S (S (S (S (S (S n)))))))))


{-| 11 + some natural number `n`.
-}
type alias Nat11Plus n =
    S (S (S (S (S (S (S (S (S (S (S n))))))))))


{-| 12 + some natural number `n`.
-}
type alias Nat12Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))


{-| 13 + some natural number `n`.
-}
type alias Nat13Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))


{-| 14 + some natural number `n`.
-}
type alias Nat14Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))


{-| 15 + some natural number `n`.
-}
type alias Nat15Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))


{-| 16 + some natural number `n`.
-}
type alias Nat16Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))


{-| 17 + some natural number `n`.
-}
type alias Nat17Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))


{-| 18 + some natural number `n`.
-}
type alias Nat18Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))


{-| 19 + some natural number `n`.
-}
type alias Nat19Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))


{-| 20 + some natural number `n`.
-}
type alias Nat20Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))


{-| 21 + some natural number `n`.
-}
type alias Nat21Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))


{-| 22 + some natural number `n`.
-}
type alias Nat22Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))


{-| 23 + some natural number `n`.
-}
type alias Nat23Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))


{-| 24 + some natural number `n`.
-}
type alias Nat24Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))


{-| 25 + some natural number `n`.
-}
type alias Nat25Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))


{-| 26 + some natural number `n`.
-}
type alias Nat26Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))


{-| 27 + some natural number `n`.
-}
type alias Nat27Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))


{-| 28 + some natural number `n`.
-}
type alias Nat28Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))


{-| 29 + some natural number `n`.
-}
type alias Nat29Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))


{-| 30 + some natural number `n`.
-}
type alias Nat30Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))


{-| 31 + some natural number `n`.
-}
type alias Nat31Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))


{-| 32 + some natural number `n`.
-}
type alias Nat32Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))


{-| 33 + some natural number `n`.
-}
type alias Nat33Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))


{-| 34 + some natural number `n`.
-}
type alias Nat34Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))


{-| 35 + some natural number `n`.
-}
type alias Nat35Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))


{-| 36 + some natural number `n`.
-}
type alias Nat36Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))


{-| 37 + some natural number `n`.
-}
type alias Nat37Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))


{-| 38 + some natural number `n`.
-}
type alias Nat38Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))


{-| 39 + some natural number `n`.
-}
type alias Nat39Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))


{-| 40 + some natural number `n`.
-}
type alias Nat40Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))


{-| 41 + some natural number `n`.
-}
type alias Nat41Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))


{-| 42 + some natural number `n`.
-}
type alias Nat42Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))


{-| 43 + some natural number `n`.
-}
type alias Nat43Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))


{-| 44 + some natural number `n`.
-}
type alias Nat44Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))


{-| 45 + some natural number `n`.
-}
type alias Nat45Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))


{-| 46 + some natural number `n`.
-}
type alias Nat46Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))


{-| 47 + some natural number `n`.
-}
type alias Nat47Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))


{-| 48 + some natural number `n`.
-}
type alias Nat48Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))


{-| 49 + some natural number `n`.
-}
type alias Nat49Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))


{-| 50 + some natural number `n`.
-}
type alias Nat50Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))


{-| 51 + some natural number `n`.
-}
type alias Nat51Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 52 + some natural number `n`.
-}
type alias Nat52Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 53 + some natural number `n`.
-}
type alias Nat53Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 54 + some natural number `n`.
-}
type alias Nat54Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 55 + some natural number `n`.
-}
type alias Nat55Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 56 + some natural number `n`.
-}
type alias Nat56Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 57 + some natural number `n`.
-}
type alias Nat57Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 58 + some natural number `n`.
-}
type alias Nat58Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 59 + some natural number `n`.
-}
type alias Nat59Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 60 + some natural number `n`.
-}
type alias Nat60Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 61 + some natural number `n`.
-}
type alias Nat61Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 62 + some natural number `n`.
-}
type alias Nat62Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 63 + some natural number `n`.
-}
type alias Nat63Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 64 + some natural number `n`.
-}
type alias Nat64Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 65 + some natural number `n`.
-}
type alias Nat65Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 66 + some natural number `n`.
-}
type alias Nat66Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 67 + some natural number `n`.
-}
type alias Nat67Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 68 + some natural number `n`.
-}
type alias Nat68Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 69 + some natural number `n`.
-}
type alias Nat69Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 70 + some natural number `n`.
-}
type alias Nat70Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 71 + some natural number `n`.
-}
type alias Nat71Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 72 + some natural number `n`.
-}
type alias Nat72Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 73 + some natural number `n`.
-}
type alias Nat73Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 74 + some natural number `n`.
-}
type alias Nat74Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 75 + some natural number `n`.
-}
type alias Nat75Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 76 + some natural number `n`.
-}
type alias Nat76Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 77 + some natural number `n`.
-}
type alias Nat77Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 78 + some natural number `n`.
-}
type alias Nat78Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 79 + some natural number `n`.
-}
type alias Nat79Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 80 + some natural number `n`.
-}
type alias Nat80Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 81 + some natural number `n`.
-}
type alias Nat81Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 82 + some natural number `n`.
-}
type alias Nat82Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 83 + some natural number `n`.
-}
type alias Nat83Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 84 + some natural number `n`.
-}
type alias Nat84Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 85 + some natural number `n`.
-}
type alias Nat85Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 86 + some natural number `n`.
-}
type alias Nat86Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 87 + some natural number `n`.
-}
type alias Nat87Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 88 + some natural number `n`.
-}
type alias Nat88Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 89 + some natural number `n`.
-}
type alias Nat89Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 90 + some natural number `n`.
-}
type alias Nat90Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 91 + some natural number `n`.
-}
type alias Nat91Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 92 + some natural number `n`.
-}
type alias Nat92Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 93 + some natural number `n`.
-}
type alias Nat93Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 94 + some natural number `n`.
-}
type alias Nat94Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 95 + some natural number `n`.
-}
type alias Nat95Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 96 + some natural number `n`.
-}
type alias Nat96Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 97 + some natural number `n`.
-}
type alias Nat97Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 98 + some natural number `n`.
-}
type alias Nat98Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 99 + some natural number `n`.
-}
type alias Nat99Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 100 + some natural number `n`.
-}
type alias Nat100Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 101 + some natural number `n`.
-}
type alias Nat101Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 102 + some natural number `n`.
-}
type alias Nat102Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 103 + some natural number `n`.
-}
type alias Nat103Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 104 + some natural number `n`.
-}
type alias Nat104Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 105 + some natural number `n`.
-}
type alias Nat105Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 106 + some natural number `n`.
-}
type alias Nat106Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 107 + some natural number `n`.
-}
type alias Nat107Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 108 + some natural number `n`.
-}
type alias Nat108Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 109 + some natural number `n`.
-}
type alias Nat109Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 110 + some natural number `n`.
-}
type alias Nat110Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 111 + some natural number `n`.
-}
type alias Nat111Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 112 + some natural number `n`.
-}
type alias Nat112Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 113 + some natural number `n`.
-}
type alias Nat113Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 114 + some natural number `n`.
-}
type alias Nat114Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 115 + some natural number `n`.
-}
type alias Nat115Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 116 + some natural number `n`.
-}
type alias Nat116Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 117 + some natural number `n`.
-}
type alias Nat117Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 118 + some natural number `n`.
-}
type alias Nat118Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 119 + some natural number `n`.
-}
type alias Nat119Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 120 + some natural number `n`.
-}
type alias Nat120Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 121 + some natural number `n`.
-}
type alias Nat121Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 122 + some natural number `n`.
-}
type alias Nat122Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 123 + some natural number `n`.
-}
type alias Nat123Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 124 + some natural number `n`.
-}
type alias Nat124Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 125 + some natural number `n`.
-}
type alias Nat125Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 126 + some natural number `n`.
-}
type alias Nat126Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 127 + some natural number `n`.
-}
type alias Nat127Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 128 + some natural number `n`.
-}
type alias Nat128Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 129 + some natural number `n`.
-}
type alias Nat129Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 130 + some natural number `n`.
-}
type alias Nat130Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 131 + some natural number `n`.
-}
type alias Nat131Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 132 + some natural number `n`.
-}
type alias Nat132Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 133 + some natural number `n`.
-}
type alias Nat133Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 134 + some natural number `n`.
-}
type alias Nat134Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 135 + some natural number `n`.
-}
type alias Nat135Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 136 + some natural number `n`.
-}
type alias Nat136Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 137 + some natural number `n`.
-}
type alias Nat137Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 138 + some natural number `n`.
-}
type alias Nat138Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 139 + some natural number `n`.
-}
type alias Nat139Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 140 + some natural number `n`.
-}
type alias Nat140Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 141 + some natural number `n`.
-}
type alias Nat141Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 142 + some natural number `n`.
-}
type alias Nat142Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 143 + some natural number `n`.
-}
type alias Nat143Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 144 + some natural number `n`.
-}
type alias Nat144Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 145 + some natural number `n`.
-}
type alias Nat145Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 146 + some natural number `n`.
-}
type alias Nat146Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 147 + some natural number `n`.
-}
type alias Nat147Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 148 + some natural number `n`.
-}
type alias Nat148Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 149 + some natural number `n`.
-}
type alias Nat149Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 150 + some natural number `n`.
-}
type alias Nat150Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 151 + some natural number `n`.
-}
type alias Nat151Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 152 + some natural number `n`.
-}
type alias Nat152Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 153 + some natural number `n`.
-}
type alias Nat153Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 154 + some natural number `n`.
-}
type alias Nat154Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 155 + some natural number `n`.
-}
type alias Nat155Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 156 + some natural number `n`.
-}
type alias Nat156Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 157 + some natural number `n`.
-}
type alias Nat157Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 158 + some natural number `n`.
-}
type alias Nat158Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 159 + some natural number `n`.
-}
type alias Nat159Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| 160 + some natural number `n`.
-}
type alias Nat160Plus n =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S n)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


{-| Exact the natural number 0.
-}
type alias Nat0 =
    Z


{-| Exact the natural number 1.
-}
type alias Nat1 =
    Nat1Plus Z


{-| Exact the natural number 2.
-}
type alias Nat2 =
    Nat2Plus Z


{-| Exact the natural number 3.
-}
type alias Nat3 =
    Nat3Plus Z


{-| Exact the natural number 4.
-}
type alias Nat4 =
    Nat4Plus Z


{-| Exact the natural number 5.
-}
type alias Nat5 =
    Nat5Plus Z


{-| Exact the natural number 6.
-}
type alias Nat6 =
    Nat6Plus Z


{-| Exact the natural number 7.
-}
type alias Nat7 =
    Nat7Plus Z


{-| Exact the natural number 8.
-}
type alias Nat8 =
    Nat8Plus Z


{-| Exact the natural number 9.
-}
type alias Nat9 =
    Nat9Plus Z


{-| Exact the natural number 10.
-}
type alias Nat10 =
    Nat10Plus Z


{-| Exact the natural number 11.
-}
type alias Nat11 =
    Nat11Plus Z


{-| Exact the natural number 12.
-}
type alias Nat12 =
    Nat12Plus Z


{-| Exact the natural number 13.
-}
type alias Nat13 =
    Nat13Plus Z


{-| Exact the natural number 14.
-}
type alias Nat14 =
    Nat14Plus Z


{-| Exact the natural number 15.
-}
type alias Nat15 =
    Nat15Plus Z


{-| Exact the natural number 16.
-}
type alias Nat16 =
    Nat16Plus Z


{-| Exact the natural number 17.
-}
type alias Nat17 =
    Nat17Plus Z


{-| Exact the natural number 18.
-}
type alias Nat18 =
    Nat18Plus Z


{-| Exact the natural number 19.
-}
type alias Nat19 =
    Nat19Plus Z


{-| Exact the natural number 20.
-}
type alias Nat20 =
    Nat20Plus Z


{-| Exact the natural number 21.
-}
type alias Nat21 =
    Nat21Plus Z


{-| Exact the natural number 22.
-}
type alias Nat22 =
    Nat22Plus Z


{-| Exact the natural number 23.
-}
type alias Nat23 =
    Nat23Plus Z


{-| Exact the natural number 24.
-}
type alias Nat24 =
    Nat24Plus Z


{-| Exact the natural number 25.
-}
type alias Nat25 =
    Nat25Plus Z


{-| Exact the natural number 26.
-}
type alias Nat26 =
    Nat26Plus Z


{-| Exact the natural number 27.
-}
type alias Nat27 =
    Nat27Plus Z


{-| Exact the natural number 28.
-}
type alias Nat28 =
    Nat28Plus Z


{-| Exact the natural number 29.
-}
type alias Nat29 =
    Nat29Plus Z


{-| Exact the natural number 30.
-}
type alias Nat30 =
    Nat30Plus Z


{-| Exact the natural number 31.
-}
type alias Nat31 =
    Nat31Plus Z


{-| Exact the natural number 32.
-}
type alias Nat32 =
    Nat32Plus Z


{-| Exact the natural number 33.
-}
type alias Nat33 =
    Nat33Plus Z


{-| Exact the natural number 34.
-}
type alias Nat34 =
    Nat34Plus Z


{-| Exact the natural number 35.
-}
type alias Nat35 =
    Nat35Plus Z


{-| Exact the natural number 36.
-}
type alias Nat36 =
    Nat36Plus Z


{-| Exact the natural number 37.
-}
type alias Nat37 =
    Nat37Plus Z


{-| Exact the natural number 38.
-}
type alias Nat38 =
    Nat38Plus Z


{-| Exact the natural number 39.
-}
type alias Nat39 =
    Nat39Plus Z


{-| Exact the natural number 40.
-}
type alias Nat40 =
    Nat40Plus Z


{-| Exact the natural number 41.
-}
type alias Nat41 =
    Nat41Plus Z


{-| Exact the natural number 42.
-}
type alias Nat42 =
    Nat42Plus Z


{-| Exact the natural number 43.
-}
type alias Nat43 =
    Nat43Plus Z


{-| Exact the natural number 44.
-}
type alias Nat44 =
    Nat44Plus Z


{-| Exact the natural number 45.
-}
type alias Nat45 =
    Nat45Plus Z


{-| Exact the natural number 46.
-}
type alias Nat46 =
    Nat46Plus Z


{-| Exact the natural number 47.
-}
type alias Nat47 =
    Nat47Plus Z


{-| Exact the natural number 48.
-}
type alias Nat48 =
    Nat48Plus Z


{-| Exact the natural number 49.
-}
type alias Nat49 =
    Nat49Plus Z


{-| Exact the natural number 50.
-}
type alias Nat50 =
    Nat50Plus Z


{-| Exact the natural number 51.
-}
type alias Nat51 =
    Nat51Plus Z


{-| Exact the natural number 52.
-}
type alias Nat52 =
    Nat52Plus Z


{-| Exact the natural number 53.
-}
type alias Nat53 =
    Nat53Plus Z


{-| Exact the natural number 54.
-}
type alias Nat54 =
    Nat54Plus Z


{-| Exact the natural number 55.
-}
type alias Nat55 =
    Nat55Plus Z


{-| Exact the natural number 56.
-}
type alias Nat56 =
    Nat56Plus Z


{-| Exact the natural number 57.
-}
type alias Nat57 =
    Nat57Plus Z


{-| Exact the natural number 58.
-}
type alias Nat58 =
    Nat58Plus Z


{-| Exact the natural number 59.
-}
type alias Nat59 =
    Nat59Plus Z


{-| Exact the natural number 60.
-}
type alias Nat60 =
    Nat60Plus Z


{-| Exact the natural number 61.
-}
type alias Nat61 =
    Nat61Plus Z


{-| Exact the natural number 62.
-}
type alias Nat62 =
    Nat62Plus Z


{-| Exact the natural number 63.
-}
type alias Nat63 =
    Nat63Plus Z


{-| Exact the natural number 64.
-}
type alias Nat64 =
    Nat64Plus Z


{-| Exact the natural number 65.
-}
type alias Nat65 =
    Nat65Plus Z


{-| Exact the natural number 66.
-}
type alias Nat66 =
    Nat66Plus Z


{-| Exact the natural number 67.
-}
type alias Nat67 =
    Nat67Plus Z


{-| Exact the natural number 68.
-}
type alias Nat68 =
    Nat68Plus Z


{-| Exact the natural number 69.
-}
type alias Nat69 =
    Nat69Plus Z


{-| Exact the natural number 70.
-}
type alias Nat70 =
    Nat70Plus Z


{-| Exact the natural number 71.
-}
type alias Nat71 =
    Nat71Plus Z


{-| Exact the natural number 72.
-}
type alias Nat72 =
    Nat72Plus Z


{-| Exact the natural number 73.
-}
type alias Nat73 =
    Nat73Plus Z


{-| Exact the natural number 74.
-}
type alias Nat74 =
    Nat74Plus Z


{-| Exact the natural number 75.
-}
type alias Nat75 =
    Nat75Plus Z


{-| Exact the natural number 76.
-}
type alias Nat76 =
    Nat76Plus Z


{-| Exact the natural number 77.
-}
type alias Nat77 =
    Nat77Plus Z


{-| Exact the natural number 78.
-}
type alias Nat78 =
    Nat78Plus Z


{-| Exact the natural number 79.
-}
type alias Nat79 =
    Nat79Plus Z


{-| Exact the natural number 80.
-}
type alias Nat80 =
    Nat80Plus Z


{-| Exact the natural number 81.
-}
type alias Nat81 =
    Nat81Plus Z


{-| Exact the natural number 82.
-}
type alias Nat82 =
    Nat82Plus Z


{-| Exact the natural number 83.
-}
type alias Nat83 =
    Nat83Plus Z


{-| Exact the natural number 84.
-}
type alias Nat84 =
    Nat84Plus Z


{-| Exact the natural number 85.
-}
type alias Nat85 =
    Nat85Plus Z


{-| Exact the natural number 86.
-}
type alias Nat86 =
    Nat86Plus Z


{-| Exact the natural number 87.
-}
type alias Nat87 =
    Nat87Plus Z


{-| Exact the natural number 88.
-}
type alias Nat88 =
    Nat88Plus Z


{-| Exact the natural number 89.
-}
type alias Nat89 =
    Nat89Plus Z


{-| Exact the natural number 90.
-}
type alias Nat90 =
    Nat90Plus Z


{-| Exact the natural number 91.
-}
type alias Nat91 =
    Nat91Plus Z


{-| Exact the natural number 92.
-}
type alias Nat92 =
    Nat92Plus Z


{-| Exact the natural number 93.
-}
type alias Nat93 =
    Nat93Plus Z


{-| Exact the natural number 94.
-}
type alias Nat94 =
    Nat94Plus Z


{-| Exact the natural number 95.
-}
type alias Nat95 =
    Nat95Plus Z


{-| Exact the natural number 96.
-}
type alias Nat96 =
    Nat96Plus Z


{-| Exact the natural number 97.
-}
type alias Nat97 =
    Nat97Plus Z


{-| Exact the natural number 98.
-}
type alias Nat98 =
    Nat98Plus Z


{-| Exact the natural number 99.
-}
type alias Nat99 =
    Nat99Plus Z


{-| Exact the natural number 100.
-}
type alias Nat100 =
    Nat100Plus Z


{-| Exact the natural number 101.
-}
type alias Nat101 =
    Nat101Plus Z


{-| Exact the natural number 102.
-}
type alias Nat102 =
    Nat102Plus Z


{-| Exact the natural number 103.
-}
type alias Nat103 =
    Nat103Plus Z


{-| Exact the natural number 104.
-}
type alias Nat104 =
    Nat104Plus Z


{-| Exact the natural number 105.
-}
type alias Nat105 =
    Nat105Plus Z


{-| Exact the natural number 106.
-}
type alias Nat106 =
    Nat106Plus Z


{-| Exact the natural number 107.
-}
type alias Nat107 =
    Nat107Plus Z


{-| Exact the natural number 108.
-}
type alias Nat108 =
    Nat108Plus Z


{-| Exact the natural number 109.
-}
type alias Nat109 =
    Nat109Plus Z


{-| Exact the natural number 110.
-}
type alias Nat110 =
    Nat110Plus Z


{-| Exact the natural number 111.
-}
type alias Nat111 =
    Nat111Plus Z


{-| Exact the natural number 112.
-}
type alias Nat112 =
    Nat112Plus Z


{-| Exact the natural number 113.
-}
type alias Nat113 =
    Nat113Plus Z


{-| Exact the natural number 114.
-}
type alias Nat114 =
    Nat114Plus Z


{-| Exact the natural number 115.
-}
type alias Nat115 =
    Nat115Plus Z


{-| Exact the natural number 116.
-}
type alias Nat116 =
    Nat116Plus Z


{-| Exact the natural number 117.
-}
type alias Nat117 =
    Nat117Plus Z


{-| Exact the natural number 118.
-}
type alias Nat118 =
    Nat118Plus Z


{-| Exact the natural number 119.
-}
type alias Nat119 =
    Nat119Plus Z


{-| Exact the natural number 120.
-}
type alias Nat120 =
    Nat120Plus Z


{-| Exact the natural number 121.
-}
type alias Nat121 =
    Nat121Plus Z


{-| Exact the natural number 122.
-}
type alias Nat122 =
    Nat122Plus Z


{-| Exact the natural number 123.
-}
type alias Nat123 =
    Nat123Plus Z


{-| Exact the natural number 124.
-}
type alias Nat124 =
    Nat124Plus Z


{-| Exact the natural number 125.
-}
type alias Nat125 =
    Nat125Plus Z


{-| Exact the natural number 126.
-}
type alias Nat126 =
    Nat126Plus Z


{-| Exact the natural number 127.
-}
type alias Nat127 =
    Nat127Plus Z


{-| Exact the natural number 128.
-}
type alias Nat128 =
    Nat128Plus Z


{-| Exact the natural number 129.
-}
type alias Nat129 =
    Nat129Plus Z


{-| Exact the natural number 130.
-}
type alias Nat130 =
    Nat130Plus Z


{-| Exact the natural number 131.
-}
type alias Nat131 =
    Nat131Plus Z


{-| Exact the natural number 132.
-}
type alias Nat132 =
    Nat132Plus Z


{-| Exact the natural number 133.
-}
type alias Nat133 =
    Nat133Plus Z


{-| Exact the natural number 134.
-}
type alias Nat134 =
    Nat134Plus Z


{-| Exact the natural number 135.
-}
type alias Nat135 =
    Nat135Plus Z


{-| Exact the natural number 136.
-}
type alias Nat136 =
    Nat136Plus Z


{-| Exact the natural number 137.
-}
type alias Nat137 =
    Nat137Plus Z


{-| Exact the natural number 138.
-}
type alias Nat138 =
    Nat138Plus Z


{-| Exact the natural number 139.
-}
type alias Nat139 =
    Nat139Plus Z


{-| Exact the natural number 140.
-}
type alias Nat140 =
    Nat140Plus Z


{-| Exact the natural number 141.
-}
type alias Nat141 =
    Nat141Plus Z


{-| Exact the natural number 142.
-}
type alias Nat142 =
    Nat142Plus Z


{-| Exact the natural number 143.
-}
type alias Nat143 =
    Nat143Plus Z


{-| Exact the natural number 144.
-}
type alias Nat144 =
    Nat144Plus Z


{-| Exact the natural number 145.
-}
type alias Nat145 =
    Nat145Plus Z


{-| Exact the natural number 146.
-}
type alias Nat146 =
    Nat146Plus Z


{-| Exact the natural number 147.
-}
type alias Nat147 =
    Nat147Plus Z


{-| Exact the natural number 148.
-}
type alias Nat148 =
    Nat148Plus Z


{-| Exact the natural number 149.
-}
type alias Nat149 =
    Nat149Plus Z


{-| Exact the natural number 150.
-}
type alias Nat150 =
    Nat150Plus Z


{-| Exact the natural number 151.
-}
type alias Nat151 =
    Nat151Plus Z


{-| Exact the natural number 152.
-}
type alias Nat152 =
    Nat152Plus Z


{-| Exact the natural number 153.
-}
type alias Nat153 =
    Nat153Plus Z


{-| Exact the natural number 154.
-}
type alias Nat154 =
    Nat154Plus Z


{-| Exact the natural number 155.
-}
type alias Nat155 =
    Nat155Plus Z


{-| Exact the natural number 156.
-}
type alias Nat156 =
    Nat156Plus Z


{-| Exact the natural number 157.
-}
type alias Nat157 =
    Nat157Plus Z


{-| Exact the natural number 158.
-}
type alias Nat158 =
    Nat158Plus Z


{-| Exact the natural number 159.
-}
type alias Nat159 =
    Nat159Plus Z


{-| Exact the natural number 160.
-}
type alias Nat160 =
    Nat160Plus Z
