{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import qualified Data.Text.IO as TIO (readFile)
import Data.Text
import qualified Data.HashMap.Strict as HM
import Text.Hamlet

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "Hello, world! Hey Hey Hey") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param
