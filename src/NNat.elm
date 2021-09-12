module NNat exposing (add, sub)

{-| Operations that can only be used with `Nat (N ...)`s (`nat0`, `nat1`, ...). You will probably never need those.


# modify

@docs add, sub

-}

import I as Internal
import Nat exposing (Is, N, Nat, To)


{-| The `Nat (N ...)` plus another `Nat (N ...)`. Give the added value twice as a tuple.

    nat6 |> NNat.add ( nat5, nat5 )
    --> nat11
    -->     : Nat
    -->        (N Nat11
    -->            (Nat11Plus a_)
    -->            (Is a To Nat11Plus a)
    -->            (Is b To Nat11Plus b)
    -->        )

This is only rarely useful, as you shouldn't

    inRangeXAndXPlus10 x =
        -- won't work
        isInRange x (x |> NNat.add ( nat10, nat10 ))

Only use it when the `Nat (N ...)` is used once.

    isAtLeast10GreaterThan x =
        isAtLeast (x |> NNat.add ( nat10, nat10 ))

(examples don't compile)

-}
add :
    ( Nat (N added atLeastFirstAdded_ (Is n To sum) (Is atLeastN To atLeastSum))
    , Nat
        (N
            added
            atLeastSecondAdded_
            (Is aPlusN To aPlusSum)
            (Is bPlusN To bPlusSum)
        )
    )
    -> Nat (N n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    -> Nat (N sum atLeastSum (Is a To aPlusSum) (Is b To bPlusSum))
add nNatToAdd =
    Internal.nNatAdd nNatToAdd


{-| The `Nat (N ...)` minus another `Nat (N ...)`. Give the subtracted value twice as a tuple.

    nat6 |> NNat.sub ( nat5, nat5 )
    --> nat1 :
    -->     Nat
    -->         (N Nat1 (Nat1Plus a_)
    -->             (Is a To (Nat1Plus a))
    -->             (Is b To (Nat1Plus b))
    -->         )

This is only rarely useful, as you shouldn't

    inRangeXMinus10ToX x =
        -- won't work
        isInRange (x |> NNat.sub ( nat10, nat10 )) x

Only use it when the `Nat (N ...)` is used once.

    isAtLeast10LessThan x =
        isAtLeast (x |> NNat.sub ( nat10, nat10 ))

(examples don't compile)

-}
sub :
    ( Nat
        (N
            subbed
            atLeastFirstSubbed_
            (Is difference To n)
            (Is atLeastDifference To atLeastN)
        )
    , Nat
        (N
            subbed
            atLeastSecondSubbed_
            (Is aPlusDifference To aPlusN)
            (Is bPlusDifference To bPlusN)
        )
    )
    -> Nat (N n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    ->
        Nat
            (N
                difference
                atLeastDifference
                (Is a To aPlusDifference)
                (Is b To bPlusDifference)
            )
sub nNatToSubtract =
    Internal.nNatSub nNatToSubtract
