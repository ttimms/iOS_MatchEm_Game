//
//  Game.swift
//  MatchEmTab
//
//  Created by Tyler Timms on 10/12/18.
//  Copyright © 2018 Tyler Timms. All rights reserved.
//

import UIKit

typealias PieceID = Int
typealias PairID = Int

class Game: NSObject {
    
    // Id variables
    var nextId = 0
    var pair = 0
    
    // Last three game scores
    var numPairs1 = 0
    var score1 = 0
    var numPairs2 = 0
    var score2 = 0
    var numPairs3 = 0
    var score3 = 0
    
    func createPiece() -> PieceID {
        nextId += 1
        return nextId
    }
    func makePair() -> PairID {
        pair += 1
        return pair
    }
    
    func isSelected(pieceID id: PieceID) -> Bool {
        return false
    }
}
