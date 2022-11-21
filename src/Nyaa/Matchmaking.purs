module Nyaa.Matchmaking where

import Prelude

import Control.Alt ((<|>))
import Control.Promise (toAffE)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, effectCanceler, launchAff_, makeAff, parallel, sequential)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref as Ref
import FRP.Event (create, subscribe)
import Nyaa.Firebase.Firebase (Ticket(..), cancelTicket, createTicket)
import Nyaa.Util.Backoff (backoff)

doMatchmaking
  :: Int
  -> Effect Unit
  -> ( { player1 :: String
       , player2 :: String
       , player1Name :: String
       , player2Name :: String
       }
       -> Effect Unit
     )
  -> Effect Unit
doMatchmaking room failure success = do
  ticketEvent <- create
  launchAff_ do
    let
      happyPath = do
        -- number below random... change?
        unsub <- backoff (Milliseconds 278.0) 8
          (toAffE $ createTicket room ticketEvent.push)
        happy <- makeAff \f -> do
          unsubTicketRef <- Ref.new (pure unit)
          unsubTicket <- liftEffect $ subscribe ticketEvent.event \(Ticket t) ->
            -- let _ = spy "got ticket" t in
            case t.player2, t.player2Name of
              Just player2, Just player2Name -> do
                f
                  ( Right
                      { player1: t.player1
                      , player1Name: t.player1Name
                      , player2
                      , player2Name
                      }
                  )
                join $ Ref.read unsubTicketRef
              _, _ -> pure unit
          Ref.write unsubTicket unsubTicketRef
          pure (effectCanceler unsubTicket)
        liftEffect do
          log "happy path"
          unsub
          success happy
      aiPath = do
        delay (Milliseconds 7_000.0)
        liftEffect $ log "killing ticket"
        toAffE cancelTicket
        liftEffect do
          log "running failure"
          failure
    sequential (parallel happyPath <|> parallel aiPath)