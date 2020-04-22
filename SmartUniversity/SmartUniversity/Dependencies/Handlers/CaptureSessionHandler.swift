//
//  CaptureSessionHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation
import UIKit

protocol CaptureSessionHandling {

    var delegate: CaptureSessionHandlerDelegate? { get set }

    func handleViewDidLoad(_ view: UIView)
    func handleViewWillAppear(_ view: UIView)
    func handleViewWillDisappear(_ view: UIView)
}

final class CaptureSessionHandler: NSObject, CaptureSessionHandling {

    weak var delegate: CaptureSessionHandlerDelegate?

    private(set) var captureSession: AVCaptureSession?
    private(set) var previewLayer: AVCaptureVideoPreviewLayer?

    private let deviceProvider: CaptureDeviceProviding
    private let sessionProvider: CaptureSessionProviding

    init(
        deviceProvider: CaptureDeviceProviding = CaptureDeviceProvider.shared,
        sessionProvider: CaptureSessionProviding = CaptureSessionProvider.shared
    ) {
        self.deviceProvider = deviceProvider
        self.sessionProvider = sessionProvider
    }

    // MARK: - CaptureSessionHandling

    func handleViewDidLoad(_ view: UIView) {
        let captureSession = sessionProvider.makeCaptureSession()

        guard let sessionInput = makeVideoDeviceInput(for: captureSession) else {
            return handleSessionError(.videoInputUnavailable)
        }
        captureSession.addInput(sessionInput)

        guard let sessionOutput = makeSessionMetadataOutput(for: captureSession) else {
            return handleSessionError(.metadataOutputUnavailable)
        }
        captureSession.addOutput(sessionOutput)

        if sessionOutput.availableMetadataObjectTypes.contains(.qr) {
            sessionOutput.metadataObjectTypes = [.qr]
            sessionOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            return handleSessionError(.metadataOutputUnavailable)
        }

        self.captureSession = captureSession
    }

    func handleViewWillAppear(_ view: UIView) {
        guard let captureSession = captureSession else { return }

        if captureSession.isRunning == false {
            DispatchQueue.main.async {
                captureSession.startRunning()
            }
        }

        let previewLayer = makeVideoPreviewLayer(for: captureSession, captureView: view)
        self.previewLayer = previewLayer

        delegate?.captureSessionHandler(self, didLoadPreviewLayer: previewLayer)
    }

    func handleViewWillDisappear(_ view: UIView) {
        guard let captureSession = captureSession else { return }

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    // MARK: - Capture Session Component Factories

    private func makeVideoDeviceInput(for session: AVCaptureSession) -> AVCaptureDeviceInput? {

        guard let videoCaptureDevice = deviceProvider.videoCaptureDevice else { return nil }

        let captureDeviceInput: AVCaptureDeviceInput?
        do { captureDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice) } catch { return nil }

        if let videoInput = captureDeviceInput, session.canAddInput(videoInput) {
            return videoInput
        } else { return nil }
    }

    private func makeSessionMetadataOutput(for session: AVCaptureSession) -> AVCaptureMetadataOutput? {
        let metadataOutput = AVCaptureMetadataOutput()

        guard session.canAddOutput(metadataOutput) else { return nil }
        return metadataOutput
    }

    private func makeVideoPreviewLayer(
        for session: AVCaptureSession,
        captureView: UIView
    ) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = captureView.layer.bounds

        return previewLayer
    }

    // MARK: - Helpers

    private func handleSessionError(_ error: CaptureSessionError) {
        captureSession = nil

        delegate?.captureSessionHandler(self, didTriggerError: error)
    }
}

extension CaptureSessionHandler: AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard
            let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        else { return }

        guard
            let previewLayer = previewLayer,
            let codeObject = previewLayer.transformedMetadataObject(for: metadataObject)
        else { return }

        delegate?.captureSessionHandler(
            self,
            didReceiveValidOutput: stringValue,
            fromObjectWithBounds: codeObject.bounds
        )
    }
}
