## elm-bounded-nat

Type-safe natural numbers (`>= 0`), ensuring that a `Nat` is in a range _at compile-time_:

```elm
toHexChar : Nat (ArgIn min Nat15 maybeN) -> Char
```

**No number below 0 or above 15** can be passed in as an argument!

# examples

```noformatingples
elm install lue-bird/elm-typed-value
elm install lue-bird/elm-bounded-nat
```

```elm
import Nat exposing (Nat, Min, In, N, Is, To, ArgIn)
import NNats exposing (..)
    -- (..) is nat0 to nat160
import InNat
import MinNat

import TypeNats exposing (..)
    -- (..) is Nat0 to Nat160 & Nat1Plus to Nat160Plus

import Typed exposing (val, val2)
```


## color

```elm
rgb : Float -> Float -> Float -> Color
```

This is common, but
- _the one implementing_ the function has to handle the case where a value is not between 0 and 1
- the _type_ doesn't tell us that a `Float` between 0 & 1 is wanted

```elm
rgbPer100 :
    Nat (ArgIn redMin Nat100 redMaybeN)
    -> Nat (ArgIn greenMin Nat100 greenMaybeN)
    -> Nat (ArgIn blueMin Nat100 blueMaybeN)
    -> Color
```
- _the one using_ the function must prove that the numbers are actually between 0 and 100
- you clearly know what input is desired

The type
```elm
Nat (ArgIn min Nat100 maybeN)
```
is saying it wants:

```
an integer >= 0                  Nat          
  in a range                        ArgIn       
    at least any minimum value        min   
    at most 100                       Nat100
    which might be exact              maybeN
```


They can prove it by

- already knowing

```elm
red = rgbPer100 nat100 nat0 nat0 -- 👍

nat0 : Nat (N Nat0 atLeast0 ...)
-- so it's also between 0 and 0/1/.../100

nat100 : Nat (N Nat100 (N100Plus orMore) ...)
-- so it's also between 100 and 100(/101/...)
```
- checking

```elm
isUserIntANat : Int -> Maybe (Nat (Min Nat0))
isUserIntANat =
    Nat.isIntAtLeast nat0
```
- clamping

```elm
grey float =
    let
        greyLevel =
            float
                * 100
                |> round
                |> Nat.intInRange nat0 nat100
    in
    rgbPer100 greyLevel greyLevel greyLevel
```

- There are more ways, but you get the idea 🙂

&emsp;


## digit

```elm
toDigit : Char -> Maybe Int
```

You might be able to do anything with this `Int` value, but you lost useful information.

- Can the result even be negative?
- Could the number have multiple digits?

```elm
toDigit : Char -> Maybe Digit

type alias Digit =
    Nat (In Nat0 Nat9)
```

The type of a value reflects how much you know.

- `In`: between a minimum & maximum value
- `Min`: at least a minimum value
- `N`: exact value
    - also describes the difference between 2 values


&emsp;


## factorial

```elm
intFactorial : Int -> Int
intFactorial x =
    if x == 0 then
        1

    else
        x * intFactorial (x - 1)
```

This forms an infinite loop if we call `intFactorial -1`...

Let's disallow negative numbers here!

```elm
factorial : Nat (ArgIn min max maybeN) -> Nat (Min Nat1)
factorial =
    factorialBody
```
Says: for every natural number `n >= 0`, `n! >= 1`.
```elm
factorialBody : -- as in factorial
factorialBody =
    case x |> MinNat.isAtLeast nat1 { lowest = nat0 } of
        Nat.Below _ ->
            MinNat.value nat1

        Nat.EqualOrGreater atLeast1 ->
            -- atLeast1 is a Nat (Min Nat1)
            Nat.mul atLeast1
                (factorial
                    (atLeast1 |> MinNat.subN nat1)
                    -- so we can subtract 1
                )

factorial nat4 --> Nat 24
```

→ There is no way to put a negative number in.

→ We have the extra promise, that every result is `>= 1`

By the way, we need `factorial` & `factorialBody` because of a [compiler bug](https://github.com/elm/compiler/issues/2180).

But we can do even better!
`!19` is already > the maximum safe `Int` `2^53 - 1`.

```elm
safeFactorial : Nat (ArgIn min Nat18 maybeN) -> Nat (Min Nat1)
safeFactorial =
    factorial
```

No extra work.


## tips

- keep _as much type information as possible_ and drop it only where you need to.
```elm
squares2To10 =
    Nat.range nat2 nat10
        -- more info than List.range 2 10
        -- → every Nat is In Nat2 (Nat10Plus a)
        |> List.map
            (Nat.toPower nat2
                -- we still know it's >= 2
            )
```
- keep your _function annotations as general as possible_
    
Instead of accepting only exact values

```elm
rgb : Nat (ArgN red (Is redTo100 To Nat100) x) -> --...
```
accept values that are somewhere in a range.

```elm
rgb : Nat (ArgIn redMin Nat100 maybeN) -> --...
```

`maybeN` says that it _can_ be exact anyway. Or instead of

```elm
charFromCode : Nat (Min min) -> Char
```

which you should also never do, allow `Nat (In min ...)` with any max & `Nat (N ...)` to fit in as well!

```elm
charFromCode : Nat (ArgIn min max maybeN) -> Char
```

Take a look at [`elm-typesafe-array`][typesafe-array] to see a lot of this in action!

You get to know that
- a `Nat (ArgIn ...)` is very useful as an index
- `In`, `Min`, `Only` can also describe the array length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
