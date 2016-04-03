{-# LANGUAGE OverloadedStrings #-}
module Handler.Coffee where

import Import
import Database.Persist.Sql (fromSqlKey)

coffeeToJson :: Entity Coffee -> Value
coffeeToJson (Entity coffeeId coffee) = object
  ["name" .= coffeeName coffee
  , "price" .= coffeePrice coffee
  , "caffeine_level" .= coffeeCaffineLevel coffee
  , "order_path" .= ("/order/" ++ (show $ (fromSqlKey coffeeId) :: String))
  , "milk_ratio" .= coffeeMilkRatio coffee]

getMenu :: Handler TypedContent
getMenu = do
  coffees <- runDB $ selectList ([]::[Filter Coffee]) []
  return $ TypedContent "application/json" $ toContent $ object ["coffees" .= map coffeeToJson coffees]
  --where coffees = [Coffee "long black" 3 8 0, Coffee "flat white" 3.5 5 2]

postCoffeeR :: Handler TypedContent
postCoffeeR = do
  coffee <- requireJsonBody :: Handler Coffee
  insertedCoffee <- runDB $ insertEntity coffee
  --contentType "application/json"
  return $ TypedContent "application/json" $ (toContent.coffeeToJson) insertedCoffee

postOrderR :: Int -> Handler TypedContent
postOrderR = undefined
