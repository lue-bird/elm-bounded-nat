module Common exposing
    ( fromInternalLessOrEqualOrGreater, fromInternalBelowOrInOrAboveRange, fromInternalAtMostOrAbove, fromInternalBelowOrAtLeast
    , serializeValid
    )

{-| Stuff that's used by many modules but shouldn't be exposed in `Nat`.


# compare


## comparison result

@docs fromInternalLessOrEqualOrGreater, fromInternalBelowOrInOrAboveRange, fromInternalAtMostOrAbove, fromInternalBelowOrAtLeast


# extra

@docs serializeValid

-}

import I as Internal
import Nat exposing (Nat)
import Serialize exposing (Codec)
import Typed exposing (val)



-- # compare
-- ## comparison result


fromInternalBelowOrAtLeast :
    Internal.BelowOrAtLeast less equalOrGreater
    -> Nat.BelowOrAtLeast less equalOrGreater
fromInternalBelowOrAtLeast belowOrAtLeast =
    case belowOrAtLeast of
        Internal.Below less ->
            Nat.Below less

        Internal.EqualOrGreater equalOrGreater ->
            Nat.EqualOrGreater equalOrGreater


fromInternalAtMostOrAbove :
    Internal.AtMostOrAbove lessOrEqual greater
    -> Nat.AtMostOrAbove lessOrEqual greater
fromInternalAtMostOrAbove atMostOrAbove =
    case atMostOrAbove of
        Internal.EqualOrLess equalOrLess ->
            Nat.EqualOrLess equalOrLess

        Internal.Above greater ->
            Nat.Above greater


fromInternalLessOrEqualOrGreater :
    Internal.LessOrEqualOrGreater less equal greater
    -> Nat.LessOrEqualOrGreater less equal greater
fromInternalLessOrEqualOrGreater lessOrEqualOrGreater =
    case lessOrEqualOrGreater of
        Internal.Less less ->
            Nat.Less less

        Internal.Equal equal ->
            Nat.Equal equal

        Internal.Greater greater ->
            Nat.Greater greater


fromInternalBelowOrInOrAboveRange :
    Internal.BelowOrInOrAboveRange below inRange above
    -> Nat.BelowOrInOrAboveRange below inRange above
fromInternalBelowOrInOrAboveRange belowOrInOrAboveRange =
    case belowOrInOrAboveRange of
        Internal.BelowRange lessThanMinimum ->
            Nat.BelowRange lessThanMinimum

        Internal.InRange inRange ->
            Nat.InRange inRange

        Internal.AboveRange greaterThanMaximum ->
            Nat.AboveRange greaterThanMaximum



-- # extra


serializeValid :
    (Int -> Result expected (Nat range))
    ->
        Codec
            { expected : expected
            , actual : Int
            }
            (Nat range)
serializeValid mapValid =
    Serialize.int
        |> Serialize.mapValid
            (\int ->
                mapValid int
                    |> Result.mapError
                        (\expected ->
                            { expected = expected
                            , actual = int
                            }
                        )
            )
            val
