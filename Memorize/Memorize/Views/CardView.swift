//
//  CardView.swift
//  Memorize
//
//  Created by Nikita Rossik on 8/21/21.
//

import SwiftUI

struct CardView: View {
	private let card: EmojiMemoryGame.Card
	private let radius: CGFloat = 25
	private let lineWidth: CGFloat = 3
	private let geometryFont: (CGSize) -> Font = { size in
		Font.system(size: min(size.width, size.height) * 0.8)
	}
	
	init(_ card: EmojiMemoryGame.Card) { self.card = card }
	
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				let shape = RoundedRectangle(cornerRadius: radius)
				
				if card.isFaceUp {
					shape.fill().foregroundColor(.white)
					shape.strokeBorder(lineWidth: lineWidth)
					Text(card.content).font(geometryFont(proxy.size))
				} else if card.isMatched {
					shape.opacity(0)
				} else {
					shape.fill()
				}
			}
		}
	}
}


//struct CardView_Previews: PreviewProvider {
//
//	static var previews: some View {
//		let card = EmojiMemoryGame.Card(content: "🏔", id: 1)
//		CardView(card)
//	}
//}
