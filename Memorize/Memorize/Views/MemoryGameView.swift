//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct MemoryGameView: View {
	
	@ObservedObject var game: EmojiMemoryGame
	
	private let cardRatio: CGFloat = 2/2.2
	
	private let columns: [GridItem] = [
		.init(.adaptive(minimum: 100))
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(game.cards) { card in
					CardView(card) 
						.aspectRatio(cardRatio, contentMode: .fit)
						.onTapGesture { game.choose(card) }
				}
			}
		}
		.foregroundColor(.pink)
		.padding(.all)
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let game = EmojiMemoryGame()
		MemoryGameView(game: game)
			.preferredColorScheme(.dark)
			.previewDisplayName("Game")
	}
}
