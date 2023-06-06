module ProvenAndDiscarded exposing
    ( ProvenAndDiscarded
    , from
    , map, and
    )

{-| Remember all the things you once experienced.
But you can't relive them... This is

@docs ProvenAndDiscarded


## create

@docs from


## alter

@docs map, and

-}


{-| Tight safety layer for types with a phantom parameter.

You proof that you can produce the phantom values but don't store them,
allowing for no runtime overhead and the use of functions as phantom parameters
without compromising on

  - serializability, for example
      - json import/export on the debugger
  - calling `==`, for example
      - on hot module reloading
        with old code might end up remaining in the model
      - [lamdera](https://www.lamdera.com/)
      - accidental `==` crash

The very fact that this is "necessary" for convenience
(no extra functions to create a non-function representation of the base type)
makes me sad :(

-}
type ProvenAndDiscarded provenCanExist
    = ProvenAndDiscarded


from : provenCanExist -> ProvenAndDiscarded provenCanExist
from _ =
    ProvenAndDiscarded


map :
    (provenCanExist -> mappedProvenCanExist)
    -> (ProvenAndDiscarded provenCanExist -> ProvenAndDiscarded mappedProvenCanExist)
map _ =
    \ProvenAndDiscarded -> ProvenAndDiscarded


{-| -}
and :
    ProvenAndDiscarded additionalProvenCanExist
    -> ProvenAndDiscarded provenCanExist
    -> ProvenAndDiscarded ( provenCanExist, additionalProvenCanExist )
and additional =
    \ProvenAndDiscarded -> ProvenAndDiscarded
