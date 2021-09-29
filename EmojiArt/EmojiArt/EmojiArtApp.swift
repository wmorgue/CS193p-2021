//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
	@StateObject var doc = EmojiDocument()
	@StateObject var paletteStore = PaletteStore(named: "Default")
	
	var body: some Scene {
		WindowGroup {
			DocumentView(document: doc)
				.environmentObject(paletteStore)
		}
	}
}
