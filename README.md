# DevSketch Mobile

**Sketch to Flutter code in seconds. 100% on-device AI powered by Arm.**

Entry for the [Arm AI Developer Challenge 2025](https://arm-ai-developer-challenge.devpost.com/)

## 🎯 Overview

DevSketch Mobile is an iOS application that transforms UI mockups and wireframes into working Flutter code - entirely on your device. No cloud, no waiting, just instant code generation powered by Arm AI.

### The Problem
Building mobile UIs is time-consuming. Designers sketch, developers translate. The iteration cycle is slow.

### The Solution
1. 📸 **Capture** - Photo or upload any UI mockup
2. 🤖 **Detect** - AI identifies UI elements (buttons, text fields, labels, etc.)
3. 💻 **Generate** - Instant Flutter code generation
4. 📤 **Export** - Complete Flutter project ready to deploy

### Why It Matters
- **Speed**: Prototype in seconds, not hours
- **Privacy**: 100% on-device processing (no cloud)
- **Efficiency**: Powered by Arm Neural Engine optimization
- **Impact**: Accelerates mobile development workflow for every developer

## 🚀 Features

- **Real-time UI Detection**: Identifies buttons, text fields, labels, images, and containers
- **Flutter Code Generation**: Template-based, working code ready to customize
- **On-Device Processing**: All AI inference runs locally on Arm architecture
- **Instant Preview**: View generated code with syntax highlighting
- **Export Options**: Full Flutter project structure ready to build

## 🛠️ Technology Stack

- **Platform**: iOS 16+ (SwiftUI)
- **AI Framework**: Core ML (optimized for Arm Neural Engine)
- **Vision Model**: YOLOv8-Nano (custom trained on UI mockups)
- **Code Generation**: Template-based Swift engine
- **Target Framework**: Flutter
- **Architecture**: Arm-optimized throughout the stack

## 📱 Requirements

- iOS 16.0 or later
- iPhone with A12 Bionic or newer (Arm-based)
- Xcode 14.0 or later
- ~50MB storage

## 🔧 Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/Kevthetech143/arm-devsketch-mobile.git
cd arm-devsketch-mobile
```

### Step 2: Open in Xcode

```bash
cd ios
open DevSketch.xcodeproj
```

### Step 3: Configure Code Signing

1. In Xcode, select the **DevSketch** target
2. Go to **Signing & Capabilities** tab
3. Select your **Team** (Apple Developer account required)
4. Xcode will automatically manage signing

> **Note:** A free Apple Developer account works for testing on your own device.

### Step 4: Select Your Device

1. Connect your iPhone via USB (or use Simulator for testing)
2. Select your device from the device dropdown in Xcode's toolbar
3. For best results, use a **physical device** with A12 chip or newer

### Step 5: Build and Run

1. Press **⌘R** or click the **Play** button
2. Wait for the build to complete (~30 seconds)
3. The app will launch on your device

### Step 6: Test the App

1. Tap **"Demo Mode"** to test with a sample sketch
2. Tap **"Run AI Detection"** to see the ML model in action
3. View detected elements with bounding boxes
4. Tap **"Generate Flutter Code"** to see the output
5. Use **"Copy Code"** or **"Export Flutter Project"**

### Troubleshooting

| Issue | Solution |
|-------|----------|
| "Signing requires a development team" | Select your team in Signing & Capabilities |
| Model fails to load | Ensure `ios/Models/ui_detector.mlpackage` exists |
| App crashes on launch | Clean build folder (⌘⇧K) and rebuild |
| Camera not working | Camera requires physical device, use Demo Mode in Simulator |

## 🎥 Demo

[Demo video coming soon]

## 🏗️ Project Structure

```
arm-devsketch-mobile/
├── ios/                    # iOS app (SwiftUI)
│   ├── DevSketch/         # Main app target
│   ├── Models/            # Core ML models
│   ├── Views/             # SwiftUI views
│   ├── Services/          # Camera, ML inference
│   └── Utils/             # Helpers
├── flutter_templates/      # Flutter widget templates
├── assets/                # Example sketches
├── docs/                  # Documentation
└── demo/                  # Demo materials
```

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

This is a hackathon submission. Contributions welcome after the competition period.

## 👥 Team

Built for the Arm AI Developer Challenge 2025

## 📧 Contact

Questions? Open an issue or reach out via Devpost.

---

**Built with ❤️ on Arm**
