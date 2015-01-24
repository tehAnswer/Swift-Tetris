//
//  Shape.swift
//  Tetris-Swift
//
//  Created by Sergio Gijón on 24/1/15.
//  Copyright (c) 2015 Sergio Gijón. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
          case .Zero:
            return "0"
          case .Ninety:
            return "90"
          case .OneEighty:
            return "180"
          case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

let NumShapesTypes: UInt32 = 7
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
    let color: BlockColor
    
    var blocks = Array<Block>()
    var orientation: Orientation
    
    var column, row: Int
    
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }
    
    var bottomBlocks:Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
           return bottomBlocks
        }
        return []
    }
    
    var hashValue:Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    var description: String {
        return "\(color) \(orientation): <\(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])>"
    }
    
    init(column:Int, row:Int, color: BlockColor, orientation: Orientation){
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    convenience init(column:Int, row:Int) {
        self.init(column: column, row:row, color: BlockColor.random(), orientation:Orientation.random())
    }
}

func ==(left:Shape, right:Shape) -> Bool {
    return left.description == right.description
}




































