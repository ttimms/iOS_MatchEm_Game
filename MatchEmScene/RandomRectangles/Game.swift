//
//  Game.swift
//  RandomRectangles
//
//  Created by Tyler Timms on 10/12/18.
//  Copyright © 2018 Tyler Timms. All rights reserved.
//

import UIKit

typealias PieceID = Int
typealias PairID = Int

class Game: NSObject {
    
    var nextId = 0
    var pair = 0
    
    func createPiece() -> PieceID {
        nextId += 1

        // Create GamePiece object ...
        
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
