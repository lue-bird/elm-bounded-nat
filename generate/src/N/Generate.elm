module Z.Generate exposing (main)

{-| Helps you generate the source code of the module `Ns`

Run `elm reactor` in this directory to preview & download

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
import Elm.Pretty exposing (pretty, prettyTypeAnnotation)
import File.Download
import Html exposing (Html)
import Pretty
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
    typed "Z" [ n ]


minAsDifferenceAndMaxType : Int -> Generation.TypeAnnotation
minAsDifferenceAndMaxType n =
    typed "In"
        [ typeUpN n "minX_"
        , typeUpN n "maxX_"
        ]


limitType :
    Generation.TypeAnnotation
    -> Generation.TypeAnnotation
    -> Generation.TypeAnnotation
limitType on increase =
    typed "Limit" [ on, increase ]


typeUpN : Int -> String -> Generation.TypeAnnotation
typeUpN n var =
    typed ([ "Up", n |> String.fromInt ] |> String.concat)
        [ typeVar var ]


toType : Generation.TypeAnnotation
toType =
    typed "To" []


typeNN : Int -> Generation.TypeAnnotation
typeNN n =
    typed
        ([ "N", n |> String.fromInt ] |> String.concat)
        []


addN : Int -> String
addN n =
    [ "Add", n |> String.fromInt ] |> String.concat


typeAddN : Int -> Generation.TypeAnnotation -> Generation.TypeAnnotation
typeAddN n base =
    case n of
        0 ->
            base

        1 ->
            n0OrAdd1Type base typePossibly

        n2AtLeast ->
            typed (addN n2AtLeast) [ base ]


add : Int -> Generation.Expression
add powerInInt =
    construct "add" [ val (nX powerInInt) ]


n0OrAdd1Type :
    Generation.TypeAnnotation
    -> Generation.TypeAnnotation
    -> Generation.TypeAnnotation
n0OrAdd1Type minus1 possiblyOrNever =
    typed "N0OrAdd1" [ possiblyOrNever, minus1 ]


typeNever : Generation.TypeAnnotation
typeNever =
    typed "Never" []


typePossibly : Generation.TypeAnnotation
typePossibly =
    typed "Possibly" []



-- tags


type NTag
    = TypeExact
    | TypeAdd
    | TypeUp
    | Exact



--


type Location
    = Local
    | Dependency


onDependencyBoundedNat : Location -> String
onDependencyBoundedNat =
    onDependency "lue-bird/bounded-nat"


onDependency : String -> (Location -> String)
onDependency dependencyName =
    \location ->
        case location of
            Local ->
                ""

            Dependency ->
                [ "https://dark.elm.dmy.fr/packages/", dependencyName, "/latest/" ]
                    |> String.concat


typeNNDeclaration :
    LinearOrBinary
    -> Location
    -> (Int -> Declaration NTag)
typeNNDeclaration linearOrBinary nLocation =
    \n ->
        packageExposedAliasDecl TypeExact
            [ markdown
                ([ "The [natural number]("
                 , nLocation |> onDependencyBoundedNat
                 , "N#N0OrAdd1) `"
                 , String.fromInt n
                 , "`"
                 ]
                    |> String.concat
                )
            ]
            ([ "N", n |> String.fromInt ] |> String.concat)
            []
            (typeNNImplementation linearOrBinary n)


typeNNImplementation : LinearOrBinary -> (Int -> Generation.TypeAnnotation)
typeNNImplementation linearOrBinary =
    \n ->
        case linearOrBinary of
            Linear ->
                List.repeat n ()
                    |> List.foldl
                        (\() soFar ->
                            n0OrAdd1Type soFar typeNever
                        )
                        (n0OrAdd1Type typeNever typePossibly)

            Binary ->
                (case
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
                            typeAddN power soFar
                        )
                        (n0OrAdd1Type typeNever typePossibly)


typeAddNDeclaration :
    LinearOrBinary
    -> Location
    -> (Int -> Declaration NTag)
typeAddNDeclaration linearOrBinary nLocation =
    \n ->
        packageExposedAliasDecl TypeAdd
            [ markdown
                ([ "The [natural number](N"
                 , nLocation |> onDependencyBoundedNat
                 , "#N0OrAdd1) `"
                 , n |> String.fromInt
                 , " +` a given `n`"
                 ]
                    |> String.concat
                )
            ]
            (addN n)
            [ "n" ]
            (typeAddNImplementation linearOrBinary n "n")


typeAddNImplementation : LinearOrBinary -> (Int -> String -> Generation.TypeAnnotation)
typeAddNImplementation linearOrBinary =
    \n var ->
        case linearOrBinary of
            Linear ->
                List.repeat n ()
                    |> List.foldl
                        (\() soFar ->
                            n0OrAdd1Type soFar typeNever
                        )
                        (typeVar var)

            Binary ->
                (case
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
                            typeAddN power soFar
                        )
                        (typeVar var)


type LinearOrBinary
    = Linear
    | Binary


typeUpXDeclaration :
    LinearOrBinary
    -> (Int -> Declaration NTag)
typeUpXDeclaration linearOrBinary =
    \x ->
        packageExposedAliasDecl TypeUp
            [ markdown
                ([ "`"
                 , x |> String.fromInt
                 , "` as the difference `"
                 , typed "Up"
                    [ typeVar "x"
                    , toType
                    , typeAddN x (typeVar "x")
                    ]
                    |> prettyTypeAnnotation
                    |> Pretty.pretty 1000
                 , "`"
                 ]
                    |> String.concat
                )
            ]
            ([ "Up", x |> String.fromInt ] |> String.concat)
            [ "x" ]
            (typed "Up"
                [ typeVar "x"
                , toType
                , typeAddNImplementation linearOrBinary x "x"
                ]
            )


nNDeclaration :
    LinearOrBinary
    -> Location
    -> (Int -> Declaration NTag)
nNDeclaration linearOrBinary nLocation =
    \n ->
        packageExposedFunDecl Exact
            [ markdown
                ([ "The [`N`](N"
                 , nLocation |> onDependencyBoundedNat
                 , "#N) `"
                 , n |> String.fromInt
                 , "`"
                 ]
                    |> String.concat
                )
            ]
            (nType (minAsDifferenceAndMaxType n))
            (nX n)
            []
            (nNImplementation linearOrBinary n)


nNImplementation : LinearOrBinary -> (Int -> Generation.Expression)
nNImplementation linearOrBinary =
    \n ->
        case linearOrBinary of
            Linear ->
                applyBinOp
                    (val (nX (n - 1)))
                    piper
                    (add 1)

            Binary ->
                case
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
                                        (add n10ToPower)
                                )
                                (val (nX (2 ^ folding.initial)))


