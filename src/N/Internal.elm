module N.Internal exposing
    ( N, NoMax(..)
    , minWith
    , toInt, differences, minimum
    , maxMap, maxFrom, differenceTo
    )

{-|

@docs N, NoMax


## create

@docs minWith


## scan

@docs toInt, differences, minimum


## alter

@docs maxMap, maxFrom, differenceTo

-}

import RecordWithoutConstructorFunction exposing (RecordWithoutConstructorFunction)


{-| A **bounded** natural number `>= 0`.
-}
type N range
    = NLimitedTo range Int


type NoMax
    = MaximumUnknown


type alias In min max difference =
    RecordWithoutConstructorFunction
        { min : min
        , max : () -> max
        , diff : difference
        }


{-| Drop the range constraints
to supply another library with its `Int` representation.
-}
toInt : N range_ -> Int
toInt =
    \(NLimitedTo _ int) -> int


{-| The smallest allowed number promised by the range type.
-}
minimum : N (In minimum max_ difference_) -> minimum
minimum =
    \(NLimitedTo rangeLimits _) -> rangeLimits.min


minWith : min -> (Int -> N (In min NoMax {}))
minWith lowerLimit =
    NLimitedTo
        { min = lowerLimit
        , max = \() -> MaximumUnknown
        , diff = {}
        }


{-| Replace its greatest allowed number promised by the range type with another from a given [`N`](#N).

**Should not be exposed!**

-}
maxFrom :
    N (In toTransferMaxFromMin_ maxToTransfer toTransferMaxFromDifference_)
    ->
        (N (In min max_ difference)
         -> N (In min maxToTransfer difference)
        )
maxFrom toTransferMaxFrom =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { min = nLimits.min
                , max =
                    \() ->
                        let
                            (NLimitedTo toTransferMaxFromLimit _) =
                                toTransferMaxFrom
                        in
                        toTransferMaxFromLimit.max ()
                , diff = nLimits.diff
                }


{-| Change its greatest allowed number promised by the range type with another from a given [`N`](#N).

**Should not be exposed!**

-}
maxMap :
    (max -> maxMapped)
    ->
        (N (In min max difference)
         -> N (In min maxMapped difference)
        )
maxMap maxChange =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { min = nLimits.min
                , max =
                    \() -> nLimits.max () |> maxChange
                , diff = nLimits.diff
                }


differenceTo :
    differenceReplacement
    ->
        (N (In min max difference_)
         -> N (In min max differenceReplacement)
        )
differenceTo differenceReplacement =
    \(NLimitedTo nLimits int) ->
        int
            |> NLimitedTo
                { min = nLimits.min
                , max = nLimits.max
                , diff = differenceReplacement
                }


{-| The number representation as all differences promised by its type.
-}
differences : N (In min_ max_ differences) -> differences
differences =
    \(NLimitedTo rangeLimits _) -> rangeLimits.diff
