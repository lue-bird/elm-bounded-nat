module NNatTests exposing (suite)

{-| Especially type tests.
-}

import Dict exposing (Dict)
import Expect
import NNat
import NNats exposing (..)
import Nat exposing (Nat)
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


testAddN =
    nat7 |> NNat.add ( nat9, nat9 )


testSubN =
    nat17 |> NNat.sub ( nat9, nat9 )
