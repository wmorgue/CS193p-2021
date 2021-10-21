//
//  iOS.swift
//  EmojiArt (iOS)
//
//  Created by Nikita Rossik on 10/21/21.
//

import SwiftUI


struct Pasteboard {
	static var url: URL? { UIPasteboard.general.url?.imageURL }
	static var imageData: Data? { UIPasteboard.general.image?.imageData }
}

extension UIImage {
	var imageData: Data? { jpegData(compressionQuality: 1.0) }
}

extension View {
	func popoverPadding() -> some View { self }

	func paletteControlButtonStyle() -> some View { self }
	
	@ViewBuilder
	func wrappedNavigationViewDismiss(_ dismiss: Closure?) -> some View {
		let userInterface = UIDevice.current.userInterfaceIdiom
		
		switch userInterface {
			case .phone: NavigationView {
				self
					.navigationBarTitleDisplayMode(.inline)
					.dismissable(dismiss)
				
			}
			.navigationViewStyle(.stack)
			default: self
		}
	}
	
	@ViewBuilder
	func dismissable(_ dismiss: Closure?) -> some View {
		let userInterface = UIDevice.current.userInterfaceIdiom
		
		switch userInterface {
			case .phone:
				self.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Close") { dismiss!() }
					}
					
				}
			default: self
		}
	}
}
