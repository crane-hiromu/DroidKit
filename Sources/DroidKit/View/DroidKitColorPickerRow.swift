//
//  DroidKitColorPickerRow.swift
//
//
//  Created by h.crane on 2022/09/17.
//

import SwiftUI

// MARK: - Row
struct DroidKitColorPickerRow: View {
    let color: Binding<Color>
    
    var body: some View {
        ColorPicker("Color: ", selection: color).padding()
            .frame(width: 260)
            .foregroundColor(.white)
    }
}
