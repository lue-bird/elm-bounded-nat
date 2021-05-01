module NNat exposing (add, sub)

{-| Operations that only apply for `Nat (N ...)`s.


## modify

@docs add, sub

-}

import I as Internal
import Nat exposing (Is, N, Nat, To, ValueN)


{-| The `Nat (N ...)` plus another `Nat (N ...)`. Give the added value twice as a tuple.

    nat6 |> NNat.add ( nat5, nat5 )
    --> Nat 11 :
    --> Nat
    -->     (ValueN Nat11
    -->         (Nat11Plus a)
    -->         (Is a To Nat11Plus a)
    -->         (Is b To Nat11Plus b)
    -->     )

This is only rarely useful, as you shouldn't

    inRangeXAndXPlus10 x =
        -- won't work
        isInRange x (x |> NNat.add ( nat10, nat10 ))

    isAtLeast10GreaterThan x =
        -- the only use case
        isAtLeast (x |> NNat.add ( nat10, nat10 ))

(examples don't compile, just for demonstration)

-}
add :
    ( Nat (N added (Is n To sum) (Is atLeastN To atLeastSum))
    , Nat
        (N
            added
            (Is aPlusN To aPlusSum)
            (Is bPlusN To bPlusSum)
        )
    )
    -> Nat (ValueN n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    -> Nat (ValueN sum atLeastSum (Is a To aPlusSum) (Is b To bPlusSum))
add nNatToAdd =
    Internal.add (nNatToAdd |> Tuple.first)


{-| The `Nat (N ...)` plus another `Nat (N ...)`. Give the subtracted value twice as a tuple.

    nat6 |> NNat.sub ( nat5, nat5 )
    --> Nat 1 :
    --> Nat
    -->     (N Nat1
    -->         (Is a To Nat1Plus a)
    -->         (Is b To Nat1Plus b)
    -->     )

This is only rarely useful, as you shouldn't

    inRangeXMinus10ToX x =
        -- won't work
        isInRange (x |> NNat.sub ( nat10, nat10 )) x

    isAtLeast10LessThan x =
        -- the only use case
        isAtLeast (x |> NNat.sub ( nat10, nat10 ))

(examples don't compile, just for demonstration)

-}
sub :
    ( Nat (N subbed (Is difference To n) (Is atLeastDifference To atLeastN))
    , Nat
        (N
            subbed
            (Is aPlusDifference To aPlusN)
            (Is bPlusDifference To bPlusN)
        )
    )
    -> Nat (ValueN n atLeastN (Is a To aPlusN) (Is b To bPlusN))
    ->
        Nat
            (ValueN
                difference
                atLeastDifference
                (Is a To aPlusDifference)
                (Is b To bPlusDifference)
            )
sub nNatToSubtract =
    Internal.sub (nNatToSubtract |> Tuple.first)
