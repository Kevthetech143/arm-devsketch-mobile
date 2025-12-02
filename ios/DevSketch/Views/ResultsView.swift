//
//  ResultsView.swift
//  DevSketch Mobile
//
//  Display detection results and generate code
//  Arm AI Developer Challenge 2025
//

import SwiftUI

struct ResultsView: View {
    let capturedImage: UIImage
    let detections: [DetectionResult]
    let inferenceTime: TimeInterval

    @State private var showCodeGeneration = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Detection overlay on image
                GeometryReader { geometry in
                    ZStack {
                        // Captured image
                        Image(uiImage: capturedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        // Detection overlays
                        ForEach(detections) { detection in
                            DetectionOverlay(
                                detection: detection,
                                imageSize: geometry.size
                            )
                        }
                    }
                }

                // Stats bar
                HStack {
                    Label("\(detections.count) elements", systemImage: "square.3.layers.3d")
                    Spacer()
                    Label("\(String(format: "%.0f", inferenceTime * 1000))ms", systemImage: "bolt.fill")
                    Spacer()
                    Label("On-device", systemImage: "cpu.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))

                // Detection list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(detections) { detection in
                            DetectionRow(detection: detection)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 200)

                // Generate code button
                Button(action: {
                    showCodeGeneration = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("Generate Flutter Code")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Detected Elements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Retry capture
                        dismiss()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCodeGeneration) {
            CodeGenerationView(detections: detections)
        }
    }
}

// Detection overlay box
struct DetectionOverlay: View {
    let detection: DetectionResult
    let imageSize: CGSize

    var body: some View {
        let rect = detection.boundingBoxInView(size: imageSize)

        Rectangle()
            .strokeBorder(colorForElement, lineWidth: 2)
            .background(colorForElement.opacity(0.1))
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
            .overlay(
                Text(detection.label)
                    .font(.caption2)
                    .padding(2)
                    .background(colorForElement)
                    .foregroundColor(.white)
                    .cornerRadius(2)
                    .position(x: rect.midX, y: rect.minY - 10)
            )
    }

    var colorForElement: Color {
        let type = UIElementType.from(cocoLabel: detection.label)
        switch type {
        case .button: return .blue
        case .textField: return .green
        case .label: return .orange
        case .image: return .purple
        case .container: return .gray
        case .unknown: return .gray
        }
    }
}

// Detection list row
struct DetectionRow: View {
    let detection: DetectionResult

    var body: some View {
        HStack {
            Image(systemName: iconForElement)
                .foregroundColor(colorForElement)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(detection.label.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("Confidence: \(String(format: "%.0f", detection.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(UIElementType.from(cocoLabel: detection.label).rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(colorForElement.opacity(0.2))
                .foregroundColor(colorForElement)
                .cornerRadius(4)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }

    var iconForElement: String {
        let type = UIElementType.from(cocoLabel: detection.label)
        switch type {
        case .button: return "button.horizontal.fill"
        case .textField: return "text.cursor"
        case .label: return "textformat"
        case .image: return "photo.fill"
        case .container: return "rectangle.fill"
        case .unknown: return "questionmark.square.fill"
        }
    }

    var colorForElement: Color {
        let type = UIElementType.from(cocoLabel: detection.label)
        switch type {
        case .button: return .blue
        case .textField: return .green
        case .label: return .orange
        case .image: return .purple
        case .container: return .gray
        case .unknown: return .gray
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(
            capturedImage: UIImage(systemName: "photo")!,
            detections: [],
            inferenceTime: 0.085
        )
    }
}
