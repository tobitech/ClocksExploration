//
//  ClocksExplorationTests.swift
//  ClocksExplorationTests
//
//  Created by Oluwatobi Omotayo on 14/01/2023.
//

@testable import ClocksExploration
import XCTest

@MainActor
final class ClocksExplorationTests: XCTestCase {
	
	func testWelcome() async {
		let model = FeatureModel(clock: ImmediateClock())
		
		XCTAssertEqual(model.message, "")
		await model.task()
		XCTAssertEqual(model.message, "Welcome!")
	}
	
}
