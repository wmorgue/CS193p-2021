//
//  PaletteChooser.swift
//  PaletteChooser
//
//  Created by Nikita Rossik on 9/17/21.
//

import SwiftUI

struct PaletteChooser: View {
	var emojiFontSize: CGFloat = 40
	var emojiFont: Font { .system(size: emojiFontSize) }
	
	//	@State private var editing = false
	@State private var managing = false
	@State private var chosenPaletteIndex = 0
	@State private var paletteToEdit: Palette?
	@EnvironmentObject var store: PaletteStore
	
	var body: some View {
		HStack {
			paletteButton
			body(for: store.palette(at: chosenPaletteIndex))
		}
		.clipped()
	}
}

struct ScrollingEmojisView: View {
	let emojis: String
	
	internal init(_ emojis: String) {
		self.emojis = emojis
	}
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(emojis.removingDuplicateCharacters.compactMap { String($0) }, id: \.self) { emoji in
					Text(emoji)
						.onDrag { NSItemProvider(object: emoji as NSString) }
				}
			}
		}
	}
}

extension PaletteChooser {
	@ViewBuilder
	var contexMenu: some View {
		// New palette
		AnimatedActionButton(title: "New", systemImage: "plus") {
			store.insertPalette(named: "New palette", emojis: nil, at: chosenPaletteIndex)
			paletteToEdit = store.palette(at: chosenPaletteIndex)
			//			editing.toggle()
		}
		
		// Edit palette
		AnimatedActionButton(title: "Edit", systemImage: "pencil.and.outline") {
			paletteToEdit = store.palette(at: chosenPaletteIndex)
			//			editing.toggle()
		}
		
		// Delete palette
		AnimatedActionButton(title: "Delete", systemImage: "trash") {
			chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
		}
		
		// Palette Manager
		AnimatedActionButton(title: "Manage", systemImage: "slider.horizontal.3") {
			managing.toggle()
		}
		
		// Go to
		gotoMenu
	}
	
	var gotoMenu: some View {
		Menu {
			ForEach(store.palettes) { palette in
				AnimatedActionButton(title: palette.name) {
					if let index = store.palettes.index(matching: palette) {
						chosenPaletteIndex = index
					}
				}
			}
		} label: {
			Label("Go to", systemImage: "menucard")
		}
	}
	
	var paletteButton: some View {
		Button {
			withAnimation {
				chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
			}
		} label: {
			Image(systemName: "paintpalette")
		}
		.font(emojiFont)
		.contextMenu { contexMenu }
	}
	
	var rollTransition: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .offset(x: 0, y: emojiFontSize),
			removal: .offset(x: 0, y: -emojiFontSize)
		)
	}
	
	func body(for palette: Palette) -> some View {
		HStack {
			Text(palette.name)
			ScrollingEmojisView(palette.emojis)
				.font(emojiFont)
		}
		.id(palette.id)
		.transition(rollTransition)
		.sheet(isPresented: $managing) {
			PaletteManager()
		}
		.popover(item: $paletteToEdit) { palette in
			PaletteEditor(palette: $store.palettes[palette])
		}
		//		.popover(isPresented: $editing) {
		//			PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
		//		}
	}
}
