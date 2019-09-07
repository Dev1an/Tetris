//
//  AppDelegate.swift
//  Tetris
//
//  Created by Damiaan on 03/09/2019.
//  Copyright © 2019 dPro. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		window = Window(
			model: Model(width: 15, height: 20),
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false)
		window.center()
		window.setFrameAutosaveName("Main Window")
		
		window.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}

class Window: NSWindow {
	let model: Model
	init(model: Model, contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
		self.model = model
		super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
		
		contentView = NSHostingView(rootView: ContentView().environmentObject(model))
	}
	
	override func moveDown(_ sender: Any?) {
		model.advance()
	}
	
	override func moveLeft(_ sender: Any?) {
		model.moveLeft()
	}
	
	override func moveRight(_ sender: Any?) {
		model.moveRight()
	}
	
	override func moveUp(_ sender: Any?) {
		model.rotateClockWise()
	}
}
