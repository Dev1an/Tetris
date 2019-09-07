//
//  Model.swift
//  Tetris
//
//  Created by Damiaan on 07/09/2019.
//  Copyright © 2019 dPro. All rights reserved.
//

import SwiftUI

struct Object {
	let shape: [[Bool]]
	let color: Color
			
	var width: Int { shape.first?.count ?? 0 }
}

class Model: ObservableObject {
	var cursor: Object { willSet {objectWillChange.send()} }
	var offset: (row: Int, column: Int) { willSet {objectWillChange.send()} }
	var gameOver = false { willSet { objectWillChange.send() } }
	var timer: Timer?
	
	@Published var blocks: [[Color]]
	
	init(width: Int, height: Int)  {
		let emptyRow = [Color](repeating: .clear, count: width)
		blocks = [[Color]](repeating: emptyRow, count: height)
		cursor = Object.randomTetromino
		offset = (0, width/2 - cursor.width/2)
	}
	
	func advance() {
		if gameOver {
			print("Game Over")
		} else if cursorHitsGround {
			var changedRows = Set<Int>()
			for (row, column) in cursor.blockIndices(movedBy: offset) {
				blocks[row][column] = cursor.color
				changedRows.insert(row)
			}
			removeFullRows(in: changedRows)
			cursor = Object.randomTetromino
			offset = (0, width/2 - cursor.width/2)
			for (row, column) in cursor.blockIndices(movedBy: offset) {
				if blocks[row][column] != .clear {
					gameOver = true
					timer?.invalidate()
					return
				}
			}
		} else {
			offset.row += 1
		}
	}
		
	func moveLeft() {
		if offset.column > 0 && !blocksOverlap(with: &cursor, movedBy: offset + (0,-1)) {
			offset.column -= 1
		}
	}
	
	func moveRight() {
		if offset.column + cursor.width < width && !blocksOverlap(with: &cursor, movedBy: offset + (0,1)) {
			offset.column += 1
		}
	}
	
	func rotateClockWise() {
		var rotated = cursor.rotatedClockWise
		changeCursorIfPossible(to: &rotated)
	}
	
	func rotateCounterClockWise() {
		var rotated = cursor.rotatedCounterClockWise
		changeCursorIfPossible(to: &rotated)
	}
	
	func changeCursorIfPossible(to object: inout Object) {
		let beforeRightBound = offset.column + object.width <= width
		let afterLeftBound = offset.column >= 0
		if beforeRightBound && afterLeftBound && !blocksOverlap(with: &object, movedBy: offset) {
			cursor = object
		}
	}
	
	func removeFullRows(in rows: Set<Int>) {
		let fullRows = rows.filter {blocks[$0].firstIndex(of: .clear) == nil}
		blocks.remove(atOffsets: IndexSet(fullRows))
		if !fullRows.isEmpty {
			let emptyRow = [Color](repeating: .clear, count: width)
			let emptyRows = [[Color]](repeating: emptyRow, count: fullRows.count)
			blocks.insert(contentsOf: emptyRows, at: 0)
		}
	}
	
	var width: Int { blocks.first?.count ?? 0 }

	var blocksWithCursor: [[Color]] {
		var result = blocks
		for (row, column) in cursor.blockIndices(movedBy: offset) {
			result[row][column] = cursor.color
		}
		return result
	}
	
	 func blocksOverlap(with object: inout Object, movedBy offset: (Int, Int)) -> Bool {
		for (row, column) in object.blockIndices(movedBy: offset) {
			if blocks[row][column] != .clear { return true }
		}
		return false
	}
	
	var cursorHitsGround: Bool {
		if cursor.shape.count + offset.row == blocks.count {
			return true
		} else {
			return blocksOverlap(with: &cursor, movedBy: offset + (1,0))
		}
	}
	
	func play() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
			self.advance()
		}
	}
	
	func pause() {
		timer?.invalidate()
	}
	
	deinit {
		timer?.invalidate()
	}
}

func +(left: (Int, Int), right: (Int, Int)) -> (Int, Int) { (left.0+right.0, left.1 + right.1) }
