//
//  MunimapViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

final class MunimapViewController: BaseViewController<MunimapScreenView> {

    let munimapServerURL: URL
    var webViewHandler: WebViewHandling

    init(munimapServerURL: URL, webViewHandler: WebViewHandling) {
        self.munimapServerURL = munimapServerURL
        self.webViewHandler = webViewHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewHandler.webView = screenView?.webView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        webViewHandler.loadURL(munimapServerURL)
    }
}