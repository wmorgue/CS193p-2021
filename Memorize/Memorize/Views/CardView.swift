//
//  CardView.swift
//  Memorize
//
//  Created by Nikita Rossik on 8/21/21.
//

import SwiftUI

struct CardView: View {
	private let card: EmojiMemoryGame.Card

	init(_ card: EmojiMemoryGame.Card) { self.card = card }
	
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				let shape = RoundedRectangle(cornerRadius: Const.radius)
				
				if card.isFaceUp {
					shape.fill().foregroundColor(.white)
					shape.strokeBorder(lineWidth: Const.lineWidth)
					Pie(startAngle: Const.startAngle, endAngle: Const.endAngle).padding(5).opacity(0.4)
					Text(card.content).font(Const.geometryFont(proxy.size))
				} else if card.isMatched {
					shape.opacity(0)
				} else {
					shape.fill()
				}
			}
		}
	}
}

extension CardView {
	struct Const {
		static let radius: CGFloat = 10
		static let lineWidth: CGFloat = 3
		static let startAngle: Angle = .degrees(0-90)
		static let endAngle: Angle = .degrees(110-90)
		static let geometryFont: (CGSize) -> Font = { size in
			Font.system(size: min(size.width, size.height) * 0.75)
		}
	}
}


//struct CardView_Previews: PreviewProvider {
//
//	static var previews: some View {
//		let card = EmojiMemoryGame()
//		card.choose(card.cards.first!)
//		return CardView(card)
//	}
//}
