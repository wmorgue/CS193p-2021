//
//  EmojiDocument.swift
//  EmojiDocument
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

/// Reactive emoji document class.
final class EmojiDocument: ObservableObject {
	@Published var backgroundImage: UIImage?
	@Published var backgroundImageFetchStatus: FetchStatus = .idle
	
	@Published private(set) var emojiArt: Model {
		didSet {
			scheduleAutoSave()
			if emojiArt.background != oldValue.background {
				fetchBackgroundImageDataIfNecessary()
			}
		}
	}
	
	init() {
		if let url = Autosave.url, let autoSavedEmoji = try? Model(url: url) {
			emojiArt = autoSavedEmoji
			fetchBackgroundImageDataIfNecessary()
		} else {
			emojiArt = Model()
		}
	}
	
	/// Return emojis from `Model`.
	/// Syntax sugar.
	var emojis: [Model.Emoji] { emojiArt.emojis }
	
	/// Return backgrounds from `Model`.
	/// Syntax sugar.
	var backgrounds: Model.Background { emojiArt.background }
	
	private var autoSaveTimer: Timer?
	
	//MARK: - Intent(s)
	
	private func save(to url: URL) {
		let thisFunc = "\(String(describing: self)).\(#function) at \(#line)"
		
		do {
			let data: Data = try emojiArt.json()
			print("Debug data: ", String(data: data, encoding: .utf8) ?? "nil")
			try data.write(to: url)
		} catch let encodingError where encodingError is EncodingError {
			print(thisFunc, "Couldn't encode Model as JSON 'cause: \(encodingError.localizedDescription)")
		} catch {
			print(thisFunc, error.localizedDescription)
		}
	}
	
	private func autoSave() {
		if let url = Autosave.url {
			save(to: url)
		}
	}
	
	private func scheduleAutoSave() {
		autoSaveTimer?.invalidate()
		autoSaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
			self.autoSave()
		}
	}
	
	/// Fetch Background Image Data async
	private func fetchBackgroundImageDataIfNecessary() {
		backgroundImage = nil
		
		switch emojiArt.background {
			case .url(let url):
				backgroundImageFetchStatus = .fetching
				
				DispatchQueue.global(qos: .userInitiated).async {
					let imageData = try? Data(contentsOf: url)
					DispatchQueue.main.async { [weak self] in
						if self?.emojiArt.background == Model.Background.url(url) {
							
							self?.backgroundImageFetchStatus = .idle
							if imageData != nil {
								self?.backgroundImage = UIImage(data: imageData!)
							}
							if self?.backgroundImage == nil {
								self?.backgroundImageFetchStatus = .failed(url)
							}
						}
					}
				}
			case .imageData(let data):
				backgroundImage = UIImage(data: data)
			case .blank:
				break // Do nothing
		}
	}
	
	/// Set background.
	func setBackground(_ background: Model.Background) {
		emojiArt.background = background
		
#if DEBUG
		print("Set a background: \(background)")
#endif
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
	
	/// Scale emoji index size
	func scaleEmoji(_ emoji: Model.Emoji, by scale: CGFloat) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
		}
	}
}


extension EmojiDocument {
	//MARK: - FetchStatus
	enum FetchStatus: Equatable {
		case idle
		case fetching
		case failed(URL)
	}
	
	private struct Autosave {
		static let filename = "Autosave.emojiart"
		static var url: URL? {
			// For iOS we always use a `.userDomainMask`.
			// In macOS it will be `.network` or other.
			let document: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
			return document?.appendingPathComponent(filename)
		}
		static let coalescingInterval: Double = 5
	}
}
