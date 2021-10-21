//
//  EmojiArtApp.swift
//  Shared
//
//  Created by Nikita Rossik on 10/21/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
	@StateObject var paletteStore = PaletteStore(named: "Default")
	
	var body: some Scene {
		DocumentGroup(newDocument: { EmojiDocument() }) { config in
			DocumentView(document: config.document)
				.environmentObject(paletteStore)
		}
	}
}
