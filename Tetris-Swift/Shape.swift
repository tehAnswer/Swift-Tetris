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
    
    final func initializeBlocks() {
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
                
            }
        }
    }
    
    
    final func rotateBlocks(orientation: Orientation) {
        if let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {
            for (idx, (columnDiff:Int, rowDiff:Int)) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + columnDiff
                blocks[idx].row = row + rowDiff
            }
        }
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows:1)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int, row:Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    final class func random(startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(NumShapesTypes)) {
        case 0:
            return SquareShape(column:startingColumn, row:startingRow)
        case 1:
            return LineShape(column:startingColumn, row:startingRow)
        case 2:
            return TShape(column:startingColumn, row:startingRow)
        case 3:
            return LShape(column:startingColumn, row:startingRow)
        case 4:
            return JShape(column:startingColumn, row:startingRow)
        case 5:
            return SShape(column:startingColumn, row:startingRow)
        default:
            return ZShape(column:startingColumn, row:startingRow)
        }
    }
}

func ==(left:Shape, right:Shape) -> Bool {
    return left.description == right.description
}




































