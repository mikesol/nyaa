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
  , Autocapitalize
  , unAutocapitalize
  , acOff
  , acOn
  , acNone
  , acSentences
  , acWords
  , acCharacters
  , Autocomplete
  , unAutocomplete
  , autocompleteName
  , autocompleteEmail
  , autocompleteTel
  , autocompleteUrl
  , autocompleteOn
  , autocompleteOff
  , autocompleteHonorificPrefix
  , autocompleteGivenName
  , autocompleteAdditionalName
  , autocompleteFamilyName
  , autocompleteHonorificSuffix
  , autocompleteNickname
  , autocompleteUsername
  , autocompleteNewPassword
  , autocompleteCurrentPassword
  , autocompleteOneTimeCode
  , autocompleteOrganizationTitle
  , autocompleteOrganization
  , autocompleteStreetAddress
  , autocompleteAddressLine1
  , autocompleteAddressLine2
  , autocompleteAddressLine3
  , autocompleteAddressLevel4
  , autocompleteAddressLevel3
  , autocompleteAddressLevel2
  , autocompleteAddressLevel1
  , autocompleteCountry
  , autocompleteCountryName
  , autocompletePostalCode
  , autocompleteCcName
  , autocompleteCcGivenName
  , autocompleteCcAdditionalName
  , autocompleteCcFamilyName
  , autocompleteCcNumber
  , autocompleteCcExp
  , autocompleteCcExpMonth
  , autocompleteCcExpYear
  , autocompleteCcCsc
  , autocompleteCcType
  , autocompleteTransactionCurrency
  , autocompleteTransactionAmount
  , autocompleteLanguage
  , autocompleteBday
  , autocompleteBdayDay
  , autocompleteBdayMonth
  , autocompleteBdayYear
  , autocompleteSex
  , autocompleteTelCountryCode
  , autocompleteTelNational
  , autocompleteTelAreaCode
  , autocompleteTelLocal
  , autocompleteTelExtension
  , autocompleteImpp
  , autocompletePhoto
  , Autocorrect
  , unAutocorrect
  , autocorrectOff
  , autocorrectOn
  , Enterkeyhint
  , unEnterkeyhint
  , enterkeyhintDone
  , enterkeyhintEnter
  , enterkeyhintGo
  , enterkeyhintNext
  , enterkeyhintPrevious
  , enterkeyhintSearch
  , enterkeyhintSend
  , enterkeyhintUndefined
  , Inputmode
  , unInputmode
  , inputmodeDecimal
  , inputmodeEmail
  , inputmodeNone
  , inputmodeNumeric
  , inputmodeSearch
  , inputmodeTel
  , inputmodeText
  , inputmodeUrl
 , InputType
    , unInputType
    , inputtypeDate
  , inputtypeDatetimeLocal
  , inputtypeEmail
  , inputtypeMonth
  , inputtypeNumber
  , inputtypePassword
  , inputtypeSearch
  , inputtypeTel
  , inputtypeText
  , inputtypeTime
  , inputtypeUrl
  , inputtypeWeek


  ) where

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

newtype Autocapitalize = Autocapitalize String

unAutocapitalize :: Autocapitalize -> String
unAutocapitalize (Autocapitalize t) = t

acOff :: Autocapitalize
acOff = Autocapitalize "off"

acNone :: Autocapitalize
acNone = Autocapitalize "none"

acOn :: Autocapitalize
acOn = Autocapitalize "on"

acSentences :: Autocapitalize
acSentences = Autocapitalize "sentences"

acWords :: Autocapitalize
acWords = Autocapitalize "words"

acCharacters :: Autocapitalize
acCharacters = Autocapitalize "characters"

-- starting Autocomplete
newtype Autocomplete = Autocomplete String

unAutocomplete :: Autocomplete -> String
unAutocomplete (Autocomplete t) = t

autocompleteName :: Autocomplete
autocompleteName = Autocomplete "name"

autocompleteEmail :: Autocomplete
autocompleteEmail = Autocomplete "email"

autocompleteTel :: Autocomplete
autocompleteTel = Autocomplete "tel"

autocompleteUrl :: Autocomplete
autocompleteUrl = Autocomplete "url"

autocompleteOn :: Autocomplete
autocompleteOn = Autocomplete "on"

autocompleteOff :: Autocomplete
autocompleteOff = Autocomplete "off"

