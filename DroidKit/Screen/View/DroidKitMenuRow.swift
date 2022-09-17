//
//  DroidKitMenuRow.swift
//
//
//  Created by h.crane on 2022/09/17.
//

#if DEBUG

import SwiftUI

// MARK: - Row
struct DroidKitMenuRow: View {
    let soundType: DroidSound
    let action: (DroidSound) async throws -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text("Type: No.\(soundType.rawValue)")
                .foregroundColor(.white)
            
            Menu("Set") {
                ForEach(DroidSound.allCases, id: \.self) { type in
                    DroidKitActionButton(title: "Sound No.\(type.rawValue)") {
                        try await action(type)
                    }
                }
            }
            .modifier(ActionButtonModifier())
        }
    }
}

#endif
