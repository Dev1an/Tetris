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
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false)
		window.center()
		window.setFrameAutosaveName("Main Window")

		window.contentView = NSHostingView(rootView: ContentView())

		window.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

