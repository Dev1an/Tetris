//
//  ContentView.swift
//  Tetris
//
//  Created by Damiaan on 03/09/2019.
//  Copyright © 2019 dPro. All rights reserved.
//

import SwiftUI

struct Object {
	let shape: [[Bool]]
	let color: Color
			
	var width: Int { shape.first?.count ?? 0 }	
}

func +(left: (Int, Int), right: (Int, Int)) -> (Int, Int) { (left.0+right.0, left.1 + right.1) }

class Model: ObservableObject {
	var cursor: Object { willSet {objectWillChange.send()} }
	var offset: (row: Int, column: Int) { willSet {objectWillChange.send()} }
	
	@Published var blocks: [[Color]]
	
	init(width: Int, height: Int)  {
		let emptyRow = [Color](repeating: .clear, count: width)
		blocks = [[Color]](repeating: emptyRow, count: height)
		cursor = Object.randomTetromino
		offset = (0, width/2 - cursor.width/2)
	}
	
	func advance() {
		if cursorHitsGround {
			for (row, column) in cursor.blockIndices(movedBy: offset) {
				blocks[row][column] = cursor.color
			}
			cursor = Object.randomTetromino
			offset = (0, width/2 - cursor.width/2)
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
		if !blocksOverlap(with: &rotated, movedBy: offset) { cursor = rotated }
	}
	
	func rotateCounterClockWise() {
		var rotated = cursor.rotatedCounterClockWise
		if !blocksOverlap(with: &rotated, movedBy: offset) { cursor = rotated }
	}
	
	func place() {
		
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
}

struct ContentView: View {
	@EnvironmentObject var model: Model
    var body: some View {
		VStack {
			ZStack {
				Text("Tetris")
				canvas
			}
			HStack {
				Button("<-") { self.model.moveLeft() }
				Button("Advance") { self.model.advance() }
				Button("->") { self.model.moveRight() }
			}
			HStack {
				Button("<") { self.model.rotateCounterClockWise() }
				Button(">") { self.model.rotateClockWise() }
			}
		}.padding()
    }
	
	var canvas: some View {
		let blocks = model.blocksWithCursor
		return VStack(spacing: 1) {
			ForEach(blocks.indices) { row in
				HStack(spacing: 1) {
					ForEach(blocks[row].indices) { column in
						Rectangle()
							.frame(width: 20, height: 20)
							.foregroundColor(blocks[row][column])
					}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(Model(width: 15, height: 20))
    }
}
