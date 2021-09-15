//
//  Model.swift
//  Model
//
//  Created by Nikita Rossik on 9/14/21.
//

import Foundation

struct Model {
	var emojis: [Emoji] = []
	var background = Background.blank
	
	init() {}
	
	private var uniqEmoji = 0
	mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
		uniqEmoji += 1
		emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqEmoji))
	}
}


extension Model {
	struct Emoji: Identifiable, Hashable {
		let text: String
		var x,y: Int
		var size: Int
		let id: Int
		
		fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
			self.text = text
			self.x = x
			self.y = y
			self.size = size
			self.id = id
		}
	}
}
