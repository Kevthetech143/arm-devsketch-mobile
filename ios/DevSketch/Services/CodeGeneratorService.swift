//
//  CodeGeneratorService.swift
//  DevSketch
//
//  Converts ML detection results to Flutter code
//  Material 3 compliant templates
//

import Foundation
import Vision

// MARK: - Detection Result Model

struct DetectionResult: Identifiable {
    let id = UUID()
    let type: UIElementType
    let boundingBox: CGRect  // Normalized 0-1 coordinates
    let confidence: Float
    let label: String?

    enum UIElementType: String, CaseIterable {
        case button
        case textField
        case text
        case label
        case container
        case image
        case icon
        case unknown

        init(from classLabel: String) {
            // Map COCO classes to UI elements
            switch classLabel.lowercased() {
            case "button", "remote", "cell phone":
                self = .button
            case "textfield", "input", "keyboard":
                self = .textField
            case "text", "label", "book":
                self = .text
            case "container", "box", "rectangle", "tv", "laptop":
                self = .container
            case "image", "picture", "person", "frisbee":
                self = .image
            case "icon", "clock", "stop sign":
                self = .icon
            default:
                self = .unknown
            }
        }
    }
}

// MARK: - Code Generator Service

class CodeGeneratorService {

    // MARK: - Properties

    private let screenWidth: CGFloat = 375.0   // iPhone width
    private let screenHeight: CGFloat = 812.0  // iPhone height
    private let rowThreshold: CGFloat = 0.08   // Y-distance to group into same row

    // MARK: - Public Methods

    /// Generate complete Flutter page code from detections
    func generateFlutterCode(from detections: [DetectionResult], pageName: String = "GeneratedPage") -> String {
        // Sort by position (top to bottom, left to right)
        let sorted = detections.sorted { a, b in
            if abs(a.boundingBox.minY - b.boundingBox.minY) < rowThreshold {
                return a.boundingBox.minX < b.boundingBox.minX
            }
            return a.boundingBox.minY < b.boundingBox.minY
        }

        // Group into rows
        let rows = groupIntoRows(sorted)

        // Generate widget tree
        let widgetTree = generateLayout(rows: rows)

        // Generate complete page
        return generatePage(pageName: pageName, content: widgetTree)
    }

    /// Generate code preview (shorter version for display)
    func generatePreview(from detections: [DetectionResult]) -> String {
        let widgets = detections.prefix(5).map { generateWidget(for: $0) }
        return widgets.joined(separator: "\n\n")
    }

    // MARK: - Private Methods

    /// Group detections into rows based on Y position
    private func groupIntoRows(_ detections: [DetectionResult]) -> [[DetectionResult]] {
        var rows: [[DetectionResult]] = []
        var currentRow: [DetectionResult] = []
        var lastY: CGFloat = -1

        for detection in detections {
            if lastY < 0 || abs(detection.boundingBox.minY - lastY) < rowThreshold {
                currentRow.append(detection)
            } else {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [detection]
            }
            lastY = detection.boundingBox.minY
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    /// Generate layout from grouped rows
    private func generateLayout(rows: [[DetectionResult]]) -> String {
        var children: [String] = []

        for row in rows {
            if row.count == 1 {
                // Single element
                children.append(generateWidget(for: row[0]))
            } else {
                // Multiple elements - wrap in Row
                let rowWidgets = row.map { "Expanded(child: \(generateWidget(for: $0)))" }
                let rowCode = """
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    \(rowWidgets.joined(separator: ",\n          ")),
                  ],
                )
                """
                children.append(rowCode)
            }
            children.append("const SizedBox(height: 16)")
        }

        return """
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            \(children.joined(separator: ",\n        ")),
          ],
        )
        """
    }

    /// Generate individual widget code
    private func generateWidget(for detection: DetectionResult) -> String {
        let width = Int(detection.boundingBox.width * screenWidth)
        let height = Int(detection.boundingBox.height * screenHeight)
        let label = detection.label ?? detection.type.rawValue.capitalized

        switch detection.type {
        case .button:
            return generateButton(label: label, width: width, height: height)
        case .textField:
            return generateTextField(label: label)
        case .text, .label:
            return generateText(text: label)
        case .container:
            return generateContainer(width: width, height: height)
        case .image:
            return generateImagePlaceholder(width: width, height: height)
        case .icon:
            return generateIcon(size: height)
        case .unknown:
            return generateContainer(width: width, height: height)
        }
    }

    /// Generate complete page with imports
    private func generatePage(pageName: String, content: String) -> String {
        return """
        import 'package:flutter/material.dart';

        class \(pageName) extends StatefulWidget {
          const \(pageName)({super.key});

          @override
          State<\(pageName)> createState() => _\(pageName)State();
        }

        class _\(pageName)State extends State<\(pageName)> {
          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('\(pageName)'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: \(content)
                ),
              ),
            );
          }
        }
        """
    }

    // MARK: - Widget Templates

    private func generateButton(label: String, width: Int, height: Int) -> String {
        return """
        ElevatedButton(
          onPressed: () {
            // TODO: Add action
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(\(width), \(max(height, 48))),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('\(label)'),
        )
        """
    }

    private func generateTextField(label: String) -> String {
        return """
        TextField(
          decoration: InputDecoration(
            labelText: '\(label)',
            hintText: 'Enter \(label.lowercased())',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        )
        """
    }

    private func generateText(text: String) -> String {
        return """
        Text(
          '\(text)',
          style: Theme.of(context).textTheme.bodyLarge,
        )
        """
    }

    private func generateContainer(width: Int, height: Int) -> String {
        return """
        Container(
          width: \(width),
          height: \(height),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        )
        """
    }

    private func generateImagePlaceholder(width: Int, height: Int) -> String {
        return """
        Container(
          width: \(width),
          height: \(height),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.image,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        )
        """
    }

    private func generateIcon(size: Int) -> String {
        return """
        Icon(
          Icons.star,
          size: \(max(size, 24)),
          color: Theme.of(context).colorScheme.primary,
        )
        """
    }
}

// MARK: - Extension for VNRecognizedObjectObservation

extension CodeGeneratorService {

    /// Convert Vision observations to DetectionResults
    func convertObservations(_ observations: [VNRecognizedObjectObservation]) -> [DetectionResult] {
        return observations.compactMap { observation in
            guard let topLabel = observation.labels.first else { return nil }

            return DetectionResult(
                type: DetectionResult.UIElementType(from: topLabel.identifier),
                boundingBox: observation.boundingBox,
                confidence: topLabel.confidence,
                label: topLabel.identifier
            )
        }
    }
}
