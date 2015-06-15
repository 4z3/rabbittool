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

    --conn <- openConnection'' defaultConnectionOpts
    --    { coServers = [(host, 5672)]
    --    , coVHost = path
    --    , coAuth = [plain user pass]
    --    , coHeartbeatDelay = Just 60
    --    }
    conn <- openConnection host path user pass
    chan <- openChannel conn

    -- declare a queue, exchange and binding
    _ <- declareQueue chan newQueue {queueName = myQueue}
    declareExchange chan newExchange {exchangeName = myExchange, exchangeType = "direct"}
    bindQueue chan myQueue myExchange myKey

    -- subscribe to the queue
    _ <- consumeMsgs chan myQueue Ack consumeHandler
    _ <- addChannelExceptionHandler chan exceptionHandler

    logStrLn "ready."
    _ <- getLine -- wait for keypress
    closeConnection conn
    logStrLn "connection closed"
  where
    myExchange = "rabbittoolExchange"
    myKey = "rabbittoolKey"
    myQueue = "rabbittoolQueue"

consumeHandler :: (Message,Envelope) -> IO ()
consumeHandler (msg, env) = do
    logStrLn $ "received message: " ++ (BL.unpack $ msgBody msg)
    -- acknowledge receiving the message
    ackEnv env

exceptionHandler :: SomeException -> IO ()
exceptionHandler =
  logStrLn . show
