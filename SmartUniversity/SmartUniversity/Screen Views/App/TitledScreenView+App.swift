//
//  TitledScreenView+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension TitledScreenView {

    convenience init() {
        self.init(layoutProvider: AppLayoutProvider.shared)
    }
}
