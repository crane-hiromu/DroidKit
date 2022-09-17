//
//  DroidKitSliderRow.swift
//
//
//  Created by h.crane on 2022/09/17.
//

#if DEBUG

import SwiftUI

// MARK: - Row
struct DroidKitSliderRow: View {
    let label: String
    let value: Binding<Double>
    let range: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Text(label)
                .foregroundColor(.white)
            
            Slider(value: value, in: range, step: step)
                .frame(width: 140)
        }
    }
}

#endif
