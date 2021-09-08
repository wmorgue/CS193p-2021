//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct MemoryGameView: View {
	
	@State private var isRestarted = false
	@State private var dealt: Set<Int> = []
	@Namespace private var deadlingNamespace
	@ObservedObject var game: EmojiMemoryGame
	
	var body: some View {
		ZStack(alignment: .bottom) {
			VStack {
				gameBody
				HStack {
					restartGame
					Spacer()
					shuffleButton
				}
				.padding(.horizontal)
			}
			deckBody
		}
		.font(.largeTitle)
		.foregroundColor(.primary)
		.padding(.all)
	}
}


extension MemoryGameView {
	private struct CardConst {
		static let color = Color.pink
		static let aspectRatio: CGFloat = 2/2.2
		static let dealDuration: Double = 0.5
		static let totalDeadDuration: Double = 2
		static let undealHeight: CGFloat = 90
		static let undeadWidth = undealHeight * aspectRatio
	}
	
	// MARK: Methods
	private func deal(_ card: EmojiMemoryGame.Card) {
		dealt.insert(card.id)
	}
	
	private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
		!dealt.contains(card.id)
	}
	
	private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
		var delay = 0.0
		if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
			delay = Double(index) * (CardConst.totalDeadDuration / Double(game.cards.count))
		}
		return Animation.easeInOut(duration: CardConst.dealDuration).delay(delay)
	}
	
	private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
		-Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
	}
	
	// MARK: Some Views
	var gameBody: some View {
		AspectVGrid(game.cards, CardConst.aspectRatio) { card in
			if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
				Color.clear
			} else {
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: deadlingNamespace)
					.padding(4)
					.transition(.asymmetric(insertion: .identity, removal: .opacity))
					.zIndex(zIndex(of: card))
					.onTapGesture {
						withAnimation {
							game.choose(card)
						}
					}
			}
		}
		.foregroundColor(CardConst.color)
	}
	
	var deckBody: some View {
		ZStack {
			ForEach(game.cards.filter(isUndealt)) { card in
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: deadlingNamespace)
					.transition(.asymmetric(insertion: .opacity, removal: .identity))
			}
		}
		.frame(width: CardConst.undeadWidth, height: CardConst.undealHeight)
		.foregroundColor(CardConst.color)
		.onTapGesture {
			//"deal" my cards
			for card in game.cards {
				withAnimation(dealAnimation(for: card)) {
					deal(card)
				}
			}
		}
	}
	
	// MARK: Button's
	var shuffleButton: some View {
		Button {
			withAnimation { game.shuffle() }
		} label: {
			Image(systemName: "shuffle")
		}
		.accessibilityLabel("Shuffle cards")
	}
	
	var restartGame: some View {
		Button {
			withAnimation {
				isRestarted.toggle()
				dealt = []
				game.restart()
			}
		} label: {
			Image(systemName: "restart")
				.rotationEffect(.degrees(isRestarted ? 0 : 180))
				.animation(.spring())
		}
		.accessibilityLabel("Restart the game")
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
