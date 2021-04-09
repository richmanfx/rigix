{-
    Агент
-}

module Main where

import Zoerlib
import System.Log.Logger


main :: IO ()
main = do 
  
    -- Читать конфигурацию из файла (TODO: пока заглушка)
    print.configurationRead $ "$HOME/.rigix/rigix.toml"

    -- Логирование
    let loggerName = "RigixLogger"
    let logFileName = "/home/zoer/.rigix/rigix.log"   -- TODO: Расхардкодить путь!!!
    let logLevel = "INFO"
    let toFileFlag = True
    setLogging loggerName logFileName logLevel toFileFlag
  

    infoM loggerName "Информационное сообщение !!!"
    debugM loggerName "Отладочное сообщение !!!"
