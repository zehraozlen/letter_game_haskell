import Data.Char (toUpper)

-- Initial game board 
firstBoard :: [[Char]]
firstBoard =
    [ ['X', 'A', '-', '-', 'X']
    , ['B', '-', '-', '-', 'Z']
    , ['X', 'C', '-', '-', 'X']
    ]

-- Prints the board 
printBoard :: [[Char]] -> IO ()
printBoard board = do
    mapM_ putStrLn [formatRow r | r <- [0,5..14]]
  where
    formatRow i = unwords [[c] | (_, c) <- take 5 (drop i (zip [0..] (concat board)))]

-- Takes the maximum number of moves and who starts the game as an input 
getMax :: IO Int
getMax = do
    putStrLn "Enter the maximum number of total moves allowed:"
    readLn

takeOrder :: IO String
takeOrder = do
    putStrLn "Who starts first? Type 'last' or 'firsts':"
    getLine

-- Converts a position to a row and column index 
index :: Int -> (Int, Int)
index i = (i `div` 5, i `mod` 5)

-- Finds the position in the board for a char
findPosition :: Char -> [[Char]] -> (Int, Int)
findPosition ch board =
    head [(r, c) | (r, row) <- zip [0..] board, (c, val) <- zip [0..] row, val == ch]

-- Checks whether the index is outside
checkBorders :: (Int, Int) -> Bool
checkBorders (r, c) = r >= 0 && r < 3 && c >= 0 && c < 5

-- Checks whether that index is empty 
isEmpty :: [[Char]] -> (Int, Int) -> Bool
isEmpty board (r, c) = board !! r !! c == '-'

--Checks whether that index is fixed place
isFixed :: [[Char]] -> (Int, Int) -> Bool
isFixed board (r, c) = board !! r !! c == 'X'

-- Checks whether that move is valid
isValid :: [[Char]] -> Char -> (Int, Int) -> Bool
isValid board ch (r, c)
    | not (checkBorders (r, c)) = False
    | isFixed board (r, c) = False
    | not (isEmpty board (r, c)) = False
    | otherwise =
        let (cr, cc) = findPosition ch board
            dr = r - cr
            dc = c - cc
            -- Checks the distance condition
            checkDistance = abs dr <= 1 && abs dc <= 1 && (dr /= 0 || dc /= 0)
            -- Checks the condition for moving forward
            checkDirection = if ch `elem` "ABC" then dc >= 0 else True
        in checkDistance && checkDirection

--Puts the character to given index 
replace :: Int -> Char -> [Char] -> [Char]
replace idx val row = take idx row ++ [val] ++ drop (idx + 1) row

--Moves letter from one index to another
move :: [[Char]] -> Char -> (Int, Int) -> [[Char]]
move board ch (r, c) =
    let (cr, cc) = findPosition ch board
        deleted = take cr board ++ [replace cc '-' (board !! cr)] ++ drop (cr + 1) board
        updated = take r deleted ++ [replace c ch (deleted !! r)] ++ drop (r + 1) deleted
    in updated

-- Checks winning condition 
checkWinner :: [[Char]] -> String -> Bool
checkWinner board "last" =
    let (_, zc) = findPosition 'Z' board
        cols = [c | ch <- "ABC", let (_, c) = findPosition ch board]
    in all (\c -> zc < c) cols
checkWinner board "firsts" =
    null [() | r <- [0..2], c <- [0..4], isValid board 'Z' (r, c)]
checkWinner _ _ = False

-- Game loop
playGame :: [[Char]] -> Int -> String -> Int -> IO ()
playGame board maxMoves currentTurn remainingMoves = do
    if remainingMoves == 0 then putStrLn "\nGame Over: Draw!"
    else do
        if currentTurn == "firsts" then do
            putStrLn "Please select one of the first three letters and a cell to move it (e.g., A 6):"
            input <- getLine
            let parts = words input
            if length parts == 2 then do
                let ch = toUpper (head (parts !! 0))
                let pos = read (parts !! 1) :: Int
                let target = index pos
                if ch `elem` "ABC" && isValid board ch target then do
                    let newboard = move board ch target
                    printBoard newboard  -- Print the board after A/B/C's move
                    if checkWinner newboard "firsts" then do
                        putStrLn "\nA&B&C win!"
                    else if checkWinner newboard "last" then do
                        putStrLn "\nZ wins!"
                    else
                        playGame newboard maxMoves "last" (remainingMoves - 1)
                else do
                    putStrLn "Invalid move!"
                    playGame board maxMoves "last" remainingMoves
            else do
                putStrLn "Invalid format!"
                playGame board maxMoves currentTurn remainingMoves

        else do
            putStrLn "Please select a cell for the Z:"
            pos <- readLn
            let target = index pos
            if isValid board 'Z' target then do
                let newboard = move board 'Z' target
                printBoard newboard  -- Print the board after Z's move
                if checkWinner newboard "last" then do
                    putStrLn "\nZ wins!"
                else if checkWinner newboard "firsts" then do
                    putStrLn "\nA&B&C win!"
                else
                    playGame newboard maxMoves "firsts" (remainingMoves - 1)
            else do
                putStrLn "Invalid move!"
                playGame board maxMoves "firsts" remainingMoves

-- Main
main :: IO ()
main = do
    putStrLn "Welcome!"
    let board = firstBoard
    printBoard board  
   
    maxMoves <- getMax
    firstTurn <- takeOrder
    playGame board maxMoves firstTurn maxMoves
