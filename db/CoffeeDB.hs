{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
module CoffeeDB (seed, clean) where

import Import
import Application (dbWithLogging)

seed :: IO()
seed = dbWithLogging $ insertMany_ coffees

clean :: IO()
clean = dbWithLogging $ deleteWhere ([]::[Filter Coffee])

coffees :: [Coffee]
coffees = [Coffee "Long Black" 3 7 0, Coffee "Flat White" 3.5 5 2, Coffee "Espresso" 10 0 4, Coffee "Latte" 3 7 7]
