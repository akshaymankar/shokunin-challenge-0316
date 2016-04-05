module Utils (resultToMaybe, objectOrNothing ) where

import Data.Maybe
import Data.Aeson

resultToMaybe :: Result a -> Maybe a
resultToMaybe (Success x) = Just x
resultToMaybe _ = Nothing

objectOrNothing :: Value -> Maybe Object
objectOrNothing (Object o) = Just o
objectOrNothing _ = Nothing
