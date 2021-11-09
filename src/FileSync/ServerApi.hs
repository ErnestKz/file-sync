{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeOperators              #-}

module FileSync.ServerApi (serverRun) where

import           FileSync.Messages

import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           Servant.API
import           Servant.Server

import           Data.Text
import           Data.Time                (UTCTime)

-- type UserAPI = "Message" :> QueryParam "Message" ClientMessage :> Get '[JSON] [ServerMessage]
-- type SyncApi = ClientMessage :> Get '[JSON] ServerMessage
-- type SyncApi =  Get '[JSON] ServerMessage
type SyncApi =  Get '[JSON] ClientMessage

server :: Server SyncApi
server = return a

-- boilerplate to guide the type inferrence
syncApi :: Proxy SyncApi
syncApi = Proxy

app :: Application
app = serve syncApi server

serverRun :: IO ()
serverRun = run 8081 app
