//
//  Cardify.swift
//  Cardify
//
//  Created by Nikita Rossik on 9/1/21.
//

import SwiftUI


struct Cardify: AnimatableModifier {

	/// In degrees
	var rotation: Double
	var animatableData: Double {
		get { rotation }
		set { rotation = newValue }
	}
	
	init(isFaceUp: Bool) {
		rotation = isFaceUp ? 0 : 180
	}
	
	func body(content: Content) -> some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: Const.radius)
			
			if rotation < 90 {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: Const.lineWidth)
			} else {
				shape.fill()
			}
			content
				.opacity(rotation < 90 ? 1 : 0)
		}
		.rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
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
