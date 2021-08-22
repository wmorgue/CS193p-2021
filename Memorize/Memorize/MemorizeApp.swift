//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
	private let game = EmojiMemoryGame()

	var body: some Scene {
		WindowGroup {
			MemoryGameView(game: game)
		}
	}
}
