{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeOperators              #-}

module FileSync.ServerApi (serverRun, syncApi) where

import           FileSync.Messages

import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant

import           Control.Monad.IO.Class   (MonadIO (liftIO))

-- type UserAPI = "Message" :> QueryParam "Message" ClientMessage :> Get '[JSON] [ServerMessage]
-- type SyncApi = ClientMessage :> Get '[JSON] ServerMessage
-- type SyncApi =  Get '[JSON] ServerMessage
type SyncApi = ReqBody '[JSON] ClientMessage :> Get '[JSON] ServerMessage

messageHandler :: ClientMessage -> Handler ServerMessage
messageHandler (ClientCheckForUpdates timeStamps) = return $ ServerInformUpdates []
messageHandler (ClientRequestFile fileName)       = do fileContents <- liftIO (readFile fileName)
                                                       return (ServerSendFile fileName fileContents)
messageHandler (ClientSendUpdate fileName fileContents) = liftIO (writeFile fileName fileContents) >>
                                                          return (ServerAckUpdateRequest "Updated")
-- https://docs.servant.dev/en/stable/tutorial/Server.html
server :: Server SyncApi
server = messageHandler

-- boilerplate to guide the type inferrence
syncApi :: Proxy SyncApi
syncApi = Proxy

app :: Application
app = serve syncApi server

serverRun :: IO ()
serverRun = run 8081 app
