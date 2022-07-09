module N.Generate exposing (main)

{-| Helps you generate the source code of the module `Ns`.

Run `elm reactor` in this directory to preview & download.

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
    { numberToGenerateFor : Int
    , moduleNFolding : Folding
    , moduleNBinaryFolding : Folding
    , moduleNLinearFolding : Folding
    }


type Folding
    = Shown
    | Folded



--


init : ( Model, Cmd Msg )
init =
    ( { numberToGenerateFor = 31
      , moduleNFolding = Folded
      , moduleNBinaryFolding = Folded
      , moduleNLinearFolding = Folded
      }
    , Cmd.none
    )


type Msg
    = NumberToGenerateForChanged String
    | DownloadModules
    | DownloadModulesAtTime ( Time.Zone, Time.Posix )
    | SwitchVisibleModule GeneratedModuleKind


type GeneratedModuleKind
    = N0To16
    | NBinary
    | NLinear


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumberToGenerateForChanged text ->
            ( case text |> String.toInt of
                Just number ->
                    { model
                        | numberToGenerateFor = number
                        , moduleNBinaryFolding = Folded
                        , moduleNLinearFolding = Folded
                        , moduleNFolding = Folded
                    }

                Nothing ->
                    model
            , Cmd.none
            )

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
                "bounded-nat.zip"
                "application/zip"
                (let
                    toZipEntry moduleFile =
                        zipEntryFromModule time moduleFile
                 in
                 Zip.fromEntries
                    [ toZipEntry n0To16Module
                    ]
                    |> Zip.toBytes
                )
            )

        SwitchVisibleModule moduleKind ->
            ( case moduleKind of
                N0To16 ->
                    { model
                        | moduleNFolding =
                            model.moduleNFolding |> foldingToggle
                    }

                NBinary ->
                    { model
                        | moduleNBinaryFolding =
                            model.moduleNBinaryFolding |> foldingToggle
                    }

                NLinear ->
                    { model
                        | moduleNLinearFolding =
                            model.moduleNLinearFolding |> foldingToggle
                    }
            , Cmd.none
            )


foldingToggle : Folding -> Folding
foldingToggle visibility =
    case visibility of
        Shown ->
            Folded

        Folded ->
            Shown



--


nX : Int -> String
nX x =
    [ "n", x |> String.fromInt ] |> String.concat


nType : Generation.TypeAnnotation -> Generation.TypeAnnotation
nType n =
    typed "N" [ n ]


inDiffType : Int -> Generation.TypeAnnotation
inDiffType n =
    typed "In"
        [ nXType n
        , addXType n
            (n0ableType (typeVar "atLeast_") possiblyType)
        , isType n
        ]


isType : Int -> Generation.TypeAnnotation
isType n =
    typed "Is"
        [ diffType n "x0"
        , diffType n "x1"
        ]


diffType : Int -> String -> Generation.TypeAnnotation
diffType n var =
    typed "Diff"
        [ typeVar var
        , toType
        , addXType n (typeVar var)
        ]


toType : Generation.TypeAnnotation
toType =
    typed "To" []


nXType : Int -> Generation.TypeAnnotation
nXType x =
    typed
        ([ "N", x |> String.fromInt ] |> String.concat)
        []


addX : Int -> String
addX x =
    [ "Add", x |> String.fromInt ] |> String.concat


addXType : Int -> Generation.TypeAnnotation -> Generation.TypeAnnotation
addXType x more =
    case x of
        0 ->
            more

        1 ->
            n0ableType more possiblyType

        n2AtLeast ->
            typed (addX n2AtLeast) [ more ]


diffAdd : Int -> Generation.Expression
diffAdd powerInInt =
    construct "diffAdd"
        [ tuple (List.repeat 2 (val (nX powerInInt))) ]


n0ableType :
    Generation.TypeAnnotation
    -> Generation.TypeAnnotation
    -> Generation.TypeAnnotation
n0ableType minus1 possiblyOrNever =
    typed "N0able" [ minus1, possiblyOrNever ]


neverType : Generation.TypeAnnotation
neverType =
    typed "Never" []


possiblyType : Generation.TypeAnnotation
possiblyType =
    typed "Possibly" []



-- tags


type NsTag
    = TypeExact
    | TypeAdd
    | NDiffValue



--


