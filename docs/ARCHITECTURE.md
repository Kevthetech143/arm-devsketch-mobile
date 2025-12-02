# DevSketch Mobile - Architecture

## Overview

DevSketch Mobile transforms hand-drawn UI sketches into Flutter code using on-device AI inference powered by Arm architecture.

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     iOS Application                      │
│                      (SwiftUI)                          │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Camera     │   │    Core ML   │   │     Code     │
│   Service    │   │   Inference  │   │  Generator   │
└──────────────┘   └──────────────┘   └──────────────┘
        │                   │                   │
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│    Image     │   │   UI Element │   │   Flutter    │
│  Processing  │   │   Detection  │   │  Templates   │
└──────────────┘   └──────────────┘   └──────────────┘
```

## Components

### 1. Camera Service
**Responsibility**: Capture and preprocess images
- AVFoundation camera integration
- Image preprocessing (resize, normalize)
- Real-time preview
- Photo capture trigger

**Key Files**:
- `ios/DevSketch/Services/CameraService.swift`
- `ios/DevSketch/Views/CameraView.swift`

### 2. Core ML Inference Engine
**Responsibility**: Detect UI elements from sketches
- Load YOLOv8 model (.mlpackage)
- Run inference on captured images
- Parse detection results (bounding boxes + classes)
- Optimize for Arm Neural Engine

**Key Files**:
- `ios/DevSketch/Services/MLInferenceService.swift`
- `ios/Models/UIComponentDetector.mlpackage`

**Model Details**:
- Input: 640x640 RGB image
- Output: Bounding boxes, class labels, confidence scores
- Classes: button, textfield, label, image, container, icon
- Inference time: <100ms on A12+ devices

### 3. Layout Analyzer
**Responsibility**: Convert detections to spatial relationships
- Parse bounding box coordinates
- Determine relative positioning
- Identify parent-child relationships
- Calculate spacing and alignment

**Key Files**:
- `ios/DevSketch/Services/LayoutAnalyzer.swift`

**Algorithm**:
```
1. Sort elements by Y-coordinate (top to bottom)
2. Group elements into rows (similar Y values)
3. Within rows, sort by X-coordinate (left to right)
4. Identify containers (elements with others inside)
5. Calculate relative positions and sizes
6. Generate layout tree structure
```

### 4. Code Generator
**Responsibility**: Convert layout tree to Flutter code
- Template-based code generation
- Flutter widget mapping
- Style inference (colors, padding, etc.)
- Syntax-correct Dart code output

**Key Files**:
- `ios/DevSketch/Services/CodeGenerator.swift`
- `flutter_templates/` (widget templates)

**Template System**:
```swift
// Example: Button template
"""
ElevatedButton(
  onPressed: () {},
  child: Text('\(label)'),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(\(width), \(height)),
  ),
)
"""
```

### 5. Export Module
**Responsibility**: Package and deliver Flutter project
- Generate complete Flutter project structure
- Include pubspec.yaml, main.dart, etc.
- ZIP compression
- Export to Files app or share sheet

**Key Files**:
- `ios/DevSketch/Services/ExportService.swift`

## Data Flow

```
1. User captures sketch photo
   ↓
2. Image preprocessed (640x640, normalized)
   ↓
3. Core ML model detects UI elements
   → [button at (100,50,200,80), textfield at (100,150,200,40), ...]
   ↓
4. Layout analyzer parses spatial relationships
   → Tree: Column [Button, TextField, Button]
   ↓
5. Code generator applies templates
   → Flutter widget code
   ↓
6. Preview displayed + Export option
   ↓
7. User exports complete Flutter project
```

## Performance Optimization

### Arm Neural Engine Utilization
- Core ML automatically uses Neural Engine for convolution ops
- Model quantization (FP16 or INT8) for faster inference
- Batch size = 1 (single image processing)

### Memory Management
- Lazy loading of models
- Image buffer reuse
- Release resources after inference

### Latency Targets
- Camera capture: <50ms
- Preprocessing: <20ms
- Model inference: <100ms
- Code generation: <50ms
- **Total: <220ms** (sub-second experience)

## Error Handling

### Detection Failures
- No elements detected → Show manual mode option
- Low confidence (<0.5) → Highlight uncertain elements
- Invalid layout → Fallback to grid-based layout

### Model Loading Errors
- Missing model file → Show setup instructions
- Incompatible iOS version → Version check on launch
- Insufficient memory → Reduce model precision

## Security & Privacy

### On-Device Processing
- **No cloud uploads**: All processing is local
- **No data collection**: No telemetry or analytics
- **Photo storage**: User controls photo storage (not saved by default)

### Permissions
- Camera access (required)
- Photo library (optional, for importing existing sketches)
- File system write (for export)

## Testing Strategy

### Unit Tests
- Layout analyzer logic
- Code generator templates
- Utility functions

### Integration Tests
- Camera → ML inference pipeline
- ML inference → code generation pipeline
- End-to-end: photo → code output

### Performance Tests
- Inference latency benchmarks
- Memory usage profiling
- Battery consumption

## Future Enhancements

### Phase 2
- Multiple framework support (React Native, Jetpack Compose)
- Advanced widgets (charts, animations)
- Style customization UI
- Multi-page app support

### Phase 3
- Collaborative features (share templates)
- Cloud sync (optional)
- Web version
- IDE plugins

---

**Built with ❤️ on Arm**
