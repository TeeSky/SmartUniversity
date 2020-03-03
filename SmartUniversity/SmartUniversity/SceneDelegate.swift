//
//  SceneDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 01/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol SceneDependencyProviding {

    var sceneHandler: WindowSceneHandling? { get }

    init()

    func makeRootViewController() -> UIViewController // CR0: Consider property? Benefit to explicitness of make?
}

protocol WindowSceneHandling {

    func windowWillBecomeVisible(_ window: UIWindow)

    func windowDidBecomeVisible(_ window: UIWindow)
}

final class SceneDelegate<DependencyProvider: SceneDependencyProviding>: UIResponder, UIWindowSceneDelegate {

    let dependencyProvider = DependencyProvider()

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = dependencyProvider.makeRootViewController()

        dependencyProvider.sceneHandler?.windowWillBecomeVisible(window)
        window.makeKeyAndVisible()
        dependencyProvider.sceneHandler?.windowDidBecomeVisible(window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see
        // `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}