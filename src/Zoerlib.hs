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


-- Читать конфигурацию из заданного TOML-файла
configurationRead :: String -> (String, String, String)
configurationRead fileName = 
  (fileName, "127.0.0.1", "7777")


-- Вернуть уровень логирования, выраженный в Priority
getLogLevel :: String -> Priority
getLogLevel logLevel
  | logLevel == "INFO"  = INFO
  | logLevel == "DEBUG" = DEBUG
  | otherwise = ERROR

-- Выставить параметры логирования
setLogging :: String -> String -> String -> Bool -> IO ()
setLogging loggerName logFileName logLevel toFileFlag= do

  let formatString = "$time [$prio]: $msg"
  let formatter = simpleLogFormatter formatString

  -- В файл, если флаг установлен
  Control.Monad.when toFileFlag $ do
    logFileHandler <- fileHandler logFileName (getLogLevel logLevel)
    updateGlobalLogger loggerName $ addHandler (setFormatter logFileHandler formatter)

  -- В консоль
  stdOutHandler <-
      streamHandler stdout (getLogLevel logLevel) >>=
      \lh -> return $ setFormatter lh (simpleLogFormatter formatString)
  updateGlobalLogger loggerName $ addHandler stdOutHandler
  updateGlobalLogger loggerName $ setLevel (getLogLevel logLevel)
