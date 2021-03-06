//
//  LayoutProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

enum LayoutSide {
    case top
    case left
    case bottom
    case right
}

enum SizeClass {
    case small
    case normal
    case large
}

protocol LayoutProviding {

    var contentSpacing: CGFloat { get }

    func contentInsets(
        for view: UIView,
        size: SizeClass,
        respectingSafeAreasOn safeAreaSides: Set<LayoutSide>
    ) -> UIEdgeInsets

    func preferredSize(for button: UIButton) -> CGSize

    func textSize(_ sizeClass: SizeClass) -> CGFloat
}

extension LayoutProviding {

    // MARK: - Convenience

    func contentInsets(
        for view: UIView,
        size: SizeClass = .normal,
        respectingSafeAreasOn safeAreaSides: Set<LayoutSide> = []
    ) -> UIEdgeInsets {
        contentInsets(for: view, size: .normal, respectingSafeAreasOn: safeAreaSides)
    }

    // MARK: - Helpers

    func safeAreaInsets(
        for view: UIView,
        respectingSafeAreasOn safeAreaRespectingSides: Set<LayoutSide> = []
    ) -> UIEdgeInsets {
        let actualSafeAreaInsets = rootSuperview(for: view).safeAreaInsets

        var respectedSafeAreaInsets = UIEdgeInsets.zero
        safeAreaRespectingSides.forEach { side in
            let additionalInsets: UIEdgeInsets
            switch side {
                case .top:      additionalInsets = .init(top: actualSafeAreaInsets.top)
                case .left:     additionalInsets = .init(left: actualSafeAreaInsets.left)
                case .bottom:   additionalInsets = .init(bottom: actualSafeAreaInsets.bottom)
                case .right:    additionalInsets = .init(right: actualSafeAreaInsets.right)
            }
            respectedSafeAreaInsets = respectedSafeAreaInsets.merged(with: additionalInsets)
        }
        return respectedSafeAreaInsets
    }

    private func rootSuperview(for view: UIView) -> UIView {
        var rootSuperview = view
        while let superview = rootSuperview.superview {
            rootSuperview = superview
        }
        return rootSuperview
    }
}

extension Set where Element == LayoutSide {

    static func all() -> Self {
        [.top, .left, .bottom, .right]
    }
}
