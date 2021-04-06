module TypeNats exposing
    ( Nat100Plus, Nat101Plus, Nat102Plus, Nat103Plus, Nat104Plus, Nat105Plus
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
    , Nat160Plus, Nat161Plus, Nat162Plus, Nat163Plus, Nat164Plus, Nat165Plus
    , Nat166Plus, Nat167Plus, Nat168Plus, Nat169Plus, Nat16Plus, Nat170Plus
    , Nat171Plus, Nat172Plus, Nat173Plus, Nat174Plus, Nat175Plus, Nat176Plus
    , Nat177Plus, Nat178Plus, Nat179Plus, Nat17Plus, Nat180Plus, Nat181Plus
    , Nat182Plus, Nat183Plus, Nat184Plus, Nat185Plus, Nat186Plus, Nat187Plus
    , Nat188Plus, Nat189Plus, Nat18Plus, Nat190Plus, Nat191Plus, Nat192Plus
    , Nat19Plus, Nat1Plus, Nat20Plus, Nat21Plus, Nat22Plus, Nat23Plus, Nat24Plus
    , Nat25Plus, Nat26Plus, Nat27Plus, Nat28Plus, Nat29Plus, Nat2Plus, Nat30Plus
    , Nat31Plus, Nat32Plus, Nat33Plus, Nat34Plus, Nat35Plus, Nat36Plus, Nat37Plus
    , Nat38Plus, Nat39Plus, Nat3Plus, Nat40Plus, Nat41Plus, Nat42Plus, Nat43Plus
    , Nat44Plus, Nat45Plus, Nat46Plus, Nat47Plus, Nat48Plus, Nat49Plus, Nat4Plus
    , Nat50Plus, Nat51Plus, Nat52Plus, Nat53Plus, Nat54Plus, Nat55Plus, Nat56Plus
    , Nat57Plus, Nat58Plus, Nat59Plus, Nat5Plus, Nat60Plus, Nat61Plus, Nat62Plus
    , Nat63Plus, Nat64Plus, Nat65Plus, Nat66Plus, Nat67Plus, Nat68Plus, Nat69Plus
    , Nat6Plus, Nat70Plus, Nat71Plus, Nat72Plus, Nat73Plus, Nat74Plus, Nat75Plus
    , Nat76Plus, Nat77Plus, Nat78Plus, Nat79Plus, Nat7Plus, Nat80Plus, Nat81Plus
    , Nat82Plus, Nat83Plus, Nat84Plus, Nat85Plus, Nat86Plus, Nat87Plus, Nat88Plus
    , Nat89Plus, Nat8Plus, Nat90Plus, Nat91Plus, Nat92Plus, Nat93Plus, Nat94Plus
    , Nat95Plus, Nat96Plus, Nat97Plus, Nat98Plus, Nat99Plus, Nat9Plus
    , Nat0, Nat1, Nat10, Nat100, Nat101, Nat102, Nat103, Nat104, Nat105, Nat106, Nat107
    , Nat108, Nat109, Nat11, Nat110, Nat111, Nat112, Nat113, Nat114, Nat115, Nat116
    , Nat117, Nat118, Nat119, Nat12, Nat120, Nat121, Nat122, Nat123, Nat124, Nat125
    , Nat126, Nat127, Nat128, Nat129, Nat13, Nat130, Nat131, Nat132, Nat133, Nat134
    , Nat135, Nat136, Nat137, Nat138, Nat139, Nat14, Nat140, Nat141, Nat142, Nat143
    , Nat144, Nat145, Nat146, Nat147, Nat148, Nat149, Nat15, Nat150, Nat151, Nat152
    , Nat153, Nat154, Nat155, Nat156, Nat157, Nat158, Nat159, Nat16, Nat160, Nat161
    , Nat162, Nat163, Nat164, Nat165, Nat166, Nat167, Nat168, Nat169, Nat17, Nat170
    , Nat171, Nat172, Nat173, Nat174, Nat175, Nat176, Nat177, Nat178, Nat179, Nat18
    , Nat180, Nat181, Nat182, Nat183, Nat184, Nat185, Nat186, Nat187, Nat188, Nat189
    , Nat19, Nat190, Nat191, Nat192, Nat2, Nat20, Nat21, Nat22, Nat23, Nat24, Nat25, Nat26
    , Nat27, Nat28, Nat29, Nat3, Nat30, Nat31, Nat32, Nat33, Nat34, Nat35, Nat36, Nat37, Nat38
    , Nat39, Nat4, Nat40, Nat41, Nat42, Nat43, Nat44, Nat45, Nat46, Nat47, Nat48, Nat49, Nat5
    , Nat50, Nat51, Nat52, Nat53, Nat54, Nat55, Nat56, Nat57, Nat58, Nat59, Nat6, Nat60, Nat61
    , Nat62, Nat63, Nat64, Nat65, Nat66, Nat67, Nat68, Nat69, Nat7, Nat70, Nat71, Nat72, Nat73
    , Nat74, Nat75, Nat76, Nat77, Nat78, Nat79, Nat8, Nat80, Nat81, Nat82, Nat83, Nat84, Nat85
    , Nat86, Nat87, Nat88, Nat89, Nat9, Nat90, Nat91, Nat92, Nat93, Nat94, Nat95, Nat96, Nat97
    , Nat98, Nat99
    )

