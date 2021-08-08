module GenerateForElmBoundedNat exposing (main)

{-| Helps you generate the source code of the modules

  - [`NNat`](NNat)
  - [`TypeNats`](TypeNats)
  - [`N`](N)
  - the `natXs` in [`I`](I)

Thanks to [`the-sett/elm-syntax-dsl`](https://package.elm-lang.org/packages/the-sett/elm-syntax-dsl/latest/)!

-}

import Browser
import Element as Ui
import Element.Background as UiBg
import Element.Border as UiBorder
import Element.Font as UiFont
import Element.Input as UiInput
import Elm.CodeGen as Generation exposing (applyBinOp, code, construct, fqVal, importStmt, markdown, piper, tuple, typeVar, typed, val)
import Elm.CodeGen.Extra exposing (..)
import File.Download
import Html exposing (Html)
import Nats exposing (..)
import Task
import Time
import Ui.Extra as Ui exposing (edges)
import Zip


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { natsModuleFolding :
        Folding (Ui.Element Msg)
    }


type Folding content
    = Shown content
    | Folded



-- tags


type NatsTag
    = ExactTypeNat
    | TypeNatPlusN
    | NNatsValue



--


init : ( Model, Cmd Msg )
init =
    ( { natsModuleFolding = Folded
      }
    , Cmd.none
    )


type Msg
    = DownloadModules
    | DownloadModulesAtTime ( Time.Zone, Time.Posix )
    | SwitchVisibleModule CodeForElmBoundedArray


type CodeForElmBoundedArray
    = Nats


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DownloadModules ->
            ( model
            , Task.perform
                (\time -> DownloadModulesAtTime time)
                (Time.here
                    |> Task.andThen
                        (\here ->
                            Time.now
                                |> Task.map (\now -> ( here, now ))
                        )
                )
            )

        DownloadModulesAtTime time ->
            ( model
            , File.Download.bytes
                "elm-bounded-nat modules.zip"
                "application/zip"
                (let
                    toZipEntry moduleFile =
                        zipEntryFromModule time moduleFile
                 in
                 Zip.fromEntries
                    [ toZipEntry natsModule
                    ]
                    |> Zip.toBytes
                )
            )

        SwitchVisibleModule moduleKind ->
            ( case moduleKind of
                Nats ->
                    { model
                        | natsModuleFolding =
                            switchFolding
                                (.natsModuleFolding model)
                                viewNatsModule
                    }
            , Cmd.none
            )


switchFolding :
    Folding content
    -> content
    -> Folding content
switchFolding visibility content =
    case visibility of
        Shown _ ->
            Folded

        Folded ->
            Shown content



--


nNatX : Int -> String
nNatX x =
    [ "nat", x |> String.fromInt ] |> String.concat


natNAnn : Generation.TypeAnnotation -> Generation.TypeAnnotation
natNAnn n =
    typed "Nat" [ n ]


nAnn : Int -> Generation.TypeAnnotation
nAnn n =
    typed "N"
        [ natXAnn n
        , natXPlusAnn n (typeVar "a_")
        , isAnn n "a"
        , isAnn n "b"
        ]


isAnn : Int -> String -> Generation.TypeAnnotation
isAnn n var =
    typed "Is"
        [ typeVar var
        , toAnn
        , natXPlusAnn n (typeVar var)
        ]


toAnn : Generation.TypeAnnotation
toAnn =
    typed "To" []


natX : Int -> String
natX x =
    [ "Nat", x |> String.fromInt ]
        |> String.concat


natXAnn : Int -> Generation.TypeAnnotation
natXAnn x =
    typed (natX x) []


natXPlus : Int -> String
natXPlus x =
    [ "Nat", x |> String.fromInt, "Plus" ]
        |> String.concat


natXPlusAnn : Int -> Generation.TypeAnnotation -> Generation.TypeAnnotation
natXPlusAnn x more =
    case x of
        0 ->
            more

        _ ->
            typed (natXPlus x) [ more ]



--


lastN : Int
lastN =
    160


viewNatsModule : Ui.Element msg_
viewNatsModule =
    Ui.module_ natsModule


natsModule : Module NatsTag
natsModule =
    { name = [ "Nats" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "## [numbers](#numbers)"
                    , markdown
                        ([ "`"
                         , nNatX 0
                         , " : Nat (N "
                         , natX 0
                         , " ...)` to `"
                         , nNatX lastN
                         , " : Nat (N "
                         , natX lastN
                         , " ...)`."
                         ]
                            |> String.concat
                        )
                    , markdown "See [`Nat.N`](Nat#N), [`Nat.N`](Nat#N) & [`NNat`](NNat) for an explanation."
                    , markdown "##[types](#types)"
                    , markdown "Express exact natural numbers in a type."
                    , code "onlyExact1 : Nat (Only Nat1) -> Cake"
                    , markdown "- `takesOnlyExact1 nat10` is a compile-time error"
                    , code "add2 : Nat (Only n) -> Nat (Only (Nat2Plus n))"
                    , markdown "- `add2 nat2` is of type `Nat (Only Nat4)`"
                    , markdown "## limits"
                    , markdown "If type aliases expand too much"
                    , code "big : Nat (Only (Nat160Plus (Nat160Plus (Nat160Plus Nat160))))"
                    , markdown "- compilation is a bit slower (but following compilations are fast again)"
                    , markdown "- (`elm-stuff` can corrupt)"
                    , markdown "- **tools that analyse the types are slow**"
                    , markdown "# numbers"
                    , docTagsFrom NNatsValue declarations
                    , markdown "# types"
                    , markdown "## plus n"
                    , docTagsFrom TypeNatPlusN declarations
                    , markdown "## exact"
                    , docTagsFrom ExactTypeNat declarations
                    ]
            }
    , imports =
        [ importStmt [ "I" ]
            noAlias
            (exposingExplicit
                (aliasExpose [ "N", "Is", "To", "Nat", "S", "Z" ]
                    ++ funExpose [ "nNatAdd" ]
                )
            )
        ]
    , declarations =
        let
            exactDoc : Int -> Doc kind_
            exactDoc n =
                [ markdown
                    ([ "Exact the natural number "
                     , String.fromInt n
                     , "."
                     ]
                        |> String.concat
                    )
                ]

            natPlusNDoc : Int -> Doc kind_
            natPlusNDoc n =
                [ markdown
                    ([ n |> String.fromInt
                     , " + some natural number `n`."
                     ]
                        |> String.concat
                    )
                ]
        in
        [ [ 0, 1 ]
            |> List.map
                (\x ->
                    packageExposedFunDecl NNatsValue
                        [ markdown
                            ([ "The exact `Nat` ", x |> String.fromInt, "." ]
                                |> String.concat
                            )
                        ]
                        (natNAnn (nAnn x))
                        (nNatX x)
                        []
                        (fqVal [ "I" ] (nNatX x))
                )
        , List.range 2 lastN
            |> List.map
                (\x ->
                    packageExposedFunDecl NNatsValue
                        [ markdown
                            ([ "The exact `Nat` ", x |> String.fromInt, "." ]
                                |> String.concat
                            )
                        ]
                        (natNAnn (nAnn x))
                        (nNatX x)
                        []
                        (applyBinOp
                            (val (nNatX (x - 1)))
                            piper
                            (construct "nNatAdd"
                                [ tuple (List.repeat 2 (val (nNatX 1))) ]
                            )
                        )
                )
        , [ packageExposedAliasDecl TypeNatPlusN
                (natPlusNDoc 1)
                (natX 1 ++ "Plus")
                [ "n" ]
                (typed "S" [ typeVar "n" ])
          ]
        , List.range 2 lastN
            |> List.map
                (\n ->
                    packageExposedAliasDecl TypeNatPlusN
                        (natPlusNDoc n)
                        (natXPlus n)
                        [ "n" ]
                        (List.repeat n ()
                            |> List.foldl
                                (\() after -> typed "S" [ after ])
                                (typeVar "n")
                        )
                )
        , [ packageExposedAliasDecl ExactTypeNat
                (exactDoc 0)
                (natX 0)
                []
                (typed "Z" [])
          ]
        , List.range 1 lastN
            |> List.map
                (\n ->
                    packageExposedAliasDecl ExactTypeNat
                        (exactDoc n)
                        (natX n)
                        []
                        (natXPlusAnn n (typed "Z" []))
                )
        ]
            |> List.concat
    }



