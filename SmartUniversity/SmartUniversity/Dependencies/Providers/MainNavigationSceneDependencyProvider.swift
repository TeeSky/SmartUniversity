//
//  MainNavigationSceneDependencyProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MainNavigationSceneDependencyProvider: SceneDependencyProviding {

    var sceneHandler: WindowSceneHandling?

    private lazy var munimapServerURL: URL = {
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    func makeRootViewController() -> UIViewController {
        MainNavigationViewController(controllers: [
            makeTabBarMunimapViewController(),
            makeTabBarARViewController()
        ])
    }

    private func makeTabBarMunimapViewController() -> UIViewController {
        let controller = MunimapViewController(
            munimapServerURL: munimapServerURL,
            webViewHandler: WebViewHandler.shared
        )
        controller.tabBarItem = UITabBarItem(title: "MUNIMap", image: UIImage(systemName: "map"), tag: 0)

        return controller
    }

    private func makeTabBarARViewController() -> UIViewController {
        let controller = ARViewController()
        controller.tabBarItem = UITabBarItem(title: "AR View", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1)

        return controller
    }
}