n0To16Module : Module NsTag
n0To16Module =
    let
        lastN : Int
        lastN =
            16
    in
    { name = [ "N0To16" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "Default implementation for the members of the `bounded-nat` package"
                    ]
            }
    , imports = []
    , declarations =
        let
            exactDoc : Int -> Doc kind_
            exactDoc n =
                [ markdown
                    ([ "Type for the exact natural number `"
                     , String.fromInt n
                     , "`"
                     ]
                        |> String.concat
                    )
                ]
        in
        [ List.range 2 lastN
            |> List.map
                (\x ->
                    packageExposedFunDecl NDiffValue
                        [ markdown
                            ([ "The exact natural number `", x |> String.fromInt, "`" ]
                                |> String.concat
                            )
                        ]
                        (nType (inDiffType x))
                        (nX x)
                        []
                        (applyBinOp
                            (val (nX (x - 1)))
                            piper
                            (diffAdd 1)
                        )
                )
        , List.range 1 lastN
            |> List.map
                (\n ->
                    packageExposedAliasDecl TypeAdd
                        [ markdown
                            ([ "Type for the natural number `"
                             , n |> String.fromInt
                             , " +` some natural number `n`"
                             ]
                                |> String.concat
                            )
                        ]
                        (addX n)
                        [ "n" ]
                        (List.repeat n ()
                            |> List.foldl
                                (\() soFar ->
                                    n0ableType soFar neverType
                                )
                                (typeVar "n")
                        )
                )
        , List.range 0 lastN
            |> List.map
                (\n ->
                    packageExposedAliasDecl TypeExact
                        (exactDoc n)
                        ([ "N", n |> String.fromInt ] |> String.concat)
                        []
                        (List.repeat n ()
                            |> List.foldl
                                (\() soFar ->
                                    n0ableType soFar neverType
                                )
                                (n0ableType neverType possiblyType)
                        )
                )
        ]
            |> List.concat
    }


nBinaryModule : Int -> Module NsTag
nBinaryModule n =
    { name = [ "N", "Binary" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "When you need big numbers or multiple medium sized ones."
                    ]
            }
    , imports =
        [ importStmt [ "N" ]
            noAlias
            (exposingExplicit
                (aliasExpose [ "N", "Is", "To", "In", "N0", "Add1", "Add2", "Add4", "Add8", "Add16" ]
                    ++ funExpose [ "n1", "n2", "n4", "n8", "n16", "diffAdd" ]
                )
            )
        ]
    , declarations =
        [ packageExposedFunDecl NDiffValue
            [ markdown
                ([ "The exact natural number `", n |> String.fromInt, "`" ]
                    |> String.concat
                )
            ]
            (nType (inDiffType n))
            (nX n)
            []
            (case
                n
                    |> intToPowersOf 2
                    |> List.concatMap
                        (\part ->
                            List.repeat part.amount part.power
                        )
                    |> List.reverse
             of
                [] ->
                    Generation.string "the number to generate for must be ≥ 1"

                greatestPower :: smallerPowers ->
                    let
                        folding =
                            case smallerPowers of
                                [] ->
                                    { initial = greatestPower - 1
                                    , list = List.repeat 1 (greatestPower - 1)
                                    }

                                secondGreatestPower :: evenSmallerPowers ->
                                    { initial = greatestPower
                                    , list = secondGreatestPower :: evenSmallerPowers
                                    }
                    in
                    folding.list
                        |> List.map (\power -> 2 ^ power)
                        |> List.foldl
                            (\n10ToPower soFar ->
                                applyBinOp
                                    soFar
                                    piper
                                    (diffAdd n10ToPower)
                            )
                            (val (nX (2 ^ folding.initial)))
            )
        , packageExposedAliasDecl TypeAdd
            [ markdown
                ([ "Type for the natural number `"
                 , n |> String.fromInt
                 , " +` some natural number `n`"
                 ]
                    |> String.concat
                )
            ]
            (addX n)
            [ "n" ]
            ((case
                n
                    |> intToPowersOf 2
                    |> List.concatMap
                        (\part ->
                            List.repeat part.amount part.power
                        )
              of
                [ powerMultipleItself ] ->
                    List.repeat 2
                        (powerMultipleItself - 1)

                powers ->
                    powers
             )
                |> List.map (\power -> 2 ^ power)
                |> List.foldl
                    (\power soFar ->
                        addXType power soFar
                    )
                    (typeVar "n")
            )
        , packageExposedAliasDecl TypeExact
            [ markdown
                ([ "Type for the exact natural number `"
                 , String.fromInt n
                 , "`"
                 ]
                    |> String.concat
                )
            ]
            ([ "N", n |> String.fromInt ] |> String.concat)
            []
            (addXType n
                (n0ableType neverType possiblyType)
            )
        ]
    }