{-| Express exact natural numbers in a type.

    onlyExact1 : Nat (Only Nat1 maybeN) -> Cake

  - `takesOnlyExact1 nat10` is a compile-time error

```
add2 : Nat (Only n maybeN) -> Nat (ValueOnly (Nat2Plus n))
```

  - `add2 nat2` is of type `Nat (ValueOnly Nat4)`


### about a big limitation

Sadly, while experimenting with type aliases, I discovered that type aliases can only expand so much.

    compilingGetsKilled : Nat (N (Nat100Plus Nat93) x y)

If a type alias is not fully expanded after ~192 tries,

  - the compilation stops

  - the elm-stuff can corrupt


## at least

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
@docs Nat160Plus, Nat161Plus, Nat162Plus, Nat163Plus, Nat164Plus, Nat165Plus
@docs Nat166Plus, Nat167Plus, Nat168Plus, Nat169Plus, Nat16Plus, Nat170Plus
@docs Nat171Plus, Nat172Plus, Nat173Plus, Nat174Plus, Nat175Plus, Nat176Plus
@docs Nat177Plus, Nat178Plus, Nat179Plus, Nat17Plus, Nat180Plus, Nat181Plus
@docs Nat182Plus, Nat183Plus, Nat184Plus, Nat185Plus, Nat186Plus, Nat187Plus
@docs Nat188Plus, Nat189Plus, Nat18Plus, Nat190Plus, Nat191Plus, Nat192Plus
@docs Nat19Plus, Nat1Plus, Nat20Plus, Nat21Plus, Nat22Plus, Nat23Plus, Nat24Plus
@docs Nat25Plus, Nat26Plus, Nat27Plus, Nat28Plus, Nat29Plus, Nat2Plus, Nat30Plus
@docs Nat31Plus, Nat32Plus, Nat33Plus, Nat34Plus, Nat35Plus, Nat36Plus, Nat37Plus
@docs Nat38Plus, Nat39Plus, Nat3Plus, Nat40Plus, Nat41Plus, Nat42Plus, Nat43Plus
@docs Nat44Plus, Nat45Plus, Nat46Plus, Nat47Plus, Nat48Plus, Nat49Plus, Nat4Plus
@docs Nat50Plus, Nat51Plus, Nat52Plus, Nat53Plus, Nat54Plus, Nat55Plus, Nat56Plus
@docs Nat57Plus, Nat58Plus, Nat59Plus, Nat5Plus, Nat60Plus, Nat61Plus, Nat62Plus
@docs Nat63Plus, Nat64Plus, Nat65Plus, Nat66Plus, Nat67Plus, Nat68Plus, Nat69Plus
@docs Nat6Plus, Nat70Plus, Nat71Plus, Nat72Plus, Nat73Plus, Nat74Plus, Nat75Plus
@docs Nat76Plus, Nat77Plus, Nat78Plus, Nat79Plus, Nat7Plus, Nat80Plus, Nat81Plus
@docs Nat82Plus, Nat83Plus, Nat84Plus, Nat85Plus, Nat86Plus, Nat87Plus, Nat88Plus
@docs Nat89Plus, Nat8Plus, Nat90Plus, Nat91Plus, Nat92Plus, Nat93Plus, Nat94Plus
@docs Nat95Plus, Nat96Plus, Nat97Plus, Nat98Plus, Nat99Plus, Nat9Plus


## exact

@docs Nat0, Nat1, Nat10, Nat100, Nat101, Nat102, Nat103, Nat104, Nat105, Nat106, Nat107
@docs Nat108, Nat109, Nat11, Nat110, Nat111, Nat112, Nat113, Nat114, Nat115, Nat116
@docs Nat117, Nat118, Nat119, Nat12, Nat120, Nat121, Nat122, Nat123, Nat124, Nat125
@docs Nat126, Nat127, Nat128, Nat129, Nat13, Nat130, Nat131, Nat132, Nat133, Nat134
@docs Nat135, Nat136, Nat137, Nat138, Nat139, Nat14, Nat140, Nat141, Nat142, Nat143
@docs Nat144, Nat145, Nat146, Nat147, Nat148, Nat149, Nat15, Nat150, Nat151, Nat152
@docs Nat153, Nat154, Nat155, Nat156, Nat157, Nat158, Nat159, Nat16, Nat160, Nat161
@docs Nat162, Nat163, Nat164, Nat165, Nat166, Nat167, Nat168, Nat169, Nat17, Nat170
@docs Nat171, Nat172, Nat173, Nat174, Nat175, Nat176, Nat177, Nat178, Nat179, Nat18
@docs Nat180, Nat181, Nat182, Nat183, Nat184, Nat185, Nat186, Nat187, Nat188, Nat189
@docs Nat19, Nat190, Nat191, Nat192, Nat2, Nat20, Nat21, Nat22, Nat23, Nat24, Nat25, Nat26
@docs Nat27, Nat28, Nat29, Nat3, Nat30, Nat31, Nat32, Nat33, Nat34, Nat35, Nat36, Nat37, Nat38
@docs Nat39, Nat4, Nat40, Nat41, Nat42, Nat43, Nat44, Nat45, Nat46, Nat47, Nat48, Nat49, Nat5
@docs Nat50, Nat51, Nat52, Nat53, Nat54, Nat55, Nat56, Nat57, Nat58, Nat59, Nat6, Nat60, Nat61
@docs Nat62, Nat63, Nat64, Nat65, Nat66, Nat67, Nat68, Nat69, Nat7, Nat70, Nat71, Nat72, Nat73
@docs Nat74, Nat75, Nat76, Nat77, Nat78, Nat79, Nat8, Nat80, Nat81, Nat82, Nat83, Nat84, Nat85
@docs Nat86, Nat87, Nat88, Nat89, Nat9, Nat90, Nat91, Nat92, Nat93, Nat94, Nat95, Nat96, Nat97
@docs Nat98, Nat99

-}

import N


{-| 1 + some n, which is at least 1.
-}
type alias Nat1Plus n =
    N.Nat1Plus n


{-| 2 + some n, which is at least 2.
-}
type alias Nat2Plus n =
    N.Nat2Plus n


{-| 3 + some n, which is at least 3.
-}
type alias Nat3Plus n =
    N.Nat3Plus n


{-| 4 + some n, which is at least 4.
-}
type alias Nat4Plus n =
    N.Nat4Plus n


{-| 5 + some n, which is at least 5.
-}
type alias Nat5Plus n =
    N.Nat5Plus n


{-| 6 + some n, which is at least 6.
-}
type alias Nat6Plus n =
    N.Nat6Plus n


{-| 7 + some n, which is at least 7.
-}
type alias Nat7Plus n =
    N.Nat7Plus n


{-| 8 + some n, which is at least 8.
-}
type alias Nat8Plus n =
    N.Nat8Plus n


{-| 9 + some n, which is at least 9.
-}
type alias Nat9Plus n =
    N.Nat9Plus n


{-| 10 + some n, which is at least 10.
-}
type alias Nat10Plus n =
    N.Nat10Plus n


{-| 11 + some n, which is at least 11.
-}
type alias Nat11Plus n =
    N.Nat11Plus n


{-| 12 + some n, which is at least 12.
-}
type alias Nat12Plus n =
    N.Nat12Plus n


