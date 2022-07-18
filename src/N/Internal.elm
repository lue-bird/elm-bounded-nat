module N.Internal exposing
    ( N, NoMax
    , minWith
    , toInt, minimum
    , maxMap, maxFrom
    , minMap
    , MinAndMinAsDifferencesAndMax, differencesTo, minDifference0, minDifference1, n0
    )

{-|

@docs N, NoMax


## create

@docs minWith


## scan

@docs toInt, differences, minimum


## alter

@docs maxMap, maxFrom
@docs minMap
@docs differenceTo

-}

import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)


{-| A **bounded** natural number `>= 0`.
-}
type N range
    = NLimitedTo range Int


type alias NoMax =
    RecordWithoutConstructorFunction
        { maximumUnknown : () }


type alias MinAndMinAsDifferencesAndMax minimum minimumAsDifference0 minimumAsDifference1 maximum =
    RecordWithoutConstructorFunction
        { minimum : minimum
        , maximum : () -> maximum
        , minimumDifference0 : minimumAsDifference0
        , minimumDifference1 : minimumAsDifference1
        }


{-| Drop the range constraints
to supply another library with its `Int` representation.
-}
toInt : N range_ -> Int
toInt =
    \(NLimitedTo _ int) -> int


{-| The smallest allowed number promised by the range type.
-}
minimum : N (MinAndMinAsDifferencesAndMax minimum minDiff0_ minDiff1_ max_) -> minimum
minimum =
    \(NLimitedTo rangeLimits _) -> rangeLimits.minimum


minWith :
    min
    -> minDiff0
    -> minDiff1
    -> (Int -> N (MinAndMinAsDifferencesAndMax min minDiff0 minDiff1 NoMax))
minWith lowerLimit minDiff0 minDiff1 =
    NLimitedTo
        { minimum = lowerLimit
        , maximum = \() -> { maximumUnknown = () }
        , minimumDifference0 = minDiff0
        , minimumDifference1 = minDiff1
        }


{-| Replace its greatest allowed number promised by the range type with another from a given [`N`](#N).
-}
maxFrom :
    N (MinAndMinAsDifferencesAndMax toTransferMaxFromMin_ toTransferMaxFromMinDifference0_ toTransferMaxFromMinDifference1_ maxToTransfer)
    ->
        (N (MinAndMinAsDifferencesAndMax min minDifference0 minDifference1 max_)
         -> N (MinAndMinAsDifferencesAndMax min minDifference0 minDifference1 maxToTransfer)
        )
maxFrom toTransferMaxFrom =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { minimum = nLimits.minimum
                , maximum =
                    \() ->
                        let
                            (NLimitedTo toTransferMaxFromLimit _) =
                                toTransferMaxFrom
                        in
                        toTransferMaxFromLimit.maximum ()
                , minimumDifference0 = nLimits.minimumDifference0
                , minimumDifference1 = nLimits.minimumDifference1
                }


{-| Change its greatest allowed number promised by the range type with another from a given [`N`](#N).
-}
maxMap :
    (max -> maxMapped)
    ->
        (N (MinAndMinAsDifferencesAndMax min minDifference0 minDifference1 max)
         -> N (MinAndMinAsDifferencesAndMax min minDifference0 minDifference1 maxMapped)
        )
maxMap maxChange =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { minimum = nLimits.minimum
                , maximum =
                    \() -> nLimits.maximum () |> maxChange
                , minimumDifference0 = nLimits.minimumDifference0
                , minimumDifference1 = nLimits.minimumDifference1
                }


{-| Change its smallest allowed number promised by the range type with another from a given [`N`](#N).
-}
minMap :
    (min -> minMapped)
    ->
        (N (MinAndMinAsDifferencesAndMax min minDifference0 minDifference1 max)
         -> N (MinAndMinAsDifferencesAndMax minMapped minDifference0 minDifference1 max)
        )
minMap minChange =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { minimum = nLimits.minimum |> minChange
                , maximum = nLimits.maximum
                , minimumDifference0 = nLimits.minimumDifference0
                , minimumDifference1 = nLimits.minimumDifference1
                }


differencesTo :
    minDifference0Replacement
    -> minDifference1Replacement
    ->
        (N (MinAndMinAsDifferencesAndMax min minDifference0_ minDifference1_ max)
         -> N (MinAndMinAsDifferencesAndMax min minDifference0Replacement minDifference1Replacement max)
        )
differencesTo difference0Replacement difference1Replacement =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { minimum = nLimits.minimum
                , maximum = nLimits.maximum
                , minimumDifference0 = difference0Replacement
                , minimumDifference1 = difference1Replacement
                }


{-| The minimum representation as the first difference promised by its type
-}
minDifference0 : N (MinAndMinAsDifferencesAndMax min_ minDifference0 minDifference1 max_) -> minDifference0
minDifference0 =
    \(NLimitedTo rangeLimits _) -> rangeLimits.minimumDifference0


{-| The minimum representation as the first difference promised by its type
-}
minDifference1 : N (MinAndMinAsDifferencesAndMax min_ minDifference0 minDifference1 max_) -> minDifference1
minDifference1 =
    \(NLimitedTo rangeLimits _) -> rangeLimits.minimumDifference1


{-| The exact natural number `0`
-}
n0 : n0 -> minDiff0 -> minDiff1 -> N (MinAndMinAsDifferencesAndMax n0 minDiff0 minDiff1 atLeast_)
n0 n0Min minDiff0 minDiff1 =
    0
        |> minWith n0Min minDiff0 minDiff1
        |> maxMap
            (\_ ->
                let
                    {- The [mutual recursion prevents TCO](https://jfmengels.net/tail-call-optimization/#so-what-are-these-conditions),
                       forcing a stack overflow runtime exception.

                       The arguments help identify the cause on inspection when debugging.

                    -}
                    failLoudlyWithStackOverflow : List String -> valueThatWillNeverBeCreatedDueToRuntimeError_
                    failLoudlyWithStackOverflow details =
                        let
                            failLoudlyWithStackOverflowMutuallyRecursive : List String -> valueThatWillNeverBeCreatedDueToRuntimeError_
                            failLoudlyWithStackOverflowMutuallyRecursive messageAndCulpritRecursive =
                                failLoudlyWithStackOverflow messageAndCulpritRecursive
                        in
                        failLoudlyWithStackOverflowMutuallyRecursive details
                in
                {- Currently, by design, no `N0able` unifies with higher `N<x>`s

                       N0 Possible

                   is impossible as a maximum for `n0` for example because

                       N0able atLeast Possibly

                   correctly doesn't unify with any `N< x≥1 >`

                   ideas:

                   - 👎 define
                       n<x> : N (In (Add<x> atLeast\_) N<x> ...)
                       N<x> = Add<x> Never -- to forbid > max
                       N0able s = [ N0 | Add1 s ]
                   - requirements for minimum can't be expressed
                   - `Increase` `sub` becomes impossible to implement
                   - 👎 adding an escape hatch
                       N0able s possiblyOrNever = [ N0AtLeast | N0 possiblyOrNever | Add1 s ]
                   - `Increase` `sub` becomes impossible to implement

                   Happen to have more ideas
                   on how to avoid the current hack (which also makes elm crash on `==`)?
                   → please PR

                -}
                failLoudlyWithStackOverflow
                    [ "internal minimum evaluated or leaked somewhere from `N`'s API."
                    , "💙 Please report under https://github.com/lue-bird/elm-bounded-nat/issues"
                    ]
            )
