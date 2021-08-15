//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import SwiftUI


final class EmojiMemoryGame: ObservableObject {
	static let emojis = ["🦔", "👾", "🦿", "🪢", "🌧", "🥦", "🥢", "🥌", "🏆", "🛩", "🏖", "🪥", "🧴", "♻️"]

	static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
	}

	@Published private var model = createMemoryGame()

	var cards: [MemoryGame<String>.Card] { model.cards }


	// MARK: - Intent(s)
	func choose(_ card: MemoryGame<String>.Card) { model.choose(card) }
}
