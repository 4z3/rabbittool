{-# LANGUAGE OverloadedStrings #-}
import Control.Applicative
import Control.Exception
import Network.AMQP
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import System.Environment
import Lib

main :: IO ()
main = do
    host <- getEnv "rabbittool.host"
    path <- T.pack <$> getEnv "rabbittool.path"
    user <- T.pack <$> getEnv "rabbittool.user"
    pass <- T.pack <$> getEnv "rabbittool.pass"

    conn <- openConnection host path user pass
    chan <- openChannel conn

    _ <- addChannelExceptionHandler chan exceptionHandler

    let msg = "hello, world!"

    publishMsg chan myExchange myKey
        newMsg {msgBody = BL.pack msg,
                msgDeliveryMode = Just Persistent}

    closeConnection conn
  where
    myExchange = "rabbittoolExchange"
    myKey = "rabbittoolKey"

exceptionHandler :: SomeException -> IO ()
exceptionHandler =
  logStrLn . show
