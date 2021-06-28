//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import Foundation


struct MemoryGame<CardContent> {
	private(set) var cards: Array<Card>

	func choose(_ card: Card) {}

	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = Array<Card>()

		for index in 0..<numberOfPairsOfCards {
			let content = createCardContent(index)

			cards.append(Card( content: content))
			cards.append(Card( content: content))
		}
	}
}


extension MemoryGame {
	struct Card {
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		var content: CardContent
	}
}
