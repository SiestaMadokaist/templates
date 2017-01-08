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

  check :: Int -> Int -> Int -> Bool
  check k r n = (k * n) `mod` 10 == r

  solve :: Int -> Int -> [Int]
  solve k r = map (check k r) [1..10]

  main :: IO()
  main = do
    [k, r] <- getLine >>= return . (map readInt) . words
    print $ solve k r