--


button :
    msg
    -> List (Ui.Attribute msg)
    -> Ui.Element msg
    -> Ui.Element msg
button onPress attributes label =
    UiInput.button
        ([ UiBorder.color (Ui.rgb 1 0.4 0)
         , UiBorder.widthEach { edges | bottom = 2 }
         ]
            ++ attributes
        )
        { onPress = Just onPress, label = label }


view : Model -> Html Msg
view { natsModuleFolding } =
    [ Ui.text "elm-bounded-nat modules"
        |> Ui.el
            [ UiFont.size 40
            , UiFont.family [ UiFont.monospace ]
            ]
    , button DownloadModules
        [ Ui.padding 16
        ]
        (Ui.text "⬇ download elm modules")
    , ((Ui.text "📂 preview modules"
            |> Ui.el [ Ui.paddingXY 0 6 ]
       )
        :: (let
                switchButton text switch =
                    button switch
                        [ Ui.padding 12
                        , Ui.width Ui.fill
                        ]
                        (Ui.text text
                            |> Ui.el
                                [ UiFont.family [ UiFont.monospace ] ]
                        )
                        |> Ui.el
                            [ Ui.paddingXY 0 4
                            , Ui.moveUp 6
                            ]

                viewAccordingToFolding visibility name switch =
                    case visibility of
                        Shown ui ->
                            [ Ui.el
                                [ Ui.width (Ui.px 1)
                                , UiBg.color (Ui.rgba 1 0.4 0 0.6)
                                , Ui.height Ui.fill
                                ]
                                Ui.none
                            , [ switchButton ("⌃ " ++ name) switch
                              , ui |> Ui.el [ Ui.moveRight 5 ]
                              ]
                                |> Ui.column []
                            ]
                                |> Ui.row
                                    [ Ui.height Ui.fill ]

                        Folded ->
                            switchButton ("⌄ " ++ name) switch
            in
            [ {- ( iValuesFolding
                   , ( "values in I", IValues )
                   )
                 ,
              -}
              ( natsModuleFolding
              , ( "Nats", Nats )
              )
            ]
                |> List.map
                    (\( visibility, ( name, moduleKind ) ) ->
                        viewAccordingToFolding visibility
                            name
                            (SwitchVisibleModule moduleKind)
                    )
           )
      )
        |> Ui.column
            [ Ui.width Ui.fill
            ]
    ]
        |> Ui.column
            [ Ui.paddingXY 40 60
            , Ui.spacing 32
            , Ui.width Ui.fill
            , Ui.height Ui.fill
            , UiBg.color (Ui.rgb255 35 36 31)
            , UiFont.color (Ui.rgb 1 1 1)
            ]
        |> Ui.layoutWith
            { options =
                [ Ui.focusStyle
                    { borderColor = Just (Ui.rgba 0 1 1 0.4)
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            []
