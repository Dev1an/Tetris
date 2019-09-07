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
