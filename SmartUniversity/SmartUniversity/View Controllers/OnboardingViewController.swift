//
//  OnboardingViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {

    func onboardingViewControllerDidSelectNext(_ viewController: OnboardingViewController)

    func onboardingViewControllerDidSelectSkip(_ viewController: OnboardingViewController)
}

class OnboardingViewController: BaseViewController<OnboardingScreenView> {
    typealias ActionCompletion = () -> Void
    typealias Action = (OnboardingViewController, @escaping ActionCompletion) -> Void

    weak var delegate: OnboardingViewControllerDelegate?

    var action: Action?

    var titleText: String {
        didSet { screenView?.titleText = titleText }
    }

    var bodyText: String {
        didSet { screenView?.bodyText = bodyText }
    }

    private let isFinal: Bool

    init(titleText: String, bodyText: String, isFinal: Bool) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.isFinal = isFinal

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.configure(withTitleText: titleText, bodyText: bodyText, asFinal: isFinal)

        screenView?.didTapNextHandler = { [unowned self] in

            if let action = self.action {
                let actionCompletion = {
                    DispatchQueue.main.async { self.delegate?.onboardingViewControllerDidSelectNext(self) }
                }

                action(self, actionCompletion)
            } else {
                self.delegate?.onboardingViewControllerDidSelectNext(self)
            }
        }
        screenView?.didTapSkipHandler = { [unowned self] in
            self.delegate?.onboardingViewControllerDidSelectSkip(self)
        }
    }
}
