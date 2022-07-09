## bounded-nat

A natural number ≥ 0 that has extra information about its range _at compile-time_

## example: `toHexChar`

```elm
toHexChar : Int -> Char
```

- the _type_ doesn't tell us that an `Int` between 0 & 15 is wanted
- _the one implementing_ `toHexChar` has to handle the cases where the argument isn't between 0 & 15
    - either by introducing `Maybe` which will be carried throughout your program
    - or by providing silent default error values like `'?'` or even worse `'0'`
- the `Int` range promise of the argument is lost after the operation

with `bounded-nat`:
```elm
toHexChar : N (In anyMinimum_ N15 difference_) -> Char
```

- the _type_ tells us that a number between 0 & 15 is wanted
- the _user_ proves that the number is actually between 0 & 15

The argument type says: Give me an integer ≥ 0 `N` `In` range
  - `≥ 0`; `anyMinimum_` value allowed
  - `≤` `N15`
  - which might be a [specific value like `n0`, `n1`, ... which has a `difference_`](N#Is)
`)`

Users can prove this by explicitly

  - using exact values

    ```elm
    toHexChar n2 --→ 'c'
    red = rgbPercent n100 n0 n0  --👍
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
        float * 100 |> round |> N.intInRange n0 n100
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
toDigit : Char -> Maybe (N (In N0 (Add9 a_) {}))
```

The type of an [`N`](N#N) value will reflect how much you and the compiler know

  - at least a minimum value? [`Min`](N#Min)
  - between a minimum & maximum value? [`In`](N#In)
  - a specific value? [`N (In ... (Is ...))`](N#Is)
    - allows precise adding, subtracting, ...


&emsp;


## example: `factorial`

```elm
intFactorial : Int -> Int
intFactorial x =
    case x of
        0 ->
            1

        non0 ->
            non0 * intFactorial (non0 - 1)
```

This forms an infinite loop if we call `intFactorial -1`...

Let's disallow negative numbers here!

```elm
factorial : N (In min_ max_ difference_) -> N (Min N1)
factorial =
    factorialBody
```
Says: For every `n ≥ 0`, `n! ≥ 1`.
```elm
factorialBody : N (In min_ max_ difference_) -> N (Min N1)
factorialBody x =
    case x |> N.minIsAtLeast n1 { bottom = n0 } of
        Err _ ->
            n1 |> N.noMax

        Ok atLeast1 ->
            -- atLeast1 : N (Min N1)
            -- so subtracting 1, we're still ≥ 0
            factorial (atLeast1 |> N.minSub n1)
                |> N.mul atLeast1

factorial n4 |> N.toInt --→ 24
```

→ You can't put a negative number in

→ We have an extra promise! every result is `≥ 1`

Sadly, we need separate `factorial` & `factorialBody` because there's [no support for polymorphic recursion](https://github.com/elm/compiler/issues/2180).

But we can do even better!
`!19` is already `>` the maximum safe `Int` `2^53 - 1`.

```elm
safeFactorial : N (In min_ N18 difference_) -> N (Min N1)
safeFactorial =
    factorial
```

No extra work.


## tips

  - keep _as much type information as possible_ and drop it only where you need to: "Wrap early, unwrap late"
      - [`elm-radio`](https://elm-radio.com/episode/wrap-early-unwrap-late/)
      - [`elm-patterns`](https://sporto.github.io/elm-patterns/basic/wrap-early.html)

  - keep _argument types as broad as possible_
    
    Instead of accepting only `n0`, `n1`, ... values in a range

    ```elm
    percent :
        N (In p_ atLeast_ (Is (Diff to100_ To N100) diff1_))
        -> Length
    ```
    accept values that are somewhere in a range.

    ```elm
    percent : N (In min_ N100 difference_) -> Length
    ```

    `difference_` says that it _can_ be exact anyway.
    
    Or instead of

    ```elm
    charFromCode : N (Min min_) -> Char
    ```

    which you should also never do, allow `N (In min_ ...)` with any max & `N (N ...)` to fit in as well:

    ```elm
    charFromCode : N (In min_ max_ difference_) -> Char
    ```

## ready? go!

- 👀 **[`typesafe-array`][typesafe-array]** shows that
    - `N (In ...)` is very useful as an index
    - `In`, `Min`, `Exactly` can also describe a length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
