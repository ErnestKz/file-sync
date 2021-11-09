{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE InstanceSigs      #-}
{-# LANGUAGE OverloadedStrings #-}

module FileSync.Messages where

import qualified Data.Aeson           as A
import           Data.Aeson.Types     (FromJSON, ToJSON)

import           Data.ByteString.Lazy (ByteString)
import qualified Data.Text            as T

import           GHC.Generics         (Generic)

type TimeStamp = Int
type FileName = T.Text
type FileContents = T.Text

data ClientMessage =
  ClientCheckForUpdates { timeStamps :: [TimeStamp] } |
  ClientSendUpdate
  { clientFileName     :: FileName
  , clientFileContents :: FileContents
  } deriving (Show, Generic, ToJSON, FromJSON)

data ServerMessage =
  ServerSendUpdate
  { serverFileName     :: FileName
  , serverFileContents :: FileContents } |
  ServerInformUpdates
  { fileUpdatesAvailable :: [ (FileName, TimeStamp) ]
  } deriving (Show, Generic, ToJSON, FromJSON)

a :: ClientMessage
a = ClientSendUpdate "hello" "hello"
b :: ByteString
b = A.encode a
c :: Maybe ClientMessage
c = A.decode b
d :: Either String ClientMessage
d = A.eitherDecode b
