//
//  CameraService.swift
//  DevSketch Mobile
//
//  Camera capture and AVFoundation integration
//  Arm AI Developer Challenge 2025
//

import AVFoundation
import UIKit
import SwiftUI

class CameraService: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var isAuthorized = false
    @Published var capturedImage: UIImage?

    private var photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?

    override init() {
        super.init()
    }

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.isAuthorized = true
                        self?.setupCaptureSession()
                    }
                }
            }
        case .denied, .restricted:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }

    private func setupCaptureSession() {
        session.beginConfiguration()

        // Set session preset for quality
        session.sessionPreset = .photo

        // Setup video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                         for: .video,
                                                         position: .back) else {
            session.commitConfiguration()
            return
        }

        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }

            // Setup photo output
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                photoOutput.isHighResolutionCaptureEnabled = true
            }

            session.commitConfiguration()

            // Start session on background thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
            session.commitConfiguration()
        }
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let photoSettings = AVCapturePhotoSettings()

        // Enable high resolution capture
        photoSettings.isHighResolutionPhotoEnabled = true

        // Set quality
        if let photoFormat = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoFormat]
        }

        // Capture the photo
        photoOutput.capturePhoto(with: photoSettings, delegate: self)

        // Store completion handler
        self.photoCaptureCompletion = completion
    }

    private var photoCaptureCompletion: ((UIImage?) -> Void)?

    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.stopRunning()
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            photoCaptureCompletion?(nil)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            photoCaptureCompletion?(nil)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
            self?.photoCaptureCompletion?(image)
        }
    }
}
