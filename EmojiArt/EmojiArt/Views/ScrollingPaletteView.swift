//
//  ScrollingPaletteView.swift
//  ScrollingPaletteView
//
//  Created by Nikita Rossik on 9/17/21.
//

import SwiftUI

struct ScrollingPaletteView: View {
	let emojis: String
	
	var paletteButton: some View {
		Button(action: {}, label: {
			Image(systemName: "paintpalette")
		})
	}
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				paletteButton
				ForEach(emojis.compactMap { String($0) }, id: \.self) { emoji in
					Text(emoji)
						.onDrag { NSItemProvider(object: emoji as NSString) }
				}
			}
		}
	}
}
