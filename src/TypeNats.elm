module TypeNats exposing (Nat0, Nat1, Nat10, Nat100, Nat100Plus, Nat101, Nat101Plus, Nat102, Nat102Plus, Nat103, Nat103Plus, Nat104, Nat104Plus, Nat105, Nat105Plus, Nat106, Nat106Plus, Nat107, Nat107Plus, Nat108, Nat108Plus, Nat109, Nat109Plus, Nat10Plus, Nat11, Nat110, Nat110Plus, Nat111, Nat111Plus, Nat112, Nat112Plus, Nat113, Nat113Plus, Nat114, Nat114Plus, Nat115, Nat115Plus, Nat116, Nat116Plus, Nat117, Nat117Plus, Nat118, Nat118Plus, Nat119, Nat119Plus, Nat11Plus, Nat12, Nat120, Nat120Plus, Nat121, Nat121Plus, Nat122, Nat122Plus, Nat123, Nat123Plus, Nat124, Nat124Plus, Nat125, Nat125Plus, Nat126, Nat126Plus, Nat127, Nat127Plus, Nat128, Nat128Plus, Nat129, Nat129Plus, Nat12Plus, Nat13, Nat130, Nat130Plus, Nat131, Nat131Plus, Nat132, Nat132Plus, Nat133, Nat133Plus, Nat134, Nat134Plus, Nat135, Nat135Plus, Nat136, Nat136Plus, Nat137, Nat137Plus, Nat138, Nat138Plus, Nat139, Nat139Plus, Nat13Plus, Nat14, Nat140, Nat140Plus, Nat141, Nat141Plus, Nat142, Nat142Plus, Nat143, Nat143Plus, Nat144, Nat144Plus, Nat145, Nat145Plus, Nat146, Nat146Plus, Nat147, Nat147Plus, Nat148, Nat148Plus, Nat149, Nat149Plus, Nat14Plus, Nat15, Nat150, Nat150Plus, Nat151, Nat151Plus, Nat152, Nat152Plus, Nat153, Nat153Plus, Nat154, Nat154Plus, Nat155, Nat155Plus, Nat156, Nat156Plus, Nat157, Nat157Plus, Nat158, Nat158Plus, Nat159, Nat159Plus, Nat15Plus, Nat16, Nat160, Nat160Plus, Nat161, Nat161Plus, Nat162, Nat162Plus, Nat163, Nat163Plus, Nat164, Nat164Plus, Nat165, Nat165Plus, Nat166, Nat166Plus, Nat167, Nat167Plus, Nat168, Nat168Plus, Nat169, Nat169Plus, Nat16Plus, Nat17, Nat170, Nat170Plus, Nat171, Nat171Plus, Nat172, Nat172Plus, Nat173, Nat173Plus, Nat174, Nat174Plus, Nat175, Nat175Plus, Nat176, Nat176Plus, Nat177, Nat177Plus, Nat178, Nat178Plus, Nat179, Nat179Plus, Nat17Plus, Nat18, Nat180, Nat180Plus, Nat181, Nat181Plus, Nat182, Nat182Plus, Nat183, Nat183Plus, Nat184, Nat184Plus, Nat185, Nat185Plus, Nat186, Nat186Plus, Nat187, Nat187Plus, Nat188, Nat188Plus, Nat189, Nat189Plus, Nat18Plus, Nat19, Nat190, Nat190Plus, Nat191, Nat191Plus, Nat192, Nat192Plus, Nat19Plus, Nat1Plus, Nat2, Nat20, Nat20Plus, Nat21, Nat21Plus, Nat22, Nat22Plus, Nat23, Nat23Plus, Nat24, Nat24Plus, Nat25, Nat25Plus, Nat26, Nat26Plus, Nat27, Nat27Plus, Nat28, Nat28Plus, Nat29, Nat29Plus, Nat2Plus, Nat3, Nat30, Nat30Plus, Nat31, Nat31Plus, Nat32, Nat32Plus, Nat33, Nat33Plus, Nat34, Nat34Plus, Nat35, Nat35Plus, Nat36, Nat36Plus, Nat37, Nat37Plus, Nat38, Nat38Plus, Nat39, Nat39Plus, Nat3Plus, Nat4, Nat40, Nat40Plus, Nat41, Nat41Plus, Nat42, Nat42Plus, Nat43, Nat43Plus, Nat44, Nat44Plus, Nat45, Nat45Plus, Nat46, Nat46Plus, Nat47, Nat47Plus, Nat48, Nat48Plus, Nat49, Nat49Plus, Nat4Plus, Nat5, Nat50, Nat50Plus, Nat51, Nat51Plus, Nat52, Nat52Plus, Nat53, Nat53Plus, Nat54, Nat54Plus, Nat55, Nat55Plus, Nat56, Nat56Plus, Nat57, Nat57Plus, Nat58, Nat58Plus, Nat59, Nat59Plus, Nat5Plus, Nat6, Nat60, Nat60Plus, Nat61, Nat61Plus, Nat62, Nat62Plus, Nat63, Nat63Plus, Nat64, Nat64Plus, Nat65, Nat65Plus, Nat66, Nat66Plus, Nat67, Nat67Plus, Nat68, Nat68Plus, Nat69, Nat69Plus, Nat6Plus, Nat7, Nat70, Nat70Plus, Nat71, Nat71Plus, Nat72, Nat72Plus, Nat73, Nat73Plus, Nat74, Nat74Plus, Nat75, Nat75Plus, Nat76, Nat76Plus, Nat77, Nat77Plus, Nat78, Nat78Plus, Nat79, Nat79Plus, Nat7Plus, Nat8, Nat80, Nat80Plus, Nat81, Nat81Plus, Nat82, Nat82Plus, Nat83, Nat83Plus, Nat84, Nat84Plus, Nat85, Nat85Plus, Nat86, Nat86Plus, Nat87, Nat87Plus, Nat88, Nat88Plus, Nat89, Nat89Plus, Nat8Plus, Nat9, Nat90, Nat90Plus, Nat91, Nat91Plus, Nat92, Nat92Plus, Nat93, Nat93Plus, Nat94, Nat94Plus, Nat95, Nat95Plus, Nat96, Nat96Plus, Nat97, Nat97Plus, Nat98, Nat98Plus, Nat99, Nat99Plus, Nat9Plus)

