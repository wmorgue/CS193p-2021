//
//  Cardify.swift
//  Cardify
//
//  Created by Nikita Rossik on 9/1/21.
//

import SwiftUI


struct Cardify: ViewModifier {
	var isFaceUp: Bool
	
	func body(content: Content) -> some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: Const.radius)
			
			if isFaceUp {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: Const.lineWidth)
			} else {
				shape.fill()
			}
			content
				.opacity(isFaceUp ? 1 : 0)
		}
	}
}

extension Cardify {
	struct Const {
		static let radius: CGFloat = 10
		static let lineWidth: CGFloat = 3
	}
}

extension View {
	func cardify(isFaceUp: Bool) -> some View {
		self.modifier(Cardify(isFaceUp: isFaceUp))
	}
}
