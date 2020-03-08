//
//  ARSceneDependencyProviderTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 08/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
@testable import SmartUniversity

class ARSceneDependencyProviderTests: XCTestCase {

    var provider: ARSceneDependencyProvider!

    override func setUp() {
        provider = ARSceneDependencyProvider()
    }

    func testIsRootViewControllerARViewController() {
        let expectedViewControllerType = ARViewController.self

        XCTAssertTrue(expectedViewControllerType == type(of: provider.makeRootViewController()))
    }

}