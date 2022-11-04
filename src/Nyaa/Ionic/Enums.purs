module Nyaa.Ionic.Enums
  ( Collapse
  , Color
  , Fill
  , ItemShape
  , ItemType
  , LabelPosition
  , Lines(..)
  , Mode
  , RouterDirection
  , TitleSize
  , collapseCondense
  , collapseFade
  , danger
  , dark
  , fillOutline
  , fillSolid
  , full
  , inset
  , itemShapeRound
  , itemTypeButton
  , itemTypeReset
  , itemTypeSubmit
  , labelFixed
  , labelFloating
  , labelStacked
  , light
  , medium
  , modeIOS
  , modeMD
  , none
  , primary
  , routerBack
  , routerForward
  , routerRoot
  , secondary
  , success
  , tertiary
  , titleLarge
  , titleSmall
  , unCollapse
  , unColor
  , unFill
  , unItemShape
  , unItemType
  , unLabelPosition
  , unLines
  , unMode
  , unRouterDirection
  , unTitleSize
  , warning
  )
  where

newtype Collapse = Collapse String
unCollapse :: Collapse -> String
unCollapse (Collapse x) = x
newtype Mode = Mode String
unMode :: Mode -> String
unMode (Mode x) = x
newtype Lines = Lines String
unLines :: Lines -> String
unLines (Lines x) = x
newtype ItemType = ItemType String
unItemType :: ItemType -> String
unItemType (ItemType t) = t
newtype ItemShape = ItemShape String
unItemShape :: ItemShape -> String
unItemShape (ItemShape t) = t
newtype Fill = Fill String
unFill :: Fill -> String
unFill (Fill t) = t

newtype Color = Color String
unColor :: Color -> String
unColor (Color x) = x
modeIOS :: Mode
modeIOS = Mode "ios"

modeMD :: Mode
modeMD = Mode "md"

collapseFade :: Collapse
collapseFade = Collapse "fade"

collapseCondense :: Collapse
collapseCondense = Collapse "condense"
danger :: Color
danger = Color "danger"
dark :: Color
dark = Color "dark"
light :: Color
light = Color "light"
medium :: Color
medium = Color "medium"
primary :: Color
primary = Color "primary"
secondary :: Color
secondary = Color "secondary"
success :: Color
success = Color "success"
tertiary :: Color
tertiary = Color "tertiary"
warning :: Color
warning = Color "warning"

none :: Lines
none = Lines "none"
full :: Lines
full = Lines "full"
inset :: Lines
inset = Lines "inset"
itemTypeButton :: ItemType
itemTypeButton = ItemType "button"
itemTypeReset :: ItemType
itemTypeReset = ItemType "reset"
itemTypeSubmit :: ItemType
itemTypeSubmit = ItemType "submit"
itemShapeRound :: ItemShape
itemShapeRound = ItemShape "round"

newtype TitleSize = TitleSize String
unTitleSize :: TitleSize -> String
unTitleSize (TitleSize t) = t
titleSmall :: TitleSize
titleSmall = TitleSize "small"
titleLarge :: TitleSize
titleLarge = TitleSize "large"
newtype RouterDirection = RouterDirection String

unRouterDirection :: RouterDirection -> String
unRouterDirection (RouterDirection rd) = rd

routerForward :: RouterDirection
routerForward = RouterDirection "forward"
routerBack :: RouterDirection
routerBack = RouterDirection "back"
routerRoot :: RouterDirection
routerRoot = RouterDirection "root"

fillSolid :: Fill
fillSolid = Fill "solid"
fillOutline :: Fill
fillOutline = Fill "outline"

newtype LabelPosition = LabelPosition String
unLabelPosition :: LabelPosition -> String
unLabelPosition (LabelPosition t) = t

labelFixed :: LabelPosition
labelFixed = LabelPosition "fixed"
labelFloating :: LabelPosition
labelFloating = LabelPosition "floating"
labelStacked :: LabelPosition
labelStacked = LabelPosition "stacked"