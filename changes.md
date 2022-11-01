### 29.2.0 plans

  - `N.Generator` that auto-generates `N<x>`, `Add<x>` and `n<x>` for x >= 17 add

# change log

### 28.1.0

  - `order` add

## 29.0.0

  - `minAtLeast` name → `atLeastMin`
  - `abs` name → `absoluteInt`
      - consistent with `inInt`, `atLeastInt`, ...
  - `Value`, `InValue` name → `FixedValue`, `InFixedValue`
      - consistent with `ExactlyValue`, `MinValue`, `InfinityValue`
  - `intAtLeast`, `intIn`, `intIsAtLeast`, `intIsIn`
    name → `atLeastInt`, `inInt`, `isAtLeastInt`, `isInInt`
  - `randomIn` name → `inRandom`
      - consistent with `inFuzz`, `inFuzzUniform`
  - `inFuzz ( lo, hi )`, `inFuzzUniform ( lo, hi )` add
  - `modulusByInt` add

## 28.0.0

  - `N.atMost` remove
      - type was impossible to set safely
  - `N.minAtMost` → `atMost` with arguments without max infinity allowed

## 27.0.0

  - `N.atMost` type correct
    ```elm
    N (In (Fixed takenMin) takenMax)
    -> N (In (Up minToTakenMin_ To takenMin) max_)
    -> N (In (Fixed takenMin) takenMax)
    ```
    →
    ```elm
    N (In (Up upperLimitMinToMax_ To upperLimitMin) upperLimitMax)
    -> N (In min (Fixed max))
    -> N (In min upperLimitMax)
    ```
  - `N.minAtMost` add
  - `N.intIn` upper limit maximum allowed to be more broad

## 26.0.0

  - `emptiness-typed`, `linear-direction` uses remove
      - `until` is already in `module ArraySized`
      - `smallest`, `greatest` remove
          - in favor of `Stack.fold Up N.smaller/N.greater`
  - `type N0able successorMinus1 n0PossiblyOrNever`
    →
    `N0OrAdd1 n0PossiblyOrNever successorMinus1`
      - more readable and understandable
  - `no-record-type-alias-constructor-function` dependency remove
      - `type alias In ... = RecordWithoutConstructorFunction { ... }`
        →
        `type In ... = Range { ... }`
  - `min`, `max` name → `minTo`, `maxTo`
      - make obvious it sets absolute
  - `maxNo` name → `maxToInfinity`
      - to make obvious it sets absolute like `maxTo` but up to `Infinity`
  - `minimumAsDifference`, `maximumAsDifference` name → `min`, `max`
      - to be more consistent with `minTo`, `maxTo`, `maxToInfinity`, `minDown`, `maxUp`, `maxToValue`, `maxFromValue`, ...
  - `valueToFixed`, `inValueToFixed` name → `fixedFromValue`, `inFixedFromValue`
  - `div`, `mul`, `sub` name → `divideBy`, `multiplyBy`, `subtract`
      - not aggressively common things should get descriptive names!
  - `minAdd`, `minSub` name → `addMin`, `subtractMin`
  - `upDifference`, `downDifference`, `differenceUp`, `differenceDown` name
    → `addDifference`, `subtractDifference`, `differenceAdd`, `differenceSubtract`
  - `Up0→16` add
      - to improve result write- and readability
  - `maxFromValue`, `maxToValue`, `minFromValue`, `minToValue` add
  - ```elm
    type alias Exactly n =
        In (Fixed n) (Fixed n)
    ```
    →
    ```elm
    InFixed n n
    ```

### 25.3.0

  - `smaller`, `greater` add

### 25.2.0

  - `toString` add
  - `smallest`, `greatest` add

### 25.1.0

  - fixed `Value` types, conversions add
      - not including functions
  - `InFixed` add

## 25.0.0

  - `Difference` made opaque
      - so that `toInt` can't be messed with
  - `fixed` remove
  - `MaxNo = Fixed { maximumUnknown : () }`
    → `Infinity = Fixed { infinity : () }`
  - `differenceToInt` add
  - `specific` add

## 24.0.0

  - `sub`, `minSub` minimum subtraction `Fixed`

### 23.1.0

  - `range` add

## 23.0.0

  - `atLeast` name → `minAtLeast`
  - `atLeast` with maximum `Fixed` add
  - `atMost` add

