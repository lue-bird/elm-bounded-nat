module ProvenAndDiscarded.Internal exposing (ProvenAndDiscarded, from, map2Flat)

{-| The unsafe part of `ProvenAndDiscarded`.

Every function type here must be checked with extreme detail

All the other helpers in `module ProvenAndDiscarded` are build using
only these:

@docs ProvenAndDiscarded, from, map2Flat

-}


type ProvenAndDiscarded provenCanExist
    = ProvenAndDiscarded


from : provenCanExist -> ProvenAndDiscarded provenCanExist
from _ =
    ProvenAndDiscarded


map2Flat :
    (( a, b )
     -> ProvenAndDiscarded combinedProvenCanExist
    )
    ->
        (( ProvenAndDiscarded a, ProvenAndDiscarded b )
         -> ProvenAndDiscarded combinedProvenCanExist
        )
map2Flat _ =
    \( ProvenAndDiscarded, ProvenAndDiscarded ) -> ProvenAndDiscarded
