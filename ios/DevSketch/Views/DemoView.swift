//
//  DemoView.swift
//  DevSketch Mobile
//
//  Demo mode for testing AI inference without camera
//  Generates a sample sketch programmatically for simulator testing
//

import SwiftUI

struct DemoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var mlService = MLInferenceService()
    @State private var sampleSketch: UIImage?
    @State private var showResults = false
    @State private var isProcessing = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Demo Mode")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Test AI inference with a sample sketch")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                // Sample Sketch Display
                if let sketch = sampleSketch {
                    VStack {
                        Image(uiImage: sketch)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 400)
                            .border(Color.gray.opacity(0.3), width: 1)
                            .cornerRadius(12)

                        Text("Sample Login Form Sketch")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack {
                        ProgressView()
                        Text("Generating sample sketch...")
                            .font(.caption)
                    }
                }

                Spacer()

                // Model Status
                HStack {
                    Circle()
                        .fill(mlService.isModelLoaded ? Color.green : Color.orange)
                        .frame(width: 10, height: 10)
                    Text(mlService.isModelLoaded ? "YOLOv8 Model Ready" : "Loading Model...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Action Button
                Button(action: runInference) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "cpu.fill")
                        }
                        Text(isProcessing ? "Processing..." : "Run AI Detection")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mlService.isModelLoaded ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!mlService.isModelLoaded || isProcessing)
                .padding(.horizontal)

                // Results count
                if !mlService.detections.isEmpty {
                    Text("Detected \(mlService.detections.count) elements in \(String(format: "%.0f", mlService.inferenceTime * 1000))ms")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            generateSampleSketch()
        }
        .fullScreenCover(isPresented: $showResults) {
            if let sketch = sampleSketch {
                ResultsView(
                    capturedImage: sketch,
                    detections: mlService.detections,
                    inferenceTime: mlService.inferenceTime
                )
            }
        }
    }

    /// Generate a simple login form sketch programmatically
    private func generateSampleSketch() {
        let size = CGSize(width: 375, height: 667)

        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // White background
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        // Black stroke for drawing
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(3.0)

        // Draw a simple login form sketch

        // 1. Logo placeholder (circle at top)
        let logoRect = CGRect(x: 137, y: 50, width: 100, height: 100)
        context.strokeEllipse(in: logoRect)
        drawCenteredText("LOGO", in: logoRect, context: context)

        // 2. "Welcome" text area
        let welcomeRect = CGRect(x: 87, y: 180, width: 200, height: 40)
        context.stroke(welcomeRect)
        drawCenteredText("Welcome Back", in: welcomeRect, context: context)

        // 3. Email text field
        let emailRect = CGRect(x: 40, y: 260, width: 295, height: 50)
        context.stroke(emailRect)
        drawLeftText("Email", in: emailRect, context: context)

        // 4. Password text field
        let passwordRect = CGRect(x: 40, y: 330, width: 295, height: 50)
        context.stroke(passwordRect)
        drawLeftText("Password", in: passwordRect, context: context)

        // 5. Sign In button (filled)
        let signInRect = CGRect(x: 40, y: 420, width: 295, height: 55)
        context.setFillColor(UIColor.black.cgColor)
        context.fill(signInRect)
        context.setFillColor(UIColor.white.cgColor)
        drawCenteredText("SIGN IN", in: signInRect, context: context, color: .white)

        // 6. "Forgot Password?" text
        let forgotRect = CGRect(x: 100, y: 495, width: 175, height: 30)
        context.setFillColor(UIColor.black.cgColor)
        drawCenteredText("Forgot Password?", in: forgotRect, context: context)

        // 7. Create Account button (outlined)
        context.setStrokeColor(UIColor.black.cgColor)
        let createRect = CGRect(x: 40, y: 550, width: 295, height: 55)
        context.stroke(createRect)
        drawCenteredText("CREATE ACCOUNT", in: createRect, context: context)

        sampleSketch = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func drawCenteredText(_ text: String, in rect: CGRect, context: CGContext, color: UIColor = .black) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]

        let textRect = CGRect(
            x: rect.origin.x,
            y: rect.origin.y + (rect.height - 20) / 2,
            width: rect.width,
            height: 20
        )

        (text as NSString).draw(in: textRect, withAttributes: attrs)
    }

    private func drawLeftText(_ text: String, in rect: CGRect, context: CGContext) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ]

        let textRect = CGRect(
            x: rect.origin.x + 10,
            y: rect.origin.y + (rect.height - 18) / 2,
            width: rect.width - 20,
            height: 18
        )

        (text as NSString).draw(in: textRect, withAttributes: attrs)
    }

    private func runInference() {
        guard let sketch = sampleSketch else { return }

        isProcessing = true
        mlService.detectUIElements(in: sketch)

        // Wait for inference to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isProcessing = false
            showResults = true
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
