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

  data Query = Query { degree :: Int, p :: Point } deriving (Show, Ord, Eq)
  data Point = Point { x :: Int, y :: Int} deriving (Show, Ord, Eq)

  qFromArr :: [Int] -> Query
  qFromArr (d:x:y:_) = Query d (Point x y)

  qDist :: Query -> Float
  qDist (Query _ (Point x y)) =
    let dx = x - 50
        dy = y - 50
        dx2 = (fromIntegral (dx * dx)) :: Float
        dy2 = (fromIntegral (dy * dy)) :: Float
        in sqrt $ dx2 + dy2

  q1 :: Int -> Int -> Float
  q1 x y
    | x == y && x == 50 = 0
    | otherwise =
      let dx = (fromIntegral (x - 50)) :: Float
          dy = (fromIntegral (y - 50)) :: Float
          dst = sqrt (dx * dx + dy * dy)
          in (pi / 2) - (acos (dx / dst))

  q2 :: Int -> Int -> Float
  q2 x y
    | x == y && x == 50 = 0
    | otherwise =
      let dx = (fromIntegral (x - 50)) :: Float
          dy = (fromIntegral (50 - y)) :: Float
          dst = sqrt (dx * dx + dy * dy)
          in (acos (dx / dst)) 

  q3 :: Int -> Int -> Float
  q3 x y
    | x == y && x == 50 = 0
    | otherwise =
      let dx = (fromIntegral (50 - x)) :: Float
          dy = (fromIntegral (50 - y)) :: Float
          dst = sqrt (dx * dx + dy * dy)
          in (pi / 2) - (acos (dx / dst)) 

  q4 :: Int -> Int -> Float
  q4 x y
    | x == y && x == 50 = 0
    | otherwise =
      let dx = (fromIntegral (50 - x)) :: Float
          dy = (fromIntegral (y - 50)) :: Float
          dst = sqrt (dx * dx + dy * dy)
          in (acos (dx / dst))

  qDeg :: Query -> Float
  qDeg (Query _ (Point x y))
    | x >= 50 && y >= 50 = q1 x y
    | x >= 50 && y <= 50 = (q2 x y) + (pi / 2)
    | x <= 50 && y <= 50 = (q3 x y) + (pi )
    | x <= 50 && y >= 50 = (q4 x y) + (pi / 2) + (pi)

  qPercentage :: Query -> Float
  qPercentage q = (qDeg q) / (2 * pi) * 100

  qWithin :: Query -> Bool
  qWithin q@(Query d _) = ((fromIntegral d) :: Float) > (qPercentage q)

  qBlack :: Query -> Bool
  qBlack q = (qWithin q) && (qDist q <= 50)

  qColor :: Query -> String
  qColor q
    | qBlack q = "black"
    | otherwise = "white"

  printerDecorator :: Int -> [String] -> [String]
  printerDecorator n [] = []
  printerDecorator n (x:xs) = ("Case #" ++ (show n) ++ ": " ++ x):(printerDecorator (n + 1) xs)

  main :: IO()
  main = do
    n <- getLine >>= return . readInt
    queries <- readMultilineInput n (return . qFromArr . (map readInt) . words)
    let colors = map qColor queries
        outputs = printerDecorator 1 colors
    forM_ outputs putStrLn
