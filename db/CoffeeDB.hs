{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
module CoffeeDB (seed, clean) where

import Import
import Application (dbWithLogging, runAllMigrations)

seed :: IO()
seed = do
  dbWithLogging runAllMigrations
  dbWithLogging $ insertMany_ coffees

clean :: IO()
clean = dbWithLogging $ deleteWhere ([]::[Filter Coffee])

coffees :: [Coffee]
coffees = [
  Coffee "Long Black" 3 7 0 "long-black",
  Coffee "Flat White" 3.5 5 2 "flat-white",
  Coffee "Espresso" 10 0 4 "espresso",
  Coffee "Latte" 3 7 7 "latte"]
