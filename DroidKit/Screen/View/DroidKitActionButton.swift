//
//  DroidKitActionButton.swift
//
//
//  Created by h.tsuruta on 2022/09/17.
//

#if DEBUG

import SwiftUI

// MARK: - Button
struct DroidKitActionButton: View {
    let title: String
    let action: () async throws -> Void
    
    var body: some View {
        Button(title) {
            Task {
                do {
                    try await action()
                } catch {
                    debugPrint("fail to \(title): \(error.localizedDescription)")
                }
            }
        }
        .modifier(ActionButtonModifier())
    }
}

// MARK: - Modifier
struct ActionButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold, design: .default))
            .frame(width: 110, height: 44)
            .background(.white)
            .cornerRadius(8)
    }
}

#endif