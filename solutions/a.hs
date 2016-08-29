module Main where
  import Data.List
  import Control.Monad
  import Data.Array
  import qualified Data.Set as S

  toArray :: [a] -> Array Int a
  toArray xs =
    let ls = length xs - 1
        in array (0, ls) $ zip [0..ls] xs

  readInt :: String -> Int
  readInt s = read s :: Int

  readMultilineInput :: Int -> (String -> IO a) -> IO [a]
  readMultilineInput n transformer = replicateM n (getLine >>= transformer)

  elemSet :: (Ord a) => a -> S.Set a -> Bool
  elemSet elem sets =
    let found = elem `S.lookupIndex` sets
        in toBool found
        where
          toBool :: Maybe Int -> Bool
          toBool (Just _) = True
          toBool Nothing = False

  considerSeats :: String -> (Bool, Bool)
  considerSeats ('O':'O':_) = (True, False)
  considerSeats (_:_:'|':'O':'O':_) = (False, True)
  considerSeats _ = (False, False)

  transform :: (Bool, Bool) -> String -> String
  transform (True, False) (a:b:s) = '+':'+':s
  transform (False, True) (a:b:s) =  a:b:"|++"

  reshow :: Bool -> [((Bool, Bool), String)] -> [String] -> [String]
  reshow _ [] accumulator = accumulator
  reshow True ((_, s):xs) accumulator                   = reshow True xs (s:accumulator)
  reshow False ((pred@(True, False), s):xs) accumulator = reshow True xs ((transform pred s):accumulator)
  reshow False ((pred@(False, True), s):xs) accumulator = reshow True xs ((transform pred s):accumulator)
  reshow False ((pred@(False, False), s):xs) accumulator  = reshow False xs (s:accumulator)

  hasTrue :: (Bool, Bool) -> Bool
  hasTrue (False, False) = False
  hasTrue _ = True

  main :: IO()
  main = do
    n <- getLine >>= return . readInt
    seats <- readMultilineInput n return
    let consideredSeats = considerSeats `map` seats
        hasAns = any hasTrue consideredSeats
        ans = consideredSeats `zip` seats
        action = case hasAns of
          False -> putStrLn "NO"
          True -> do
            putStrLn "YES"
            mapM_ putStrLn $ reverse $ reshow False ans []
    -- putStrLn $ show ans
    action
