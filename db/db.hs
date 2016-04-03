{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}

import CoffeeDB
import System.Environment
import Prelude (IO, error)
import Data.List
import Data.Eq

main :: IO()
main = do
  args <- getArgs
  if length args == 1
     then case head args of
            "seed" -> seed
            "clean" -> clean

     else error "Invalid Arguments"
