//
//  ContentView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var viewModel: EmojiMemoryGame
	
	private let columns: [GridItem] = [
		.init(.adaptive(minimum: 100, maximum: 120))
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(viewModel.cards) { card in
					CardView(card) 
						.aspectRatio(contentMode: .fit)
						.onTapGesture { viewModel.choose(card) }
				}
			}
		}
		.foregroundColor(.pink)
		.padding(.all)
	}
}


struct CardView: View {
	private let radius: CGFloat = 25
	private let lineWidth: CGFloat = 3
	private let card: MemoryGame<String>.Card
	
	var body: some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: radius)
			
			if card.isFaceUp {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: lineWidth)
				Text(card.content).font(.largeTitle)
			} else if card.isMatched {
				shape.opacity(0)
			} else {
				shape.fill()
			}
		}
	}
	
	init(_ card: MemoryGame<String>.Card) {
		self.card = card
	}
}



















struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let game = EmojiMemoryGame()
		
		ContentView(viewModel: game)
		
	}
}
