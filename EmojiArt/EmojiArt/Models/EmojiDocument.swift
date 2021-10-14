//
//  EmojiDocument.swift
//  EmojiDocument
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

/// Reactive emoji document class.
final class EmojiDocument: ReferenceFileDocument {
	static var readableContentTypes = [UTType.emojiArt]
	static var writeableContentTypes = [UTType.emojiArt]
	
	init() {
		emojiArt = Model()
	}
	
	init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents {
			emojiArt = try Model(json: data)
			fetchBackgroundImageDataIfNecessary()
		} else {
			throw CocoaError(.fileReadCorruptFile)
		}
	}
	
	@Published var backgroundImage: UIImage?
	@Published var backgroundImageFetchStatus: FetchStatus = .idle
	
	@Published private(set) var emojiArt: Model {
		didSet {
			if emojiArt.background != oldValue.background {
				fetchBackgroundImageDataIfNecessary()
			}
		}
	}
	
	
	func snapshot(contentType: UTType) throws -> Data { try emojiArt.json() }
	func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: snapshot) }
	
	
	/// Return emojis from `Model`.
	/// Syntax sugar.
	var emojis: [Model.Emoji] { emojiArt.emojis }
	
	/// Return backgrounds from `Model`.
	/// Syntax sugar.
	var backgrounds: Model.Background { emojiArt.background }
	
	private var backgroundImageCancellable: AnyCancellable?
	
	//MARK: - Intent(s)
	
	/// Fetch Background Image Data async
	private func fetchBackgroundImageDataIfNecessary() {
		backgroundImage = nil
		
		switch emojiArt.background {
			case .url(let url):
				// Set fetching status and cancel previos long-lag D'n'D transaction's
				backgroundImageFetchStatus = .fetching
				backgroundImageCancellable?.cancel()
				
				// Then create a new session
				let session = URLSession.shared
				let publisher = session
					.dataTaskPublisher(for: url)
					.map{ (data, _) in UIImage(data: data) }
					.replaceError(with: nil)
					.receive(on: DispatchQueue.main)
				
				backgroundImageCancellable = publisher
					.sink { [weak self] image in
						self?.backgroundImage = image
						self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
					}
			case .imageData(let data):
				backgroundImage = UIImage(data: data)
			case .blank:
				break // Do nothing
		}
	}
	
	/// Set background.
	func setBackground(_ background: Model.Background, undoManager: UndoManager?) {
		undoablyPerform(operation: "Set background", with: undoManager) {
			emojiArt.background = background
			
			#if DEBUG
			print("Set a background: \(background)")
			#endif
		}
	}
	
	/// Adding a new Emoji.
	func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
		undoablyPerform(operation: "Add \(emoji)", with: undoManager) {
			emojiArt.addEmoji(emoji, at: location, size: Int(size))
		}
	}
	
	/// Move emoji on screen
	func moveEmoji(_ emoji: Model.Emoji, by offset: CGSize, undoManager: UndoManager?) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			undoablyPerform(operation: "Move", with: undoManager) {
				emojiArt.emojis[index].x += Int(offset.width)
				emojiArt.emojis[index].y += Int(offset.height)
			}
		}
	}
	
	/// Scale emoji index size
	func scaleEmoji(_ emoji: Model.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			undoablyPerform(operation: "Scale", with: undoManager) {
				emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
			}
		}
	}
	
	//MARK: - Undo
	private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
		let oldEmojiState = emojiArt
		doit()
		undoManager?.registerUndo(withTarget: self) { myself in
			myself.undoablyPerform(operation: operation, with: undoManager) {
				myself.emojiArt = oldEmojiState
			}
		}
		undoManager?.setActionName(operation)
	}
}


extension EmojiDocument {
	//MARK: - FetchStatus
	enum FetchStatus: Equatable {
		case idle
		case fetching
		case failed(URL)
	}
}


extension UTType {
	static let emojiArt = UTType(exportedAs: "com.nikita.EmojiArt.application")
}
