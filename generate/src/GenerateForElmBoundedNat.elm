module GenerateForElmBoundedNat exposing (main)

{-| Helps you generate the source code of the modules
- [`NNat`](NNat)
- [`TypeNats`](NNat-Type)

Thanks to [`the-sett/elm-syntax-dsl`](https://package.elm-lang.org/packages/the-sett/elm-syntax-dsl/latest/)!
-}

import Browser
--import NNats exposing (..)
import Bytes.Encode
import Element as Ui
import Element.Background as UiBg
import Element.Border as UiBorder
import Element.Font as UiFont
import Element.Input as UiInput
import Elm.CodeGen
    exposing
        ( access
        , and
        , append
        , applyBinOp
        , binOp
        , binOpChain
        , caseExpr
        , char
        , code
        , composel
        , composer
        , cons
        , construct
        , customTypeDecl
        , equals
        , extRecordAnn
        , fqConstruct
        , fqFun
        , fqNamedPattern
        , fqTyped
        , fun
        , funExpose
        , importStmt
        , int
        , intAnn
        , lambda
        , letDestructuring
        , letExpr
        , letFunction
        , letVal
        , list
        , listAnn
        , listPattern
        , markdown
        , maybeAnn
        , minus
        , namedPattern
        , normalModule
        , openTypeExpose
        , parens
        , pipel
        , piper
        , plus
        , record
        , recordAnn
        , recordPattern
        , tuple
        , tupleAnn
        , tuplePattern
        , typeOrAliasExpose
        , typeVar
        , typed
        , unConsPattern
        , unit
        , unitAnn
        , val
        , valDecl
        , varPattern
        )
import Elm.Pretty
import Extra.GenerateElm exposing (..)
import Extra.Ui as Ui
import File.Download
import Html exposing (Html)
import Html.Attributes
import SyntaxHighlight
import Task
import Time
import Zip
import Zip.Entry


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { nNatsModuleShownOrFolded :
        ShownOrFolded (Ui.Element Msg)
    , natNTypeModuleShownOrFolded :
        ShownOrFolded (Ui.Element Msg)
    }


type ShownOrFolded content
    = Shown content
    | Folded



--tags

type NNatsTag =
    NNatsValue

type NatNTypeTag
    = NatNTypeExact
    | NatNTypeAtLeast

--


init : ( Model, Cmd Msg )
init =
    ( { nNatsModuleShownOrFolded = Folded
      , natNTypeModuleShownOrFolded = Folded
      }
    , Cmd.none
    )


type Msg
    = DownloadModules
    | DownloadModulesAtTime ( Time.Zone, Time.Posix )
    | SwitchVisibleModule ModulesInElmNArrays


type ModulesInElmNArrays
    = NNats
    | NatNType


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
                "elm-nArrays-modules.zip"
                "application/zip"
                (let
                    toZipEntry moduleFile =
                        zipEntryFromModule time moduleFile
                 in
                 Zip.fromEntries
                    [ toZipEntry nNatsModule
                    , toZipEntry natNTypeModule
                    ]
                    |> Zip.toBytes
                )
            )

        SwitchVisibleModule moduleKind ->
            ( case moduleKind of
                NNats ->
                    { model
                        | nNatsModuleShownOrFolded =
                            switchShownOrFolded
                                (.nNatsModuleShownOrFolded model)
                                viewNNatsModule
                    }
                NatNType ->
                    { model
                        | natNTypeModuleShownOrFolded =
                            switchShownOrFolded
                                (.natNTypeModuleShownOrFolded model)
                                viewNatNTypeModule
                    }
            , Cmd.none
            )


switchShownOrFolded :
    ShownOrFolded content
    -> content
    -> ShownOrFolded content
switchShownOrFolded visibility content =
    case visibility of
        Shown _ ->
            Folded

        Folded ->
            Shown content



--


natNAnn : Elm.CodeGen.TypeAnnotation -> Elm.CodeGen.TypeAnnotation
natNAnn n =
    typed "Nat" [ n ]


nAnn : Int  -> Elm.CodeGen.TypeAnnotation
nAnn n =
    typed "ValueN"
        [ natXAnn n
        , natXPlusAnn n (typeVar "more")
        , isAnn n "a"
        , isAnn n "b"
        ]

isAnn : Int -> String -> Elm.CodeGen.TypeAnnotation
isAnn n var =
    typed "Is"
        [ typeVar var, toAnn, natXPlusAnn n (typeVar var)
        ]

