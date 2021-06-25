//
//  ContentView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct ContentView: View {
	private var columns: [GridItem] = [
		.init(.adaptive(minimum: 100, maximum: 120))
	]

	@State var humansCounter = 6
	@State var humans: [String] = ["😵‍💫", "😛", "👩🏼‍💻", "🥷🏿", "🐈", "🦔", "✈️"]

	var body: some View {
		VStack(spacing: 25) {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(humans[0...humansCounter], id: \.self) { human in
						CardView(emojis: human)
							.aspectRatio(contentMode: .fit)
					}
				}
				.foregroundColor(.pink)
			}

			Spacer()

			HStack {
				removeCard
				Spacer()
				shuffleEmoji
				Spacer()
				addCard
			}
			.font(.largeTitle)
			.padding(.horizontal )

		}
		.padding(.all)
	}
}


extension ContentView {
	private var removeCard: some View {
		Button { humansCounter -= 1 } label: {
			Image(systemName: "minus.circle")
		}
		.disabled(humansCounter < 2)
	}

	private var addCard: some View {
		Button { humansCounter += 1 } label: {
			Image(systemName: "plus.circle")
		}
	}

	private var shuffleEmoji: some View {
		Button("Shuffle") { humans.shuffle() }
	}
}


struct CardView: View {
	let emojis: String
	@State var isFaceUp: Bool = false

	var body: some View {

		ZStack {
			let shape = RoundedRectangle(cornerRadius: 25.0)

			switch isFaceUp {
				case true:
					shape.fill().foregroundColor(.white)
					shape.strokeBorder(lineWidth: 3)
					Text(emojis).font(.largeTitle)
				case false:
					shape.fill()
			}
		}
		.onTapGesture {
			isFaceUp.toggle()
		}
	}
}



















struct ContentView_Previews: PreviewProvider {
	static var previews: some View { ContentView() }
}
