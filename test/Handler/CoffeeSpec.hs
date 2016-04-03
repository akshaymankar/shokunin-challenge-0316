module Handler.CoffeeSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $
  it "gets menu" $ do
    get Menu
    statusIs 200
