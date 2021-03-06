//
//  UIEdgeInsets+init.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    // MARK: - Singular

    init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }

    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }

    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }

    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }

    // MARK: - Axis groups

    init(horizontal: CGFloat) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }

    init(vertical: CGFloat) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    // MARK: - Mixed axis and singular

    init(left: CGFloat, right: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: left, bottom: vertical, right: right)
    }

    init(top: CGFloat, bottom: CGFloat, horizontal: CGFloat) {
        self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
    }

    // MARK: - All

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
}
