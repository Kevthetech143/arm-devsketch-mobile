# DevSketch Mobile - Devpost Submission

## Project Name
**DevSketch Mobile** - UI to Flutter Code in Seconds

## Tagline
Transform UI mockups into working Flutter code using 100% on-device AI powered by Arm.

---

## Inspiration

Every mobile app starts as a design. Developers spend hours manually translating mockups and wireframes into functional code. We asked: what if your phone could do this instantly?

DevSketch Mobile bridges the gap between design and implementation. Capture any UI mockup, and get real Flutter code in seconds - all powered by on-device AI running on Arm architecture. No cloud. No waiting. Just instant code generation.

---

## What it does

DevSketch Mobile is an iOS app that:

1. **Captures** UI mockups and wireframes using the camera or photo upload
2. **Analyzes** the image using on-device machine learning (Core ML + YOLOv8)
3. **Detects** 12 UI element types: buttons, text fields, labels, images, icons, switches, and more
4. **Generates** working Flutter code with Material 3 styling
5. **Exports** a complete Flutter project ready to build and customize

**Key Features:**
- 100% on-device AI processing (no cloud required)
- Custom YOLOv8 model trained on 4,800+ UI screenshots
- Real-time inference using Apple Neural Engine (Arm architecture)
- Complete Flutter project export with pubspec.yaml, main.dart, etc.
- Privacy-first: your designs never leave your device

---

## How we built it

**Architecture:**
- **iOS App:** SwiftUI for modern, declarative UI
- **ML Pipeline:** Core ML with Vision framework
- **Model:** Custom YOLOv8-Nano trained on VINS dataset (5.9MB)
- **Code Generation:** Template-based Flutter widget generation
- **Export:** Complete Flutter project structure

**Custom Model Training:**
- Dataset: VINS (Visual Information Navigation System) - 4,800 UI screenshots
- 12 UI element classes: TextButton, EditText, Text, Image, Icon, Switch, CheckedTextView, Drawer, Modal, PageIndicator, UpperTaskBar, BackgroundImage
- Training: 50 epochs on Google Colab T4 GPU
- Export: CoreML with NMS for on-device inference

**Technical Stack:**
- Swift 5.9 / SwiftUI
- Core ML / Vision Framework
- YOLOv8-Nano (custom trained, CoreML exported)
- Apple Neural Engine (Arm optimized)
- Flutter code templates (Material 3)

**Arm Optimization:**
- Model runs on Apple Neural Engine (Arm-based)
- MLModelConfiguration.computeUnits = .all
- ~250ms inference on iPhone (on-device)
- No cloud latency - pure on-device speed

---

## Challenges we ran into

1. **Custom Model Training:** Pre-trained COCO models don't detect UI elements. We trained a custom YOLOv8 model on the VINS dataset with 12 UI-specific classes.

2. **Dataset Selection:** Finding a suitable UI element dataset required research. VINS provided 4,800 labeled UI screenshots with bounding boxes.

3. **CoreML Export:** Converting YOLOv8 PyTorch model to CoreML with NMS (Non-Maximum Suppression) required careful configuration.

4. **On-Device Performance:** Balancing detection accuracy with inference speed on mobile hardware. Achieved ~250ms per image.

5. **Code Generation Logic:** Converting 2D bounding boxes into logical Flutter widget hierarchies (rows, columns, proper nesting).

---

## Accomplishments that we're proud of

- **Custom-trained AI model** - Not using generic pre-trained weights, but a purpose-built UI detector
- **~250ms inference** on-device using Arm Neural Engine
- **12 UI element types** detected with 85%+ confidence
- **Complete project export** - not just code snippets, but runnable Flutter apps
- **Privacy-first design** - zero cloud dependencies, all processing on-device
- **Clean architecture** - modular services for camera, ML inference, code generation, export

---

## What we learned

- How to train and export custom YOLOv8 models for CoreML
- The power of on-device ML with Arm's Neural Engine
- Core ML and Vision framework integration patterns
- Template-based code generation strategies
- The importance of dataset selection for domain-specific ML tasks

---

## What's next for DevSketch Mobile

1. **Expand Training Data:** Train on more diverse UI styles (iOS, Material, custom designs)
2. **Photo Library Import:** Add photo picker for uploading existing mockups
3. **Improve Accuracy:** Fine-tune model on real-world wireframes and hand-drawn sketches
4. **Multi-page Support:** Detect navigation flows between screens
5. **More Frameworks:** Support React Native, SwiftUI code output
6. **Real-time Preview:** Live Flutter preview on device
7. **Figma Integration:** Export directly to Figma for design refinement

---

## Built With

- swift
- swiftui
- coreml
- vision-framework
- yolov8
- flutter
- arm
- neural-engine
- material-design-3
- python
- google-colab

---

## Try it out

**GitHub:** https://github.com/Kevthetech143/arm-devsketch-mobile

**Requirements:**
- iOS 16.0+
- iPhone with A12 chip or later (Neural Engine)
- Xcode 14.0+

**Setup:**
```bash
git clone https://github.com/Kevthetech143/arm-devsketch-mobile
cd arm-devsketch-mobile/ios
open DevSketch.xcodeproj
# Select your team in Signing & Capabilities
# Build and run on device or simulator
```

---

## Team

Built with passion for the Arm AI Developer Challenge 2025.

---

## Screenshots

1. App home screen - Clean interface with Arm AI branding
2. Demo mode - Sample wireframe with "Run AI Detection" button
3. Detection results - Bounding boxes overlay showing detected elements
4. Generated code - Flutter/Dart code with syntax highlighting
5. Export options - Copy code or export complete Flutter project

---

## Video Demo

[Demo video showing: Launch app → Demo mode → Run detection → View results → Generate code → Export]

---

*DevSketch Mobile - UI to code in seconds. 100% on-device. Powered by Arm.*
