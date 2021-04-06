module T exposing (Differences, In, Is, Nat(..), To, ValueN)

{-| For performance reasons, supplying the module [`NNats`](NNats) from here to make names shorter.
-}


type Nat range
    = Nat Int


type Is a to b
    = Is Never


type To
    = To Never


type In minimum maximum maybeN
    = In Never


type alias ValueN n atLeastN asADifference asAnotherDifference =
    N n atLeastN asADifference asAnotherDifference


type alias N n atLeastN asADifference asAnotherDifference =
    In n atLeastN (Differences asADifference asAnotherDifference)


type alias Differences a b =
    D a b


type D a b
    = D Never
