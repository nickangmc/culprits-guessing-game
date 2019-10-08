--  File     : proj1.hs
--  Author   : Mink Chen Ang (Nick)
--  Origin   : Tues Aug 28 20:45:05 2018
--  Purpose  : Project 1 of COMP30020 Declaractive Programming

module Proj1 (Person, parsePerson, height, hair, sex,
              GameState, initialGuess, nextGuess, feedback) where

import Data.List


--Represents a suspect
data Person = Person Height Hair Sex deriving (Show, Read, Eq)

data Height = S | T deriving (Show, Read, Eq, Enum, Bounded)
data Hair = R | D | B deriving (Show, Read, Eq, Enum, Bounded)
data Sex = F | M deriving (Show, Read, Eq, Enum, Bounded)


-- Holds a list of suspects to help decide next guess based on the previous
-- one.
type GameState = [[Person]]

------------------------------------------------------------
{- ParsePerson, height, hair, and sex functions implementations to the
 - project
 - Primary functions to handle Person and its related type data
 -}

-- Takes a three-character string and returns Just p, where p is the person
-- specified by the input string. If an invalid string is provided,
-- returns Nothing.
parsePerson :: String -> Maybe Person
parsePerson p@(p1:p2:p3:_)
    | and [length p == 3,
           [p1] `elem` show' (allValues :: [Height]),
           [p2] `elem` show' (allValues :: [Hair]),
           [p3] `elem` show' (allValues :: [Sex])]
        = Just (Person fea1 fea2 fea3)
    | otherwise = Nothing
    where fea1 = read [p1] :: Height
          fea2 = read [p2] :: Hair
          fea3 = read [p3] :: Sex


-- Returns the person’s height.
height :: Person -> Height
height (Person x _ _) = x


-- Returns the person’s hair colour.
hair :: Person -> Hair
hair (Person _ x _) = x


-- Returns the person’s sex.
sex :: Person -> Sex
sex (Person _ _ x) = x


------------------------------------------------------------
{- Helper functions to help in handling Person and its related type data -}

-- Returns all values of an Enum type data
allValues :: (Bounded a, Enum a) => [a]
allValues = [minBound..]


-- Takes in a list and returns the list with each of its elements turned into
-- a String accordingly via the method show.
show' :: (Show a) => [a] -> [String]
show' [] = []
show' (x:xs) = show x : show' xs


-- Takes in a list of Person and returns a list of String, with each String
-- element corresponds to a Person element in the same order as the input list.
personToString :: [Person] -> [String]
personToString [] = []
personToString (p:ps) =
    let personString = (show $ height p) ++ (show $ hair p) ++ (show $ sex p)
    in  personString : personToString ps


-- Takes in a list of String and returns a list of Person, with each Person
-- element corresponds to a String element in the same order as the input list.
stringToPerson :: [String] -> [Person]
stringToPerson [] = []
stringToPerson (x:xs) =
    let (Just someone) = parsePerson x
    in someone : stringToPerson xs


------------------------------------------------------------
{- A generic Helper function  -}

-- Takes in two lists and zip each of their elements together accordingly
-- and returns the zipped elements in a list. Similar to the original zip
-- function but returns the zipped elements in a different format.
zip' :: (Ord a) => [a] -> [a] -> [[a]]
zip' [] [] = []
zip' (a:as) [] = [a] : zip' as []
zip' [] (b:bs) = [b] : zip' [] bs
zip' (a:as) (b:bs) = sort [a,b] : zip' as bs


------------------------------------------------------------
{- Feedback function implementation to the project and its helper functions
-}

-- Takes first a list of the true culprits and second a list of the suspects
-- in a lineup, and returns a quadruple of correct suspects, correct heights,
-- correct hair colours, and correct sexes, in that order.
feedback :: [Person] -> [Person] -> (Int,Int,Int,Int)
feedback culpritList suspectList =
    let culprits = sort $ personToString(culpritList)
        suspects = sort $ personToString(suspectList)
        (a:b:c:[]) = matchPerson culprits suspects
        numActualCulprits = findActualCulprits culprits suspects
    in  (numActualCulprits, a, b, c)


-- Takes first a list of String (culprits) and second a list of String
-- (suspects) in a lineup, find if there is any matches between culprits and
-- suspects, then calculate the feedback scores accordingly.
matchPerson :: [String] -> [String] -> [Int]

-- If there are two matches found, then feedback scores will be [0,0,0]
matchPerson [c1] [s1]
    | c1 == s1  = [0,0,0]
    | otherwise = findMatchingFeatures culprits suspects
    where culprits = zip' c1 []
          suspects = zip' s1 []

matchPerson (c1:c2:_) (s1:s2:_)
    | c1 == s1 = matchPerson [c2] [s2]
    | c1 == s2 = matchPerson [c2] [s1]
    | c2 == s1 = matchPerson [c1] [s2]
    | c2 == s2 = matchPerson [c1] [s1]
    | otherwise = findMatchingFeatures culprits suspects
    where culprits = zip' c1 c2
          suspects = zip' s1 s2


-- Takes in two zip'-ed lists of String (culprits & suspects), calculates and
-- returns their feedback scores based on their features.
findMatchingFeatures :: [String] -> [String] -> [Int]
findMatchingFeatures [] _ = []
findMatchingFeatures _ [] = []
findMatchingFeatures (x:xs) (y:ys)
    = getScore x y : findMatchingFeatures xs ys


-- Takes in two String variables (each represents a type of features from two
-- Person), returns their similarity scores.
getScore :: String -> String -> Int
getScore [] _ = 0
getScore _ [] = 0
getScore (x:xs) (y:ys)
    | x == y = 1 + getScore xs ys
    | x < y  = 0 + getScore xs (y:ys)
    | x > y  = 0 + getScore (x:xs) ys


-- Takes first a list of String (culprits) and second a list of String
-- (suspects) in a lineup, finds and return the number of matches between
-- culprits and suspects.
findActualCulprits :: [String] -> [String] -> Int
findActualCulprits [] _ = 0
findActualCulprits _ [] = 0
findActualCulprits (c:cs) (s:ss)
    | c == s = 1 + findActualCulprits cs ss
    | c < s  = 0 + findActualCulprits cs (s:ss)
    | c > s  = 0 + findActualCulprits (c:cs) ss


------------------------------------------------------------
{- InitialGuess function implementation to the project and its helper
 - function.
 -}

-- Returns initial lineup and initial game state.
initialGuess :: ([Person],GameState)
initialGuess =
    -- generate all possible combinations of Person
    let personInString = [a ++ b ++ c | a <- show' (allValues :: [Height]),
                                        b <- show' (allValues :: [Hair]),
                                        c <- show' (allValues :: [Sex])]
        personList = stringToPerson personInString
        gameState  = makeDistinct [[person1, person2] | person1 <- personList,
                                                        person2 <- personList,
                                                        person1 /= person2]
    -- the initial lineup is selected arbitrarily via trial and error to
    -- has the lowest average guesses
    in (stringToPerson ["SBF", "SDF"], gameState)


-- Takes in initial GameState and return the GameState with any duplicate
-- pairs of combination of Person removed
makeDistinct :: GameState -> GameState
makeDistinct [] = []
makeDistinct (x:xs)
    | [b, a] `elem` xs = makeDistinct xs
    | otherwise = x : makeDistinct xs
    where [a, b] = x


------------------------------------------------------------
{- NextGuess function implementation to the project -}

-- Takes as input a pair of the previous guess and game state (as returned by
-- initialGuess and nextGuess), and the feedback to this guess as a quadruple
-- of correct suspects, correct height, correct hair colour, and correct sex,
-- in that order, and returns a pair of the next guess and new game state.
nextGuess :: ([Person],GameState) -> (Int,Int,Int,Int) -> ([Person],GameState)
nextGuess (previousGuess, gameState) score
    | length newGameState > 0 = (head newGameState, tail newGameState)
    | otherwise = ([], [])
    where newGameState = filter (\x -> feedback previousGuess x == score)
                         gameState


------------------------------------------------------------
-- End of the file --
