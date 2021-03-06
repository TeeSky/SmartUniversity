//
//  CornerTapView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 14/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class CornerTapView: VerticalFrameBasedView {

    struct Content {
        let icon: UIImage?

        let text: String
        let textSize: CGFloat
        let alignment: NSTextAlignment
    }

    // MARK: - Property overrides

    override var insets: UIEdgeInsets {
        layoutProvider.contentInsets(for: self, respectingSafeAreasOn: [.bottom])
    }

    override var insetAgnosticSubviews: [UIView] { [backgroundView] }

    override var backgroundColor: UIColor? {
        get { backgroundConfiguration.color }
        set {
            guard let backgroundColor = newValue else { return }
            backgroundConfiguration = Self.makeBackgroundConfiguration(with: backgroundColor)
        }
    }

    override var tintColor: UIColor? {
        get { super.tintColor }
        set {
            guard let tintColor = newValue else { return }

            super.tintColor = tintColor
            iconView.image = iconView.image?.withTintColor(tintColor)
        }
    }

    // MARK: - Delegate

    var tapHandler: (() -> Void)?

    // MARK: - Configuration

    var content: Content {
        didSet { configure(with: content) }
    }

    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    var preferredWidth: CGFloat {
        let leftMostView = frames(forWidth: .greatestFiniteMagnitude).max(by: { $0.frame.maxX < $1.frame.maxX })
        return (leftMostView?.frame ?? .zero).maxX
    }

    // MARK: - View spacing

    private lazy var contentSpacing = layoutProvider.contentSpacing

    // MARK: - Subviews

    private lazy var iconView = UIImageView()

    private var backgroundView: GradientView {
        willSet { backgroundView.removeFromSuperview() }
        didSet { insertSubview(backgroundView, at: 0) }
    }

    private var label: UILabel

    // MARK: - Background configuration

    private var backgroundConfiguration: GradientView.Configuration {
        didSet { backgroundView = GradientView(configuration: backgroundConfiguration) }
    }

    // MARK: - Dependencies

    private let colorProvider: ColorProviding
    private let layoutProvider: LayoutProviding

    // MARK: - Inits

    init(content: Content, colorProvider: ColorProviding, layoutProvider: LayoutProviding) {
        self.content = content

        self.colorProvider = colorProvider
        self.layoutProvider = layoutProvider

        label = Self.makeLabel(with: content, colorProvider: colorProvider)

        backgroundConfiguration = Self.makeBackgroundConfiguration(with: colorProvider.overlayColor)
        backgroundView = GradientView(configuration: backgroundConfiguration)

        super.init(frame: .zero)

        configure(with: content)
        configureTapDelegate(with: #selector(viewTapped))

        addSubviews(backgroundView, label, iconView)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Layouting

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {
        let contentMaxWidth = width - insets.horizontalSum

        let iconSize = CGSize(width: 60, height: 60)
        let labelSize = label.size(constrainedToWidth: contentMaxWidth)

        let contentWidth = max(iconSize.width, labelSize.width)
        let contentHeight = iconSize.height + contentSpacing + labelSize.height

        let iconViewFrame = CGRect(x: insets.left + (contentWidth - iconSize.width) / 2, y: insets.top, size: iconSize)

        let labelFrame = CGRect(
            x: insets.left + (contentWidth - labelSize.width) / 2,
            y: iconViewFrame.maxY + contentSpacing,
            size: labelSize
        )

        let backgroundFrame = CGRect(
            origin: .zero,
            width: contentWidth + insets.horizontalSum,
            height: contentHeight + insets.verticalSum
        )

        return [(iconView, iconViewFrame), (label, labelFrame), (backgroundView, backgroundFrame)]
    }

    // MARK: - Handling

    @objc private func viewTapped() {
        tapHandler?()
    }

    // MARK: - Delegate configuration

    private func configureTapDelegate(with selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }

    // MARK: - Helpers - Configuration

    private func configure(with content: Content) {
        label = Self.makeLabel(with: content, colorProvider: colorProvider)
        iconView.image = content.icon
    }

    // MARK: - Helpers - Factories

    private static func makeLabel(with content: Content, colorProvider: ColorProviding) -> UILabel {
        let label = UILabel(
            font: .boldSystemFont(ofSize: content.textSize),
            textColor: colorProvider.textColor,
            numberOfLines: 0
        )
        label.text = content.text
        label.textAlignment = content.alignment
        return label
    }

    private static func makeBackgroundConfiguration(with overlayColor: UIColor) -> GradientView.Configuration {
        .init(color: overlayColor, axis: .vertical(locations: [0.2, 0.9, 1.0], upToDown: false))
    }
}
