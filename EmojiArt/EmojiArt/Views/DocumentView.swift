//
//  DocumentView.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

struct DocumentView: View {
	@ObservedObject var document: EmojiDocument
	
	var body: some View {
		VStack(spacing: 0) {
			documentBody
			palette
		}
	}
	
	var documentBody: some View {
		Color.pink
	}
	
	var palette: some View {
		ScrollingPaletteView(emojis: testEmojis)
	}
	
	private let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
}

struct ScrollingPaletteView: View {
	let emojis: String
	
	var paletteButton: some View {
		Button(action: {}, label: {
			Image(systemName: "paintpalette")
		})
	}
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				paletteButton
				ForEach(emojis.compactMap { String($0) }, id: \.self) { emoji in
					Text(emoji)
				}
			}
			.font(.system(size: 42))
		}
		.padding(.top)
		.background(.thinMaterial)
	}
}






struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		DocumentView(document: EmojiDocument())
	}
}
