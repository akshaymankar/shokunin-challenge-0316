{-# LANGUAGE OverloadedStrings #-}
module Handler.Coffee where

import Import
import Data.HashMap.Strict as H (insert)
import Data.Aeson               (Result, Object)
import Data.Aeson.Types         (fromJSON)
import Database.Persist.Sql     (fromSqlKey, toSqlKey)
import Prelude                  (read)

coffeeEntityToJson :: Entity Coffee -> Value
coffeeEntityToJson (Entity _ coffee) = coffeeToJson coffee

orderEntityToJson :: Entity Order -> Value
orderEntityToJson (Entity orderId _) = object
  ["wait_time" .= (5 :: Int),
   "order" .= ("/order/" ++ (show $ fromSqlKey orderId))]

coffeeToJson :: Coffee -> Value
coffeeToJson coffee = object
  ["name" .= coffeeName coffee,
   "price" .= coffeePrice coffee,
   "caffeine_level" .= coffeeCaffineLevel coffee,
   "order_path" .= ("/order/" ++ (show $ coffeeSlug coffee)),
   "milk_ratio" .= coffeeMilkRatio coffee]

getMenu :: Handler TypedContent
getMenu = do
  coffees <- runDB $ selectList ([]::[Filter Coffee]) []
  return $ TypedContent "application/json" $ toContent $ object ["coffees" .= map coffeeEntityToJson coffees]

postCoffeeR :: Handler TypedContent
postCoffeeR = do
  coffee <- requireJsonBody :: Handler Coffee
  insertedCoffee <- runDB $ insertEntity coffee
  return $ TypedContent "application/json" $ (toContent.coffeeEntityToJson) insertedCoffee

createOrder :: Entity Coffee -> Object -> Maybe Order
createOrder coffeeEntity o = resultToMaybe $ fromJSON (Object order)
  where order = H.insert "coffeeId" (toJSON (fromSqlKey $ entityKey coffeeEntity)) o

orderFromResult :: Entity Coffee -> Result Value -> Maybe Order
orderFromResult coffeeEntity = createOrder coffeeEntity <=< objectOrNothing <=< resultToMaybe

postOrderR :: String -> Handler TypedContent
postOrderR slug = do
  coffeeEntity <- runDB $ getBy404 $ UniqueSlug slug
  json <- parseJsonBody :: Handler (Result Value)
  insertedOrder <- fromMaybe (error "Invalid Order") $ map (runDB.insertEntity) $ orderFromResult coffeeEntity json
  sendResponseStatus status201 $ TypedContent "application/json" $ toContent $ orderEntityToJson insertedOrder

getOrderR :: String -> Handler TypedContent
getOrderR = getOrder.read

getOrder :: Int64 -> Handler TypedContent
getOrder orderId = do
  orderEntity <- runDB $ get $ (toSqlKey orderId :: Key Order)
  case orderEntity of
    (Just _) -> return $ TypedContent "application/json" $ toContent $ object ["status" .= ("READY" :: String)]
    Nothing -> error "fasdfd"
