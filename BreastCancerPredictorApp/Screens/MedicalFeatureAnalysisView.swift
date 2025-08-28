//
//  MedicalFeatureAnalysisView.swift
//  BreastCancerPredictorApp
//
//  Created by Shivansh Dubey on 17/07/25.
//

import SwiftUI

struct PredictionResult: Codable {
    let predictions: [String: Int]
}

struct MedicalFeatureAnalysisView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var radiusMean: Double = 14
    @State private var textureMean: Double = 19
    @State private var perimeterMean: Double = 90
    @State private var areaMean: Double = 600
    @State private var smoothnessMean: Double = 0.1
    @State private var concavityMean: Double = 0.05
    @State private var concavePointsMean: Double = 0.03
    @State private var radiusWorst: Double = 18
    @State private var perimeterWorst: Double = 120
    @State private var areaWorst: Double = 900
    
    @State private var isLoading = false
    @State private var showResult = false
    @State private var result: PredictionResult? = nil
    @State private var showError = false
    @State private var errorMessage = ""
    
    var featuresArray: [Double] {
        [radiusMean, textureMean, perimeterMean, areaMean, smoothnessMean, concavityMean, concavePointsMean, radiusWorst, perimeterWorst, areaWorst]
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                // Fixed Top Title & Custom Back Button
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("Medical Feature Analysis")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#36D1C4"), Color(hex: "#1976D2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    Text("Enter the medical measurements for AI-powered breast cancer prediction")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                }
                .background(Color.white)
                .zIndex(1)
                
                // Scrollable Sliders
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        FeatureSliderCard(icon: "scope", iconColor: Color(hex: "#36D1C4"), label: "Radius Mean", value: $radiusMean, range: 6...30)
                        FeatureSliderCard(icon: "waveform.path.ecg", iconColor: Color(hex: "#36D1C4"), label: "Texture Mean", value: $textureMean, range: 9...40)
                        FeatureSliderCard(icon: "brain.head.profile", iconColor: Color(hex: "#36D1C4"), label: "Perimeter Mean", value: $perimeterMean, range: 40...190)
                        FeatureSliderCard(icon: "square.grid.2x2", iconColor: Color(hex: "#36D1C4"), label: "Area Mean", value: $areaMean, range: 100...2500)
                        FeatureSliderCard(icon: "scribble.variable", iconColor: Color(hex: "#36D1C4"), label: "Smoothness Mean", value: $smoothnessMean, range: 0.05...0.2, format: "%.3f")
                        FeatureSliderCard(icon: "chart.line.uptrend.xyaxis", iconColor: Color(hex: "#36D1C4"), label: "Concavity Mean", value: $concavityMean, range: 0.01...0.5, format: "%.3f")
                        FeatureSliderCard(icon: "point.3.filled.connected.trianglepath.dotted", iconColor: Color(hex: "#36D1C4"), label: "Concave Points Mean", value: $concavePointsMean, range: 0.01...0.2, format: "%.3f")
                        FeatureSliderCard(icon: "scope", iconColor: Color(hex: "#1976D2"), label: "Radius Worst", value: $radiusWorst, range: 7...40)
                        FeatureSliderCard(icon: "brain.head.profile", iconColor: Color(hex: "#1976D2"), label: "Perimeter Worst", value: $perimeterWorst, range: 50...250)
                        FeatureSliderCard(icon: "square.grid.2x2", iconColor: Color(hex: "#1976D2"), label: "Area Worst", value: $areaWorst, range: 200...4000)
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            // Fixed Bottom Predict Risk Button
            .safeAreaInset(edge: .bottom) {
                Button(action: predictRisk) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#36D1C4")))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Predict Risk")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#36D1C4"), Color(hex: "#1976D2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding( 16)
                .padding(.bottom, 8)
                .background(Color.white)
                .disabled(isLoading)
            }
            // Navigation to result screen
            NavigationLink(destination: PredictionResultView(result: result, goHome: {
                presentationMode.wrappedValue.dismiss() }), isActive: $showResult) {
                EmptyView()
            }
            .hidden()
            // Error alert
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    func predictRisk() {
        isLoading = true
        errorMessage = ""
        showError = false
        let url = URL(string: "https://breastcancerapi-production.up.railway.app/predict")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let features30 = Array(repeating: featuresArray, count: 3).flatMap { $0 }
        let payload = ["features": features30]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            isLoading = false
            errorMessage = "Failed to encode request."
            showError = true
            return
        }
        NetworkManager.shared.fetchPrediction(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Error fetching prediction: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                    showError = true
                    return
                }
                guard let data = data else {
                    errorMessage = "No data received."
                    showError = true
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(PredictionResult.self, from: data)
                    result = decoded
                    showResult = true
                } catch {
                    errorMessage = "Failed to decode response."
                    showError = true
                }
            }
        }
    }
}




#Preview {
    MedicalFeatureAnalysisView()
}
