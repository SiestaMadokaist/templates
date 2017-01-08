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

  readInteger :: String -> Integer
  readInteger s = read s :: Integer

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

  -- data Point = Point { x :: Int, y :: Int } deriving (Ord, Eq)
  couldWin :: Char -> String -> Bool
  couldWin x (a:b:'.':_) = x == a && x == b
  couldWin x (a:'.':b:_) = x == a && x == b
  couldWin x ('.':a:b:_) = x == a && x == b
  couldWin x _ = False

  lineCouldWin :: Char -> String -> Bool
  lineCouldWin a (x:xs) = couldWin a (x:xs) || couldWin a xs

  diagonalCouldWin :: Char -> [String] -> Bool
  diagonalCouldWin c [(x1:x2:x3:_), (y1:y2:y3:_), (z1:z2:z3:_)]
    | x1 == '.' && y2 == z3 && c == y2 = True
    | x3 == '.' && y2 == z1 && c == y2 = True
    | z1 == '.' && y2 == x3 && c == y2 = True
    | z3 == '.' && y2 == x1 && c == y2 = True
    | y2 == '.' && x1 == z3 && c == x1 = True
    | y2 == '.' && x3 == z1 && c == x3 = True
    | otherwise = False

  yesNo :: Bool -> String
  yesNo True = "YES"
  yesNo _ = "NO"

  to3x3 :: [String] -> [[String]]
  to3x3 (a:b:c:d:_) = [
          map (take 3) (a:b:c:[]),
          map (take 3) (b:c:d:[]),
          map (drop 1) (a:b:c:[]),
          map (drop 1) (b:c:d:[])
        ]

  main :: IO()
  main = do
    tics <- readMultilineInput 4 return
    let alltics = intercalate [] tics
        ticsAlter = transpose tics
        playCount = length $ filter (=='.') alltics
        diagonals = to3x3 tics
        c = case playCount `mod` 2 of
              0 -> 'x'
              1 -> 'o'
        result1 = any (lineCouldWin c) tics
        result2 = any (lineCouldWin c) ticsAlter
        result3 = any (diagonalCouldWin c) diagonals
    -- print $ c
    -- print $ map (lineCouldWin c) tics
    -- forM_ ticsAlter print
    -- print $ map (lineCouldWin c) ticsAlter
    putStrLn $ yesNo $ result1 || result2 || result3
