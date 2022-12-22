## Why this, why that

### why these `something_` type variables?

The "_" at the end shows that this type variable is used only in this place.

Our types have a lot of type variables, most of them only used once.
If you see a -_ you know not to focus on these.

See the rule [`single-use-type-vars-end-with-underscore`](https://package.elm-lang.org/packages/lue-bird/elm-review-single-use-type-vars-end-with-underscore/latest/).

If you have questions, don't hesitate to ask (e.g. in slack (@lue lue.the.bird@gmail.com) or by starting a discussion in github)!

### why all the `...Min`- versions?

Can't we define `Infinity` so that it unifies with all other `Up` types?

    type alias Infinity =
        Add1 Infinity

but: elm doesn't like recursive aliases and rightfully so here
because such a value is `Never` constructable.
