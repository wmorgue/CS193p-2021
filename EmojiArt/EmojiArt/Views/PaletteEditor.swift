//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/30/21.
//

import SwiftUI

struct PaletteEditor: View {
	@Binding var palette: Palette
	@State private var emptyBinding = ""
	
	var body: some View {
		List {
			Section("Name") {
				TextField("Name", text: $palette.name, prompt: Text("Type a new name for palette"))
			}
			Section("Add emoji") {
				TextField("", text: $emptyBinding, prompt: Text("Insert a new emoji"))
					.onChange(of: emptyBinding) { emojis in
						insertNewEmojis(emojis)
					}
			}
			Section("Delete emoji") {
				let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
				
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
					ForEach(emojis, id: \.self) { emoji in
						Text(emoji)
							.onTapGesture {
								withAnimation {
									palette.emojis.removeAll(where: { String($0) == emoji })
								}
							}
							.font(.system(size: 40))
					}
				}
			}
		}
		.navigationTitle("Edit \(palette.name)")
		.frame(minWidth: 350, minHeight: 400)
	}
	
	func insertNewEmojis(_ emojis: String) {
		withAnimation {
			palette.emojis = (emojis + palette.emojis).filter { $0.isEmoji }.removingDuplicateCharacters
		}
	}
}

struct PaletteEditor_Previews: PreviewProvider {
	static var previews: some View {
		let flora = PaletteStore(named: "Flora Preview").palette(at: 3)
		let animal = PaletteStore(named: "Animal Preview").palette(at: 4)
		
		Group {
			PaletteEditor(palette: .constant(flora))
				.previewDisplayName("Flora")
				.previewLayout(.fixed(width: 350.0, height: 400.0))
			PaletteEditor(palette: .constant(animal))
				.previewDisplayName("Animal")
				.previewLayout(.fixed(width: 350.0, height: 400.0))
		}
	}
}