{-| Express exact natural numbers in a type.


    onlyExact1 : Nat (Only Nat1 maybeN) -> Cake
- `takesOnlyExact1 nat10` is a compile-time error


    add2 : Nat (Only n maybeN) -> Nat (ValueOnly (Nat2Plus n))
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

import N exposing (S, Z)


{-| 1 + some n, which is at least 1.


-}
type alias Nat1Plus n =
    S n


{-| 2 + some n, which is at least 2.


-}
type alias Nat2Plus n =
    Nat1Plus (S n)


{-| 3 + some n, which is at least 3.


-}
type alias Nat3Plus n =
    Nat2Plus (S n)


{-| 4 + some n, which is at least 4.


-}
type alias Nat4Plus n =
    Nat3Plus (S n)


{-| 5 + some n, which is at least 5.


-}
type alias Nat5Plus n =
    Nat4Plus (S n)


{-| 6 + some n, which is at least 6.


-}
type alias Nat6Plus n =
    Nat5Plus (S n)


{-| 7 + some n, which is at least 7.


-}
type alias Nat7Plus n =
    Nat6Plus (S n)


{-| 8 + some n, which is at least 8.


-}
type alias Nat8Plus n =
    Nat7Plus (S n)


{-| 9 + some n, which is at least 9.


-}
type alias Nat9Plus n =
    Nat8Plus (S n)


{-| 10 + some n, which is at least 10.


-}
type alias Nat10Plus n =
    Nat9Plus (S n)


{-| 11 + some n, which is at least 11.


-}
type alias Nat11Plus n =
    Nat10Plus (S n)


{-| 12 + some n, which is at least 12.


-}
type alias Nat12Plus n =
    Nat11Plus (S n)


{-| 13 + some n, which is at least 13.


-}
type alias Nat13Plus n =
    Nat12Plus (S n)


{-| 14 + some n, which is at least 14.


-}
type alias Nat14Plus n =
    Nat13Plus (S n)


{-| 15 + some n, which is at least 15.


-}
type alias Nat15Plus n =
    Nat14Plus (S n)


{-| 16 + some n, which is at least 16.


-}
type alias Nat16Plus n =
    Nat15Plus (S n)


{-| 17 + some n, which is at least 17.


-}
type alias Nat17Plus n =
    Nat16Plus (S n)


{-| 18 + some n, which is at least 18.


-}
type alias Nat18Plus n =
    Nat17Plus (S n)


{-| 19 + some n, which is at least 19.


-}
type alias Nat19Plus n =
    Nat18Plus (S n)


{-| 20 + some n, which is at least 20.


-}
type alias Nat20Plus n =
    Nat19Plus (S n)


{-| 21 + some n, which is at least 21.


-}
type alias Nat21Plus n =
    Nat20Plus (S n)


{-| 22 + some n, which is at least 22.


-}
type alias Nat22Plus n =
    Nat21Plus (S n)


{-| 23 + some n, which is at least 23.


-}
type alias Nat23Plus n =
    Nat22Plus (S n)


{-| 24 + some n, which is at least 24.


-}
type alias Nat24Plus n =
    Nat23Plus (S n)


{-| 25 + some n, which is at least 25.


-}
type alias Nat25Plus n =
    Nat24Plus (S n)


{-| 26 + some n, which is at least 26.


-}
type alias Nat26Plus n =
    Nat25Plus (S n)


{-| 27 + some n, which is at least 27.


-}
type alias Nat27Plus n =
    Nat26Plus (S n)


{-| 28 + some n, which is at least 28.


-}
type alias Nat28Plus n =
    Nat27Plus (S n)


{-| 29 + some n, which is at least 29.


-}
type alias Nat29Plus n =
    Nat28Plus (S n)


{-| 30 + some n, which is at least 30.


-}
type alias Nat30Plus n =
    Nat29Plus (S n)


{-| 31 + some n, which is at least 31.


-}
type alias Nat31Plus n =
    Nat30Plus (S n)


{-| 32 + some n, which is at least 32.


-}
type alias Nat32Plus n =
    Nat31Plus (S n)


{-| 33 + some n, which is at least 33.


-}
type alias Nat33Plus n =
    Nat32Plus (S n)


{-| 34 + some n, which is at least 34.


-}
type alias Nat34Plus n =
    Nat33Plus (S n)


{-| 35 + some n, which is at least 35.


-}
type alias Nat35Plus n =
    Nat34Plus (S n)


{-| 36 + some n, which is at least 36.


-}
type alias Nat36Plus n =
    Nat35Plus (S n)


{-| 37 + some n, which is at least 37.


-}
type alias Nat37Plus n =
    Nat36Plus (S n)


{-| 38 + some n, which is at least 38.


-}
type alias Nat38Plus n =
    Nat37Plus (S n)


{-| 39 + some n, which is at least 39.


-}
type alias Nat39Plus n =
    Nat38Plus (S n)


{-| 40 + some n, which is at least 40.


-}
type alias Nat40Plus n =
    Nat39Plus (S n)


{-| 41 + some n, which is at least 41.


-}
type alias Nat41Plus n =
    Nat40Plus (S n)


{-| 42 + some n, which is at least 42.


-}
type alias Nat42Plus n =
    Nat41Plus (S n)


{-| 43 + some n, which is at least 43.


-}
type alias Nat43Plus n =
    Nat42Plus (S n)


{-| 44 + some n, which is at least 44.


-}
type alias Nat44Plus n =
    Nat43Plus (S n)


{-| 45 + some n, which is at least 45.


-}
type alias Nat45Plus n =
    Nat44Plus (S n)


{-| 46 + some n, which is at least 46.


-}
type alias Nat46Plus n =
    Nat45Plus (S n)


{-| 47 + some n, which is at least 47.


-}
type alias Nat47Plus n =
    Nat46Plus (S n)


{-| 48 + some n, which is at least 48.


-}
type alias Nat48Plus n =
    Nat47Plus (S n)


{-| 49 + some n, which is at least 49.


-}
type alias Nat49Plus n =
    Nat48Plus (S n)


{-| 50 + some n, which is at least 50.


-}
type alias Nat50Plus n =
    Nat49Plus (S n)


{-| 51 + some n, which is at least 51.


-}
type alias Nat51Plus n =
    Nat50Plus (S n)


{-| 52 + some n, which is at least 52.


-}
type alias Nat52Plus n =
    Nat51Plus (S n)


{-| 53 + some n, which is at least 53.


-}
type alias Nat53Plus n =
    Nat52Plus (S n)


{-| 54 + some n, which is at least 54.


-}
type alias Nat54Plus n =
    Nat53Plus (S n)


{-| 55 + some n, which is at least 55.


-}
type alias Nat55Plus n =
    Nat54Plus (S n)


{-| 56 + some n, which is at least 56.


-}
type alias Nat56Plus n =
    Nat55Plus (S n)


{-| 57 + some n, which is at least 57.


-}
type alias Nat57Plus n =
    Nat56Plus (S n)


{-| 58 + some n, which is at least 58.


-}
type alias Nat58Plus n =
    Nat57Plus (S n)


{-| 59 + some n, which is at least 59.


-}
type alias Nat59Plus n =
    Nat58Plus (S n)


{-| 60 + some n, which is at least 60.


-}
type alias Nat60Plus n =
    Nat59Plus (S n)


{-| 61 + some n, which is at least 61.


-}
type alias Nat61Plus n =
    Nat60Plus (S n)


{-| 62 + some n, which is at least 62.


-}
type alias Nat62Plus n =
    Nat61Plus (S n)


{-| 63 + some n, which is at least 63.


-}
type alias Nat63Plus n =
    Nat62Plus (S n)


{-| 64 + some n, which is at least 64.


-}
type alias Nat64Plus n =
    Nat63Plus (S n)


{-| 65 + some n, which is at least 65.


-}
type alias Nat65Plus n =
    Nat64Plus (S n)


{-| 66 + some n, which is at least 66.


-}
type alias Nat66Plus n =
    Nat65Plus (S n)


{-| 67 + some n, which is at least 67.


-}
type alias Nat67Plus n =
    Nat66Plus (S n)


{-| 68 + some n, which is at least 68.


-}
type alias Nat68Plus n =
    Nat67Plus (S n)


{-| 69 + some n, which is at least 69.


-}
type alias Nat69Plus n =
    Nat68Plus (S n)


{-| 70 + some n, which is at least 70.


-}
type alias Nat70Plus n =
    Nat69Plus (S n)


{-| 71 + some n, which is at least 71.


-}
type alias Nat71Plus n =
    Nat70Plus (S n)


{-| 72 + some n, which is at least 72.


-}
type alias Nat72Plus n =
    Nat71Plus (S n)


{-| 73 + some n, which is at least 73.


-}
type alias Nat73Plus n =
    Nat72Plus (S n)


{-| 74 + some n, which is at least 74.


-}
type alias Nat74Plus n =
    Nat73Plus (S n)


{-| 75 + some n, which is at least 75.


-}
type alias Nat75Plus n =
    Nat74Plus (S n)


{-| 76 + some n, which is at least 76.


-}
type alias Nat76Plus n =
    Nat75Plus (S n)


{-| 77 + some n, which is at least 77.


-}
type alias Nat77Plus n =
    Nat76Plus (S n)


{-| 78 + some n, which is at least 78.


-}
type alias Nat78Plus n =
    Nat77Plus (S n)


{-| 79 + some n, which is at least 79.


-}
type alias Nat79Plus n =
    Nat78Plus (S n)


{-| 80 + some n, which is at least 80.


-}
type alias Nat80Plus n =
    Nat79Plus (S n)


{-| 81 + some n, which is at least 81.


-}
type alias Nat81Plus n =
    Nat80Plus (S n)


{-| 82 + some n, which is at least 82.


-}
type alias Nat82Plus n =
    Nat81Plus (S n)


{-| 83 + some n, which is at least 83.


-}
type alias Nat83Plus n =
    Nat82Plus (S n)


{-| 84 + some n, which is at least 84.


-}
type alias Nat84Plus n =
    Nat83Plus (S n)


{-| 85 + some n, which is at least 85.


-}
type alias Nat85Plus n =
    Nat84Plus (S n)


{-| 86 + some n, which is at least 86.


-}
type alias Nat86Plus n =
    Nat85Plus (S n)


{-| 87 + some n, which is at least 87.


-}
type alias Nat87Plus n =
    Nat86Plus (S n)


{-| 88 + some n, which is at least 88.


-}
type alias Nat88Plus n =
    Nat87Plus (S n)


{-| 89 + some n, which is at least 89.


-}
type alias Nat89Plus n =
    Nat88Plus (S n)


{-| 90 + some n, which is at least 90.


-}
type alias Nat90Plus n =
    Nat89Plus (S n)


{-| 91 + some n, which is at least 91.


-}
type alias Nat91Plus n =
    Nat90Plus (S n)


{-| 92 + some n, which is at least 92.


-}
type alias Nat92Plus n =
    Nat91Plus (S n)


{-| 93 + some n, which is at least 93.


-}
type alias Nat93Plus n =
    Nat92Plus (S n)


{-| 94 + some n, which is at least 94.


-}
type alias Nat94Plus n =
    Nat93Plus (S n)


{-| 95 + some n, which is at least 95.


-}
type alias Nat95Plus n =
    Nat94Plus (S n)


{-| 96 + some n, which is at least 96.


-}
type alias Nat96Plus n =
    Nat95Plus (S n)


{-| 97 + some n, which is at least 97.


-}
type alias Nat97Plus n =
    Nat96Plus (S n)


{-| 98 + some n, which is at least 98.


-}
type alias Nat98Plus n =
    Nat97Plus (S n)


{-| 99 + some n, which is at least 99.


-}
type alias Nat99Plus n =
    Nat98Plus (S n)


{-| 100 + some n, which is at least 100.


-}
type alias Nat100Plus n =
    Nat99Plus (S n)


{-| 101 + some n, which is at least 101.


-}
type alias Nat101Plus n =
    Nat100Plus (S n)


{-| 102 + some n, which is at least 102.


-}
type alias Nat102Plus n =
    Nat101Plus (S n)


{-| 103 + some n, which is at least 103.


-}
type alias Nat103Plus n =
    Nat102Plus (S n)


{-| 104 + some n, which is at least 104.


-}
type alias Nat104Plus n =
    Nat103Plus (S n)


{-| 105 + some n, which is at least 105.


-}
type alias Nat105Plus n =
    Nat104Plus (S n)


{-| 106 + some n, which is at least 106.


-}
type alias Nat106Plus n =
    Nat105Plus (S n)


{-| 107 + some n, which is at least 107.


-}
type alias Nat107Plus n =
    Nat106Plus (S n)


{-| 108 + some n, which is at least 108.


-}
type alias Nat108Plus n =
    Nat107Plus (S n)


{-| 109 + some n, which is at least 109.


-}
type alias Nat109Plus n =
    Nat108Plus (S n)


{-| 110 + some n, which is at least 110.


-}
type alias Nat110Plus n =
    Nat109Plus (S n)


{-| 111 + some n, which is at least 111.


-}
type alias Nat111Plus n =
    Nat110Plus (S n)


{-| 112 + some n, which is at least 112.


-}
type alias Nat112Plus n =
    Nat111Plus (S n)


{-| 113 + some n, which is at least 113.


-}
type alias Nat113Plus n =
    Nat112Plus (S n)


{-| 114 + some n, which is at least 114.


-}
type alias Nat114Plus n =
    Nat113Plus (S n)


{-| 115 + some n, which is at least 115.


-}
type alias Nat115Plus n =
    Nat114Plus (S n)


{-| 116 + some n, which is at least 116.


-}
type alias Nat116Plus n =
    Nat115Plus (S n)


{-| 117 + some n, which is at least 117.


-}
type alias Nat117Plus n =
    Nat116Plus (S n)


{-| 118 + some n, which is at least 118.


-}
type alias Nat118Plus n =
    Nat117Plus (S n)


{-| 119 + some n, which is at least 119.


-}
type alias Nat119Plus n =
    Nat118Plus (S n)


{-| 120 + some n, which is at least 120.


-}
type alias Nat120Plus n =
    Nat119Plus (S n)


{-| 121 + some n, which is at least 121.


-}
type alias Nat121Plus n =
    Nat120Plus (S n)


{-| 122 + some n, which is at least 122.


-}
type alias Nat122Plus n =
    Nat121Plus (S n)


{-| 123 + some n, which is at least 123.


-}
type alias Nat123Plus n =
    Nat122Plus (S n)


{-| 124 + some n, which is at least 124.


-}
type alias Nat124Plus n =
    Nat123Plus (S n)


{-| 125 + some n, which is at least 125.


-}
type alias Nat125Plus n =
    Nat124Plus (S n)


{-| 126 + some n, which is at least 126.


-}
type alias Nat126Plus n =
    Nat125Plus (S n)


{-| 127 + some n, which is at least 127.


-}
type alias Nat127Plus n =
    Nat126Plus (S n)


{-| 128 + some n, which is at least 128.


-}
type alias Nat128Plus n =
    Nat127Plus (S n)


{-| 129 + some n, which is at least 129.


-}
type alias Nat129Plus n =
    Nat128Plus (S n)


{-| 130 + some n, which is at least 130.


-}
type alias Nat130Plus n =
    Nat129Plus (S n)


{-| 131 + some n, which is at least 131.


-}
type alias Nat131Plus n =
    Nat130Plus (S n)


{-| 132 + some n, which is at least 132.


-}
type alias Nat132Plus n =
    Nat131Plus (S n)


{-| 133 + some n, which is at least 133.


-}
type alias Nat133Plus n =
    Nat132Plus (S n)


{-| 134 + some n, which is at least 134.


-}
type alias Nat134Plus n =
    Nat133Plus (S n)


{-| 135 + some n, which is at least 135.


-}
type alias Nat135Plus n =
    Nat134Plus (S n)


{-| 136 + some n, which is at least 136.


-}
type alias Nat136Plus n =
    Nat135Plus (S n)


{-| 137 + some n, which is at least 137.


-}
type alias Nat137Plus n =
    Nat136Plus (S n)


{-| 138 + some n, which is at least 138.


-}
type alias Nat138Plus n =
    Nat137Plus (S n)


{-| 139 + some n, which is at least 139.


-}
type alias Nat139Plus n =
    Nat138Plus (S n)


{-| 140 + some n, which is at least 140.


-}
type alias Nat140Plus n =
    Nat139Plus (S n)


{-| 141 + some n, which is at least 141.


-}
type alias Nat141Plus n =
    Nat140Plus (S n)


{-| 142 + some n, which is at least 142.


-}
type alias Nat142Plus n =
    Nat141Plus (S n)


{-| 143 + some n, which is at least 143.


-}
type alias Nat143Plus n =
    Nat142Plus (S n)


{-| 144 + some n, which is at least 144.


-}
type alias Nat144Plus n =
    Nat143Plus (S n)


{-| 145 + some n, which is at least 145.


-}
type alias Nat145Plus n =
    Nat144Plus (S n)


{-| 146 + some n, which is at least 146.


-}
type alias Nat146Plus n =
    Nat145Plus (S n)


{-| 147 + some n, which is at least 147.


-}
type alias Nat147Plus n =
    Nat146Plus (S n)


{-| 148 + some n, which is at least 148.


-}
type alias Nat148Plus n =
    Nat147Plus (S n)


{-| 149 + some n, which is at least 149.


-}
type alias Nat149Plus n =
    Nat148Plus (S n)


{-| 150 + some n, which is at least 150.


-}
type alias Nat150Plus n =
    Nat149Plus (S n)


{-| 151 + some n, which is at least 151.


-}
type alias Nat151Plus n =
    Nat150Plus (S n)


{-| 152 + some n, which is at least 152.


-}
type alias Nat152Plus n =
    Nat151Plus (S n)


{-| 153 + some n, which is at least 153.


-}
type alias Nat153Plus n =
    Nat152Plus (S n)


{-| 154 + some n, which is at least 154.


-}
type alias Nat154Plus n =
    Nat153Plus (S n)


{-| 155 + some n, which is at least 155.


-}
type alias Nat155Plus n =
    Nat154Plus (S n)


{-| 156 + some n, which is at least 156.


-}
type alias Nat156Plus n =
    Nat155Plus (S n)


{-| 157 + some n, which is at least 157.


-}
type alias Nat157Plus n =
    Nat156Plus (S n)


{-| 158 + some n, which is at least 158.


-}
type alias Nat158Plus n =
    Nat157Plus (S n)


{-| 159 + some n, which is at least 159.


-}
type alias Nat159Plus n =
    Nat158Plus (S n)


{-| 160 + some n, which is at least 160.


-}
type alias Nat160Plus n =
    Nat159Plus (S n)


{-| 161 + some n, which is at least 161.


-}
type alias Nat161Plus n =
    Nat160Plus (S n)


{-| 162 + some n, which is at least 162.


-}
type alias Nat162Plus n =
    Nat161Plus (S n)


{-| 163 + some n, which is at least 163.


-}
type alias Nat163Plus n =
    Nat162Plus (S n)


{-| 164 + some n, which is at least 164.


-}
type alias Nat164Plus n =
    Nat163Plus (S n)


{-| 165 + some n, which is at least 165.


-}
type alias Nat165Plus n =
    Nat164Plus (S n)


{-| 166 + some n, which is at least 166.


-}
type alias Nat166Plus n =
    Nat165Plus (S n)


{-| 167 + some n, which is at least 167.


-}
type alias Nat167Plus n =
    Nat166Plus (S n)


{-| 168 + some n, which is at least 168.


-}
type alias Nat168Plus n =
    Nat167Plus (S n)


{-| 169 + some n, which is at least 169.


-}
type alias Nat169Plus n =
    Nat168Plus (S n)


{-| 170 + some n, which is at least 170.


-}
type alias Nat170Plus n =
    Nat169Plus (S n)


{-| 171 + some n, which is at least 171.


-}
type alias Nat171Plus n =
    Nat170Plus (S n)


{-| 172 + some n, which is at least 172.


-}
type alias Nat172Plus n =
    Nat171Plus (S n)


{-| 173 + some n, which is at least 173.


-}
type alias Nat173Plus n =
    Nat172Plus (S n)


{-| 174 + some n, which is at least 174.


-}
type alias Nat174Plus n =
    Nat173Plus (S n)


{-| 175 + some n, which is at least 175.


-}
type alias Nat175Plus n =
    Nat174Plus (S n)


{-| 176 + some n, which is at least 176.


-}
type alias Nat176Plus n =
    Nat175Plus (S n)


{-| 177 + some n, which is at least 177.


-}
type alias Nat177Plus n =
    Nat176Plus (S n)


{-| 178 + some n, which is at least 178.


-}
type alias Nat178Plus n =
    Nat177Plus (S n)


{-| 179 + some n, which is at least 179.


-}
type alias Nat179Plus n =
    Nat178Plus (S n)


{-| 180 + some n, which is at least 180.


-}
type alias Nat180Plus n =
    Nat179Plus (S n)


{-| 181 + some n, which is at least 181.


-}
type alias Nat181Plus n =
    Nat180Plus (S n)


{-| 182 + some n, which is at least 182.


-}
type alias Nat182Plus n =
    Nat181Plus (S n)


{-| 183 + some n, which is at least 183.


-}
type alias Nat183Plus n =
    Nat182Plus (S n)


{-| 184 + some n, which is at least 184.


-}
type alias Nat184Plus n =
    Nat183Plus (S n)


{-| 185 + some n, which is at least 185.


-}
type alias Nat185Plus n =
    Nat184Plus (S n)


{-| 186 + some n, which is at least 186.


-}
type alias Nat186Plus n =
    Nat185Plus (S n)


{-| 187 + some n, which is at least 187.


-}
type alias Nat187Plus n =
    Nat186Plus (S n)


{-| 188 + some n, which is at least 188.


-}
type alias Nat188Plus n =
    Nat187Plus (S n)


{-| 189 + some n, which is at least 189.


-}
type alias Nat189Plus n =
    Nat188Plus (S n)


{-| 190 + some n, which is at least 190.


-}
type alias Nat190Plus n =
    Nat189Plus (S n)


{-| 191 + some n, which is at least 191.


-}
type alias Nat191Plus n =
    Nat190Plus (S n)


{-| 192 + some n, which is at least 192.


-}
type alias Nat192Plus n =
    Nat191Plus (S n)


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


{-| Exact the natural number 161.


-}
type alias Nat161 =
    Nat161Plus Z


{-| Exact the natural number 162.


-}
type alias Nat162 =
    Nat162Plus Z


{-| Exact the natural number 163.


-}
type alias Nat163 =
    Nat163Plus Z


{-| Exact the natural number 164.


-}
type alias Nat164 =
    Nat164Plus Z


{-| Exact the natural number 165.


-}
type alias Nat165 =
    Nat165Plus Z


{-| Exact the natural number 166.


-}
type alias Nat166 =
    Nat166Plus Z


{-| Exact the natural number 167.


-}
type alias Nat167 =
    Nat167Plus Z


{-| Exact the natural number 168.


-}
type alias Nat168 =
    Nat168Plus Z


{-| Exact the natural number 169.


-}
type alias Nat169 =
    Nat169Plus Z


{-| Exact the natural number 170.


-}
type alias Nat170 =
    Nat170Plus Z


{-| Exact the natural number 171.


-}
type alias Nat171 =
    Nat171Plus Z


{-| Exact the natural number 172.


-}
type alias Nat172 =
    Nat172Plus Z


{-| Exact the natural number 173.


-}
type alias Nat173 =
    Nat173Plus Z


{-| Exact the natural number 174.


-}
type alias Nat174 =
    Nat174Plus Z


{-| Exact the natural number 175.


-}
type alias Nat175 =
    Nat175Plus Z


{-| Exact the natural number 176.


-}
type alias Nat176 =
    Nat176Plus Z


{-| Exact the natural number 177.


-}
type alias Nat177 =
    Nat177Plus Z


{-| Exact the natural number 178.


-}
type alias Nat178 =
    Nat178Plus Z


{-| Exact the natural number 179.


-}
type alias Nat179 =
    Nat179Plus Z


{-| Exact the natural number 180.


-}
type alias Nat180 =
    Nat180Plus Z


{-| Exact the natural number 181.


-}
type alias Nat181 =
    Nat181Plus Z


{-| Exact the natural number 182.


-}
type alias Nat182 =
    Nat182Plus Z


{-| Exact the natural number 183.


-}
type alias Nat183 =
    Nat183Plus Z


{-| Exact the natural number 184.


-}
type alias Nat184 =
    Nat184Plus Z


{-| Exact the natural number 185.


-}
type alias Nat185 =
    Nat185Plus Z


{-| Exact the natural number 186.


-}
type alias Nat186 =
    Nat186Plus Z


{-| Exact the natural number 187.


-}
type alias Nat187 =
    Nat187Plus Z


{-| Exact the natural number 188.


-}
type alias Nat188 =
    Nat188Plus Z


{-| Exact the natural number 189.


-}
type alias Nat189 =
    Nat189Plus Z


{-| Exact the natural number 190.


-}
type alias Nat190 =
    Nat190Plus Z


{-| Exact the natural number 191.


-}
type alias Nat191 =
    Nat191Plus Z


{-| Exact the natural number 192.


-}
type alias Nat192 =
    Nat192Plus Z
