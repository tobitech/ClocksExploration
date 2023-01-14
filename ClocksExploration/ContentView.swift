//
//  ContentView.swift
//  ClocksExploration
//
//  Created by Oluwatobi Omotayo on 14/01/2023.
//

import SwiftUI

extension Clock {
	/// Suspends for the given duration
	func sleep(
		for duration: Duration,
		tolerance: Duration? = nil
	) async throws {
		try await self.sleep(until: self.now.advanced(by: duration), tolerance: tolerance)
	}
}

@MainActor
class FeatureModel: ObservableObject {
	@Published var message = ""
	
	let clock: any Clock<Duration>
	
	init(clock: any Clock<Duration>) {
		self.clock = clock
	}
	
	func task() async {
		do {
			// try await Task.sleep(for: .seconds(5))
			try await self.clock.sleep(for: .seconds(5))
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
		ContentView(model: .init(clock: ContinuousClock()))
	}
}
