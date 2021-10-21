//
//  DocumentView.swift
//  EmojiArt
//
//  Created by Nikita Rossik on 9/14/21.
//

import SwiftUI

struct DocumentView: View {
	@SceneStorage("DocumentView.steadyZoomScale")
	private var steadyZoomScale: CGFloat = 1
	@SceneStorage("DocumentView.steadyPanOffset")
	private var steadyPanOffset: CGSize = .zero
	
	@State private var autoZoom = false
	@State private var alertToShow: IdentifiableAlert?
	@State private var backgroundPicker: BackgroundPickerType?
	@GestureState private var magnifyBy: CGFloat = 1
	@GestureState private var gesturePanOffset: CGSize = .zero
	@ObservedObject var document: EmojiDocument
	@Environment(\.undoManager) var undoManager
	
	@ScaledMetric var defaultFontSize: CGFloat = 42
	private var zoomScale: CGFloat { steadyZoomScale * magnifyBy }
	private var panOffset: CGSize {
		(steadyPanOffset + gesturePanOffset) * zoomScale
	}
	
	
	var body: some View {
		VStack(spacing: 0) {
			documentBody
			paletteChooser
		}
	}
	
	//MARK: Document body
	var documentBody: some View {
		GeometryReader { proxy in
			ZStack {
				Color.white
				OptionalImage(uiImage: document.backgroundImage)
					.scaleEffect(zoomScale)
					.position(convertFromEmojiCoordinates((0,0), in: proxy))
					.gesture(doubleTapToZoom(in: proxy.size))
				
				if document.backgroundImageFetchStatus == .fetching {
					ProgressView()
						.scaleEffect(2)
				} else {
					ForEach(document.emojis) { emoji in
						Text(emoji.text)
							.font(.system(size: fontSize(for: emoji)))
							.scaleEffect(zoomScale)
							.position(position(for: emoji, in: proxy))
					}
				}
			}
			.clipped()
			.onDrop(of: [.utf8PlainText, .url, .image], isTargeted: nil) { provider, location in
				dropOnView(provider: provider, at: location, in: proxy)
			}
			.gesture(panGesture().simultaneously(with: zoomGesture()))
			.alert(item: $alertToShow) { alert in
				alert.alert()
			}
			.onChange(of: document.backgroundImageFetchStatus) { status in
				switch status {
					case .failed(let url): showBackgroundImageFetchFailedAlet(url)
					default: break
				}
			}
			.onReceive(document.$backgroundImage) { image in
				if autoZoom {
					zoomToFit(image, in: proxy.size)
				}
			}
			.compactableToolbar {
				AnimatedActionButton(title: "Paste Background", systemImage: "doc.on.clipboard") {
					pasteBackgroundImage()
				}
				
				if Camera.isAvailable {
					AnimatedActionButton(title: "Take Photo", systemImage: "camera") {
						backgroundPicker = .camera
					}
				}
				
				if PhotoLibrary.isAvailable {
					AnimatedActionButton(title: "Search Photos", systemImage: "photo") {
						backgroundPicker = .library
					}
				}
				
#if os(iOS)
				if let undoManager = undoManager {
					if undoManager.canUndo {
						AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.backward") {
							undoManager.undo()
						}
					}
					
					if undoManager.canRedo {
						AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.forward") {
							undoManager.redo()
						}
					}
				}
#endif
				// TODO: Make this working!
				//				guard let undoManager = undoManager else { return nil }
				//
				//				switch undoManager {
				//					case .canUndo:
				//						AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.backward") {
				//							undoManager.undo()
				//						}
				//					case .canRedo:
				//						AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.forward") {
				//							undoManager.redo()
				//						}
				//				}
			}
			.sheet(item: $backgroundPicker) { pickerType in
				switch pickerType {
					case .camera: Camera(handlePickedImage: { image in handlePickedBackgroundImage(image) })
					case .library: PhotoLibrary(handlePickedImage: { photo in handlePickedBackgroundImage(photo) })
				}
			}
		}
	}
	
	
	//MARK: Palette on bottom with button
	var paletteChooser: some View {
		PaletteChooser()
#if os(iOS)
			.padding(.top)
			.background(.thinMaterial)
#endif
	}
}


