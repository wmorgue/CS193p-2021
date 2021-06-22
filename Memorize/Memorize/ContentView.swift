//
//  ContentView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct ContentView: View {
	let humans: [String] = ["😵‍💫", "😛", "👩🏼‍💻", "🥷🏿"]

	var body: some View {
		HStack {
			ForEach(humans, id: \.self) { human in
				CardView(emojis: human)
					.padding(.all)
					.foregroundColor(.pink)
			}
		}
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
					shape.stroke(lineWidth: 3)
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
