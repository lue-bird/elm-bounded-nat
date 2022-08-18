module Help exposing (restoreTry)


restoreTry : (error -> value) -> (Result error value -> value)
restoreTry errorToValue =
    \result ->
        case result of
            Ok value ->
                value

            Err error ->
                error |> errorToValue
