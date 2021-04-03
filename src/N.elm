module N exposing (Differences, In, Is, Nat(..), S, To, ValueN, Z)

{-| For performance reasons, supplying the modules [`TypeNats`](TypeNats) & [`NNats`](NNats) from here to make names shorter.
-}


type Nat range
    = Nat Int


type S more
    = S Never


type Z
    = Z Never


type Is a to b
    = Is Never


type To
    = To Never


type In minimum maximum maybeN
    = In Never


type alias ValueN n atLeastN asADifference asAnotherDifference =
    In n atLeastN (Differences asADifference asAnotherDifference)


type Differences a b
    = Differences Never
