module Zoerlib

( configurationRead,
  getLogLevel,
  setLogging
) where

import System.IO                         (stdout)
import Control.Monad
import System.Log.Logger
import System.Log.Formatter
import System.Log.Handler         hiding (setLevel)
import System.Log.Handler.Simple         (fileHandler, streamHandler)


{-
  Read the configuration from the specified TOML file
-} 
configurationRead :: String -> (String, String, String)
configurationRead fileName = 
  (fileName, "127.0.0.1", "7777")


{- 
  Return the logging level expressed in Priority
-}
getLogLevel :: String -> Priority
getLogLevel logLevel
  | logLevel == "INFO"  = INFO
  | logLevel == "DEBUG" = DEBUG
  | otherwise = ERROR


{- 
  Set logging parameters
-}
setLogging :: String -> String -> String -> Bool -> IO ()
setLogging loggerName logFileName logLevel toFileFlag= do

  let formatString = "$time [$prio]: $msg"
  let formatter = simpleLogFormatter formatString

  -- To the file, if the flag is set
  Control.Monad.when toFileFlag $ do
    logFileHandler <- fileHandler logFileName (getLogLevel logLevel)
    updateGlobalLogger loggerName $ addHandler (setFormatter logFileHandler formatter)

  -- In console
  stdOutHandler <-
      streamHandler stdout (getLogLevel logLevel) >>=
      \lh -> return $ setFormatter lh (simpleLogFormatter formatString)
  updateGlobalLogger loggerName $ addHandler stdOutHandler
  updateGlobalLogger loggerName $ setLevel (getLogLevel logLevel)
