//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import SwiftUI


final class EmojiMemoryGame: ObservableObject {
	typealias Card = MemoryGame<String>.Card
	
	@Published private var model = createMemoryGame()

	var cards: [Card] { model.cards }
	private static let emojis = ["🦔", "👾", "🦿", "🪢", "🌧", "🥦", "🥢", "🥌", "🏆", "🛩", "🏖", "🪥", "🧴", "♻️"]

	private static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 2) { emojis[$0] }
	}

	// MARK: - Intent(s)
	func choose(_ card: Card) { model.choose(card) }
}
