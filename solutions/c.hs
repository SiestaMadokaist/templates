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

  inv :: Char -> Char
  inv 'L' = 'R'
  inv 'R' = 'L'
  inv 'U' = 'D'
  inv 'D' = 'U'
  inv 'Q' = 'Q'

  separation :: Char -> Char -> String -> Int -> Int
  separation _ _ [] i = i
  separation 'Q' 'Q' (x:xs) i
    | x == 'U' = separation 'Q' 'U' xs i
    | x == 'D' = separation 'Q' 'D' xs i
    | x == 'R' = separation 'R' 'Q' xs i
    | x == 'L' = separation 'L' 'Q' xs i
  separation 'Q' u (x:xs) i
    | x == 'R' = separation 'R' u xs i
    | x == 'L' = separation 'L' u xs i
    | x == inv u = separation 'Q' x xs (i + 1)
    | otherwise = separation 'Q' u xs i
  separation r 'Q' (x:xs) i
    | x == 'U' = separation r 'U' xs i
    | x == 'D' = separation r 'D' xs i
    | x == inv r = separation x 'Q' xs (i + 1)
    | otherwise = separation r 'Q' xs i
  separation r u (x:xs) i
    | x == inv r = separation x 'Q' xs (i + 1)
    | x == inv u = separation 'Q' x xs (i + 1)
    | otherwise = separation r u xs i

  main :: IO()
  main = do
    i <- getLine >>= return . readInt
    moves <- getLine
    putStrLn $ show $ separation 'Q' 'Q' moves 1
