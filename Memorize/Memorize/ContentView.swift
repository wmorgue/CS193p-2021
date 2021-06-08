//
//  ContentView.swift
//  Memorize
//
//  Created by Nikita Rossik on 5/31/21.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		ZStack {
			Text("Hello, CS193p!")

			RoundedRectangle(cornerRadius: 25.0)
				.stroke(lineWidth: 3)
				.frame(width: 200, height: 200, alignment: .center)
		}
		.padding(.all)
		.foregroundColor(.pink)
	}
}






















struct ContentView_Previews: PreviewProvider {
	static var previews: some View { ContentView() }
}
