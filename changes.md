## 21.0.0 plans

  - rename `Nat` module and type to `N`
  - remove `Nats` module, moving content to `N`
      - rename `Nat`<x> types to `N`<x>
      - rename `Nat`<x>`Plus` types to `Add`<x>
      - remove `Nat`<x> and `nat`<x> for x >= 17
      - add `allowable-state` dependency
      - replace `Z` with `N0`, `S` with `Add1`:
        ```elm
        type alias N0 =
            Zero Possibly Never
        
        type alias Add1 more =
            Zero Never more
        
        type Zero possiblyOrNever ifPossible
            = Add1 ifPossible
            | Zero possiblyOrNever
        ```
      - expose `Zero(..)`
      - redefine `N` as
        ```elm
        type alias N range =
            Typed
                Checked
                NTag
                Public
                { int : Int, range : range )
        
        type NTag
            = NTag
        ```
      - readd `toInt`
      - add `range`
  - add `N.Generator` that auto-generates `N`<x>, `Add`<x> and `n`<x> for x >= 17

### rejected

  - rename `Nat` to `ℕ` and `N`<x>`Plus` to `ℕ`<x>`𐊛`
      - 👎 must be copied
      - 👎 is confusing
      - 👍 is readable
      - → no

# changelog

#### 20.0.1

- updated `typed-value` to 6.0.0

## 20.0.0

- removed `Nat.theGreater` and `Nat.theSmaller` in favor of the more general versions `Typed.max` & `Typed.min`
- exposed `Nat.NoMax`
- simplified readme

#### 19.0.1

- corrected spelling mistakes

## 19.0.0

- moved `NatX`, `NatXPlus` and `natX` in new `Nats` module
- used custom serialize errors instead of directly converting every error to a `String`
- moved `MinNat.value` to `Nat.toMin`
- moved `InNat.value` to `Nat.toIn`
- `Nat.isIntInRange` now returns an `Int` for if `BelowRange`

## 18.0.0

- moved `atMost` from `InNat` to `Nat`
- added `MinNat.atLeast`

## 17.0.0

- corrected `MinNat.isAtLeast` & `MinNat.isAtMost` `ifN_` usage

## 16.0.0

- `MinNat.isAtLeast` & `MinNat.isAtMost` can now compare to a `Nat (ArgIn ...)` instead of a `Nat (N ...)`

## 15.0.0

- replaced `Nat.restoreMax`'s argument type `Nat (N currentMax max ...)` with `Nat (In currentMax max)`
- fix a bug in the result type of `InNat.is`
- replaced result `()` from equal comparison with `In value atLeastValue` in `InNat.is` & `MinNat.is`

## 14.0.0

- removed `ArgN`
  - used `N` where `ArgN` was used previously
- renamed & changed the argument order in `InArr.add x addedMin addedMax` to `addIn addedMin addedMax x`
- renamed & changed the argument order in `InArr.sub x subbedMin subbedMax` to `addIn subbedMin subbedMax x`
- renamed & changed the argument order in `MinArr.add x addedMin` to `addMin addedMin x`
- renamed & changed the argument order in `MinArr.sub x subbedMax` to `subMax subbedMax x`
- renamed `addN` in `InArr` & `MinArr` to `add`
- renamed `subN` in `InArr` & `MinArr` to `sub`
- added "_" after unused type variables

## 13.0.0

- removed `ArgOnly`
- made `Nat.lowerMin natX` before `|> ...Nat.is... { min = natX }` redundant by replacing `min` with `{ lowest }` which can be <=, not = the minimum. Changed functions:
  - `InNat`: `isAtLeast`, `is`, `isAtMost`, `isInRange`, `atMost`
  - `MinNat`: `isAtLeast`, `is`, `isAtMost`

## 12.0.0

- fix type of the `AboveRange` part of the return type of `Nat.isIntInRange`
- add documentation to the comparison result types

## 11.0.0

  - comparisons now return a union type, replacing the pattern
    ```elm
    { case1 : ... -> result, case2 : ... -> result } -> ... -> result
    ```
    with
    ```elm
    ... -> Case1Or2 ... ...
    ```
    in `InNat`, `MinNat` & `Nat`

## 10.0.0

- gave `Nat.remainderBy`'s return type a smaller range

## 9.0.0

- added `Arg-` prefix in front of `in` & `Only` & `N`
- removed `Value-` prefix for `-N` & `-Only` & `-In` & `-Min`

#### 8.0.1