n0To16Module : Module NTag
n0To16Module =
    let
        lastN : Int
        lastN =
            16
    in
    { name = [ [ "N0To", lastN |> String.fromInt ] |> String.concat ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "Default implementation for the members of the `module N` in the package `lue-bird/elm-bounded-nat`"
                    ]
            }
    , imports = []
    , declarations =
        [ List.range 1 lastN
            |> List.map (typeAddNDeclaration Linear Local)
        , List.range 0 lastN
            |> List.map (typeNNDeclaration Linear Local)
        , List.range 0 lastN
            |> List.map (typeUpXDeclaration Linear)
        , List.range 2 lastN
            |> List.map (nNDeclaration Linear Local)
        ]
            |> List.concat
    }


nLinearModule : Int -> Module NTag
nLinearModule n =
    { name = [ "Z", "Linear" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "When you need many small-ish numbers or a few medium sized ones."
                    ]
            }
    , imports =
        [ importStmt [ "Z" ]
            noAlias
            (exposingExplicit
                (aliasExpose [ "N", "In", "To", "Up", "N0OrAdd1" ]
                    ++ funExpose [ "n1", "n2", "n4", "n8", "n16", "add" ]
                )
            )
        , importStmt [ "Possibly" ]
            noAlias
            (exposingExplicit (aliasExpose [ "Possibly" ]))
        ]
    , declarations =
        [ n |> typeAddNDeclaration Linear Dependency
        , n |> typeNNDeclaration Linear Dependency
        , n |> typeUpXDeclaration Linear
        , n |> nNDeclaration Binary Dependency
        ]
    }


nBinaryModule : Int -> Module NTag
nBinaryModule n =
    { name = [ "N", "Binary" ]
    , roleInPackage =
        PackageExposedModule
            { moduleComment =
                \declarations ->
                    [ markdown "When you need big numbers or multiple medium sized ones"
                    ]
            }
    , imports =
        [ importStmt [ "N" ]
            noAlias
            (exposingExplicit
                (aliasExpose [ "N", "In", "To", "Up", "N0", "Add1", "Add2", "Add4", "Add8", "Add16" ]
                    ++ funExpose [ "n1", "n2", "n4", "n8", "n16", "add" ]
                )
            )
        , importStmt [ "Possibly" ]
            noAlias
            (exposingExplicit (aliasExpose [ "Possibly" ]))
        ]
    , declarations =
        [ n |> typeAddNDeclaration Binary Dependency
        , n |> typeNNDeclaration Binary Dependency
        , n |> typeUpXDeclaration Binary
        , n |> nNDeclaration Binary Dependency
        ]
    }



--


intToPowersOf : Int -> (Int -> List { power : Int, amount : Int })
intToPowersOf power =
    intToAllPowersOf power
        >> List.indexedMap
            (\multiple amount ->
                { power = multiple, amount = amount }
            )
        >> List.filter (\part -> part.amount /= 0)


intToAllPowersOf : Int -> (Int -> List Int)
intToAllPowersOf power =
    \int ->
        if int <= 0 then
            []

        else
            (int |> remainderBy power)
                :: ((int // power) |> intToAllPowersOf power)



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
