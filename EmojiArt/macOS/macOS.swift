//
//  macOS.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 10/21/21.
//

import SwiftUI

typealias UIImage = NSImage
typealias PaletteManager = EmptyView
typealias Camera = CantDoItPhotoPicker
typealias PhotoLibrary = CantDoItPhotoPicker


struct CantDoItPhotoPicker: View {
	static let isAvailable = false
	var handlePickedImage: (UIImage?) -> Void
	
	var body: some View {
		EmptyView()
	}
}

struct Pasteboard {
	// Scary old NS-world
	static var url: URL? { (NSURL(from: NSPasteboard.general) as URL?)?.imageURL }
	static var imageData: Data? { NSPasteboard.general.data(forType: .tiff) }
}

extension Image {
	init(uiImage: UIImage) {
		self.init(nsImage: uiImage)
	}
}

extension UIImage {
	var imageData: Data? { tiffRepresentation }
}

extension View {
	@ViewBuilder
	func wrappedNavigationViewDismiss(_ dismiss: Closure?) -> some View { self }
	
	func paletteControlButtonStyle() -> some View {
		self
			.buttonStyle(PlainButtonStyle())
			.foregroundColor(.accentColor)
	}
	
	func popoverPadding() -> some View {
		self
			.padding(.horizontal)
	}
}