- corrected `InNat.serialize` doc (only told one about the lower bound)

## 8.0.0

- added serialize versions
- renamed `Nat.maxIs` to `restoreMax`
- `intInRange` & `InNat.isInRange` take 2 values instead of a record `{ first, last }`
- fix types of `isAtLeast` & `is` & `isAtMost` type in `MinNat` to compare to a `Nat (N ...)`

## 7.0.0

- added `MinNat.serialize` & `InNat.serialize`
- moved & renamed `toIn` from `NNat` to `InNat.value`
- moved & renamed `toMin` from `Nat` to `MinNat.value`

## 6.0.0

`Nat range` is now of type `Typed Checked (NatTag range) Public Int` from [`elm-typed-value`](https://package.elm-lang.org/packages/lue-bird/elm-typed-value/4.0.0/).
- removed `Nat.toInt` & `Nat.bi`. Use `val`/`val2` in `Typed`
- merged `Nat.Bound` types into `Nat`

#### 5.0.3

Corrected forgotten `maybeN`s & `min`s that were set to an exact value in doc.

#### 5.0.2

Corrected forgotten `maybeN`s, wrongly named `ValueMin/-In`s & minor doc mistakes.

#### 5.0.1

Updated exposings & when to use `ValueSomething` in the readme.


## 5.0.0

Changed `isAtLeast`'s `less` variant to be a `In ... maybeN`, not a `ValueIn`.
- updated links to elm-bounded-array
- replaced wrong usages of `natX |> InNat.value` in doc with `betweenXAndY`
- Changed some argument names

## 4.0.0

Use [indique/n 2.0.0](https://package.elm-lang.org/packages/indique/n/).
- removed `Nat161`/`Nat161Plus` and above for better compiling speed

## 3.0.0

Improved compiling speed using [indique/n](https://package.elm-lang.org/packages/indique/n/).
- removed `nat161` to `nat168` for better compiling speed

## 2.0.0

Fixed a bug in the type of `InNat.isAtMost`, `InNat.isInRange` & `MinNat.isAtMost`.

#### 1.0.1

Updated many old names in the documentation.

## 1.0.0

> Repository username changed from `indique` to `lue-bird`

`N n (Is a To) nPlusA (And b To nPlusB)` is now

- `N n (Is a To nPlusA) (Is b To nPlusB)` for arguments
- `ValueN n atLeastN (Is a To nPlusA) (Is b To nPlusB)` for values which is a `In n atLeastN`

Other changes

- moved `mul`, `div`, `remainderBy`, `toPower`, `maxIs`, `toMin`, `lowerMin` from `MinNat` & `InNat` to `Nat`
- moved `atLeast` from `MinNat` to `InNat`



> The following changes are still from the old package `indique/elm-bounded-nat`:

## 9.0.0

- added `Infinity` to say: no upper maximum

Made `Min min` alias to type `In min Infinity`.

- renamed module `Nat.N` to `NNat`
- renamed module `Nat.In` to `InNat`
- renamed module `Nat.Min` to `MinNat`
- renamed module `Nat.Ns` to `NNats`
- removed functions that apply for any `max` in `MinNat`
- moved functions that just result in a `Nat (Min ...)` into `InNat`
- moved `abs` & `isInt...` & `int...` into `Nat`

### 9.1.0

- added `sub` & `add` in `NNat`.

#### 9.1.1

- minor doc fix for `Nat.Bound.In`

## 10.0.0

- added `maybeN` type parameter to `In`
- `N n (Is a To nPlusA) (Is b To nPlusB)` now looks like `N n (Is a To) nPlusA (And b To nPlusB)`

`N n (Is a To) nPlusA (And b To nPlusB)` is now a `In n nPlusA ...`.

- added `ValueIn`
- renamed `Min` to `ValueMin`
- added `ValueOnly`
- unexposed `Infinity`
- renamed `Nat.N.Type` to `TypeNats`
- moved `random` into `Nat`
- moved `range` into `Nat`
- moved operations like `mul`, where the `max` is ignored into `MinNat`
- renamed `dropMax` to `toMin`
- removed `NNat.toMin` as `dropMax` works the same
- removed `NNats.nat168` to `NNats.nat192` for performance reasons

## 11.0.0

Fixed a bug in the `MinNat.add` type. Please upgrade.

## 12.0.0

Fixed a bug with `maybeN` in the types of `MinNat.isAtLeast` & `MinNat.add`. Please upgrade.
