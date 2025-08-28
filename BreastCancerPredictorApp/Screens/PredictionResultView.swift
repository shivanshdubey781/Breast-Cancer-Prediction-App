//
//  PredictionResultView.swift
//  BreastCancerPredictorApp
//
//  Created by Shivansh Dubey on 17/07/25.
//
import SwiftUI

struct PredictionResultView: View {
    @Environment(\.dismiss) private var dismiss
    let result: PredictionResult?
    let goHome: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
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
                Spacer(minLength: 44)
            }
            
            Text("Prediction Result")
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "#36D1C4"), Color(hex: "#1976D2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            ScrollView(showsIndicators: false) {
                if let result = result, let resultKeys = result.predictions.keys.map({$0}) as? [String]{
                    
                    ForEach(resultKeys, id: \.self) { key in
                        VStack(spacing: 0){
                            Text(key)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(result.predictions[key]  == 1 ? .red : .green)
                            Text((result.predictions[key]  == 1 ? "Critical" : "Normal"))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(result.predictions[key]  == 1 ? .red : .green)
                        }
                        .padding(.vertical, 5)
                    }
                    
                } else {
                    Text("No result available.")
                        .foregroundColor(.gray)
                }
            }
            Spacer(minLength: 15)
            NavigationLink(destination: HomeView()) {
                Text("Back to Home")
                    .fontWeight(.semibold)
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
                    .cornerRadius(12)
            }
            
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

