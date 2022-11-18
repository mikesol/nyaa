module Nyaa.Matchmaking where

import Prelude

import Control.Alt ((<|>))
import Control.Promise (toAffE)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, effectCanceler, launchAff_, makeAff)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Event (create, subscribe)
import Nyaa.Firebase.Firebase (Ticket(..), cancelTicket, createTicket)

doMatchmaking
  :: Effect Unit
  -> ({ player1 :: String, player2 :: String } -> Effect Unit)
  -> Effect Unit
doMatchmaking failure success = do
  ticketEvent <- create
  launchAff_ do
    unsub <- toAffE $ createTicket ticketEvent.push
    let
      happyPath = do
        happy <- makeAff \f -> do
          unsubTicketRef <- Ref.new (pure unit)
          unsubTicket <- liftEffect $ subscribe ticketEvent.event \(Ticket t) ->
            case t.player2 of
              Nothing -> pure unit
              Just player2 -> do
                f (Right { player1: t.player1, player2 })
                join $ Ref.read unsubTicketRef
          Ref.write unsubTicket unsubTicketRef
          pure (effectCanceler unsubTicket)
        liftEffect do
          unsub
          success happy
      aiPath = do
        delay (Milliseconds 5_000.0)
        toAffE cancelTicket
        liftEffect do
          unsub
          failure
    happyPath <|> aiPath