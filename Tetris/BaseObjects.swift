//
//  BaseObjects.swift
//  Tetris
//
//  Created by Damiaan on 03/09/2019.
//  Copyright © 2019 dPro. All rights reserved.
//

extension Object {
	static let tetrominos = [
		Object(
			shape: [
				[true, false],   // •    //
				[true, false],  //  •   //
				[true, true],  //   •• //
			],
			color: .red
		),
		Object(
			shape: [
				[false, true, false],  // •••  //
				[true,  true,  true], //   •  //
			],
			color: .green
		),
		Object(
			shape: [
				[true,  true,  true, true], // •••• //
			],
			color: .blue
		),
		Object(
			shape: [
				[true, true, false],  // ••   //
				[false, true, true], //   •• //
			],
			color: .yellow
		),
		Object(
			shape: [
				[false, true, true],  // •• //
				[true, true, false], // •• //
			],
			color: .orange
		),
		Object(
			shape: [
				[true, true],  // ••  //
				[true, true], //  •• //
			],
			color: .purple
		)
	]
	
	static var randomTetromino: Object { tetrominos.randomElement()! }
	
	func blockIndices(movedBy offset: (row: Int, column: Int)) -> some CoordinateSequence {
		shape.lazy.enumerated().lazy.flatMap { (row, columns) in
			columns.lazy.enumerated().lazy.compactMap {
				$1 ? (row + offset.row, $0 + offset.column) : nil
			}
		}
	}
		
	var rotatedClockWise: Object {
		Object(
			shape: shape[0].indices.map { row in
				shape.lazy.indices.reversed().map { column in
					shape[column][row]
				}
			},
			color: color
		)
	}
	
	var rotatedCounterClockWise: Object {
		Object(
			shape: shape[0].indices.lazy.reversed().map { row in
				shape.indices.map { column in
					shape[column][row]
				}
			},
			color: color
		)
	}
}

protocol CoordinateSequence: LazySequenceProtocol where Element == (Int, Int) {}
extension LazySequence: CoordinateSequence where Base.Element == (Int, Int) {}
