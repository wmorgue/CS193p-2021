//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
	let game = EmojiMemoryGame()

	var body: some Scene {
		WindowGroup {
			ContentView(viewModel: game)
		}
	}
}
