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

  p2 :: Int -> Int
  p2 x = [1, 2, 4, 3] !! (x `mod` 4)

  p3 :: Int -> Int
  p3 x = [1, 3, 4, 2] !! (x `mod` 4)

  p4 :: Int -> Int
  p4 x = [1, 4] !! (x `mod` 2)

  main :: IO()
  main = do
    c <- getLine >>= return . head . reverse
    let s = [c]
        x = readInt s
    print $ (1 + (p2 x) + (p3 x) + (p4 x)) `mod` 5