{-| 13 + some n, which is at least 13.
-}
type alias Nat13Plus n =
    N.Nat13Plus n


{-| 14 + some n, which is at least 14.
-}
type alias Nat14Plus n =
    N.Nat14Plus n


{-| 15 + some n, which is at least 15.
-}
type alias Nat15Plus n =
    N.Nat15Plus n


{-| 16 + some n, which is at least 16.
-}
type alias Nat16Plus n =
    N.Nat16Plus n


{-| 17 + some n, which is at least 17.
-}
type alias Nat17Plus n =
    N.Nat17Plus n


{-| 18 + some n, which is at least 18.
-}
type alias Nat18Plus n =
    N.Nat18Plus n


{-| 19 + some n, which is at least 19.
-}
type alias Nat19Plus n =
    N.Nat19Plus n


{-| 20 + some n, which is at least 20.
-}
type alias Nat20Plus n =
    N.Nat20Plus n


{-| 21 + some n, which is at least 21.
-}
type alias Nat21Plus n =
    N.Nat21Plus n


{-| 22 + some n, which is at least 22.
-}
type alias Nat22Plus n =
    N.Nat22Plus n


{-| 23 + some n, which is at least 23.
-}
type alias Nat23Plus n =
    N.Nat23Plus n


{-| 24 + some n, which is at least 24.
-}
type alias Nat24Plus n =
    N.Nat24Plus n


{-| 25 + some n, which is at least 25.
-}
type alias Nat25Plus n =
    N.Nat25Plus n


{-| 26 + some n, which is at least 26.
-}
type alias Nat26Plus n =
    N.Nat26Plus n


{-| 27 + some n, which is at least 27.
-}
type alias Nat27Plus n =
    N.Nat27Plus n


{-| 28 + some n, which is at least 28.
-}
type alias Nat28Plus n =
    N.Nat28Plus n


{-| 29 + some n, which is at least 29.
-}
type alias Nat29Plus n =
    N.Nat29Plus n


{-| 30 + some n, which is at least 30.
-}
type alias Nat30Plus n =
    N.Nat30Plus n


{-| 31 + some n, which is at least 31.
-}
type alias Nat31Plus n =
    N.Nat31Plus n


{-| 32 + some n, which is at least 32.
-}
type alias Nat32Plus n =
    N.Nat32Plus n


{-| 33 + some n, which is at least 33.
-}
type alias Nat33Plus n =
    N.Nat33Plus n


{-| 34 + some n, which is at least 34.
-}
type alias Nat34Plus n =
    N.Nat34Plus n


{-| 35 + some n, which is at least 35.
-}
type alias Nat35Plus n =
    N.Nat35Plus n


{-| 36 + some n, which is at least 36.
-}
type alias Nat36Plus n =
    N.Nat36Plus n


{-| 37 + some n, which is at least 37.
-}
type alias Nat37Plus n =
    N.Nat37Plus n


{-| 38 + some n, which is at least 38.
-}
type alias Nat38Plus n =
    N.Nat38Plus n


{-| 39 + some n, which is at least 39.
-}
type alias Nat39Plus n =
    N.Nat39Plus n


{-| 40 + some n, which is at least 40.
-}
type alias Nat40Plus n =
    N.Nat40Plus n


{-| 41 + some n, which is at least 41.
-}
type alias Nat41Plus n =
    N.Nat41Plus n


{-| 42 + some n, which is at least 42.
-}
type alias Nat42Plus n =
    N.Nat42Plus n


{-| 43 + some n, which is at least 43.
-}
type alias Nat43Plus n =
    N.Nat43Plus n


{-| 44 + some n, which is at least 44.
-}
type alias Nat44Plus n =
    N.Nat44Plus n


{-| 45 + some n, which is at least 45.
-}
type alias Nat45Plus n =
    N.Nat45Plus n


{-| 46 + some n, which is at least 46.
-}
type alias Nat46Plus n =
    N.Nat46Plus n


{-| 47 + some n, which is at least 47.
-}
type alias Nat47Plus n =
    N.Nat47Plus n


{-| 48 + some n, which is at least 48.
-}
type alias Nat48Plus n =
    N.Nat48Plus n


{-| 49 + some n, which is at least 49.
-}
type alias Nat49Plus n =
    N.Nat49Plus n


{-| 50 + some n, which is at least 50.
-}
type alias Nat50Plus n =
    N.Nat50Plus n


{-| 51 + some n, which is at least 51.
-}
type alias Nat51Plus n =
    N.Nat51Plus n


{-| 52 + some n, which is at least 52.
-}
type alias Nat52Plus n =
    N.Nat52Plus n


{-| 53 + some n, which is at least 53.
-}
type alias Nat53Plus n =
    N.Nat53Plus n


{-| 54 + some n, which is at least 54.
-}
type alias Nat54Plus n =
    N.Nat54Plus n


{-| 55 + some n, which is at least 55.
-}
type alias Nat55Plus n =
    N.Nat55Plus n


{-| 56 + some n, which is at least 56.
-}
type alias Nat56Plus n =
    N.Nat56Plus n


{-| 57 + some n, which is at least 57.
-}
type alias Nat57Plus n =
    N.Nat57Plus n


{-| 58 + some n, which is at least 58.
-}
type alias Nat58Plus n =
    N.Nat58Plus n


{-| 59 + some n, which is at least 59.
-}
type alias Nat59Plus n =
    N.Nat59Plus n


{-| 60 + some n, which is at least 60.
-}
type alias Nat60Plus n =
    N.Nat60Plus n


{-| 61 + some n, which is at least 61.
-}
type alias Nat61Plus n =
    N.Nat61Plus n


{-| 62 + some n, which is at least 62.
-}
type alias Nat62Plus n =
    N.Nat62Plus n


{-| 63 + some n, which is at least 63.
-}
type alias Nat63Plus n =
    N.Nat63Plus n


{-| 64 + some n, which is at least 64.
-}
type alias Nat64Plus n =
    N.Nat64Plus n


{-| 65 + some n, which is at least 65.
-}
type alias Nat65Plus n =
    N.Nat65Plus n


{-| 66 + some n, which is at least 66.
-}
type alias Nat66Plus n =
    N.Nat66Plus n


