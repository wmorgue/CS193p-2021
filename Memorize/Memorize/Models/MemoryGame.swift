//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
	private(set) var cards: [Card]
	
	private var indexOfOneAndOnlyFaceUpCard: Int? {
		get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
		set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
	}
	mutating func choose(_ card: Card) -> Void {
		if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
			 !cards[chosenIndex].isFaceUp,
			 !cards[chosenIndex].isMatched {
			if let potentionalIndex = indexOfOneAndOnlyFaceUpCard {
				if cards[chosenIndex].content == cards[potentionalIndex].content {
					cards[chosenIndex].isMatched = true
					cards[potentionalIndex].isMatched = true
				}
				cards[chosenIndex].isFaceUp = true
			} else {
				indexOfOneAndOnlyFaceUpCard = chosenIndex
			}
		}
	}
	
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = []
		
		for index in 0..<numberOfPairsOfCards {
			let content = createCardContent(index)
			
			cards.append(Card(content: content, id: index*2))
			cards.append(Card(content: content, id: index*2+1))
		}
	}
}


extension MemoryGame {
	struct Card: Identifiable {
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		let content: CardContent
		let id: Int
	}
}


extension Array {
	var oneAndOnly: Element? {
		if count == 1 {
			return first
		} else {
			return nil
		}
	}
}
