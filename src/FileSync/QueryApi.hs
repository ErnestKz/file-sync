{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module FileSync.QueryApi where

import           FileSync.Messages
import           FileSync.ServerApi       (syncApi)

import           Data.Aeson
import           Data.Proxy
import           GHC.Generics
import           Network.HTTP.Client      (defaultManagerSettings, newManager)
import           Servant.API
import           Servant.Client
import           Servant.Types.SourceT    (foreach)

import qualified Servant.Client.Streaming as S

clientMessage :: ClientMessage -> ClientM ServerMessage
clientMessage = client syncApi

query :: ClientM ServerMessage
query = do
  r <- clientMessage a
  return r

run :: IO ()
run = do
  manager' <- newManager defaultManagerSettings
  res <- runClientM query (mkClientEnv manager' (BaseUrl Http "localhost" 8081 ""))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right s -> do
      print s
