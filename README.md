## bounded-nat

A number that has extra information about its range _at compile-time_

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
toHexChar : Z (In (UpExact min_) (Up maxTo15_ To N15)) -> Char
```

  - the _type_ tells us that a number between 0 & 15 is wanted
  - the _user_ proves that the number is actually between 0 & 15

The argument type says: Give me an integer ≥ 0 [`Z`](Z#Z) [`In`](Z#In) range
  - `≥ 0`; any non-negative → `UpExact`, `min_` value allowed
  - `≤ 15`; if we [increase](Z#Up) some number by the argument's maximum, we get [`N15`](Z#N15)

Users can prove this by _explicitly_

  - using specific values

    ```elm
    toHexChar n2 --→ 'c'
    red = rgbPercent { r = n100, g = n0, b = n0 }  --👍
    ```

  - handling the possibility that a number isn't in the expected range

    ```elm
    toPositive : Int -> Maybe (Z (Min (Up x To (Add1 x))))
    toPositive =
        Z.intIsAtLeast n1 >> Result.toMaybe
    ```

  - clamping

    ```elm
    floatPercent float =
        float * 100 |> round |> Z.intIn ( n0, n100 )
    ```

  - there are more ways, but you get the idea 🙂

&emsp;


## example: `toDigit`

```elm
toDigit : Char -> Maybe Int
```

You might be able to do anything with this `Int` value, but you lost useful information.

  - can the result even be negative?
  - can the result even have multiple digits?

```elm
toDigit :
  Char
  -> Maybe
      (Z
          (In
              (Up minX To minX)
              (Up maxX To (Add9 maxX))
          )
      )
```

The type of an [`Z`](Z#Z) value will reflect how much you and the compiler know

  - at least a minimum value? [`Min`](Z#Min)
  - between a minimum & maximum value? [`In`](Z#In)


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
factorial : Z (In min_ max_) -> Z (Min (Up x To (Add1 x)))
factorial =
    factorialBody
```
Says: For every `n ≥ 0`, `n! ≥ 1`.
```elm
factorialBody : Z (In min_ max_) -> Z (Min (Up x To (Add1 x)))
factorialBody x =
    case x |> Z.isAtLeast n1 of
        Err _ ->
            n1 |> Z.maxNo

        Ok n1AtLeast ->
            -- n1AtLeast : Z (Min ..1..)
            -- so subtracting 1, we're still ≥ 0
            factorial (n1AtLeast |> Z.minSub n1)
                |> Z.mul n1AtLeast

factorial n4 |> Z.toInt --→ 24
```

→ You can't put a negative number in

→ We have an extra promise! every result is `≥ 1`

Sadly, we need separate `factorial` & `factorialBody` because there's [no support for polymorphic recursion](https://github.com/elm/compiler/issues/2180).

But we can do even better!
`!19` is already `>` the maximum safe `Int` `2^53 - 1`.

```elm
safeFactorial : Z (In min_ (Up maxTo18_ To N18)) -> Z (Min (Up x To (Add1 x)))
safeFactorial =
    factorial
```

No extra work.


## tips

  - keep _as much type information as possible_ and drop it only where you need to: "Wrap early, unwrap late"
      - [`elm-radio`](https://elm-radio.com/episode/wrap-early-unwrap-late/)
      - [`elm-patterns`](https://sporto.github.io/elm-patterns/basic/wrap-early.html)

  - keep _argument types as broad as possible_
    
    like instead of
    ```elm
    charFromCode : Z (Min min_) -> Char
    ```
    which you should never do, allow maximum-constrained numbers to fit as well:
    ```elm
    charFromCode : Z (In min_ max_) -> Char
    ```

## ready? go!

- 👀 **[`typesafe-array`][typesafe-array]** shows that
    - `Z (In ...)` is very useful as an index
    - `In`, `Min`, `UpExactly` can also describe a length

[typesafe-array]: https://package.elm-lang.org/packages/lue-bird/elm-typesafe-array/latest/
