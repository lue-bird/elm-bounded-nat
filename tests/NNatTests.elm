module NNatTests exposing (suite)

{-| Especially type tests.
-}

import Dict exposing (Dict)
import Expect
import NNat
import NNats exposing (..)
import Nat exposing (Is, N, Nat, To)
import Test exposing (Test, describe, test)
import TypeNats exposing (..)


suite : Test
suite =
    describe "NNat"
        [ test "add x |> sub x stays the same"
            (\() ->
                nat11
                    |> NNat.add ( nat9, nat9 )
                    |> NNat.sub ( nat9, nat9 )
                    |> Expect.equal nat11
            )
        ]


testAdd : Nat (N Nat16 (Nat16Plus more_) (Is a To (Nat16Plus a)) (Is b To (Nat16Plus b)))
testAdd =
    nat7 |> NNat.add ( nat9, nat9 )


testSub : Nat (N Nat8 (Nat8Plus more_) (Is a To (Nat8Plus a)) (Is b To (Nat8Plus b)))
testSub =
    nat17 |> NNat.sub ( nat9, nat9 )