{-| 67 + some n, which is at least 67.
-}
type alias Nat67Plus n =
    N.Nat67Plus n


{-| 68 + some n, which is at least 68.
-}
type alias Nat68Plus n =
    N.Nat68Plus n


{-| 69 + some n, which is at least 69.
-}
type alias Nat69Plus n =
    N.Nat69Plus n


{-| 70 + some n, which is at least 70.
-}
type alias Nat70Plus n =
    N.Nat70Plus n


{-| 71 + some n, which is at least 71.
-}
type alias Nat71Plus n =
    N.Nat71Plus n


{-| 72 + some n, which is at least 72.
-}
type alias Nat72Plus n =
    N.Nat72Plus n


{-| 73 + some n, which is at least 73.
-}
type alias Nat73Plus n =
    N.Nat73Plus n


{-| 74 + some n, which is at least 74.
-}
type alias Nat74Plus n =
    N.Nat74Plus n


{-| 75 + some n, which is at least 75.
-}
type alias Nat75Plus n =
    N.Nat75Plus n


{-| 76 + some n, which is at least 76.
-}
type alias Nat76Plus n =
    N.Nat76Plus n


{-| 77 + some n, which is at least 77.
-}
type alias Nat77Plus n =
    N.Nat77Plus n


{-| 78 + some n, which is at least 78.
-}
type alias Nat78Plus n =
    N.Nat78Plus n


{-| 79 + some n, which is at least 79.
-}
type alias Nat79Plus n =
    N.Nat79Plus n


{-| 80 + some n, which is at least 80.
-}
type alias Nat80Plus n =
    N.Nat80Plus n


{-| 81 + some n, which is at least 81.
-}
type alias Nat81Plus n =
    N.Nat81Plus n


{-| 82 + some n, which is at least 82.
-}
type alias Nat82Plus n =
    N.Nat82Plus n


{-| 83 + some n, which is at least 83.
-}
type alias Nat83Plus n =
    N.Nat83Plus n


{-| 84 + some n, which is at least 84.
-}
type alias Nat84Plus n =
    N.Nat84Plus n


{-| 85 + some n, which is at least 85.
-}
type alias Nat85Plus n =
    N.Nat85Plus n


{-| 86 + some n, which is at least 86.
-}
type alias Nat86Plus n =
    N.Nat86Plus n


{-| 87 + some n, which is at least 87.
-}
type alias Nat87Plus n =
    N.Nat87Plus n


{-| 88 + some n, which is at least 88.
-}
type alias Nat88Plus n =
    N.Nat88Plus n


{-| 89 + some n, which is at least 89.
-}
type alias Nat89Plus n =
    N.Nat89Plus n


{-| 90 + some n, which is at least 90.
-}
type alias Nat90Plus n =
    N.Nat90Plus n


{-| 91 + some n, which is at least 91.
-}
type alias Nat91Plus n =
    N.Nat91Plus n


{-| 92 + some n, which is at least 92.
-}
type alias Nat92Plus n =
    N.Nat92Plus n


{-| 93 + some n, which is at least 93.
-}
type alias Nat93Plus n =
    N.Nat93Plus n


{-| 94 + some n, which is at least 94.
-}
type alias Nat94Plus n =
    N.Nat94Plus n


{-| 95 + some n, which is at least 95.
-}
type alias Nat95Plus n =
    N.Nat95Plus n


{-| 96 + some n, which is at least 96.
-}
type alias Nat96Plus n =
    N.Nat96Plus n


{-| 97 + some n, which is at least 97.
-}
type alias Nat97Plus n =
    N.Nat97Plus n


{-| 98 + some n, which is at least 98.
-}
type alias Nat98Plus n =
    N.Nat98Plus n


{-| 99 + some n, which is at least 99.
-}
type alias Nat99Plus n =
    N.Nat99Plus n


{-| 100 + some n, which is at least 100.
-}
type alias Nat100Plus n =
    N.Nat100Plus n


{-| 101 + some n, which is at least 101.
-}
type alias Nat101Plus n =
    N.Nat101Plus n


{-| 102 + some n, which is at least 102.
-}
type alias Nat102Plus n =
    N.Nat102Plus n


{-| 103 + some n, which is at least 103.
-}
type alias Nat103Plus n =
    N.Nat103Plus n


{-| 104 + some n, which is at least 104.
-}
type alias Nat104Plus n =
    N.Nat104Plus n


{-| 105 + some n, which is at least 105.
-}
type alias Nat105Plus n =
    N.Nat105Plus n


{-| 106 + some n, which is at least 106.
-}
type alias Nat106Plus n =
    N.Nat106Plus n


{-| 107 + some n, which is at least 107.
-}
type alias Nat107Plus n =
    N.Nat107Plus n


{-| 108 + some n, which is at least 108.
-}
type alias Nat108Plus n =
    N.Nat108Plus n


{-| 109 + some n, which is at least 109.
-}
type alias Nat109Plus n =
    N.Nat109Plus n


{-| 110 + some n, which is at least 110.
-}
type alias Nat110Plus n =
    N.Nat110Plus n


{-| 111 + some n, which is at least 111.
-}
type alias Nat111Plus n =
    N.Nat111Plus n


{-| 112 + some n, which is at least 112.
-}
type alias Nat112Plus n =
    N.Nat112Plus n


{-| 113 + some n, which is at least 113.
-}
type alias Nat113Plus n =
    N.Nat113Plus n


{-| 114 + some n, which is at least 114.
-}
type alias Nat114Plus n =
    N.Nat114Plus n


{-| 115 + some n, which is at least 115.
-}
type alias Nat115Plus n =
    N.Nat115Plus n


{-| 116 + some n, which is at least 116.
-}
type alias Nat116Plus n =
    N.Nat116Plus n


{-| 117 + some n, which is at least 117.
-}
type alias Nat117Plus n =
    N.Nat117Plus n


{-| 118 + some n, which is at least 118.
-}
type alias Nat118Plus n =
    N.Nat118Plus n


{-| 119 + some n, which is at least 119.
-}
type alias Nat119Plus n =
    N.Nat119Plus n


{-| 120 + some n, which is at least 120.
-}
type alias Nat120Plus n =
    N.Nat120Plus n


{-| 121 + some n, which is at least 121.
-}
type alias Nat121Plus n =
    N.Nat121Plus n


