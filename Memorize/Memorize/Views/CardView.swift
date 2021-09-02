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
				Pie(startAngle: Const.startAngle, endAngle: Const.endAngle)
					.padding(5)
					.opacity(0.4)
				Text(card.content)
					.rotationEffect(Angle.degrees(card.isMatched ? 360 : 0)) 
					.animation(Animation.linear.repeatForever(autoreverses: false))
					.font(.system(size: Const.fontSize))
					.scaleEffect(scale(thatFits: proxy.size))
			}
			.cardify(isFaceUp: card.isFaceUp)
		}
	}
}

extension CardView {
	private func scale(thatFits size: CGSize) -> CGFloat {
		min(size.width, size.height) / (Const.fontSize / Const.fontScale)
	}
	
	struct Const {
		static let fontSize: CGFloat = 32
		static let fontScale: CGFloat = 0.7
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
