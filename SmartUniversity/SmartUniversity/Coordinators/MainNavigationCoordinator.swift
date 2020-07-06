//
//  MainNavigationCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MainNavigationCoordinator: BaseCoordinator {

    let navigationController: NavigationController
    let dependencies: Dependencies

    private(set) var onboardingCoordinator: OnboardingCoordinator? {
        didSet {
            onboardingCoordinator?.delegate = self
        }
    }

    init(navigationController: NavigationController, dependencies: MainNavigationCoordinator.Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        navigationController.pushViewController(
            dependencies.viewControllerFactory.makeViewController(for: .qrScanner(delegate: self))
        )

        if dependencies.appConfigurationProvider.isOnboardingHidden == false {
            initiateOnboarding()
        }
    }

    private func initiateOnboarding() {
        onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator?.start()
    }
}

extension MainNavigationCoordinator: OnboardingCoordinatorDelegate {

    func onboardingCoordinatorDidFinish() {
        self.dependencies.appConfigurationProvider.setDidPassOnboarding()
        self.navigationController.popToRootViewController()
    }

    func onboardingCoordinatorDidSkipOnboarding() {

        let alert = UIAlertController(
            title: "Skip onboarding",
            message: "Skipping... We'll show it at next launch again, so you don't miss the important info.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController.popToRootViewController()
        })

        self.navigationController.present(alert, animated: true)
    }
}

extension MainNavigationCoordinator: QRScannerViewControllerDelegate {

    func qrScannerViewController(
        _ qrScannerViewController: QRScannerViewController,
        didSelectContinueWith qrPoint: QRPoint
    ) {
        let postScanningViewController = ARMapPageViewController(
            arViewController: dependencies.viewControllerFactory.makeViewController(
                for: .arView(roomsData: qrPoint.rooms)
            ),
            muniMapViewController: dependencies.viewControllerFactory.makeViewController(
                for: .munimap(focusedPlaceID: qrPoint.muniMapPlaceID)
            )
        )
        postScanningViewController.didFinishHandler = { [weak self] in
            self?.navigationController.popToRootViewController()
        }
        navigationController.pushViewController(postScanningViewController)
    }
}