{-| 122 + some n, which is at least 122.
-}
type alias Nat122Plus n =
    N.Nat122Plus n


{-| 123 + some n, which is at least 123.
-}
type alias Nat123Plus n =
    N.Nat123Plus n


{-| 124 + some n, which is at least 124.
-}
type alias Nat124Plus n =
    N.Nat124Plus n


{-| 125 + some n, which is at least 125.
-}
type alias Nat125Plus n =
    N.Nat125Plus n


{-| 126 + some n, which is at least 126.
-}
type alias Nat126Plus n =
    N.Nat126Plus n


{-| 127 + some n, which is at least 127.
-}
type alias Nat127Plus n =
    N.Nat127Plus n


{-| 128 + some n, which is at least 128.
-}
type alias Nat128Plus n =
    N.Nat128Plus n


{-| 129 + some n, which is at least 129.
-}
type alias Nat129Plus n =
    N.Nat129Plus n


{-| 130 + some n, which is at least 130.
-}
type alias Nat130Plus n =
    N.Nat130Plus n


{-| 131 + some n, which is at least 131.
-}
type alias Nat131Plus n =
    N.Nat131Plus n


{-| 132 + some n, which is at least 132.
-}
type alias Nat132Plus n =
    N.Nat132Plus n


{-| 133 + some n, which is at least 133.
-}
type alias Nat133Plus n =
    N.Nat133Plus n


{-| 134 + some n, which is at least 134.
-}
type alias Nat134Plus n =
    N.Nat134Plus n


{-| 135 + some n, which is at least 135.
-}
type alias Nat135Plus n =
    N.Nat135Plus n


{-| 136 + some n, which is at least 136.
-}
type alias Nat136Plus n =
    N.Nat136Plus n


{-| 137 + some n, which is at least 137.
-}
type alias Nat137Plus n =
    N.Nat137Plus n


{-| 138 + some n, which is at least 138.
-}
type alias Nat138Plus n =
    N.Nat138Plus n


{-| 139 + some n, which is at least 139.
-}
type alias Nat139Plus n =
    N.Nat139Plus n


{-| 140 + some n, which is at least 140.
-}
type alias Nat140Plus n =
    N.Nat140Plus n


{-| 141 + some n, which is at least 141.
-}
type alias Nat141Plus n =
    N.Nat141Plus n


{-| 142 + some n, which is at least 142.
-}
type alias Nat142Plus n =
    N.Nat142Plus n


{-| 143 + some n, which is at least 143.
-}
type alias Nat143Plus n =
    N.Nat143Plus n


{-| 144 + some n, which is at least 144.
-}
type alias Nat144Plus n =
    N.Nat144Plus n


{-| 145 + some n, which is at least 145.
-}
type alias Nat145Plus n =
    N.Nat145Plus n


{-| 146 + some n, which is at least 146.
-}
type alias Nat146Plus n =
    N.Nat146Plus n


{-| 147 + some n, which is at least 147.
-}
type alias Nat147Plus n =
    N.Nat147Plus n


{-| 148 + some n, which is at least 148.
-}
type alias Nat148Plus n =
    N.Nat148Plus n


{-| 149 + some n, which is at least 149.
-}
type alias Nat149Plus n =
    N.Nat149Plus n


{-| 150 + some n, which is at least 150.
-}
type alias Nat150Plus n =
    N.Nat150Plus n


{-| 151 + some n, which is at least 151.
-}
type alias Nat151Plus n =
    N.Nat151Plus n


{-| 152 + some n, which is at least 152.
-}
type alias Nat152Plus n =
    N.Nat152Plus n


{-| 153 + some n, which is at least 153.
-}
type alias Nat153Plus n =
    N.Nat153Plus n


{-| 154 + some n, which is at least 154.
-}
type alias Nat154Plus n =
    N.Nat154Plus n


{-| 155 + some n, which is at least 155.
-}
type alias Nat155Plus n =
    N.Nat155Plus n


{-| 156 + some n, which is at least 156.
-}
type alias Nat156Plus n =
    N.Nat156Plus n


{-| 157 + some n, which is at least 157.
-}
type alias Nat157Plus n =
    N.Nat157Plus n


{-| 158 + some n, which is at least 158.
-}
type alias Nat158Plus n =
    N.Nat158Plus n


{-| 159 + some n, which is at least 159.
-}
type alias Nat159Plus n =
    N.Nat159Plus n


{-| 160 + some n, which is at least 160.
-}
type alias Nat160Plus n =
    N.Nat160Plus n


{-| 161 + some n, which is at least 161.
-}
type alias Nat161Plus n =
    N.Nat161Plus n


{-| 162 + some n, which is at least 162.
-}
type alias Nat162Plus n =
    N.Nat162Plus n


{-| 163 + some n, which is at least 163.
-}
type alias Nat163Plus n =
    N.Nat163Plus n


{-| 164 + some n, which is at least 164.
-}
type alias Nat164Plus n =
    N.Nat164Plus n


{-| 165 + some n, which is at least 165.
-}
type alias Nat165Plus n =
    N.Nat165Plus n


{-| 166 + some n, which is at least 166.
-}
type alias Nat166Plus n =
    N.Nat166Plus n


{-| 167 + some n, which is at least 167.
-}
type alias Nat167Plus n =
    N.Nat167Plus n


{-| 168 + some n, which is at least 168.
-}
type alias Nat168Plus n =
    N.Nat168Plus n


{-| 169 + some n, which is at least 169.
-}
type alias Nat169Plus n =
    N.Nat169Plus n


{-| 170 + some n, which is at least 170.
-}
type alias Nat170Plus n =
    N.Nat170Plus n


{-| 171 + some n, which is at least 171.
-}
type alias Nat171Plus n =
    N.Nat171Plus n


{-| 172 + some n, which is at least 172.
-}
type alias Nat172Plus n =
    N.Nat172Plus n


{-| 173 + some n, which is at least 173.
-}
type alias Nat173Plus n =
    N.Nat173Plus n


{-| 174 + some n, which is at least 174.
-}
type alias Nat174Plus n =
    N.Nat174Plus n


{-| 175 + some n, which is at least 175.
-}
type alias Nat175Plus n =
    N.Nat175Plus n


