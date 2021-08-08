module NNatTests exposing (suite)

import Expect
import NNat
import Nat exposing (Is, N, Nat, To)
import Nats exposing (..)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "NNat"
        [ test "add & sub"
            (\() ->
                nat11
                    |> NNat.add ( nat9, nat9 )
                    |> Expect.equal nat20
            )
        , test "sub"
            (\() ->
                nat11
                    |> NNat.sub ( nat9, nat9 )
                    |> Expect.equal nat2
            )
        ]


test0 :
    Nat
        (N
            (Nat160Plus Nat160)
            (Nat160Plus (Nat160Plus a_))
            (Is a To (Nat160Plus (Nat160Plus a)))
            (Is b To (Nat160Plus (Nat160Plus b)))
        )
test0 =
    nat160 |> NNat.add ( nat160, nat160 )


test1 :
    Nat
        (N
            (Nat160Plus Nat160)
            (Nat160Plus (Nat160Plus a_))
            (Is a To (Nat160Plus (Nat160Plus a)))
            (Is b To (Nat160Plus (Nat160Plus b)))
        )
test1 =
    nat160 |> NNat.add ( nat160, nat160 )


test2 :
    Nat
        (N
            (Nat160Plus Nat160)
            (Nat160Plus (Nat160Plus a_))
            (Is a To (Nat160Plus (Nat160Plus a)))
            (Is b To (Nat160Plus (Nat160Plus b)))
        )
test2 =
    nat160 |> NNat.add ( nat160, nat160 )


test3 :
    Nat
        (N
            (Nat160Plus Nat159)
            (Nat160Plus (Nat159Plus a_))
            (Is a To (Nat160Plus (Nat159Plus a)))
            (Is b To (Nat160Plus (Nat159Plus b)))
        )
test3 =
    nat160 |> NNat.add ( nat159, nat159 )


testBig :
    Nat
        (N
            (Nat160Plus (Nat159Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus Nat160)))))))
            (Nat160Plus (Nat159Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus a_))))))))
            (Is a To (Nat160Plus (Nat159Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus a)))))))))
            (Is b To (Nat160Plus (Nat159Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus (Nat160Plus b)))))))))
        )
testBig =
    test0
        |> NNat.add ( test1, test1 )
        |> NNat.add ( test2, test2 )
        |> NNat.add ( test3, test3 )
