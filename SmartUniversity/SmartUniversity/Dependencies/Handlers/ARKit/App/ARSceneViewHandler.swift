//
//  ARSceneViewHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import ARKit

final class ARSceneViewHandler: NSObject, ARSceneViewHandling {

    weak var delegate: ARSceneViewHandlerDelegate?

    var referenceImages: Set<ARReferenceImage> {
        didSet { setupAndRunSceneSession() }
    }

    private var sceneView: ARSCNView?

    private let sessionRunOptions: ARSession.RunOptions

    init(
        referenceImages: Set<ARReferenceImage> = Set(),
        sessionRunOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
    ) {
        self.referenceImages = referenceImages
        self.sessionRunOptions = sessionRunOptions
    }

    func handleViewDidLoad(_ view: UIView) {
        guard var sceneContainerView = view as? ARSceneContainerView else { return }

        let sceneView = ARSCNView()
        sceneView.delegate = self

        sceneContainerView.arSceneView = sceneView
        self.sceneView = sceneView
    }

    func handleViewWillAppear(_ view: UIView) {
        setupAndRunSceneSession()
    }

    func handleViewWillDisappear(_ view: UIView) {
        pauseSceneSession()
    }

    private func setupAndRunSceneSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        sceneView?.session.run(configuration, options: sessionRunOptions)
    }

    private func pauseSceneSession() {
        sceneView?.session.pause()
    }
}

extension ARSceneViewHandler: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        delegate?.arSceneViewHandler(self, didDetectReferenceImage: imageAnchor, onNode: node)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        delegate?.arSceneViewHandlerWillUpdate(self, sceneView: sceneView)
    }
}