autocompleteHonorificPrefix :: Autocomplete
autocompleteHonorificPrefix = Autocomplete "honorific-prefix"

autocompleteGivenName :: Autocomplete
autocompleteGivenName = Autocomplete "given-name"

autocompleteAdditionalName :: Autocomplete
autocompleteAdditionalName = Autocomplete "additional-name"

autocompleteFamilyName :: Autocomplete
autocompleteFamilyName = Autocomplete "family-name"

autocompleteHonorificSuffix :: Autocomplete
autocompleteHonorificSuffix = Autocomplete "honorific-suffix"

autocompleteNickname :: Autocomplete
autocompleteNickname = Autocomplete "nickname"

autocompleteUsername :: Autocomplete
autocompleteUsername = Autocomplete "username"

autocompleteNewPassword :: Autocomplete
autocompleteNewPassword = Autocomplete "new-password"

autocompleteCurrentPassword :: Autocomplete
autocompleteCurrentPassword = Autocomplete "current-password"

autocompleteOneTimeCode :: Autocomplete
autocompleteOneTimeCode = Autocomplete "one-time-code"

autocompleteOrganizationTitle :: Autocomplete
autocompleteOrganizationTitle = Autocomplete "organization-title"

autocompleteOrganization :: Autocomplete
autocompleteOrganization = Autocomplete "organization"

autocompleteStreetAddress :: Autocomplete
autocompleteStreetAddress = Autocomplete "street-address"

autocompleteAddressLine1 :: Autocomplete
autocompleteAddressLine1 = Autocomplete "address-line1"

autocompleteAddressLine2 :: Autocomplete
autocompleteAddressLine2 = Autocomplete "address-line2"

autocompleteAddressLine3 :: Autocomplete
autocompleteAddressLine3 = Autocomplete "address-line3"

autocompleteAddressLevel4 :: Autocomplete
autocompleteAddressLevel4 = Autocomplete "address-level4"

autocompleteAddressLevel3 :: Autocomplete
autocompleteAddressLevel3 = Autocomplete "address-level3"

autocompleteAddressLevel2 :: Autocomplete
autocompleteAddressLevel2 = Autocomplete "address-level2"

autocompleteAddressLevel1 :: Autocomplete
autocompleteAddressLevel1 = Autocomplete "address-level1"

autocompleteCountry :: Autocomplete
autocompleteCountry = Autocomplete "country"

autocompleteCountryName :: Autocomplete
autocompleteCountryName = Autocomplete "country-name"

autocompletePostalCode :: Autocomplete
autocompletePostalCode = Autocomplete "postal-code"

autocompleteCcName :: Autocomplete
autocompleteCcName = Autocomplete "cc-name"

autocompleteCcGivenName :: Autocomplete
autocompleteCcGivenName = Autocomplete "cc-given-name"

autocompleteCcAdditionalName :: Autocomplete
autocompleteCcAdditionalName = Autocomplete "cc-additional-name"

autocompleteCcFamilyName :: Autocomplete
autocompleteCcFamilyName = Autocomplete "cc-family-name"

autocompleteCcNumber :: Autocomplete
autocompleteCcNumber = Autocomplete "cc-number"

autocompleteCcExp :: Autocomplete
autocompleteCcExp = Autocomplete "cc-exp"

autocompleteCcExpMonth :: Autocomplete
autocompleteCcExpMonth = Autocomplete "cc-exp-month"

autocompleteCcExpYear :: Autocomplete
autocompleteCcExpYear = Autocomplete "cc-exp-year"

autocompleteCcCsc :: Autocomplete
autocompleteCcCsc = Autocomplete "cc-csc"

autocompleteCcType :: Autocomplete
autocompleteCcType = Autocomplete "cc-type"

autocompleteTransactionCurrency :: Autocomplete
autocompleteTransactionCurrency = Autocomplete "transaction-currency"

autocompleteTransactionAmount :: Autocomplete
autocompleteTransactionAmount = Autocomplete "transaction-amount"

autocompleteLanguage :: Autocomplete
autocompleteLanguage = Autocomplete "language"

autocompleteBday :: Autocomplete
autocompleteBday = Autocomplete "bday"

autocompleteBdayDay :: Autocomplete
autocompleteBdayDay = Autocomplete "bday-day"

