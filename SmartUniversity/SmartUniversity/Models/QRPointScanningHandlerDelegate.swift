//
//  QRPointScanningHandlerDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

protocol QRPointScanningHandlerDelegate: AnyObject {

    func qrPointScanningHandler(
        _ handler: QRPointScanningHandler,
        didFetchQRPoint qrPoint: QRPoint,
        forScannedValue value: String
    )

    func qrPointScanningHandler(_ handler: QRPointScanningHandler, couldNotFetchQRPointForScannedValue value: String)
}
