//
//  Model.swift
//  Model
//
//  Created by Nikita Rossik on 9/14/21.
//

import Foundation

struct Model: Codable {
	var emojis: [Emoji] = []
	var background = Background.blank
	
	/// Empty init.
	init() {}
	
	/// Init model with URL and throw it to JSON.
	init(url: URL) throws {
		let data = try Data(contentsOf: url)
		self = try Model(json: data)
	}
	
	/// Init model with JSON.
	init(json: Data) throws {
		self = try JSONDecoder().decode(Model.self, from: json)
	}
	
	/// Encode out model to JSON output.
	func json() throws -> Data {
		try JSONEncoder().encode(self)
	}
	
	private var uniqEmoji = 0
	mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
		uniqEmoji += 1
		emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqEmoji))
	}
}


extension Model {
	struct Emoji: Identifiable, Hashable, Codable {
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
