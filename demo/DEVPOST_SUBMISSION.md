# DevSketch Mobile - Devpost Submission

## Project Name
**DevSketch Mobile** - Sketch to Code in Seconds

## Tagline
Transform hand-drawn UI sketches into production-ready Flutter code using 100% on-device AI powered by Arm.

---

## Inspiration

Every mobile app starts as a sketch. Developers and designers spend countless hours translating paper mockups into functional code. We asked: what if your phone could do this instantly?

DevSketch Mobile bridges the gap between imagination and implementation. Draw your UI on paper, capture it with your phone, and get real Flutter code in seconds - all powered by on-device AI running on Arm architecture.

---

## What it does

DevSketch Mobile is an iOS app that:

1. **Captures** your hand-drawn UI sketches using the camera
2. **Analyzes** the image using on-device machine learning (Core ML + YOLOv8)
3. **Detects** UI elements: buttons, text fields, labels, images, containers
4. **Generates** production-ready Flutter code with Material 3 styling
5. **Exports** a complete Flutter project ready to run

**Key Features:**
- 100% on-device AI processing (no cloud required)
- Real-time inference using Apple Neural Engine (Arm architecture)
- Material Design 3 compliant code output
- Full Flutter project export with pubspec.yaml, main.dart, etc.
- Privacy-first: your sketches never leave your device

---

## How we built it

**Architecture:**
- **iOS App:** SwiftUI for modern, declarative UI
- **ML Pipeline:** Core ML with Vision framework
- **Model:** YOLOv8-Nano optimized for mobile (6.2MB)
- **Code Generation:** Template-based Flutter widget generation
- **Export:** Complete Flutter project structure with ZIP export

**Technical Stack:**
- Swift 5.9 / SwiftUI
- Core ML / Vision Framework
- YOLOv8-Nano (quantized for mobile)
- Apple Neural Engine (Arm optimized)
- Flutter code templates (Material 3)

**Arm Optimization:**
- Model runs on Apple Neural Engine (Arm-based)
- MLModelConfiguration.computeUnits = .all
- Sub-100ms inference on iPhone
- No cloud latency - pure on-device speed

---

## Challenges we ran into

1. **Model Selection:** Finding a pre-trained model suitable for UI element detection required research into COCO-class mapping to UI components.

2. **Real-time Performance:** Optimizing the Core ML pipeline to achieve <100ms inference while maintaining detection accuracy.

3. **Layout Intelligence:** Converting 2D detection boxes into logical Flutter widget hierarchies (rows, columns, spacing).

4. **Code Quality:** Generating clean, idiomatic Flutter code that developers would actually want to use.

---

## Accomplishments that we're proud of

- **Sub-100ms inference** on-device using Arm Neural Engine
- **Production-ready code output** with proper Material 3 theming
- **Complete project export** - not just code snippets, but runnable Flutter apps
- **Privacy-first design** - zero cloud dependencies
- **Clean architecture** - modular services for camera, ML, code gen, export

---

## What we learned

- The power of on-device ML with Arm's Neural Engine
- Core ML and Vision framework integration patterns
- Template-based code generation strategies
- The importance of user-centric design in AI tools

---

## What's next for DevSketch Mobile

1. **Fine-tuned UI Model:** Train on actual UI mockup datasets for better accuracy
2. **Multi-page Support:** Detect navigation flows between screens
3. **Handwriting Recognition:** Extract text labels from sketches
4. **More Frameworks:** Support React Native, SwiftUI output
5. **Real-time Preview:** Live Flutter preview on device
6. **Figma Integration:** Export directly to Figma for design refinement

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

---

## Try it out

**GitHub:** https://github.com/Kevthetech143/arm-devsketch-mobile

**Requirements:**
- iOS 16.0+
- iPhone with A12 chip or later (Neural Engine)

**Setup:**
```bash
git clone https://github.com/Kevthetech143/arm-devsketch-mobile
cd arm-devsketch-mobile/ios
open DevSketch.xcodeproj
# Build and run on device
```

---

## Team

Built with passion for the Arm AI Developer Challenge 2025.

---

## Screenshots

[Include in Devpost gallery]
1. App home screen
2. Camera capture view
3. Detection results with bounding boxes
4. Generated Flutter code preview
5. Export options
6. Running Flutter app from generated code

---

## Video Demo

[45-second demo video link]

---

*DevSketch Mobile - Sketch to code in seconds. 100% on-device. Powered by Arm.*