autocompleteBdayMonth :: Autocomplete
autocompleteBdayMonth = Autocomplete "bday-month"

autocompleteBdayYear :: Autocomplete
autocompleteBdayYear = Autocomplete "bday-year"

autocompleteSex :: Autocomplete
autocompleteSex = Autocomplete "sex"

autocompleteTelCountryCode :: Autocomplete
autocompleteTelCountryCode = Autocomplete "tel-country-code"

autocompleteTelNational :: Autocomplete
autocompleteTelNational = Autocomplete "tel-national"

autocompleteTelAreaCode :: Autocomplete
autocompleteTelAreaCode = Autocomplete "tel-area-code"

autocompleteTelLocal :: Autocomplete
autocompleteTelLocal = Autocomplete "tel-local"

autocompleteTelExtension :: Autocomplete
autocompleteTelExtension = Autocomplete "tel-extension"

autocompleteImpp :: Autocomplete
autocompleteImpp = Autocomplete "impp"

autocompletePhoto :: Autocomplete
autocompletePhoto = Autocomplete "photo"

-- starting Autocorrect
newtype Autocorrect = Autocorrect String

unAutocorrect :: Autocorrect -> String
unAutocorrect (Autocorrect t) = t

autocorrectOff :: Autocorrect
autocorrectOff = Autocorrect "off"

autocorrectOn :: Autocorrect
autocorrectOn = Autocorrect "on"

-- starting Enterkeyhint
newtype Enterkeyhint = Enterkeyhint String

unEnterkeyhint :: Enterkeyhint -> String
unEnterkeyhint (Enterkeyhint t) = t

enterkeyhintDone :: Enterkeyhint
enterkeyhintDone = Enterkeyhint "done"

enterkeyhintEnter :: Enterkeyhint
enterkeyhintEnter = Enterkeyhint "enter"

enterkeyhintGo :: Enterkeyhint
enterkeyhintGo = Enterkeyhint "go"

enterkeyhintNext :: Enterkeyhint
enterkeyhintNext = Enterkeyhint "next"

enterkeyhintPrevious :: Enterkeyhint
enterkeyhintPrevious = Enterkeyhint "previous"

enterkeyhintSearch :: Enterkeyhint
enterkeyhintSearch = Enterkeyhint "search"

enterkeyhintSend :: Enterkeyhint
enterkeyhintSend = Enterkeyhint "send"

enterkeyhintUndefined :: Enterkeyhint
enterkeyhintUndefined = Enterkeyhint "undefined"

-- starting Inputmode
newtype Inputmode = Inputmode String

unInputmode :: Inputmode -> String
unInputmode (Inputmode t) = t

inputmodeDecimal :: Inputmode
inputmodeDecimal = Inputmode "decimal"

inputmodeEmail :: Inputmode
inputmodeEmail = Inputmode "email"

inputmodeNone :: Inputmode
inputmodeNone = Inputmode "none"

inputmodeNumeric :: Inputmode
inputmodeNumeric = Inputmode "numeric"

inputmodeSearch :: Inputmode
inputmodeSearch = Inputmode "search"

inputmodeTel :: Inputmode
inputmodeTel = Inputmode "tel"

inputmodeText :: Inputmode
inputmodeText = Inputmode "text"

inputmodeUrl :: Inputmode
inputmodeUrl = Inputmode "url"
-- starting InputType
newtype InputType = InputType String
unInputType :: InputType -> String
unInputType (InputType t) = t
inputtypeDate :: InputType
inputtypeDate = InputType "date"
inputtypeDatetimeLocal :: InputType
inputtypeDatetimeLocal = InputType "datetime-local"
inputtypeEmail :: InputType
inputtypeEmail = InputType "email"
inputtypeMonth :: InputType
inputtypeMonth = InputType "month"
inputtypeNumber :: InputType
inputtypeNumber = InputType "number"
inputtypePassword :: InputType
inputtypePassword = InputType "password"
inputtypeSearch :: InputType
inputtypeSearch = InputType "search"
inputtypeTel :: InputType
inputtypeTel = InputType "tel"
inputtypeText :: InputType
inputtypeText = InputType "text"
inputtypeTime :: InputType
inputtypeTime = InputType "time"
inputtypeUrl :: InputType
inputtypeUrl = InputType "url"
inputtypeWeek :: InputType
inputtypeWeek = InputType "week"
