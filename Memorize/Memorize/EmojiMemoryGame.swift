//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import SwiftUI


final class EmojiMemoryGame {
	static let emojis = ["🦔", "👾", "🦿", "🪢", "🌧", "🥦", "🥢", "🥌", "🏆", "🛩", "🏖", "🪥", "🧴", "♻️"]

	static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
			emojis[pairIndex]
		}
	}

	var model = createMemoryGame()
	var cards: Array<MemoryGame<String>.Card> { model.cards }
}
