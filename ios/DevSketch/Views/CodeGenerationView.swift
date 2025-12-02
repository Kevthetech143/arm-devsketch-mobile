//
//  CodeGenerationView.swift
//  DevSketch Mobile
//
//  Display generated Flutter code with export options
//  Arm AI Developer Challenge 2025
//

import SwiftUI

struct CodeGenerationView: View {
    let detections: [DetectionResult]

    @StateObject private var codeGenerator = CodeGeneratorService()
    @State private var generatedCode: String = ""
    @State private var isGenerating = true
    @State private var showExportOptions = false
    @State private var showCopyConfirmation = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header stats
                HStack {
                    Label("\(detections.count) widgets", systemImage: "square.3.layers.3d")
                    Spacer()
                    Label("Flutter", systemImage: "chevron.left.forwardslash.chevron.right")
                    Spacer()
                    Label("Ready", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .font(.caption)
                .padding()
                .background(Color.blue.opacity(0.1))

                if isGenerating {
                    // Loading state
                    VStack(spacing: 20) {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Generating Flutter code...")
                            .font(.headline)
                        Text("Converting \(detections.count) UI elements")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    // Code display
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Line numbers + code
                            HStack(alignment: .top, spacing: 0) {
                                // Line numbers
                                VStack(alignment: .trailing, spacing: 0) {
                                    ForEach(1...max(lineCount, 1), id: \.self) { num in
                                        Text("\(num)")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.gray)
                                            .frame(height: 18)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .background(Color.gray.opacity(0.1))

                                // Code content
                                Text(generatedCode)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 8)
                                    .textSelection(.enabled)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .background(Color(UIColor.systemBackground))
                }

                // Action buttons
                VStack(spacing: 12) {
                    // Copy button
                    Button(action: copyToClipboard) {
                        HStack {
                            Image(systemName: showCopyConfirmation ? "checkmark" : "doc.on.doc")
                            Text(showCopyConfirmation ? "Copied!" : "Copy Code")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                    }

                    // Export button
                    Button(action: { showExportOptions = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export Flutter Project")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Generated Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: copyToClipboard) {
                            Label("Copy Code", systemImage: "doc.on.doc")
                        }
                        Button(action: { showExportOptions = true }) {
                            Label("Export Project", systemImage: "square.and.arrow.up")
                        }
                        Button(action: shareCode) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            generateCode()
        }
        .sheet(isPresented: $showExportOptions) {
            ExportOptionsView(code: generatedCode, detections: detections)
        }
    }

    private var lineCount: Int {
        generatedCode.components(separatedBy: "\n").count
    }

    private func generateCode() {
        isGenerating = true

        // Simulate generation delay for UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            generatedCode = codeGenerator.generateFlutterCode(from: detections)
            isGenerating = false
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = generatedCode
        showCopyConfirmation = true

        // Reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopyConfirmation = false
        }
    }

    private func shareCode() {
        // Share functionality
        let activityVC = UIActivityViewController(
            activityItems: [generatedCode],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// Export options sheet
struct ExportOptionsView: View {
    let code: String
    let detections: [DetectionResult]
    @Environment(\.dismiss) var dismiss
    @State private var projectName = "my_app"
    @State private var isExporting = false
    @State private var exportComplete = false

    var body: some View {
        NavigationView {
            Form {
                Section("Project Settings") {
                    TextField("Project Name", text: $projectName)
                        .autocapitalization(.none)

                    HStack {
                        Text("Framework")
                        Spacer()
                        Text("Flutter")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Widgets")
                        Spacer()
                        Text("\(detections.count)")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Export Options") {
                    Button(action: exportToFiles) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Save to Files")
                            Spacer()
                            if isExporting {
                                ProgressView()
                            }
                        }
                    }

                    Button(action: shareProject) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Project ZIP")
                        }
                    }
                }

                Section("What's Included") {
                    Label("pubspec.yaml", systemImage: "doc.text")
                    Label("lib/main.dart", systemImage: "chevron.left.forwardslash.chevron.right")
                    Label("Generated UI code", systemImage: "paintbrush")
                    Label("Material 3 styling", systemImage: "paintpalette")
                }
            }
            .navigationTitle("Export Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Export Complete!", isPresented: $exportComplete) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your Flutter project has been saved.")
        }
    }

    private func exportToFiles() {
        isExporting = true
        // TODO: Implement actual file export
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isExporting = false
            exportComplete = true
        }
    }

    private func shareProject() {
        // TODO: Implement ZIP export and share
    }
}

struct CodeGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        CodeGenerationView(detections: [])
    }
}
