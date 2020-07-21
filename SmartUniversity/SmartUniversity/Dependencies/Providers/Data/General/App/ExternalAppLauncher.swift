//
//  ExternalAppLauncher.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

struct ExternalAppLauncher: ExternalAppLaunching {

    func launchSettings(completion: (() -> Void)?) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return}

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl) { _ in
                completion?()
            }
        }
    }
}