toAnn : Elm.CodeGen.TypeAnnotation
toAnn =
    typed "To" []

natXAnn : Int -> Elm.CodeGen.TypeAnnotation
natXAnn x =
    typed ("Nat" ++ String.fromInt x) []

natXPlusAnn : Int -> Elm.CodeGen.TypeAnnotation -> Elm.CodeGen.TypeAnnotation
natXPlusAnn x more =
    case x of
        0-> more
        _-> typed ("Nat" ++ String.fromInt x ++ "Plus") [ more ]


toIntAnn : Elm.CodeGen.TypeAnnotation
toIntAnn =
    funAnn [ natNAnn (typeVar "n") ] intAnn



--


lastN : Int
lastN =
    192
{- can be >= 168, avoided because of performance reasons.
-}
lastNatN : Int
lastNatN =
    168

viewNNatsModule : Ui.Element msg
viewNNatsModule =
    Ui.module_ nNatsModule


nNatsModule : Module NNatsTag
nNatsModule =
    { name = [ "NNats" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations->
                    [ markdown ("`Nat (N Nat0 ...)` to `Nat (N " ++ String.fromInt lastNatN ++ " ...)`.")
                    , markdown "Bigger `Nat (N ...)` s start to slow down compilation, so they are avoided."
                    , markdown "See [`Nat.Bound.N`](Nat-Bound#N), [`Nat.Bound.ValueN`](Nat-Bound#ValueN) & [`NNat`](NNat) for an explanation."
                    , docTagsFrom NNatsValue declarations
                    ]
            }
    , imports =
        [ importStmt [ "N" ] noAlias
            (exposingExplicit
                ([ openTypeExpose "Nat"
                ]
                    ++ ([ "Is", "ValueN", "To" ]
                            |> List.map typeOrAliasExpose
                        )
                )
            )
        , importStmt [ "TypeNats" ] noAlias exposingAll
        ]
    , declarations =
        List.range 0 lastNatN
            |> List.map
                (\x ->
                    packageExposedFunDecl NNatsValue
                        [ markdown ("The `Nat` " ++ String.fromInt x ++ ".") ]
                        (natNAnn (nAnn x))
                        ("nat" ++ String.fromInt x)
                        []
                        (construct "Nat" [ int x ])
                        {-(applyBinOp
                            (val ("nat" ++ String.fromInt (x - 1)))
                            piper
                            (fun "add1")
                        )-}
                )
    }


viewNatNTypeModule : Ui.Element msg
viewNatNTypeModule =
    Ui.module_ natNTypeModule


natNTypeModule : Module NatNTypeTag
natNTypeModule =
    { name = [ "TypeNats" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "Express exact natural numbers in a type."
                    , code "onlyExact1 : Nat (Only Nat1 maybeN) -> Cake"
                    , markdown "- `takesOnlyExact1 nat10` is a compile-time error"
                    , code "add2 : Nat (Only n maybeN) -> Nat (ValueOnly (Nat2Plus n))"
                    , markdown "- `add2 nat2` is of type `Nat (ValueOnly Nat4)`"
                    , markdown "### about a big limitation"
                    , markdown "Sadly, while experimenting with type aliases, I discovered that type aliases can only expand so much."
                    , code "compilingGetsKilled : Nat (N (Nat100Plus Nat93) x y)"
                    , markdown "If a type alias is not fully expanded after ~192 tries,"
                    , markdown "- the compilation stops"
                    , markdown "- the elm-stuff can corrupt"
                    , markdown "## at least"
                    , docTagsFrom NatNTypeAtLeast declarations
                    , markdown "## exact"
                    , docTagsFrom NatNTypeExact declarations
                    ]
            }
    , imports =
        [ importStmt [ "N" ]
            noAlias
            (exposingExplicit
                [ typeOrAliasExpose "S"
                , typeOrAliasExpose "Z"
                ]
            )
        ]
    , declarations =
        [ [ packageExposedAliasDecl NatNTypeAtLeast
                [ markdown "1 + some n, which is at least 1."
                ]
                "Nat1Plus"
                [ "n" ]
                (typed "S" [ typeVar "n" ])
          ]
        , List.range 2 lastN
            |> List.map
                (\n ->
                    packageExposedAliasDecl NatNTypeAtLeast
                        [ markdown
                            (String.fromInt n
                                ++ " + some n, which is at least "
                                ++ String.fromInt n
                                ++ "."
                            )
                        ]
                        ("Nat" ++ String.fromInt n ++ "Plus")
                        [ "n" ]
                        (natXPlusAnn (n - 1)
                            (typed "S" [ typeVar "n" ])
                        )
                )
        , [ packageExposedAliasDecl NatNTypeExact
                [ markdown "Exact the natural number 0."
                ]
                "Nat0"
                []
                (typed "Z" [])
          ]
        , List.range 1 192
            |> List.map
                (\n ->
                    packageExposedAliasDecl NatNTypeExact
                        [ markdown ("Exact the natural number " ++ String.fromInt n ++ ".")
                        ]
                        ("Nat" ++ String.fromInt n)
                        []
                        (natXPlusAnn n (typed "Z" []))
                )
        ]
            |> List.concat
    }


