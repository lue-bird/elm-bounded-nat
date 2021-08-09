## bounded-nat

Type-safe natural numbers (>= 0) can ensure that a `Nat` is in a given range _at compile-time_.

```elm
toHexChar : Nat (ArgIn _ Nat15 _) -> Char
```

**No number below 0 or above 15** can be passed in as an argument!

# examples

```noformatingples
elm install lue-bird/elm-typed-value
elm install lue-bird/elm-bounded-nat
```

```elm
import Nat exposing (Nat, Min, In, ArgIn)
import InNat
import MinNat
import Nats exposing (..)
    -- nat0-160, Nat0-160 & -Plus

import Typed
```


## percent

```elm
percent : Float -> Length
```
is common.
- _the one implementing_ it has to handle the cases where a value is not between 0 and 1
- the _type_ doesn't tell us that a `Float` between 0 & 1 is wanted

with `bounded-nat`
```elm
percent :
    Nat (ArgIn min_ Nat100 ifN_)
    -> Length
```
- _the user_ it must prove that the numbers are actually between 0 and 100
- the type tells us that a number 0 to 100 is wanted

The type
```elm
Nat (ArgIn min_ Nat100 ifN_)
```
is saying it wants:

an integer >= 0: `Nat` 

- in a range: `ArgIn`
    - at least 0 → any minimum value: `min_`
    - at most 100: `Nat100`
    - which might be exact: `ifN_`

They can prove it by

  - using exact values

    ```elm
    twoThirds = percent nat67

    red = rgbPercent nat100 nat0 nat0 -- 👍
    ```

  - handling the possibility that a number isn't in the expected range

    ```elm
    toPositive : Int -> Maybe (Nat (Min Nat1))
    toPositive =
        Nat.isIntAtLeast nat1
    ```

  - clamping

    ```elm
    greyFloatPercent float =
        let
            greyLevel =
                Nat.intInRange nat0 nat100
                    (float * 100 |> round)
        in
        rgbPercent greyLevel greyLevel greyLevel
    ```

  - There are more ways, but you get the idea 🙂

&emsp;


## digit

```elm
toDigit : Char -> Maybe Int
```

You might be able to do anything with this `Int` value, but you lost useful information.

- Can the result even be negative?
- Can the result even have multiple digits?

```elm
toDigit : Char -> Maybe Digit

type alias Digit =
    Nat (In Nat0 Nat9)
```

The type of a value reflects how much you know.

- between a minimum & maximum value: `In`
- at least a minimum value: `Min`
- exact value: `N`
    - can describe the difference between 2 values → useful for adding/subtracting/...


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
factorial : Nat (ArgIn min_ max_ ifN_) -> Nat (Min Nat1)
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
                    (atLeast1 |> MinNat.sub nat1)
                    -- so we can subtract 1
                )

factorial nat4 --> Nat 24
```

→ There is no way to put a negative number in.

→ We have the extra promise, that every result is `>= 1`

Sadly, we need separate `factorial` & `factorialBody` because there's [no support for polymorphic recursion](https://github.com/elm/compiler/issues/2180).

But we can do even better!
`!19` is already > the maximum safe `Int` `2^53 - 1`.

```elm
safeFactorial : Nat (ArgIn min_ Nat18 ifN_) -> Nat (Min Nat1)
safeFactorial =
    factorial
```

No extra work.


## tips

  - keep _as much type information as possible_ and drop it only where you need to.

  - keep your _function annotations as general as possible_
    
    Instead of accepting only exact values

    ```elm
    percent :
        Nat (N p_ atLeast_ (Is to100_ To Nat100) is_)
        -> Length
    ```
    accept values that are somewhere in a range.

    ```elm
    percent : Nat (ArgIn min_ Nat100 ifN_) -> Length
    ```

    `ifN_` says that it _can_ be exact anyway. Or instead of

    ```elm
    charFromCode : Nat (Min min_) -> Char
    ```

    which you should also never do, allow `Nat (In min ...)` with any max & `Nat (N ...)` to fit in as well!

    ```elm
    charFromCode : Nat (ArgIn min_ max_ ifN_) -> Char
    ```

Take a **look at [`typesafe-array`][typesafe-array]** to see a lot of this in action!

You get to know that
- a `Nat (ArgIn ...)` is very useful as an index
- `In`, `Min`, `Only` can also describe the array length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
