/// DevSketch Mobile - Flutter Code Generator
/// Converts detected UI elements into Flutter code
/// Material 3 compliant

import 'widget_templates.dart';

/// Represents a detected UI element from the Core ML model
class DetectedElement {
  final String type;          // button, textfield, text, container, image, icon
  final double x;             // normalized x position (0-1)
  final double y;             // normalized y position (0-1)
  final double width;         // normalized width (0-1)
  final double height;        // normalized height (0-1)
  final double confidence;    // detection confidence (0-1)
  final String? label;        // optional label text if detected

  DetectedElement({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
    this.label,
  });

  /// Convert normalized coordinates to pixel values
  Map<String, double> toPixels(double screenWidth, double screenHeight) {
    return {
      'x': x * screenWidth,
      'y': y * screenHeight,
      'width': width * screenWidth,
      'height': height * screenHeight,
    };
  }
}

/// Main code generator class
class FlutterCodeGenerator {
  final double screenWidth;
  final double screenHeight;

  FlutterCodeGenerator({
    this.screenWidth = 375.0,  // Default iPhone width
    this.screenHeight = 812.0, // Default iPhone height
  });

  /// Generate complete Flutter page from detected elements
  String generatePage(List<DetectedElement> elements, {String pageName = 'GeneratedPage'}) {
    // Sort elements by position (top to bottom, left to right)
    elements.sort((a, b) {
      if ((a.y - b.y).abs() < 0.05) {
        return a.x.compareTo(b.x);
      }
      return a.y.compareTo(b.y);
    });

    // Group elements into rows based on Y position
    final rows = _groupIntoRows(elements);

    // Generate widget tree
    final widgetTree = _generateWidgetTree(rows);

    return '''
import 'package:flutter/material.dart';

class $pageName extends StatefulWidget {
  const $pageName({super.key});

  @override
  State<$pageName> createState() => _${pageName}State();
}

class _${pageName}State extends State<$pageName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pageName'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: $widgetTree
        ),
      ),
    );
  }
}
''';
  }

  /// Group elements into rows based on Y position proximity
  List<List<DetectedElement>> _groupIntoRows(List<DetectedElement> elements) {
    final rows = <List<DetectedElement>>[];
    List<DetectedElement> currentRow = [];
    double lastY = -1;

    for (final element in elements) {
      if (lastY < 0 || (element.y - lastY).abs() < 0.08) {
        currentRow.add(element);
      } else {
        if (currentRow.isNotEmpty) {
          rows.add(List.from(currentRow));
        }
        currentRow = [element];
      }
      lastY = element.y;
    }

    if (currentRow.isNotEmpty) {
      rows.add(currentRow);
    }

    return rows;
  }

  /// Generate widget tree from grouped rows
  String _generateWidgetTree(List<List<DetectedElement>> rows) {
    final children = <String>[];

    for (final row in rows) {
      if (row.length == 1) {
        // Single element in row
        children.add(_generateWidget(row.first));
      } else {
        // Multiple elements in row - wrap in Row
        final rowChildren = row.map((e) => 'Expanded(child: ${_generateWidget(e)})').toList();
        children.add('''
Row(
  children: [
    ${rowChildren.join(',\n    const SizedBox(width: 16),\n    ')},
  ],
)''');
      }
      children.add('const SizedBox(height: 16)');
    }

    return '''
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    ${children.join(',\n    ')},
  ],
)''';
  }

  /// Generate individual widget from detected element
  String _generateWidget(DetectedElement element) {
    final pixelSize = element.toPixels(screenWidth, screenHeight);

    switch (element.type.toLowerCase()) {
      case 'button':
        return '''
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    minimumSize: Size(${pixelSize['width']?.toStringAsFixed(0)}, ${pixelSize['height']?.toStringAsFixed(0)}),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('${element.label ?? 'Button'}'),
)''';

      case 'textfield':
      case 'input':
        return '''
TextField(
  decoration: InputDecoration(
    labelText: '${element.label ?? 'Input'}',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
  ),
)''';

      case 'text':
      case 'label':
        return '''
Text(
  '${element.label ?? 'Label'}',
  style: Theme.of(context).textTheme.bodyLarge,
)''';

      case 'image':
        return '''
Container(
  width: ${pixelSize['width']?.toStringAsFixed(0)},
  height: ${pixelSize['height']?.toStringAsFixed(0)},
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceVariant,
    borderRadius: BorderRadius.circular(12),
  ),
  child: const Icon(Icons.image, size: 48),
)''';

      case 'container':
      case 'box':
      case 'rectangle':
        return '''
Container(
  width: ${pixelSize['width']?.toStringAsFixed(0)},
  height: ${pixelSize['height']?.toStringAsFixed(0)},
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(context).colorScheme.outline,
    ),
  ),
)''';

      case 'icon':
        return '''
Icon(
  Icons.star,
  size: ${pixelSize['height']?.toStringAsFixed(0)},
)''';

      default:
        return '''
Container(
  width: ${pixelSize['width']?.toStringAsFixed(0)},
  height: ${pixelSize['height']?.toStringAsFixed(0)},
  color: Theme.of(context).colorScheme.surfaceVariant,
)''';
    }
  }
}

/// Example usage:
///
/// final generator = FlutterCodeGenerator();
///
/// final elements = [
///   DetectedElement(type: 'text', x: 0.1, y: 0.1, width: 0.8, height: 0.05, confidence: 0.95, label: 'Welcome'),
///   DetectedElement(type: 'textfield', x: 0.1, y: 0.2, width: 0.8, height: 0.08, confidence: 0.92, label: 'Email'),
///   DetectedElement(type: 'textfield', x: 0.1, y: 0.35, width: 0.8, height: 0.08, confidence: 0.91, label: 'Password'),
///   DetectedElement(type: 'button', x: 0.1, y: 0.5, width: 0.8, height: 0.06, confidence: 0.94, label: 'Sign In'),
/// ];
///
/// final code = generator.generatePage(elements, pageName: 'LoginPage');
/// print(code);
