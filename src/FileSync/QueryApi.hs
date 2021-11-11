{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module FileSync.QueryApi where

import           FileSync.Messages
import           FileSync.ServerApi  (syncApi)

import           Network.HTTP.Client (defaultManagerSettings, newManager)
import           Servant.Client

clientMessage :: ClientMessage -> ClientM ServerMessage
clientMessage = client syncApi

handleServerMessage :: ServerMessage -> IO ()
handleServerMessage (ServerSendFile fileName fileContents) = writeFile fileName fileContents
handleServerMessage (ServerInformUpdates updates)          = print updates
handleServerMessage (ServerAckUpdateRequest updateAck)     = print updateAck

runCommand :: ClientMessage -> IO ()
runCommand query = do
  manager' <- newManager defaultManagerSettings
  res <- runClientM (clientMessage query) (mkClientEnv manager' (BaseUrl Http "localhost" 8081 ""))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right m  -> handleServerMessage m
