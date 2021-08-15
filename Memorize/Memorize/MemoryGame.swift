//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nikita Rossik on 6/28/21.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
	private(set) var cards: [Card]
	
	private var indexOfOneAndOnlyFaceUpCard: Int?
	
	fileprivate mutating func restartGame() {
		for index in cards.indices {
			cards[index].isFaceUp = false
		}
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
				indexOfOneAndOnlyFaceUpCard = nil
			} else {
				restartGame()
				indexOfOneAndOnlyFaceUpCard = chosenIndex
			}
			cards[chosenIndex].isFaceUp.toggle()
		}
	}
	
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = [Card]()
		
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
		var content: CardContent
		var id: Int
	}
}
