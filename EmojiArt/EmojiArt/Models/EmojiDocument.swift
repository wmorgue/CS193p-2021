//
//  EmojiDocument.swift
//  EmojiDocument
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

/// Reactive emoji document class.
class EmojiDocument: ObservableObject {
	@Published private(set) var emojiArt: Model
	
	init() {
		emojiArt = Model()
		emojiArt.addEmoji("", at: (x: 0, y: 0), size: 68)
	}
	
	/// Return emojis from `Model`.
	/// Syntax sugar.
	var emojis: [Model.Emoji] { emojiArt.emojis }
	
	/// Return backgrounds from `Model`.
	/// Syntax sugar.
	var backgrounds: Model.Background { emojiArt.background }
	
	
	//MARK: Intent(s)
	
	/// Set background.
	func setBackground(_ background: Model.Background) {
		emojiArt.background = background
	}
	
	/// Adding a new Emoji.
	func addEmoji(_ text: String, at location: (x: Int, y: Int), size: CGFloat) {
		emojiArt.addEmoji(text, at: location, size: Int(size))
	}
	
	/// Move emoji on screen
	func moveEmoji(_ emoji: Model.Emoji, by offset: CGSize) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			emojiArt.emojis[index].x += Int(offset.width)
			emojiArt.emojis[index].y += Int(offset.height)
		}
	}
	
	func scaleEmoji(_ emoji: Model.Emoji, by scale: CGFloat) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
		}
	}
}
