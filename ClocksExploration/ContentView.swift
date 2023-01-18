import SwiftUI

public struct ImmediateClock: Clock {
	public func sleep(until deadline: Instant, tolerance: Duration?) async throws { /* Do nothing since we want the work to happen immediately */ }
	
	public var now = Instant() // Instant that corresponds to zero offset
	
	public var minimumResolution = Duration.zero // Duration that corresponds to zero duration
	
	public typealias Duration = Swift.Duration
	
	public struct Instant: InstantProtocol {
		private var offset: Duration = .zero
		
		public func advanced(by duration: Duration) -> Self  {
			.init(offset: self.offset + duration)
		}
		
		public func duration(to other: Self) -> Duration {
			other.offset - self.offset
		}
		
		public typealias Duration = Swift.Duration
		
		public static func < (lhs: Self, rhs: Self) -> Bool {
			lhs.offset < rhs.offset
		}
	}
}

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
		ContentView(model: .init(clock: ImmediateClock()))
	}
}
