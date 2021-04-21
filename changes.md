# changelog

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

## 1.0.0

> Repository username changed from `indique` to `lue-bird`

`N n (Is a To) nPlusA (And b To nPlusB)` is now

- `N n (Is a To nPlusA) (Is b To nPlusB)` for arguments
- `ValueN n atLeastN (Is a To nPlusA) (Is b To nPlusB)` for values which is a `In n atLeastN`

Other changes

- moved `mul`, `div`, `remainderBy`, `toPower`, `maxIs`, `toMin`, `lowerMin` from `MinNat` & `InNat` to `Nat`
- moved `atLeast` from `MinNat` to `InNat`

#### 1.0.1

Updated many old names in the documentation.

## 2.0.0

Fixed a bug in the type of `InNat.isAtMost`, `InNat.isInRange` & `MinNat.isAtMost`.

## 3.0.0

Improved compiling speed using [indique/n](https://package.elm-lang.org/packages/indique/n/).
- removed `nat161` to `nat168` for better compiling speed

## 4.0.0

Use [indique/n 2.0.0](https://package.elm-lang.org/packages/indique/n/).
- removed `Nat161`/`Nat161Plus` and above for better compiling speed

## 5.0.0

Changed `isAtLeast`'s `less` variant to be a `In ... maybeN`, not a `ValueIn`.
- updated links to elm-bounded-array
- replaced wrong usages of `natX |> NNat.toIn` in doc with `betweenXAndY`
- Changed some argument names

#### 5.0.1

Updated exposings & when to use `ValueSomething` in the readme.

#### 5.0.2

Corrected forgotten `maybeN`s, wrongly named `ValueMin/-In`s & minor doc mistakes.

#### 5.0.3

Corrected forgotten `maybeN`s & `min`s that were set to an exact value in doc.

#### 6.0.0

`Nat range` is now of type `Typed Checked (NatTag range) Public Int` from [`elm-typed-value`](https://package.elm-lang.org/packages/lue-bird/elm-typed-value/3.0.0/).
- removed `Nat.toInt` & `Nat.bi`. Use `val`/`val2` in `Typed`
- merged `Nat.Bound` types into `Nat`
