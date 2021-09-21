//
//  EmojiDocument.swift
//  EmojiDocument
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

/// Reactive emoji document class.
class EmojiDocument: ObservableObject {
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus: FetchStatus = .idle
    
    @Published private(set) var emojiArt: Model {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    init() { emojiArt = Model() }
    
    /// Return emojis from `Model`.
    /// Syntax sugar.
    var emojis: [Model.Emoji] { emojiArt.emojis }
    
    /// Return backgrounds from `Model`.
    /// Syntax sugar.
    var backgrounds: Model.Background { emojiArt.background }
    
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
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break // Do nothing
        }
    }
    
    
    //MARK: FetchStatus
    enum FetchStatus {
        case idle
        case fetching
    }
    
    //MARK: Intent(s)
    
    /// Set background.
    func setBackground(_ background: Model.Background) {
        emojiArt.background = background
        print("Set a background: \(background)")
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
