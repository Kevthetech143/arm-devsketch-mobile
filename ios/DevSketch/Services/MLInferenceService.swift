//
//  MLInferenceService.swift
//  DevSketch Mobile
//
//  Core ML inference service for UI element detection
//  Optimized for Arm Neural Engine
//  Arm AI Developer Challenge 2025
//

import CoreML
import Vision
import UIKit

/// UI Element types from VINS dataset (12 classes)
enum UIElementType: String, CaseIterable {
    case backgroundImage = "BackgroundImage"
    case checkedTextView = "CheckedTextView"
    case icon = "Icon"
    case editText = "EditText"
    case image = "Image"
    case text = "Text"
    case textButton = "TextButton"
    case drawer = "Drawer"
    case pageIndicator = "PageIndicator"
    case upperTaskBar = "UpperTaskBar"
    case modal = "Modal"
    case switchControl = "Switch"
    case unknown = "unknown"

    /// Map VINS detection labels to UI element types
    static func from(vinsLabel: String) -> UIElementType {
        switch vinsLabel {
        case "BackgroundImage": return .backgroundImage
        case "CheckedTextView": return .checkedTextView
        case "Icon": return .icon
        case "EditText": return .editText
        case "Image": return .image
        case "Text": return .text
        case "TextButton": return .textButton
        case "Drawer": return .drawer
        case "PageIndicator": return .pageIndicator
        case "UpperTaskBar": return .upperTaskBar
        case "Modal": return .modal
        case "Switch": return .switchControl
        default: return .unknown
        }
    }

    /// Human-readable display name
    var displayName: String {
        switch self {
        case .backgroundImage: return "Background"
        case .checkedTextView: return "Checkbox"
        case .icon: return "Icon"
        case .editText: return "Text Input"
        case .image: return "Image"
        case .text: return "Text"
        case .textButton: return "Button"
        case .drawer: return "Menu"
        case .pageIndicator: return "Page Dots"
        case .upperTaskBar: return "Status Bar"
        case .modal: return "Dialog"
        case .switchControl: return "Toggle"
        case .unknown: return "Unknown"
        }
    }
}

/// Result of UI element detection
struct DetectionResult: Identifiable {
    let id = UUID()
    let type: UIElementType
    let label: String
    let confidence: Float
    let boundingBox: CGRect  // Normalized coordinates (0-1)

    /// Convert bounding box to view coordinates
    func boundingBoxInView(size: CGSize) -> CGRect {
        // Vision uses bottom-left origin, convert to top-left
        let x = boundingBox.origin.x * size.width
        let y = (1 - boundingBox.origin.y - boundingBox.height) * size.height
        let width = boundingBox.width * size.width
        let height = boundingBox.height * size.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

/// Core ML inference service for detecting UI elements
class MLInferenceService: ObservableObject {
    @Published var isModelLoaded = false
    @Published var isProcessing = false
    @Published var detections: [DetectionResult] = []
    @Published var inferenceTime: TimeInterval = 0

    private var vnModel: VNCoreMLModel?
    private var request: VNCoreMLRequest?

    init() {
        loadModel()
    }

    /// Load the YOLOv8 Core ML model
    private func loadModel() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                // Configure model for optimal Arm performance
                let config = MLModelConfiguration()
                config.computeUnits = .all  // Use Neural Engine + GPU + CPU

                // Load custom UI detector model (trained on VINS dataset)
                let modelURL: URL? = Bundle.main.url(
                    forResource: "ui_detector",
                    withExtension: "mlpackage"
                ) ?? Bundle.main.url(
                    forResource: "ui_detector",
                    withExtension: "mlmodelc"
                )

                guard let modelURL = modelURL else {
                    print("Error: Model file not found in bundle (checked .mlpackage and .mlmodelc)")
                    return
                }

                let mlModel = try MLModel(contentsOf: modelURL, configuration: config)
                let vnModel = try VNCoreMLModel(for: mlModel)

                // Create Vision request
                let request = VNCoreMLRequest(model: vnModel) { [weak self] request, error in
                    self?.processResults(request: request, error: error)
                }

                // Configure request
                request.imageCropAndScaleOption = .scaleFill

                DispatchQueue.main.async {
                    self?.vnModel = vnModel
                    self?.request = request
                    self?.isModelLoaded = true
                    print("✅ Model loaded successfully - Arm Neural Engine ready")
                }

            } catch {
                print("Error loading model: \(error.localizedDescription)")
            }
        }
    }

    /// Run inference on an image
    func detectUIElements(in image: UIImage) {
        guard let cgImage = image.cgImage,
              let request = request else {
            print("Error: Model not loaded or invalid image")
            return
        }

        isProcessing = true
        let startTime = CFAbsoluteTimeGetCurrent()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                // Handle image orientation
                let orientation = CGImagePropertyOrientation(image.imageOrientation)

                // Create request handler
                let handler = VNImageRequestHandler(
                    cgImage: cgImage,
                    orientation: orientation,
                    options: [:]
                )

                // Perform inference
                try handler.perform([request])

                let endTime = CFAbsoluteTimeGetCurrent()

                DispatchQueue.main.async {
                    self?.inferenceTime = endTime - startTime
                    self?.isProcessing = false
                    print("⚡ Inference completed in \(String(format: "%.2f", (endTime - startTime) * 1000))ms")
                }

            } catch {
                print("Error running inference: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isProcessing = false
                }
            }
        }
    }

    /// Process detection results
    private func processResults(request: VNRequest, error: Error?) {
        if let error = error {
            print("Detection error: \(error.localizedDescription)")
            return
        }

        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            print("No results or unexpected result type")
            return
        }

        // Filter and convert results
        let detections = results
            .filter { $0.confidence > 0.25 }  // Confidence threshold (lower for UI elements)
            .map { observation -> DetectionResult in
                let topLabel = observation.labels.first?.identifier ?? "unknown"
                let elementType = UIElementType.from(vinsLabel: topLabel)
                return DetectionResult(
                    type: elementType,
                    label: elementType.displayName,
                    confidence: observation.confidence,
                    boundingBox: observation.boundingBox
                )
            }

        DispatchQueue.main.async { [weak self] in
            self?.detections = detections
            print("📦 Detected \(detections.count) UI elements")
        }
    }

    /// Get UI element type from detection
    func getUIElementType(for detection: DetectionResult) -> UIElementType {
        return detection.type
    }
}

// MARK: - CGImagePropertyOrientation Extension
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
