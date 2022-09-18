//
//  DroidKitSectionTitle.swift
//
//
//  Created by h.crane on 2022/09/17.
//

import SwiftUI

// MARK: - View
struct DroidKitSectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .foregroundColor(.white)
    }
}