{-| 176 + some n, which is at least 176.
-}
type alias Nat176Plus n =
    N.Nat176Plus n


{-| 177 + some n, which is at least 177.
-}
type alias Nat177Plus n =
    N.Nat177Plus n


{-| 178 + some n, which is at least 178.
-}
type alias Nat178Plus n =
    N.Nat178Plus n


{-| 179 + some n, which is at least 179.
-}
type alias Nat179Plus n =
    N.Nat179Plus n


{-| 180 + some n, which is at least 180.
-}
type alias Nat180Plus n =
    N.Nat180Plus n


{-| 181 + some n, which is at least 181.
-}
type alias Nat181Plus n =
    N.Nat181Plus n


{-| 182 + some n, which is at least 182.
-}
type alias Nat182Plus n =
    N.Nat182Plus n


{-| 183 + some n, which is at least 183.
-}
type alias Nat183Plus n =
    N.Nat183Plus n


{-| 184 + some n, which is at least 184.
-}
type alias Nat184Plus n =
    N.Nat184Plus n


{-| 185 + some n, which is at least 185.
-}
type alias Nat185Plus n =
    N.Nat185Plus n


{-| 186 + some n, which is at least 186.
-}
type alias Nat186Plus n =
    N.Nat186Plus n


{-| 187 + some n, which is at least 187.
-}
type alias Nat187Plus n =
    N.Nat187Plus n


{-| 188 + some n, which is at least 188.
-}
type alias Nat188Plus n =
    N.Nat188Plus n


{-| 189 + some n, which is at least 189.
-}
type alias Nat189Plus n =
    N.Nat189Plus n


{-| 190 + some n, which is at least 190.
-}
type alias Nat190Plus n =
    N.Nat190Plus n


{-| 191 + some n, which is at least 191.
-}
type alias Nat191Plus n =
    N.Nat191Plus n


{-| 192 + some n, which is at least 192.
-}
type alias Nat192Plus n =
    N.Nat192Plus n


{-| Exact the natural number 0.
-}
type alias Nat0 =
    N.Nat0


{-| Exact the natural number 1.
-}
type alias Nat1 =
    N.Nat1


{-| Exact the natural number 2.
-}
type alias Nat2 =
    N.Nat2


{-| Exact the natural number 3.
-}
type alias Nat3 =
    N.Nat3


{-| Exact the natural number 4.
-}
type alias Nat4 =
    N.Nat4


{-| Exact the natural number 5.
-}
type alias Nat5 =
    N.Nat5


{-| Exact the natural number 6.
-}
type alias Nat6 =
    N.Nat6


{-| Exact the natural number 7.
-}
type alias Nat7 =
    N.Nat7


{-| Exact the natural number 8.
-}
type alias Nat8 =
    N.Nat8


{-| Exact the natural number 9.
-}
type alias Nat9 =
    N.Nat9


{-| Exact the natural number 10.
-}
type alias Nat10 =
    N.Nat10


{-| Exact the natural number 11.
-}
type alias Nat11 =
    N.Nat11


{-| Exact the natural number 12.
-}
type alias Nat12 =
    N.Nat12


{-| Exact the natural number 13.
-}
type alias Nat13 =
    N.Nat13


{-| Exact the natural number 14.
-}
type alias Nat14 =
    N.Nat14


{-| Exact the natural number 15.
-}
type alias Nat15 =
    N.Nat15


{-| Exact the natural number 16.
-}
type alias Nat16 =
    N.Nat16


{-| Exact the natural number 17.
-}
type alias Nat17 =
    N.Nat17


{-| Exact the natural number 18.
-}
type alias Nat18 =
    N.Nat18


{-| Exact the natural number 19.
-}
type alias Nat19 =
    N.Nat19


{-| Exact the natural number 20.
-}
type alias Nat20 =
    N.Nat20


{-| Exact the natural number 21.
-}
type alias Nat21 =
    N.Nat21


{-| Exact the natural number 22.
-}
type alias Nat22 =
    N.Nat22


{-| Exact the natural number 23.
-}
type alias Nat23 =
    N.Nat23


{-| Exact the natural number 24.
-}
type alias Nat24 =
    N.Nat24


{-| Exact the natural number 25.
-}
type alias Nat25 =
    N.Nat25


{-| Exact the natural number 26.
-}
type alias Nat26 =
    N.Nat26


{-| Exact the natural number 27.
-}
type alias Nat27 =
    N.Nat27


{-| Exact the natural number 28.
-}
type alias Nat28 =
    N.Nat28


{-| Exact the natural number 29.
-}
type alias Nat29 =
    N.Nat29


{-| Exact the natural number 30.
-}
type alias Nat30 =
    N.Nat30


{-| Exact the natural number 31.
-}
type alias Nat31 =
    N.Nat31


{-| Exact the natural number 32.
-}
type alias Nat32 =
    N.Nat32


{-| Exact the natural number 33.
-}
type alias Nat33 =
    N.Nat33


{-| Exact the natural number 34.
-}
type alias Nat34 =
    N.Nat34


{-| Exact the natural number 35.
-}
type alias Nat35 =
    N.Nat35


{-| Exact the natural number 36.
-}
type alias Nat36 =
    N.Nat36


{-| Exact the natural number 37.
-}
type alias Nat37 =
    N.Nat37


{-| Exact the natural number 38.
-}
type alias Nat38 =
    N.Nat38


{-| Exact the natural number 39.
-}
type alias Nat39 =
    N.Nat39


{-| Exact the natural number 40.
-}
type alias Nat40 =
    N.Nat40


{-| Exact the natural number 41.
-}
type alias Nat41 =
    N.Nat41


{-| Exact the natural number 42.
-}
type alias Nat42 =
    N.Nat42


{-| Exact the natural number 43.
-}
type alias Nat43 =
    N.Nat43


{-| Exact the natural number 44.
-}
type alias Nat44 =
    N.Nat44


{-| Exact the natural number 45.
-}
type alias Nat45 =
    N.Nat45


{-| Exact the natural number 46.
-}
type alias Nat46 =
    N.Nat46


{-| Exact the natural number 47.
-}
type alias Nat47 =
    N.Nat47


{-| Exact the natural number 48.
-}
type alias Nat48 =
    N.Nat48


{-| Exact the natural number 49.
-}
type alias Nat49 =
    N.Nat49


