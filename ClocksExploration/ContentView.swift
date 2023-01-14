//
//  ContentView.swift
//  ClocksExploration
//
//  Created by Oluwatobi Omotayo on 14/01/2023.
//

import SwiftUI

@MainActor
class FeatureModel: ObservableObject {
	@Published var message = ""
	
	init(message: String = "") {
		self.message = message
	}
	
	func task() async {
		do {
			try await Task.sleep(for: .seconds(5))
			withAnimation {
				self.message = "Welcome!"
			}
		} catch {}
	}
}

struct ContentView: View {
	
	@ObservedObject var model: FeatureModel
	
	var body: some View {
		VStack {
			
			Text(self.model.message)
				.font(.title)
				.foregroundColor(.mint)
		}
		.task { await self.model.task() }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(model: .init())
	}
}
