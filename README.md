## bounded-nat

A natural number >= 0 that has extra information about its range _at compile-time_

## example: `toHexChar`

```elm
toHexChar : Int -> Char
```

- the _type_ doesn't tell us that a `Float` between 0 & 15 is wanted
- _the one implementing_ it has to handle the cases where a value is not between 0 & 15

with `bounded-nat`:
```elm
toHexChar : N (In anyMinimum_ N15 difference_) -> Char
```

- the type tells us that a number between 0 & 15 is wanted
- _the user_ it must prove that the number is actually between 0 & 15

The type of the argument
```elm
N (In min_ N15 difference_)
```
Says: Give me an integer >= 0: `N` 

- in a range: `In`
    - at least 0 → any minimum value is fine: `min_`
    - at most 15: `N15`
    - which might be `n0`, `n1`, ...: `difference_`

Users can prove this by

  - using exact values

    ```elm
    toHexChar n2
    --> 'c'

    red = rgbPercent n100 n0 n0 -- 👍
    ```

  - handling the possibility that a number isn't in the expected range

    ```elm
    toPositive : Int -> Maybe (N (Min N1))
    toPositive =
        N.intIsAtLeast n1
    ```

  - clamping

    ```elm
    floatPercent float =
        N.intInRange n0 n100
            (float * 100 |> round)
    ```

  - There are more ways, but you get the idea 🙂

&emsp;


## example: `toDigit`

```elm
toDigit : Char -> Maybe Int
```

You might be able to do anything with this `Int` value, but you lost useful information.

- Can the result even be negative?
- Can the result even have multiple digits?

```elm
toDigit : Char -> Maybe (N (In N0 (N9Plus a_) {}))
```

The type of a value reflects how much you know.

- at least a minimum value: `Min`
- between a minimum & maximum value: `In`
- exact value: `N`
    - can describe the difference between 2 values → useful for adding/subtracting/...


&emsp;


## example: `factorial`

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
factorial : N (In min_ max_ difference_) -> N (Min N1)
factorial =
    factorialBody
```
Says: For every `n >= 0`, `n! >= 1`.
```elm
factorialBody : N (In min_ max_ difference_) -> N (Min N1)
factorialBody x =
    case x |> MinDiff.isAtLeast n1 { lowest = n0 } of
        N.Below _ ->
            N.toMin n1

        N.EqualOrGreater atLeast1 ->
            -- atLeast1 --> : N (Min N1)
            -- so subtracting 1, we're still >= 0
            factorial
                (atLeast1 |> MinDiff.sub n1)
                |> N.mul atLeast1

factorial n4 --> N 24
```

→ You can't put a negative number in.

→ We have the extra promise, that every result is `>= 1`

Sadly, we need separate `factorial` & `factorialBody` because there's [no support for polymorphic recursion](https://github.com/elm/compiler/issues/2180).

But we can do even better!
`!19` is already > the maximum safe `Int` `2^53 - 1`.

```elm
safeFactorial : N (In min_ N18 difference_) -> N (Min N1)
safeFactorial =
    factorial
```

No extra work.

## setup

```noformatingples
elm install lue-bird/elm-typed-value
elm install lue-bird/elm-bounded-n
```

```elm
import N exposing (N, Min, In, In)
import InDiff
import MinDiff
import Ns exposing (..)
    -- n0-160, N0-160 & -Plus

import Typed
```


## tips

  - keep _as much type information as possible_ and drop it only where you need to: ["Wrap early, unwrap late"](https://sporto.github.io/elm-patterns/basic/wrap-early.html)

  - keep your _function annotations as general as possible_
    
    Instead of accepting only `n0`, `n1`, ... values in a range

    ```elm
    percent :
        N (N p_ atLeast_ (Is to100_ To N100) is_)
        -> Length
    ```
    accept values that are somewhere in a range.

    ```elm
    percent : N (In min_ N100 difference_) -> Length
    ```

    `difference_` says that it _can_ be exact anyway. Or instead of

    ```elm
    charFromCode : N (Min min_) -> Char
    ```

    which you should also never do, allow `N (In min_ ...)` with any max & `N (N ...)` to fit in as well:

    ```elm
    charFromCode : N (In min_ max_ difference_) -> Char
    ```

## ready? go!

- Take a **look at [`typesafe-array`][typesafe-array]** to see a lot of this in action!

    You get to know that
    - a `N (In ...)` is very useful as an index
    - `In`, `Min`, `Only` can also describe the array length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
