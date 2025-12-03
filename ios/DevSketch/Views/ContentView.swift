//
//  ContentView.swift
//  DevSketch Mobile
//
//  Main navigation and home view
//  Arm AI Developer Challenge 2025
//

import SwiftUI

struct ContentView: View {
    @State private var showCamera = false
    @State private var showOnboarding = true
    @State private var showDemo = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // App Logo/Title
                VStack(spacing: 10) {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text("DevSketch Mobile")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Sketch to Flutter code in seconds")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("100% on-device • Powered by Arm AI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)

                Spacer()

                // Action Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Capture Sketch")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Button(action: {
                        showDemo = true
                    }) {
                        HStack {
                            Image(systemName: "cpu.fill")
                            Text("Demo Mode")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                    }

                    Button(action: {
                        showOnboarding = true
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("How It Works")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)

                Spacer()

                // Footer
                VStack(spacing: 5) {
                    Text("Arm AI Developer Challenge 2025")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 15) {
                        Label("Privacy First", systemImage: "lock.shield.fill")
                        Label("Fast", systemImage: "bolt.fill")
                        Label("No Cloud", systemImage: "icloud.slash.fill")
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
        }
        .fullScreenCover(isPresented: $showDemo) {
            DemoView()
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
