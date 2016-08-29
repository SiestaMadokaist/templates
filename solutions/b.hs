module Main where
  import Data.List
  import Control.Monad
  import Data.Array
  import qualified Data.Set as S

  toArray :: [a] -> Array Int a
  toArray xs =
    let ls = length xs - 1
        in array (0, ls) $ zip [0..ls] xs

  readInt :: String -> Integer
  readInt s = read s :: Integer

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

  getTotalOnNonZero :: (Bool, [Integer]) -> Integer
  getTotalOnNonZero (True, _) = -1
  getTotalOnNonZero (False, xs) = sum xs

  hasZero :: [Integer] -> Bool
  hasZero = any (==0)

  main :: IO()
  main = do
    n <- getLine >>= return . (read :: String -> Int)
    matrix <- readMultilineInput n (return . (map readInt) . words)
    let matrixT = transpose matrix
        zeroX = 0 -- TODO
        zeroY = 0 -- TODO
        lm = length matrix
        zerosH = map hasZero matrix
        zerosV = map hasZero matrixT
        ids = [0..(length matrix - 1)]
        diags = (\index -> matrix !! index !! index) `map` ids
        diagsI = (\index -> matrix !! index !! (lm - index - 1)) `map` ids
        sdiags = sum diags
        sdiagsI = sum diagsI
        hm = zerosH `zip` matrix
        vm = zerosV `zip` matrixT
        hmm = snd . head $ filter fst hm :: [Integer]
        vmm = snd . head $ filter fst vm :: [Integer]
        horizontals = map getTotalOnNonZero hm
        verticals = map getTotalOnNonZero vm
        targetScore = head $ filter (>=0) horizontals
        allTargets = filter (>0) $ horizontals ++ verticals
        possible = all (==targetScore) allTargets
        shmm = sum hmm
        svmm = sum vmm
        d1diff = targetScore - sdiags
        d2diff = targetScore - sdiagsI
        hdiff = targetScore - shmm
        vdiff = targetScore - svmm
        action = case ans < 1 of
                   True -> print (-1)
                   False -> print ans
        ans = case n of
          1 ->  9 -- doesnt matter
          _ -> case possible && (hdiff == vdiff) of
                 False ->  (-1)
                 True -> case any (==0) diags of
                           True -> case any (==0) diagsI of
                                     True -> case d1diff == d2diff && hdiff == d1diff of
                                               False ->  (-2)
                                               True ->  d1diff
                                     False -> case d1diff == hdiff && sdiagsI == targetScore of
                                                False ->  (-3)
                                                True ->  d1diff
                           False -> case any (==0) diagsI of
                                      True -> case hdiff == d2diff && sdiags == targetScore of
                                                False ->  (-4)
                                                True ->  hdiff
                                      False -> case sdiagsI == sdiags && sdiags == targetScore of
                                                 False ->  (-5)
                                                 True ->  hdiff

    action
