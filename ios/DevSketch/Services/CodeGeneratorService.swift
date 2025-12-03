//
//  CodeGeneratorService.swift
//  DevSketch
//
//  Converts ML detection results to Flutter code
//  Material 3 compliant templates
//

import Foundation
import Vision
import Combine

// DetectionResult and UIElementType are defined in MLInferenceService.swift

// MARK: - Code Generator Service

class CodeGeneratorService: ObservableObject {

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
        case .textButton:
            return generateButton(label: label, width: width, height: height)
        case .editText:
            return generateTextField(label: label)
        case .text:
            return generateText(text: label)
        case .backgroundImage, .image:
            return generateImagePlaceholder(width: width, height: height)
        case .icon:
            return generateIcon(size: height)
        case .checkedTextView:
            return generateCheckbox(label: label)
        case .switchControl:
            return generateSwitch(label: label)
        case .drawer, .modal:
            return generateContainer(width: width, height: height)
        case .pageIndicator:
            return generatePageIndicator()
        case .upperTaskBar:
            return "" // Skip status bar - already part of Scaffold
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

    private func generateCheckbox(label: String) -> String {
        return """
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            Text('\(label)'),
          ],
        )
        """
    }

    private func generateSwitch(label: String) -> String {
        return """
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\(label)'),
            Switch(
              value: false,
              onChanged: (value) {},
            ),
          ],
        )
        """
    }

    private func generatePageIndicator() -> String {
        return """
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
            SizedBox(width: 8),
            Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
            SizedBox(width: 8),
            Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
          ],
        )
        """
    }
}

// MARK: - Extension for VNRecognizedObjectObservation

extension CodeGeneratorService {

    /// Convert Vision observations to DetectionResults
    func convertObservations(_ observations: [VNRecognizedObjectObservation]) -> [DetectionResult] {
        return observations.compactMap { observation -> DetectionResult? in
            guard let topLabel = observation.labels.first else { return nil }
            let elementType = UIElementType.from(vinsLabel: topLabel.identifier)

            return DetectionResult(
                type: elementType,
                label: topLabel.identifier,
                confidence: topLabel.confidence,
                boundingBox: observation.boundingBox
            )
        }
    }
}
