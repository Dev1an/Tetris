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

protocol CoordinateSequence: LazySequenceProtocol where Element == (Int, Int) {}
extension LazySequence: CoordinateSequence where Base.Element == (Int, Int) {}

struct OffsetObject {
	var object: Object
	var offset: (x: Int, y: Int)
	
	init(terominoCenteredInContainerWithWidth width: Int) {
		object = Object.tetrominos.randomElement()!
		offset = (width/2 - object.width/2, 0)
	}
	
	init(_ object: Object, offset: (Int,Int)) {
		self.object = object
		self.offset = offset
	}
		
	var blockIndices: some CoordinateSequence {
		object.shape.lazy.enumerated().lazy.flatMap { (row, columns) in
			columns.lazy.enumerated().lazy.compactMap {
				$1 ? (row + self.offset.y, $0 + self.offset.x) : nil
			}
		}
	}
	
	func offset(x: Int) -> OffsetObject {
		.init(object, offset: (offset.x + x, offset.y))
	}
	func offset(y: Int) -> OffsetObject {
		.init(object, offset: (offset.x, offset.y + y))
	}
}

class Model: ObservableObject {
	var cursor: OffsetObject { willSet {objectWillChange.send()} }
	
	@Published var blocks: [[Color]]
	
	init(width: Int, height: Int)  {
		let emptyRow = [Color](repeating: .clear, count: width)
		blocks = [[Color]](repeating: emptyRow, count: height)
		cursor = .init(terominoCenteredInContainerWithWidth: width)
	}
	
	func advance() {
		if cursorHitsGround {
			for (row, column) in cursor.blockIndices {
				blocks[row][column] = cursor.object.color
			}
			cursor = .init(terominoCenteredInContainerWithWidth: width)
		} else {
			cursor.offset.y += 1
		}
	}
	
	func setCursorIfPossible(to newCursor: OffsetObject) {
		if !overlaps(with: newCursor) { cursor = newCursor }
	}
	
	func moveLeft() {
		if cursor.offset.x > 0 {
			setCursorIfPossible(to: cursor.offset(x: -1))
		}
	}
	
	func moveRight() {
		if cursor.offset.x + cursor.object.width < width {
			setCursorIfPossible(to: cursor.offset(x: 1))
		}
	}
	
	func rotateClockWise() {
		setCursorIfPossible(to: OffsetObject(cursor.object.rotatedClockWise, offset: cursor.offset))
	}
	
	func rotateCounterClockWise() {
		setCursorIfPossible(to: OffsetObject(cursor.object.rotatedCounterClockWise, offset: cursor.offset))
	}
	
	func place() {
		
	}
	
	var width: Int { blocks.first?.count ?? 0 }

	var blocksWithCursor: [[Color]] {
		var result = blocks
		for (row, column) in cursor.blockIndices {
			result[row][column] = cursor.object.color
		}
		return result
	}
	
	func overlaps(with object: OffsetObject) -> Bool {
		for (row, column) in object.blockIndices {
			if blocks[row][column] != .clear {
				return true
			}
		}
		return false
	}
	
	var cursorHitsGround: Bool {
		if cursor.object.shape.count + cursor.offset.y == blocks.count {
			return true
		} else {
			return overlaps(with: cursor.offset(y: 1))
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
