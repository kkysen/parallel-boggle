{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Board
import qualified Boggle
import qualified Dictionary as Dict

import Data.Function ((&))
import Data.Maybe (fromJust)
import System.Environment (getArgs)

import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BSC

test :: IO ()
test = do
    dict <- Dict.fromFile "data/sowpods.txt"
    let board_ = ["SERS", "PATG", "LINE", "SERS"]
--     let board_ = ["LIST", "FROM", "WORD", "HELL"]
--    let board_ = ["AB", "CD"]
    let board = Board.fromList board_ & fromJust
    let boggle = Boggle.new board
    print board
    let solution = Boggle.solve boggle dict
    print solution

main :: IO ()
main = do
    dict <- Dict.fromFile "data/sowpods.txt"
    args <- getArgs
    let (board, score) = solve dict args
    print board
    print score
  where
    
    grow :: Word -> [String] -> [String]
    grow 0 args = args
    grow n args = (args ++ args) & map (\s -> s ++ s) & grow (n - 1)
    
    solve dict args = (board, score)
      where
        board = args
            & grow 3
            & map BSC.pack
            & Board.fromList
            & fromJust
        score = board
            & Boggle.new
            & (`Boggle.solve` dict)
            & Boggle.totalScore
    