nLinearModule : Int -> Module NsTag
nLinearModule n =
    { name = [ "N", "Linear" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "When you need many small-ish numbers or a few medium sized ones."
                    ]
            }
    , imports =
        [ importStmt [ "N" ]
            noAlias
            (exposingExplicit
                (aliasExpose [ "N", "Is", "To", "In", "N0able" ]
                    ++ funExpose [ "n1", "n2", "n4", "n8", "n16", "diffAdd" ]
                )
            )
        ]
    , declarations =
        [ packageExposedAliasDecl TypeAdd
            [ markdown
                ([ "Type for the natural number `"
                 , n |> String.fromInt
                 , " +` some natural number `n`"
                 ]
                    |> String.concat
                )
            ]
            (addX n)
            [ "n" ]
            (List.repeat n ()
                |> List.foldl
                    (\() soFar ->
                        n0ableType soFar neverType
                    )
                    (typeVar "n")
            )
        , packageExposedAliasDecl TypeExact
            [ markdown
                ([ "Type for the exact natural number `"
                 , String.fromInt n
                 , "`"
                 ]
                    |> String.concat
                )
            ]
            ([ "N", n |> String.fromInt ] |> String.concat)
            []
            (List.repeat n ()
                |> List.foldl
                    (\() soFar ->
                        n0ableType soFar neverType
                    )
                    (n0ableType neverType possiblyType)
            )
        , packageExposedFunDecl NDiffValue
            [ markdown
                ([ "The exact natural number `", n |> String.fromInt, "`" ]
                    |> String.concat
                )
            ]
            (nType (inDiffType n))
            (nX n)
            []
            (case
                n
                    |> intToPowersOf 2
                    |> List.concatMap
                        (\part ->
                            List.repeat part.amount part.power
                        )
                    |> List.reverse
             of
                [] ->
                    Generation.string "the number to generate for must be ≥ 1"

                greatestPower :: smallerPowers ->
                    let
                        folding =
                            case smallerPowers of
                                [] ->
                                    { initial = greatestPower - 1
                                    , list = List.repeat 1 (greatestPower - 1)
                                    }

                                secondGreatestPower :: evenSmallerPowers ->
                                    { initial = greatestPower
                                    , list = secondGreatestPower :: evenSmallerPowers
                                    }
                    in
                    folding.list
                        |> List.map (\power -> 2 ^ power)
                        |> List.foldl
                            (\n10ToPower soFar ->
                                applyBinOp
                                    soFar
                                    piper
                                    (diffAdd n10ToPower)
                            )
                            (val (nX (2 ^ folding.initial)))
            )
        ]
    }



--


intToPowersOf : Int -> (Int -> List { power : Int, amount : Int })
intToPowersOf power =
    intToAllPowersOf power
        >> List.indexedMap (\multiple amount -> { power = multiple, amount = amount })
        >> List.filter (\part -> part.amount /= 0)


intToAllPowersOf : Int -> (Int -> List Int)
intToAllPowersOf power =
    \int ->
        if int <= 0 then
            []

        else
            (::)
                (int |> remainderBy power)
                ((int // power) |> intToAllPowersOf power)



--


button :
    msg
    -> List (Ui.Attribute msg)
    -> Ui.Element msg
    -> Ui.Element msg
button onPress attributes label =
    UiInput.button
        ([ UiBorder.color interactiveColor
         , UiBorder.widthEach { edges | bottom = 2 }
         ]
            ++ attributes
        )
        { onPress = Just onPress, label = label }


view : Model -> Html Msg
view { moduleNFolding, numberToGenerateFor, moduleNBinaryFolding, moduleNLinearFolding } =
    [ Ui.text "bounded-nat"
        |> Ui.el
            [ UiFont.size 40
            , UiFont.family [ UiFont.monospace ]
            ]
    , UiInput.text
        [ UiBg.color (Ui.rgba 0 0 0 0)
        , UiBorder.widthEach { edges | bottom = 2 }
        , UiBorder.color interactiveColor
        , Ui.width Ui.shrink
        , Ui.paddingXY 0 16
        ]
        { onChange = NumberToGenerateForChanged
        , text = numberToGenerateFor |> String.fromInt
        , placeholder = Nothing
        , label =
            "number to generate for" |> UiInput.labelHidden
        }
    , button DownloadModules
        [ Ui.paddingXY 0 16
        ]
        (Ui.text "⬇ download")
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
            in
            [ { kind = NLinear
              , name = "linear"
              , folding = moduleNLinearFolding
              , module_ = nLinearModule numberToGenerateFor
              }
            , { kind = NBinary
              , name = "binary"
              , folding = moduleNBinaryFolding
              , module_ = nBinaryModule numberToGenerateFor
              }
            , { kind = N0To16
              , name = "0 → 16"
              , folding = moduleNFolding
              , module_ = n0To16Module
              }
            ]
                |> List.map
                    (\{ kind, name, module_, folding } ->
                        case folding of
                            Shown ->
                                [ Ui.el
                                    [ Ui.width (Ui.px 1)
                                    , UiBg.color interactiveColor
                                    , Ui.height Ui.fill
                                    ]
                                    Ui.none
                                , [ switchButton ("⌃ " ++ name) (kind |> SwitchVisibleModule)
                                  , module_
                                        |> Ui.module_
                                        |> Ui.el [ Ui.moveRight 5 ]
                                  ]
                                    |> Ui.column []
                                ]
                                    |> Ui.row
                                        [ Ui.height Ui.fill ]

                            Folded ->
                                switchButton ("⌄ " ++ name) (kind |> SwitchVisibleModule)
                    )
           )
      )
        |> Ui.column
            [ Ui.width Ui.fill
            ]
    ]
        |> Ui.column
            [ Ui.paddingXY 40 60
            , Ui.spacing 46
            , Ui.width Ui.fill
            , Ui.height Ui.fill
            , UiBg.color (Ui.rgb255 35 36 31)
            , UiFont.color (Ui.rgb 1 1 1)
            ]
        |> Ui.layoutWith
            { options =
                [ Ui.focusStyle
                    { borderColor = Ui.rgba 0 1 1 0.4 |> Just
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            []


interactiveColor : Ui.Color
interactiveColor =
    Ui.rgb 1 0.4 0
