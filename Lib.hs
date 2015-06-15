module Lib where

import Data.Time
import System.Locale

logStrLn :: String -> IO ()
logStrLn s = do
    t <- getCurrentTime
    putStrLn $ (strTime t) ++ " " ++ s
  where
    strTime = formatTime defaultTimeLocale "%FT%T%z"
