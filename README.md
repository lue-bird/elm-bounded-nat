## bounded-nat

Natural number ≥ 0 that has extra information about its range _at compile-time_

## example: `toHexChar`

```elm
toHexChar : Int -> Char
```

  - the _type_ doesn't show that an `Int` between 0 & 15 is expected
  - _the one implementing_ `toHexChar` has to handle the cases where the argument isn't between 0 & 15
      - either by introducing `Maybe` which will be carried throughout your program
      - or by providing silent default error values like `'?'` or even worse `'0'`
  - the `Int` range promise of the argument is lost after the operation

with `bounded-nat`:
```elm
toHexChar : N (In min_ (Up maxTo15_ To N15)) -> Char
```

  - the _type_ tells us that a number between 0 & 15 is wanted
  - the _user_ proves that the number is actually between 0 & 15

The argument type says: Give me an integer ≥ 0 [`N`](N#N) [`In`](N#In) range
  - `≥ 0` → _any_ minimum allowed → `min_` type variable that's only used once
  - `≤ 15` → if we [increase](N#Up) some number (`maxTo15_` type variable that's only used once) by the argument's maximum, we get [`N15`](N#N15)

Users can prove this by _explicitly_

  - using specific values

    ```elm
    red = rgbPercent { r = n100, g = n0, b = n0 }  --👍
    n7 |> N.subtract n1 |> N.divideBy n2 |> toHexChar --→ '3'
    ```

  - handling the possibility that a number isn't in the expected range

    ```elm
    toPositive : Int -> Maybe (N (Min (Up1 x_)))
    toPositive =
        N.isAtLeastInt n1 >> Result.toMaybe
    ```

  - clamping

    ```elm
    floatPercent float =
        float * 100 |> round |> N.inInt ( n0, n100 )
    ```

  - there are more ways, but you get the idea 🙂

&emsp;


## example: `toDigit`

```elm
toDigit : Char -> Maybe Int
```

You might be able to do anything with this `Int` value, but you lost useful information:

  - can the result even be negative?
  - can the result even have multiple digits?

```elm
toDigit :
  Char
  -> Maybe (N (In (Up0 minX_) (Up9 maxX_)))
```

The type of an [`N`](N#N) value will reflect how much you and the compiler know

  - at least a minimum value? [`Min`](N#Min)
  - between a minimum & maximum value? [`In`](N#In)


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

Let's disallow negative numbers here (& more)!

```elm
import N exposing (N, In, Min, Up1, n1, n4)

         -- for every `n ≥ 0`, `n! ≥ 1`
factorial : N (In min_ max_) -> N (Min (Up1 x_))
factorial =
    factorialBody

factorialBody : N (In min_ max_) -> N (Min (Up1 x_))
factorialBody x =
    case x |> N.isAtLeast n1 of
        Err _ ->
            n1 |> N.maxToInfinity
        Ok xMin1 ->
            -- xMin1 : N (Min ..1..), so xMin1 - 1 ≥ 0
            factorial (xMin1 |> N.subtractMin n1)
                |> N.multiplyBy xMin1

factorial n4 |> N.toInt --> 24
```

- nobody can put a negative number in
- we have an extra promise! every result is `≥ 1`

Separate `factorial` & `factorialBody` are needed because there's [no support for polymorphic recursion](https://github.com/elm/compiler/issues/2180) 😢

We can do even better!
`!19` is already `>` the maximum safe `Int` `2^53 - 1`

```elm
safeFactorial : N (In min_ (Up maxTo18_ To N18)) -> N (Min (Up1 x_))
safeFactorial =
    factorial
```

No extra work


## tips

  - keep _as much type information as possible_ and drop it only where you need to: "Wrap early, unwrap late"
      - [`elm-radio`](https://elm-radio.com/episode/wrap-early-unwrap-late/)
      - [`elm-patterns`](https://sporto.github.io/elm-patterns/basic/wrap-early.html)

  - keep _argument types as broad as possible_
    
    like instead of
    ```elm
    charFromCode : N (Min min_) -> Char
    ```
    which you should never do, allow maximum-constrained numbers to fit as well:
    ```elm
    charFromCode : N (In min_ max_) -> Char
    ```

## ready? go!

- 👀 **[`typesafe-array`][typesafe-array]** shows that
    - `N (In ...)` is very useful as an index
    - `In`, `Min`, `Exactly` can also describe a length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
