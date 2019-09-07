//
//  ContentView.swift
//  Tetris
//
//  Created by Damiaan on 03/09/2019.
//  Copyright © 2019 dPro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var model: Model
	
    var body: some View {
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
		.padding()
		.onAppear { self.model.play() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(Model(width: 15, height: 20))
    }
}
