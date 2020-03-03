//
//  ARScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class ARScreenView: UIView, BaseScreenView {

    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Smart University developer!"

        return label
    }()

    func setupSubviews() {
        addSubview(testLabel)
    }

}
