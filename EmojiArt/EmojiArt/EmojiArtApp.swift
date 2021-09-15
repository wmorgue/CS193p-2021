//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
	let doc = EmojiDocument()
	
	var body: some Scene {
		WindowGroup {
			DocumentView(document: doc)
		}
	}
}