extension DocumentView {
	enum BackgroundPickerType: Identifiable {
		var id: BackgroundPickerType { self }
		case camera
		case library
	}
	
	private func handlePickedBackgroundImage(_ image: UIImage?) {
		autoZoom = true
		if let imageData = image?.imageData {
			document.setBackground(.imageData(imageData), undoManager: undoManager)
		}
		backgroundPicker = nil
	}
	
	//MARK: Methods
	private func dropOnView(provider: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
		var found = provider.loadObjects(ofType: URL.self) { url in
			autoZoom = true
			document.setBackground(.url(url.imageURL), undoManager: undoManager)
		}
		
#if os(iOS)
		if !found {
			found = provider.loadObjects(ofType: UIImage .self) { image in
				if let data = image.jpegData(compressionQuality: 1.0) {
					autoZoom = true
					document.setBackground(.imageData(data), undoManager: undoManager)
				}
			}
		}
#endif
		
		if !found {
			found = provider.loadObjects(ofType: String.self) { string in
				if let emoji = string.first, emoji.isEmoji {
					document.addEmoji(
						String(emoji),
						at: convertToEmojiCoordinate(location, in: geometry),
						size: defaultFontSize / zoomScale,
						undoManager: undoManager
					)
				}
			}
		}
		
		return found
	}
	
	private func position(for emoji: Model.Emoji, in geometry: GeometryProxy) -> CGPoint {
		convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
	}
	
	private func convertToEmojiCoordinate(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
		let center = geometry.frame(in: .local).center
		
		let location = CGPoint(
			x: (location.x - panOffset.width - center.x) / zoomScale,
			y: (location.y - panOffset.height - center.y) / zoomScale
		)
		
		return (Int(location.x), Int(location.y))
		
	}
	
	private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
		let center = geometry.frame(in: .local).center
		
		return CGPoint(
			x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
			y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
		)
	}
	
	private func zoomToFit(_ image: UIImage?, in size: CGSize) {
		if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
			// Horizontal and vertival direction's
			let hZoom = size.width / image.size.width
			let vZoom = size.height / image.size.height
			steadyPanOffset = .zero
			steadyZoomScale = min(hZoom, vZoom)
		}
	}
	
	//MARK: Gestures method's
	private func zoomGesture() -> some Gesture {
		MagnificationGesture()
			.updating($magnifyBy) { currentState, gestureState, _ in
				gestureState = currentState
			}
			.onEnded { gestureScaleEnd in
				steadyZoomScale *= gestureScaleEnd
			}
	}
	
	private func doubleTapToZoom(in size: CGSize) -> some Gesture {
		TapGesture(count: 2)
			.onEnded {
				withAnimation {
					zoomToFit(document.backgroundImage, in: size)
				}
			}
	}
	
	private func panGesture() -> some Gesture {
		DragGesture()
			.updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
				gesturePanOffset = latestDragGestureValue.translation / zoomScale
			}
			.onEnded { finalDragGestureValue in
				steadyPanOffset = steadyPanOffset + (finalDragGestureValue.translation / zoomScale)
			}
	}
	
	private func fontSize(for emoji: Model.Emoji) -> CGFloat {
		CGFloat(emoji.size)
	}
	
	// Alert when background image doesn't loading
	private func showBackgroundImageFetchFailedAlet(_ url: URL) {
		alertToShow = IdentifiableAlert(id: "fetch failed: " + url.absoluteString, alert: {
			Alert(
				title: Text("Failed to loading image"),
				message: Text("Failed to fetch image from: \(url)"),
				dismissButton: .cancel())
		})
	}
	
	// Pasteboard logic to set background from Image or URL
	private func pasteBackgroundImage() {
		autoZoom = true
		
		if let imageData = Pasteboard.imageData {
			document.setBackground(.imageData(imageData), undoManager: undoManager)
		} else if let url = Pasteboard.url {
			document.setBackground(.url(url), undoManager: undoManager)
		} else {
			alertToShow = IdentifiableAlert(
				title: "Paste background",
				message: "There is no image currently on pasteboard.")
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		DocumentView(document: EmojiDocument())
			.previewDisplayName("Document")
			.preferredColorScheme(.light)
	}
}
