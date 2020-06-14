//
//  OnboardingScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class OnboardingScreenView: FrameBasedView {

    var titleText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var bodyText: String? {
        get { bodyLabel.text }
        set { bodyLabel.text = newValue }
    }

    var buttonText: String? {
        get { nextButton.titleLabel?.text }
        set { nextButton.setTitle(newValue, for: .normal) }
    }

    var didTapNextHandler: (() -> Void)? {
        willSet {
            nextButton.removeTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        }
        didSet {
            guard didTapNextHandler != nil else { return }

            nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        }
    }

    var didTapSkipHandler: (() -> Void)? {
        willSet {
            skipButton.removeTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        }
        didSet {
            guard didTapSkipHandler != nil else { return }

            skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        }
    }

    private let insets = UIEdgeInsets(horizontal: 15, vertical: 20)

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    private lazy var titleLabel = UILabel(
        font: .boldSystemFont(ofSize: 45),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )
    private lazy var bodyLabel = UILabel(
        font: .systemFont(ofSize: 22),
        textColor: colorProvider.textColor,
        numberOfLines: 0
    )
    private lazy var skipButton = UIButton(
        style: .transparent,
        titleText: "Skip",
        backgroundColor: colorProvider.backgroundColor
    )
    private lazy var nextButton = UIButton(titleText: "Next", backgroundColor: .lightGray)

    init(colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        var frames: [(UIView, CGRect)] = []

        let contentWidth = bounds.width - insets.horizontalSum
        let contentVerticalSpacing: CGFloat = 10

        let skipButtonSize = skipButton.size(constrainedToWidth: contentWidth)
        let skipButtonFrame = CGRect(
            x: bounds.width - insets.right - skipButtonSize.width,
            y: safeAreaInsets.top + insets.top,
            size: skipButtonSize
        )
        frames.append((skipButton, skipButtonFrame))

        let titleWidth = contentWidth - skipButtonFrame.width
        let titleLabelFrame = CGRect(
            x: insets.left,
            y: safeAreaInsets.top + insets.top,
            width: titleWidth,
            height: titleLabel.height(constrainedToWidth: titleWidth)
        )
        frames.append((titleLabel, titleLabelFrame))

        let bodyLabelHeight = bodyLabel.height(constrainedToWidth: contentWidth)
        let bodyLabelFrame = CGRect(
            x: insets.left,
            y: max((bounds.height - bodyLabelHeight) / 2, titleLabelFrame.maxY + contentVerticalSpacing),
            width: contentWidth,
            height: bodyLabelHeight
        )
        frames.append((bodyLabel, bodyLabelFrame))

        let nextButtonSize = layoutProvider.preferredSize(for: nextButton)
        let nextButtonFrame = CGRect(
            x: bounds.width - insets.right - nextButtonSize.width,
            y: bounds.height - (safeAreaInsets.bottom + insets.bottom + nextButtonSize.height),
            size: nextButtonSize
        )
        frames.append((nextButton, nextButtonFrame))

        return frames
    }

    func configure(withTitleText titleText: String, bodyText: String) {
        titleLabel.text = titleText
        bodyLabel.text = bodyText

        backgroundColor = colorProvider.backgroundColor
    }

    @objc private func nextTapped() {
        didTapNextHandler?()
    }

    @objc private func skipTapped() {
        didTapSkipHandler?()
    }
}

extension OnboardingScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(skipButton)
        addSubview(bodyLabel)
        addSubview(nextButton)
    }
}
