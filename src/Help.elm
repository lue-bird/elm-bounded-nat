module Help exposing (valueElseOnError)


valueElseOnError : (error -> value) -> (Result error value -> value)
valueElseOnError errorToValue =
    \result ->
        case result of
            Ok value ->
                value

            Err error ->
                error |> errorToValue
