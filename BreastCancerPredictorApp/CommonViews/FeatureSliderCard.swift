//
//  FeatureSliderCard.swift
//  BreastCancerPredictorApp
//
//  Created by Shivansh Dubey on 17/07/25.
//

import SwiftUI

struct FeatureSliderCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var format: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(iconColor)
                }
                Text(label)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Slider(value: $value, in: range)
                .accentColor(iconColor)
            HStack {
                Text("\(formatValue(range.lowerBound))")
                    .foregroundColor(.gray)
                Spacer()
                Text("\(formatValue(value))")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(formatValue(range.upperBound))")
                    .foregroundColor(.gray)
            }
            .font(.subheadline)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6).opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray4).opacity(0.25), lineWidth: 1)
                )
        )
    }
    
    private func formatValue(_ value: Double) -> String {
        if let format = format {
            return String(format: format, value)
        } else {
            return String(Int(value))
        }
    }
}
