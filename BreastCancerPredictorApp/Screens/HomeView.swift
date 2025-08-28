//
//  ContentView.swift
//  BreastCancerPredictorApp
//
//  Created by Shivansh Dubey on 17/07/25.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    // Gradient Text
                    Text("Breast Cancer")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#36D1C4"), Color(hex: "#1976D2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    // Header 2
                    Text("AI Prediction")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                }
                // Subtitle
                Text("Advanced machine learning technology for early detection and risk assessment. Trusted by healthcare professionals worldwide.")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Boxy Container
                VStack(alignment: .leading, spacing: 16) {
                    Text("Clinical-Grade AI Analysis")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Enter 10 key medical features and get instant predictions powered by state-of-the-art ensemble learning algorithms with 98.3% accuracy.")
                        .font(.body)
                        .foregroundColor(.gray)
                    NavigationLink(destination: MedicalFeatureAnalysisView()) {
                        HStack {
                            Image(systemName: "waveform.path.ecg")
                            Text("Start Analysis")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#36D1C4"), Color(hex: "#1976D2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(24)
                .background(
                    ZStack {
                        Color(Color.white)
                        LinearGradient(
                            colors: [Color.cyan.opacity(0.10), Color.blue.opacity(0.10)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                )
                .cornerRadius(20)
                .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
            .navigationBarBackButtonHidden(true)
        }
        
    }
}


#Preview {
    HomeView()
}