{-| Exact the natural number 50.
-}
type alias Nat50 =
    N.Nat50


{-| Exact the natural number 51.
-}
type alias Nat51 =
    N.Nat51


{-| Exact the natural number 52.
-}
type alias Nat52 =
    N.Nat52


{-| Exact the natural number 53.
-}
type alias Nat53 =
    N.Nat53


{-| Exact the natural number 54.
-}
type alias Nat54 =
    N.Nat54


{-| Exact the natural number 55.
-}
type alias Nat55 =
    N.Nat55


{-| Exact the natural number 56.
-}
type alias Nat56 =
    N.Nat56


{-| Exact the natural number 57.
-}
type alias Nat57 =
    N.Nat57


{-| Exact the natural number 58.
-}
type alias Nat58 =
    N.Nat58


{-| Exact the natural number 59.
-}
type alias Nat59 =
    N.Nat59


{-| Exact the natural number 60.
-}
type alias Nat60 =
    N.Nat60


{-| Exact the natural number 61.
-}
type alias Nat61 =
    N.Nat61


{-| Exact the natural number 62.
-}
type alias Nat62 =
    N.Nat62


{-| Exact the natural number 63.
-}
type alias Nat63 =
    N.Nat63


{-| Exact the natural number 64.
-}
type alias Nat64 =
    N.Nat64


{-| Exact the natural number 65.
-}
type alias Nat65 =
    N.Nat65


{-| Exact the natural number 66.
-}
type alias Nat66 =
    N.Nat66


{-| Exact the natural number 67.
-}
type alias Nat67 =
    N.Nat67


{-| Exact the natural number 68.
-}
type alias Nat68 =
    N.Nat68


{-| Exact the natural number 69.
-}
type alias Nat69 =
    N.Nat69


{-| Exact the natural number 70.
-}
type alias Nat70 =
    N.Nat70


{-| Exact the natural number 71.
-}
type alias Nat71 =
    N.Nat71


{-| Exact the natural number 72.
-}
type alias Nat72 =
    N.Nat72


{-| Exact the natural number 73.
-}
type alias Nat73 =
    N.Nat73


{-| Exact the natural number 74.
-}
type alias Nat74 =
    N.Nat74


{-| Exact the natural number 75.
-}
type alias Nat75 =
    N.Nat75


{-| Exact the natural number 76.
-}
type alias Nat76 =
    N.Nat76


{-| Exact the natural number 77.
-}
type alias Nat77 =
    N.Nat77


{-| Exact the natural number 78.
-}
type alias Nat78 =
    N.Nat78


{-| Exact the natural number 79.
-}
type alias Nat79 =
    N.Nat79


{-| Exact the natural number 80.
-}
type alias Nat80 =
    N.Nat80


{-| Exact the natural number 81.
-}
type alias Nat81 =
    N.Nat81


{-| Exact the natural number 82.
-}
type alias Nat82 =
    N.Nat82


{-| Exact the natural number 83.
-}
type alias Nat83 =
    N.Nat83


{-| Exact the natural number 84.
-}
type alias Nat84 =
    N.Nat84


{-| Exact the natural number 85.
-}
type alias Nat85 =
    N.Nat85


{-| Exact the natural number 86.
-}
type alias Nat86 =
    N.Nat86


{-| Exact the natural number 87.
-}
type alias Nat87 =
    N.Nat87


{-| Exact the natural number 88.
-}
type alias Nat88 =
    N.Nat88


{-| Exact the natural number 89.
-}
type alias Nat89 =
    N.Nat89


{-| Exact the natural number 90.
-}
type alias Nat90 =
    N.Nat90


{-| Exact the natural number 91.
-}
type alias Nat91 =
    N.Nat91


{-| Exact the natural number 92.
-}
type alias Nat92 =
    N.Nat92


{-| Exact the natural number 93.
-}
type alias Nat93 =
    N.Nat93


{-| Exact the natural number 94.
-}
type alias Nat94 =
    N.Nat94


{-| Exact the natural number 95.
-}
type alias Nat95 =
    N.Nat95


{-| Exact the natural number 96.
-}
type alias Nat96 =
    N.Nat96


{-| Exact the natural number 97.
-}
type alias Nat97 =
    N.Nat97


{-| Exact the natural number 98.
-}
type alias Nat98 =
    N.Nat98


{-| Exact the natural number 99.
-}
type alias Nat99 =
    N.Nat99


{-| Exact the natural number 100.
-}
type alias Nat100 =
    N.Nat100


{-| Exact the natural number 101.
-}
type alias Nat101 =
    N.Nat101


{-| Exact the natural number 102.
-}
type alias Nat102 =
    N.Nat102


{-| Exact the natural number 103.
-}
type alias Nat103 =
    N.Nat103


{-| Exact the natural number 104.
-}
type alias Nat104 =
    N.Nat104


{-| Exact the natural number 105.
-}
type alias Nat105 =
    N.Nat105


{-| Exact the natural number 106.
-}
type alias Nat106 =
    N.Nat106


{-| Exact the natural number 107.
-}
type alias Nat107 =
    N.Nat107


{-| Exact the natural number 108.
-}
type alias Nat108 =
    N.Nat108


{-| Exact the natural number 109.
-}
type alias Nat109 =
    N.Nat109


{-| Exact the natural number 110.
-}
type alias Nat110 =
    N.Nat110


{-| Exact the natural number 111.
-}
type alias Nat111 =
    N.Nat111


{-| Exact the natural number 112.
-}
type alias Nat112 =
    N.Nat112


{-| Exact the natural number 113.
-}
type alias Nat113 =
    N.Nat113


{-| Exact the natural number 114.
-}
type alias Nat114 =
    N.Nat114


{-| Exact the natural number 115.
-}
type alias Nat115 =
    N.Nat115


{-| Exact the natural number 116.
-}
type alias Nat116 =
    N.Nat116


{-| Exact the natural number 117.
-}
type alias Nat117 =
    N.Nat117


{-| Exact the natural number 118.
-}
type alias Nat118 =
    N.Nat118


{-| Exact the natural number 119.
-}
type alias Nat119 =
    N.Nat119


{-| Exact the natural number 120.
-}
type alias Nat120 =
    N.Nat120


