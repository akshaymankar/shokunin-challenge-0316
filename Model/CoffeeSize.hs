{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
module Model.CoffeeSize where

import Database.Persist.TH
import Prelude hiding(Applicative(..), print)
import Data.Maybe (fromJust)
import Text.Syntax
import Text.Syntax.Parser.Naive
import Text.Syntax.Printer.Naive
import Data.Aeson
import Data.Text as T

data CoffeeSize = Small | Medium | Large
  deriving Eq
derivePersistField "CoffeeSize"


coffeeSize :: Syntax f => f CoffeeSize
coffeeSize = pure Small <* text "small"
         <|> pure Medium <* text "medium"
         <|> pure Large <* text "large"

runParser :: Parser t -> String -> [(t, String)]
runParser (Parser p) = p
instance Read CoffeeSize where readsPrec _ = runParser coffeeSize
instance Show CoffeeSize where show = fromJust.print coffeeSize

instance ToJSON CoffeeSize where
  toJSON = toJSON.show
instance FromJSON CoffeeSize where
  parseJSON = withText "string" $ \x -> return (read (T.unpack x) :: CoffeeSize)

