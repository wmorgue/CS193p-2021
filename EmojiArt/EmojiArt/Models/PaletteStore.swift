//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/24/21.
//

import SwiftUI

struct Palette: Identifiable, Codable, Hashable {
	var name: String
	var emojis: String
	let id: Int
	
	fileprivate init(name: String, emojis: String, id: Int) {
		self.name = name
		self.emojis = emojis
		self.id = id
	}
}

final class PaletteStore: ObservableObject {
	/// Name of store, like database name.
	let name: String
	
	/// For UserDefaults key
	private var userDefaultsKey: String { "PaletteStore:" + name }
	
	/// Reactive palette
	@Published var palettes: [Palette] = [] {
		didSet {
			storeInUserDefaults()
		}
	}
	
	init(named name: String) {
		self.name = name
		restoreFromUserDefaults()
		if palettes.isEmpty {
			insertPalette(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
			insertPalette(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
			insertPalette(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
			insertPalette(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
			insertPalette(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
			insertPalette(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
			insertPalette(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪")
			insertPalette(named: "COVID", emojis: "💉🦠😷🤧🤒")
			insertPalette(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠")
		}
	}
	
	private func storeInUserDefaults() -> Void {
		let palettesEncoding = try? JSONEncoder().encode(palettes)
		UserDefaults.standard.set(palettesEncoding, forKey: userDefaultsKey)
	}
	
	private func restoreFromUserDefaults() -> Void {
		if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
			 let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData) {
			// Set palettes to decoded result.
			palettes = decodedPalettes
		}
	}
	
	// MARK: - Intent
	
	func palette(at index: Int) -> Palette {
		let safeIndex: Int = min(max(index, 0), palettes.count - 1)
		return palettes[safeIndex]
	}
	
	@discardableResult
	func removePalette(at index: Int) -> Int {
		if palettes.count > 1, palettes.indices.contains(index) {
			palettes.remove(at: index)
		}
		
		return index % palettes.count
	}
	
	func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
		let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
		let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
		let safeIndex = min(max(index, 0), palettes.count)
		palettes.insert(palette, at: safeIndex)
	}
}

