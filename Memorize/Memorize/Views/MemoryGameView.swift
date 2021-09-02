//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct MemoryGameView: View {
	
	private let cardRatio: CGFloat = 2/2.2
	@ObservedObject var game: EmojiMemoryGame
	
	var body: some View {
		AspectVGrid(game.cards, cardRatio) { card in
			if card.isMatched && !card.isFaceUp {
				Rectangle().opacity(0)
			} else {
				CardView(card)
					.padding(4)
					.onTapGesture { game.choose(card) }
			}
		}
		.foregroundColor(.pink)
		.padding(.all)
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let game = EmojiMemoryGame()
		game.choose(game.cards.first!)
		return MemoryGameView(game: game)
			.preferredColorScheme(.light)
			.previewDisplayName("Game")
	}
}
