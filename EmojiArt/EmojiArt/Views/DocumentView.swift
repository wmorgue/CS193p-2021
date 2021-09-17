//
//  DocumentView.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

struct DocumentView: View {
	private let defaultFontSize: CGFloat = 42
	@ObservedObject var document: EmojiDocument
	
	var body: some View {
		VStack(spacing: 0) {
			documentBody
			palette
		}
	}
	
	//MARK: Document body
	var documentBody: some View {
		GeometryReader { proxy in
			ZStack {
				Color.white
				ForEach(document.emojis) { emoji in
					Text(emoji.text)
						.font(.system(size: fontSize(for: emoji)))
						.position(position(for: emoji, in: proxy))
				}
			}
			.onDrop(of: [.plainText], isTargeted: nil) { provider, location in
				dropOnView(provider: provider, at: location, in: proxy)
			}
		}
	}
	
	//MARK: Palette on bottom with button
	var palette: some View {
		ScrollingPaletteView(emojis: testEmojis)
			.font(.system(size: defaultFontSize))
			.padding(.top)
			.background(.thinMaterial)
	}
	
	
	//MARK: Some random test emojis
	private let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
	
	
	//MARK: Methods
	private func dropOnView(provider: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
		return provider.loadObjects(ofType: String.self) { string in
			if let emoji = string.first, emoji.isEmoji {
				document.addEmoji(
					String(emoji),
					at: convertToEmojiCoordinate(location, in: geometry),
					size: defaultFontSize
				)
			}
		}
	}
	
	private func position(for emoji: Model.Emoji, in geometry: GeometryProxy) -> CGPoint {
		convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
	}
	
	private func convertToEmojiCoordinate(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
		let center = geometry.frame(in: .local).center
		
		let location = CGPoint(
			x: location.x - center.x,
			y: location.y - center.y
		)
		
		return (Int(location.x), Int(location.y))
		
	}
	
	private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
		let center = geometry.frame(in: .local).center
		
		return CGPoint(
			x: center.x + CGFloat(location.x),
			y: center.y + CGFloat(location.y)
		)
	}
	
	private func fontSize(for emoji: Model.Emoji) -> CGFloat {
		CGFloat(emoji.size)
	}
}



struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		DocumentView(document: EmojiDocument())
			.previewDisplayName("Document")
			.preferredColorScheme(.light)
	}
}
