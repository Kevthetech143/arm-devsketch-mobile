//
//  CameraView.swift
//  DevSketch Mobile
//
//  Camera capture interface for sketch photography
//  Arm AI Developer Challenge 2025
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraService = CameraService()
    @State private var capturedImage: UIImage?
    @State private var showProcessing = false

    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(session: cameraService.session)
                .ignoresSafeArea()

            // Overlay UI
            VStack {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                    }

                    Spacer()

                    Text("Capture Sketch")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 3)

                    Spacer()

                    // Placeholder for symmetry
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .opacity(0)
                }
                .padding()

                Spacer()

                // Instructions
                VStack(spacing: 10) {
                    Text("Position your UI sketch in frame")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .shadow(radius: 3)

                    Text("Ensure good lighting and clear visibility")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 3)
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 30)

                Spacer()

                // Capture Button
                Button(action: {
                    capturePhoto()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)

                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 85, height: 85)
                    }
                }
                .padding(.bottom, 40)
            }

            // Processing Overlay
            if showProcessing {
                ProcessingView()
            }
        }
        .onAppear {
            cameraService.checkPermissions()
        }
    }

    private func capturePhoto() {
        // TODO: Implement actual photo capture
        showProcessing = true

        // Simulate processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Placeholder: would capture actual photo here
            showProcessing = false
            // Navigate to results view
        }
    }
}

// Camera Preview using AVFoundation
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

// Processing indicator
struct ProcessingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)

                Text("Processing with Arm AI...")
                    .foregroundColor(.white)
                    .font(.headline)

                Text("On-device • No cloud")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.caption)
            }
            .padding(40)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