{-| Exact the natural number 121.
-}
type alias Nat121 =
    N.Nat121


{-| Exact the natural number 122.
-}
type alias Nat122 =
    N.Nat122


{-| Exact the natural number 123.
-}
type alias Nat123 =
    N.Nat123


{-| Exact the natural number 124.
-}
type alias Nat124 =
    N.Nat124


{-| Exact the natural number 125.
-}
type alias Nat125 =
    N.Nat125


{-| Exact the natural number 126.
-}
type alias Nat126 =
    N.Nat126


{-| Exact the natural number 127.
-}
type alias Nat127 =
    N.Nat127


{-| Exact the natural number 128.
-}
type alias Nat128 =
    N.Nat128


{-| Exact the natural number 129.
-}
type alias Nat129 =
    N.Nat129


{-| Exact the natural number 130.
-}
type alias Nat130 =
    N.Nat130


{-| Exact the natural number 131.
-}
type alias Nat131 =
    N.Nat131


{-| Exact the natural number 132.
-}
type alias Nat132 =
    N.Nat132


{-| Exact the natural number 133.
-}
type alias Nat133 =
    N.Nat133


{-| Exact the natural number 134.
-}
type alias Nat134 =
    N.Nat134


{-| Exact the natural number 135.
-}
type alias Nat135 =
    N.Nat135


{-| Exact the natural number 136.
-}
type alias Nat136 =
    N.Nat136


{-| Exact the natural number 137.
-}
type alias Nat137 =
    N.Nat137


{-| Exact the natural number 138.
-}
type alias Nat138 =
    N.Nat138


{-| Exact the natural number 139.
-}
type alias Nat139 =
    N.Nat139


{-| Exact the natural number 140.
-}
type alias Nat140 =
    N.Nat140


{-| Exact the natural number 141.
-}
type alias Nat141 =
    N.Nat141


{-| Exact the natural number 142.
-}
type alias Nat142 =
    N.Nat142


{-| Exact the natural number 143.
-}
type alias Nat143 =
    N.Nat143


{-| Exact the natural number 144.
-}
type alias Nat144 =
    N.Nat144


{-| Exact the natural number 145.
-}
type alias Nat145 =
    N.Nat145


{-| Exact the natural number 146.
-}
type alias Nat146 =
    N.Nat146


{-| Exact the natural number 147.
-}
type alias Nat147 =
    N.Nat147


{-| Exact the natural number 148.
-}
type alias Nat148 =
    N.Nat148


{-| Exact the natural number 149.
-}
type alias Nat149 =
    N.Nat149


{-| Exact the natural number 150.
-}
type alias Nat150 =
    N.Nat150


{-| Exact the natural number 151.
-}
type alias Nat151 =
    N.Nat151


{-| Exact the natural number 152.
-}
type alias Nat152 =
    N.Nat152


{-| Exact the natural number 153.
-}
type alias Nat153 =
    N.Nat153


{-| Exact the natural number 154.
-}
type alias Nat154 =
    N.Nat154


{-| Exact the natural number 155.
-}
type alias Nat155 =
    N.Nat155


{-| Exact the natural number 156.
-}
type alias Nat156 =
    N.Nat156


{-| Exact the natural number 157.
-}
type alias Nat157 =
    N.Nat157


{-| Exact the natural number 158.
-}
type alias Nat158 =
    N.Nat158


{-| Exact the natural number 159.
-}
type alias Nat159 =
    N.Nat159


{-| Exact the natural number 160.
-}
type alias Nat160 =
    N.Nat160


{-| Exact the natural number 161.
-}
type alias Nat161 =
    N.Nat161


{-| Exact the natural number 162.
-}
type alias Nat162 =
    N.Nat162


{-| Exact the natural number 163.
-}
type alias Nat163 =
    N.Nat163


{-| Exact the natural number 164.
-}
type alias Nat164 =
    N.Nat164


{-| Exact the natural number 165.
-}
type alias Nat165 =
    N.Nat165


{-| Exact the natural number 166.
-}
type alias Nat166 =
    N.Nat166


{-| Exact the natural number 167.
-}
type alias Nat167 =
    N.Nat167


{-| Exact the natural number 168.
-}
type alias Nat168 =
    N.Nat168


{-| Exact the natural number 169.
-}
type alias Nat169 =
    N.Nat169


{-| Exact the natural number 170.
-}
type alias Nat170 =
    N.Nat170


{-| Exact the natural number 171.
-}
type alias Nat171 =
    N.Nat171


{-| Exact the natural number 172.
-}
type alias Nat172 =
    N.Nat172


{-| Exact the natural number 173.
-}
type alias Nat173 =
    N.Nat173


{-| Exact the natural number 174.
-}
type alias Nat174 =
    N.Nat174


{-| Exact the natural number 175.
-}
type alias Nat175 =
    N.Nat175


{-| Exact the natural number 176.
-}
type alias Nat176 =
    N.Nat176


{-| Exact the natural number 177.
-}
type alias Nat177 =
    N.Nat177


{-| Exact the natural number 178.
-}
type alias Nat178 =
    N.Nat178


{-| Exact the natural number 179.
-}
type alias Nat179 =
    N.Nat179


{-| Exact the natural number 180.
-}
type alias Nat180 =
    N.Nat180


{-| Exact the natural number 181.
-}
type alias Nat181 =
    N.Nat181


{-| Exact the natural number 182.
-}
type alias Nat182 =
    N.Nat182


{-| Exact the natural number 183.
-}
type alias Nat183 =
    N.Nat183


{-| Exact the natural number 184.
-}
type alias Nat184 =
    N.Nat184


{-| Exact the natural number 185.
-}
type alias Nat185 =
    N.Nat185


{-| Exact the natural number 186.
-}
type alias Nat186 =
    N.Nat186


{-| Exact the natural number 187.
-}
type alias Nat187 =
    N.Nat187


{-| Exact the natural number 188.
-}
type alias Nat188 =
    N.Nat188


{-| Exact the natural number 189.
-}
type alias Nat189 =
    N.Nat189


{-| Exact the natural number 190.
-}
type alias Nat190 =
    N.Nat190


{-| Exact the natural number 191.
-}
type alias Nat191 =
    N.Nat191


{-| Exact the natural number 192.
-}
type alias Nat192 =
    N.Nat192
