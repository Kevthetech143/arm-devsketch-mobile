//
//  OnboardingView.swift
//  DevSketch Mobile
//
//  Tutorial and onboarding flow
//  Arm AI Developer Challenge 2025
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "pencil.and.outline",
            title: "Design Your UI",
            description: "Create or capture any UI mockup. Our AI detects buttons, text fields, labels, and images.",
            color: .blue
        ),
        OnboardingPage(
            icon: "camera.fill",
            title: "Capture or Upload",
            description: "Take a photo or upload any UI design. Our AI detects elements using Arm-optimized machine learning.",
            color: .green
        ),
        OnboardingPage(
            icon: "cpu.fill",
            title: "AI Processing",
            description: "100% on-device processing. No cloud uploads. Your sketches stay private and processing is instant.",
            color: .orange
        ),
        OnboardingPage(
            icon: "doc.text.fill",
            title: "Get Flutter Code",
            description: "Generate working Flutter code in seconds. Export complete projects ready to build and customize.",
            color: .purple
        )
    ]

    var body: some View {
        VStack {
            // Close Button
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
            }

            // Page Content
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            // Action Button
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    isPresented = false
                }
            }) {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: page.icon)
                .font(.system(size: 100))
                .foregroundColor(page.color)

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
}