## 22.0.0

  - `up` remove
      - in favor of `until`
  - `random` remove
      - in favor of `randomIn`
  - range types redefine
    ```elm
    In minimumAsDifference maximumAsDifference
    ```
  - `differences` remove
      - in favor of `minimumDifference0`, `minimumDifference1`
  - `diff0`, `diff1` remove
      - now `minimumDifference`, `maximumDifference`
  - `minSubAtMost` subtrahend type correct
  - `minDown` name → `min`
      - make clear its absolute, not relative
  - `maxOpen` name → `max`
      - make clear its absolute, not relative
  - add, sub versions
    replace with just a normal and a `min`- version
  - `differencesSwap` remove
  - `NoMax` name → `MaxNo`
  - `noMax` name → `maxNo`
  - `noDiff` name → `fixed`
  - `minUp`, `minDown` add
  - `maxUp`, `maxDown` add
  - `type alias Fixed n = Up N0 To n` add
  - `type alias Down high to low = Up low to high` add

### 21.2.0

  - `randomIn` add
  - `differencesSwap` add

### 21.1.0

  - `until` add

## 21.0.0

  - every `module` merge → `N`
      - `MinNat` members prefixed with `min`-
      - `NNat` members prefixed with `diff`-
      - `Nats` >= 17 remove
          - https://github.com/lue-bird/elm-typesafe-array/issues/2
          - in favor of generating locally
      - `Nat<x>Plus` → `Add<x>`
      - `Nat<x>` → `N<x>`
      - `nat<x>` → `n<x>`
      - phantom types `Z`, `S`
        →
        ```elm
        type N0able successor possiblyOrNever
            = N0 possiblyOrNever
            | Add1 successor
        
        type alias N0 =
            N0able Never Possibly
        
        type alias Add1 successor =
            N0able successor Never
        ```
      - expose `N0able(..)`
      - `Nat` → `N` defined internally as
        ```elm
        type N.Internal.N range =
            NLimitedTo range Int
        ```
      - `ArgIn min max diff0 diff1`
        →
        ```elm
        type alias In min max possibleDifferences =
            RecordWithoutConstructorFunction
                { min : min
                , max : () -> max
                , diff : possibleDifferences
                }
        ```
      - `In min max` remove
          - in favor of `In min max {}`
      - `(Is lo0 To hi0) (Is lo1 To hi1)`
        →
        ```elm
        type alias Is diff0 diff1 =
            RecordWithoutConstructorFunction
                { diff0 : diff0, diff1 : diff1 }
        
        type Diff lo To high =
            Difference
                { sub : hi -> lo
                , add : lo -> hi
                }
        ```
      - `MinNat.atLeast lowerLimit` remove
          - in favor of `N.atLeast (lowerLimit |> noMax)`
      - `.serialize`, `.Error`, ... remove
          - easy to implement yourself
      - `type LessOrEqualOrGreater l e g` replace with
        `Result e (BelowOrAbove l g)`
      - `type BelowOrInOrAboveRange l e g` replace with
        `Result e (BelowOrAbove l g)`
      - `type BelowOrAtLeast l ge` replace with
        `Result ge l`
      - `type AtMostOrAbove le g` replace with
        `Result le g`
      - `InNat.addIn`, `InNat.subIn`, `Nat.random`, `Nat.range`, ... range arguments → tuple
      - compare operations remove requirements of what to compare against
          - to simplify
      - `min-` compare operations remove
          - because normal operations now work as well
      - `range a b` replace with
        `up (b - a) |> List.map (add a)`
      - -`InRange` operations rename → -`In`
      - `intIsAtLeast` change result
        `: Maybe` → `: Result Int`
      - `minAddMin` rename → `addAtLeast`
      - `minSubMax` rename → `minSubAtMost`
      - `toMin` rename → `noMax`
      - `toIn` rename → `noDiff`
      - `restoreMax` rename → `maxOpen`
      - `lowerMin` rename → `minDown`
      - `maxUp` add
      - `type BelowOrAbove l g` add
      - `toInt` add
      - `toFloat` add
      - internals on `Diff`, minimum add

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
- made `Nat.lowerMin natX` before `|> ...Nat.is... { min = natX }` redundant by replacing `min` with `{ lowest }` which can be ≤, not = the minimum. Changed functions:
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
