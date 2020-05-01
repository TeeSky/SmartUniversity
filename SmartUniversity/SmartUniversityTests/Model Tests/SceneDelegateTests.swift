//
//  SceneDelegateTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 08/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private final class IdentifiableWindow: UIWindow, Identifiable {

    let id = UUID()

    var didReceiveMakeKeyAndVisible: Bool?

    override func makeKeyAndVisible() {
        super.makeKeyAndVisible()

        didReceiveMakeKeyAndVisible = true
    }
}

private final class IdentifiableViewController: UIViewController, Identifiable {

    let id = UUID()
}

private final class TestableSceneHandler: WindowSceneHandling {

    var didReceiveWindowWillBecomeVisible: Bool?
    var wasWindowMadeKeyAndVisibleOnWillBecomeVisible: Bool?

    var didReceiveWindowDidBecomeVisible: Bool?
    var wasWindowMadeKeyAndVisibleOnDidBecomeVisible: Bool?

    func windowWillBecomeVisible(_ window: UIWindow) {
        didReceiveWindowWillBecomeVisible = true

        guard let window = window as? IdentifiableWindow else {
            fatalError("Unexpected test window input type, expected IdentifiableWindow.")
        }
        wasWindowMadeKeyAndVisibleOnWillBecomeVisible = window.didReceiveMakeKeyAndVisible == true
    }

    func windowDidBecomeVisible(_ window: UIWindow) {
        didReceiveWindowDidBecomeVisible = true

        guard let window = window as? IdentifiableWindow else {
            fatalError("Unexpected test window input type, expected IdentifiableWindow.")
        }
        wasWindowMadeKeyAndVisibleOnDidBecomeVisible = window.didReceiveMakeKeyAndVisible == true
    }

}

private struct FakeSceneDependencyProvider: SceneDependencyProviding {

    let rootViewController = IdentifiableViewController()
    var sceneHandler: WindowSceneHandling? = TestableSceneHandler()

    func makeRootViewController() -> UIViewController { rootViewController }

}

final class SceneDelegateTests: XCTestCase {

    private var delegate: SceneDelegate<FakeSceneDependencyProvider>!

    override func setUp() {
        delegate = SceneDelegate()
    }

    func testHasCorrectDependencyProviderType() {
        let expectedDependencyProviderType = FakeSceneDependencyProvider.self

        XCTAssertTrue(expectedDependencyProviderType == type(of: delegate.dependencyProvider))
    }

    func testIsWindowEqualWithWindowDidLoadParameter() {
        let expectedWindow = makeWindow()

        delegate.windowDidLoad(expectedWindow)

        XCTAssertEqual(expectedWindow, delegate.window)
    }

    func testIsWindowViewControllerEqualToDependencyProviderRootViewController() {
        let expectedWindow = makeWindow()
        let expectedViewContollerID = delegate.dependencyProvider.rootViewController.id

        delegate.windowDidLoad(expectedWindow)

        XCTAssertEqual(expectedViewContollerID, (expectedWindow.rootViewController as! IdentifiableViewController).id)
    }

    func testDoesCallWindowSceneHandlerOnWindowDidLoadCorrectly() {
        let expectedWindow = makeWindow()

        delegate.windowDidLoad(expectedWindow)

        let sceneHandler = delegate.dependencyProvider.sceneHandler as! TestableSceneHandler

        XCTAssertTrue(sceneHandler.didReceiveWindowWillBecomeVisible!)
        XCTAssertFalse(sceneHandler.wasWindowMadeKeyAndVisibleOnWillBecomeVisible!)

        XCTAssertTrue(sceneHandler.didReceiveWindowDidBecomeVisible!)
        XCTAssertTrue(sceneHandler.wasWindowMadeKeyAndVisibleOnDidBecomeVisible!)
    }

    private func makeWindow() -> UIWindow { IdentifiableWindow(frame: .zero) }
}
