module Nyaa.Ionic.Col
  ( IonCol(..)
  , IonCol_(..)
  , ionCol
  , ionCol_
  ) where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))

data IonCol_
data IonCol

ionCol
  :: forall lock payload
   . Event (Attribute IonCol_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCol = unsafeCustomElement "ion-col" (Proxy :: Proxy IonCol_)

ionCol_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCol_ = ionCol empty

instance Attr IonCol_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonCol_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonCol_ I.Offset String where
  attr I.Offset value = unsafeAttribute { key: "offset", value: prop' value }

instance Attr IonCol_ I.OffsetLg String where
  attr I.OffsetLg value = unsafeAttribute
    { key: "offset-lg", value: prop' value }

instance Attr IonCol_ I.OffsetMd String where
  attr I.OffsetMd value = unsafeAttribute
    { key: "offset-md", value: prop' value }

instance Attr IonCol_ I.OffsetSm String where
  attr I.OffsetSm value = unsafeAttribute
    { key: "offset-sm", value: prop' value }

instance Attr IonCol_ I.OffsetXs String where
  attr I.OffsetXs value = unsafeAttribute
    { key: "offset-xs", value: prop' value }

instance Attr IonCol_ I.OffsetXl String where
  attr I.OffsetXl value = unsafeAttribute
    { key: "offset-xl", value: prop' value }

instance Attr IonCol_ I.Pull String where
  attr I.Pull value = unsafeAttribute { key: "pull", value: prop' value }

instance Attr IonCol_ I.PullLg String where
  attr I.PullLg value = unsafeAttribute { key: "pull-lg", value: prop' value }

instance Attr IonCol_ I.PullMd String where
  attr I.PullMd value = unsafeAttribute { key: "pull-md", value: prop' value }

instance Attr IonCol_ I.PullSm String where
  attr I.PullSm value = unsafeAttribute { key: "pull-sm", value: prop' value }

instance Attr IonCol_ I.PullXs String where
  attr I.PullXs value = unsafeAttribute { key: "pull-xs", value: prop' value }

instance Attr IonCol_ I.PullXl String where
  attr I.PullXl value = unsafeAttribute { key: "pull-xl", value: prop' value }

instance Attr IonCol_ I.Size String where
  attr I.Size value = unsafeAttribute { key: "size", value: prop' value }

instance Attr IonCol_ I.SizeLg String where
  attr I.SizeLg value = unsafeAttribute { key: "size-lg", value: prop' value }

instance Attr IonCol_ I.SizeMd String where
  attr I.SizeMd value = unsafeAttribute { key: "size-md", value: prop' value }

instance Attr IonCol_ I.SizeSm String where
  attr I.SizeSm value = unsafeAttribute { key: "size-sm", value: prop' value }

instance Attr IonCol_ I.SizeXs String where
  attr I.SizeXs value = unsafeAttribute { key: "size-xs", value: prop' value }

instance Attr IonCol_ I.SizeXl String where
  attr I.SizeXl value = unsafeAttribute { key: "size-xl", value: prop' value }

instance Attr IonCol_ I.Push String where
  attr I.Push value = unsafeAttribute { key: "push", value: prop' value }

instance Attr IonCol_ I.PushLg String where
  attr I.PushLg value = unsafeAttribute { key: "push-lg", value: prop' value }

instance Attr IonCol_ I.PushMd String where
  attr I.PushMd value = unsafeAttribute { key: "push-md", value: prop' value }

instance Attr IonCol_ I.PushSm String where
  attr I.PushSm value = unsafeAttribute { key: "push-sm", value: prop' value }

instance Attr IonCol_ I.PushXs String where
  attr I.PushXs value = unsafeAttribute { key: "push-xs", value: prop' value }

instance Attr IonCol_ I.PushXl String where
  attr I.PushXl value = unsafeAttribute { key: "push-xl", value: prop' value }
