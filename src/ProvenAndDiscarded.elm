module ProvenAndDiscarded exposing
    ( ProvenAndDiscarded
    , from
    , map, mapFlat, and
    )

{-| Remember all the things you once experienced.
But you can't relive them... This is

@docs ProvenAndDiscarded


## create

@docs from


## alter

@docs map, mapFlat, and

-}

import ProvenAndDiscarded.Internal


{-| Tight safety layer for types with a phantom parameter.

You build a proof that one can produce values of the phantom type.
However, no specific values will be stored – it's write-only.

This allows us to use functions as phantom parameters
without compromising on

  - serializability, for example
      - json import/export on the debugger
  - calling `==`, for example
      - on hot module reloading
        with old code might end up remaining in the model
      - [lamdera](https://www.lamdera.com/)
      - accidental `==` crash
      - `Expect.equal`
  - runtime overhead

The very fact that this is "necessary" for convenience
(no extra functions to create a non-function representation of the base type)
makes me sad :(

I hear that there are efforts to allow serializing functions
which would make this mostly obsolete and me happy :)

Here's a nice quirk in comparison to values:

    ProvenAndDiscarded.from 0 == ProvenAndDiscarded 1
    --> True

Checking for equality always returns true, as both prove that such a type can exist.

-}
type alias ProvenAndDiscarded provenCanExist =
    ProvenAndDiscarded.Internal.ProvenAndDiscarded provenCanExist


{-| Proof that a value of a type can exist by giving a sample
-}
from : provenCanExist -> ProvenAndDiscarded provenCanExist
from provenCanExist =
    ProvenAndDiscarded.Internal.from provenCanExist


{-| Proof that a value of a type can exist by
describing how one would transform an existing [`ProvenAndDiscarded`](#ProvenAndDiscarded)
sample to this type
-}
map :
    (provenCanExist -> mappedProvenCanExist)
    -> (ProvenAndDiscarded provenCanExist -> ProvenAndDiscarded mappedProvenCanExist)
map provenCanExistChange =
    \provenAndDiscarded ->
        provenAndDiscarded
            |> mapFlat (\provenCanExist -> provenCanExist |> provenCanExistChange |> from)


{-| Proof that a value of a type can exist by
describing how one would transform an existing [`ProvenAndDiscarded`](#ProvenAndDiscarded)
sample to a proven and discarded sample of this type
-}
mapFlat :
    (provenCanExist -> ProvenAndDiscarded mappedProvenCanExist)
    -> (ProvenAndDiscarded provenCanExist -> ProvenAndDiscarded mappedProvenCanExist)
mapFlat provenCanExistChangeAndDiscard =
    \provenAndDiscarded ->
        ProvenAndDiscarded.Internal.map2Flat
            (\( provenCanExist, () ) -> provenCanExist |> provenCanExistChangeAndDiscard)
            ( provenAndDiscarded, from () )


{-| Add another type that you have proven can exist.
This is used similar to how you'd use `mapN`, `andThenN` and `andMap`:

    ProvenAndDiscarded.from "What is this"
        |> ProvenAndDiscarded.and
            (ProvenAndDiscarded.from " ")
        |> ProvenAndDiscarded.map
            (\( text, delimiter ) -> text |> String.split delimiter)

Note: last step can also be [`mapFlat`](#mapFlat) for example

-}
and :
    ProvenAndDiscarded additionalProvenCanExist
    -> ProvenAndDiscarded provenCanExist
    -> ProvenAndDiscarded ( provenCanExist, additionalProvenCanExist )
and additional =
    \provenAndDiscarded ->
        ProvenAndDiscarded.Internal.map2Flat from ( provenAndDiscarded, additional )
