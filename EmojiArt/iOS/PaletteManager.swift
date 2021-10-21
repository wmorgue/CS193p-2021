//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 10/1/21.
//

import SwiftUI

struct PaletteManager: View {
	@EnvironmentObject var store: PaletteStore
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.dismiss) var dismiss
	@State private var editMode: EditMode = .inactive
	
	var body: some View {
		NavigationView {
			List {
				ForEach(store.palettes) { palette in
					NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
						VStack(alignment: .leading) {
							Text(palette.name)
								.fontWeight(colorScheme == .dark ? .thin : .light)
							Text(palette.emojis)
						}
						.gesture(editMode == .active ? tap : nil)
					}
				}
				.onDelete { indexSet in
					store.palettes.remove(atOffsets: indexSet)
				}
				.onMove { indexSet, newOffset in
					store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
				}
			}
			.navigationTitle("Manage Palettes")
			.navigationBarTitleDisplayMode(.inline)
			.dismissable { dismiss() }
			.toolbar {
				ToolbarItem { EditButton() }
			}
			.environment(\.editMode, $editMode)
		}
	}
}

extension PaletteManager {
	var tap: some Gesture {
		TapGesture()
			.onEnded {}
	}
}

struct PaletteManager_Previews: PreviewProvider {
	static var previews: some View {
		let preview = PaletteStore(named: "Preview")
		
		PaletteManager()
			.environmentObject(preview)
			.previewInterfaceOrientation(.landscapeLeft)
		
	}
}
