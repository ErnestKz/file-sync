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
type FileName = String
type FileContents = String

data ClientMessage =
  ClientCheckForUpdates { timeStamps :: [(FileName, TimeStamp)] }
  | ClientSendUpdate
    { clientFileName     :: FileName
    , clientFileContents :: FileContents }
  | ClientRequestFile
    { clientFileName     :: FileName
    } deriving (Show, Generic, ToJSON, FromJSON)

requestFile :: FileName -> ClientMessage
requestFile = ClientRequestFile

data ServerMessage =
  ServerSendFile
  { serverFileName     :: FileName
  , serverFileContents :: FileContents }
  | ServerInformUpdates
    { fileUpdatesAvailable :: [ (FileName, TimeStamp) ] }
  | ServerAckUpdateRequest T.Text
  deriving (Show, Generic, ToJSON, FromJSON)

a :: ClientMessage
a = ClientSendUpdate "hello" "hello"
b :: ByteString
b = A.encode a
c :: Maybe ClientMessage
c = A.decode b
d :: Either String ClientMessage
d = A.eitherDecode b

a' :: ServerMessage
a' = ServerSendFile "hello" "hello"

