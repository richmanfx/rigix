{-
    Rigix agent
-}

module Main where

import Zoerlib
import System.Exit
import Control.Monad
import System.Directory
import System.Log.Logger


main :: IO ()
main = do 
  
    {- 
      Configuration file read 
    -}

    -- Get home directory name
    homeDirectory <- getHomeDirectory

    -- Check configuration file exist
    let configFileName = homeDirectory ++ "/.rigix/rigix.toml"
    configFileExist <- doesFileExist configFileName
    unless configFileExist $ do
      print ("ERROR: Configuration file '" ++ configFileName ++ "' not found.")
      exitFailure 

    {- 
      Logging 
    -}
    let loggerName = "RigixLogger"
    let logFileName = homeDirectory ++ "/.rigix/rigix.log"
    let logLevel = "INFO"
    let toFileFlag = True
    setLogging loggerName logFileName logLevel toFileFlag


    infoM loggerName ("Home directory: " ++ homeDirectory)
