module Main where
  import Data.List
  import Control.Monad
  import Data.Array
  import Data.Char
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

  data Del = Del { name :: String, del :: Bool} deriving (Show, Eq)

  categorize :: Int -> [String] -> [Int] -> [Del]
  categorize _ [] _ = []
  categorize n (x:xs) ns = (Del x (n `elem` ns)) : (categorize (n + 1) xs ns)

  allSame :: Ord a => [a] -> Bool
  allSame xs = (length $ S.toList $ S.fromList xs) == 1

  solve2 :: [String] -> String
  solve2 [] = []
  solve2 (d:ds)
    | allSame d = (head d):(solve2 ds)
    | otherwise = '?':(solve2 ds)

  solve :: [String] -> Maybe String
  solve dels -- need to ensure keeps has been filtered with the length of head dels
    | not $ allSame $ map length dels = Nothing
    | otherwise = Just $ solve2 $ transpose dels

  match :: String -> String -> Bool
  match _ [] = True
  match ('?':pats) (x:xs) = True && (match pats xs)
  match (p:pats) (x:xs)
    | p /= x = False
    | otherwise = match pats xs

  isSolution :: Maybe String -> [String] -> Bool
  isSolution Nothing _ = False
  isSolution (Just pat) keeps =
    let matches = map (match pat) keeps
        in not $ any id matches

  printOutput :: Maybe String -> [String] -> IO()
  printOutput Nothing _ = putStrLn "No"
  printOutput (Just pat) xs
    | isSolution (Just pat) xs = do
      putStrLn "Yes"
      putStrLn pat
    | otherwise = putStrLn "No"

  main :: IO()
  main = do
    [n, k] <- getLine >>= return . map readInt . words
    xs <- readMultilineInput n return
    files <- getLine >>= return . map readInt . words
    let cats = categorize 1 xs files
        dels = filter del cats
        dl = length $ name $ head dels
        keeps0 = filter (not . del) cats
        keeps = filter ((==dl) . length . name) keeps0
        sdels = map name dels
        s = solve sdels
    printOutput s (map name keeps)