--


args : (arg -> String) -> List arg -> String
args argToString =
    List.map argToString >> String.join " "


indexed : ((String -> String) -> a) -> Int -> Int -> List a
indexed use first last =
    List.range first last
        |> List.map
            (\i ->
                use (\base -> base ++ String.fromInt i)
            )


charIndex : Int -> Char
charIndex i =
    i + Char.toCode 'a' |> Char.fromCode


charPrefixed : ((String -> String) -> a) -> Int -> List a
charPrefixed use last =
    List.range 0 last
        |> List.map
            (charIndex >> (\i -> use (String.cons i)))


view : Model -> Html Msg
view { nNatsModuleShownOrFolded, natNTypeModuleShownOrFolded } =
    Ui.layoutWith
        { options =
            [ Ui.focusStyle
                { borderColor = Just (Ui.rgba 0 1 1 0.38)
                , backgroundColor = Nothing
                , shadow = Nothing
                }
            ]
        }
        []
        (Ui.column
            [ Ui.paddingXY 40 60
            , Ui.spacing 32
            , Ui.width Ui.fill
            , Ui.height Ui.fill
            , UiBg.color (Ui.rgb255 35 36 31)
            , UiFont.color (Ui.rgb 1 1 1)
            ]
            [ Ui.el
                [ UiFont.size 40
                , UiFont.family [ UiFont.monospace ]
                ]
                (Ui.text "elm-bounded-nat modules")
            , UiInput.button
                [ Ui.padding 16
                , UiBg.color (Ui.rgba 1 0.4 0 0.6)
                ]
                { onPress = Just DownloadModules
                , label = Ui.text "⬇ download elm modules"
                }
            , Ui.column
                [ Ui.width Ui.fill
                ]
                (Ui.el [ Ui.paddingXY 0 6 ]
                    (Ui.text "📂 preview modules")
                    :: (let
                            switchButton text switch =
                                Ui.el
                                    [ Ui.width Ui.fill
                                    , Ui.paddingXY 0 6
                                    , Ui.moveUp 6
                                    ]
                                    (UiInput.button
                                        [ UiBg.color (Ui.rgba 1 0.4 0 0.6)
                                        , Ui.padding 12
                                        , Ui.width Ui.fill
                                        ]
                                        { onPress = Just switch
                                        , label =
                                            Ui.el
                                                [ UiFont.family [ UiFont.monospace ] ]
                                                (Ui.text text)
                                        }
                                    )

                            viewAccordingToShownOrFolded visibility name switch =
                                case visibility of
                                    Shown ui ->
                                        Ui.row
                                            [ Ui.height Ui.fill, Ui.width Ui.fill ]
                                            [ Ui.el
                                                [ Ui.width (Ui.px 1)
                                                , UiBg.color (Ui.rgba 1 0.4 0 0.6)
                                                , Ui.height Ui.fill
                                                ]
                                                Ui.none
                                            , Ui.column [ Ui.width Ui.fill ]
                                                [ switchButton ("⌃ " ++ name) switch
                                                , Ui.el [ Ui.moveRight 5 ] ui
                                                ]
                                            ]

                                    Folded ->
                                        switchButton ("⌄ " ++ name) switch
                        in
                        [ ( nNatsModuleShownOrFolded
                          , ( "NNats", NNats )
                          )
                        , ( natNTypeModuleShownOrFolded
                          , ( "TypeNats", NatNType )
                          )
                        ]
                            |> List.map
                                (\( visibility, ( name, moduleKind ) ) ->
                                    viewAccordingToShownOrFolded visibility
                                        name
                                        (SwitchVisibleModule moduleKind)
                                )
                       )
                )
            ]
        )
