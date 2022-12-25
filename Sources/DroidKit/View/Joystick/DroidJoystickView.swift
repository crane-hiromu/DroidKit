//
//  JoystickView.swift
//  
//
//  Created by h.tsuruta on 2022/12/25.
//

import Combine
import SwiftUI
import SwiftUIJoystick

// MARK: - View
@available(iOS 15.0, *)
public struct DroidJoystickView: View {
    @StateObject private var viewModel = DroidJoystickViewModel()
    
    public var body: some View {
        JoystickBuilder(
            monitor: viewModel.monitor,
            width: viewModel.output.radius,
            shape: .circle,
            background: { backgroundCircle },
            foreground: { foregroundCircle },
            locksInPlace: false)
    }
}

// MARK: - Private
@available(iOS 15.0, *)
private extension DroidJoystickView {
    
    var backgroundCircle: some View {
        let overlay = Circle()
            .stroke(.black)
            .shadow(color: .white, radius: 5)
        
        return ZStack {
            Circle()
                .fill(.gray)
                .overlay(overlay)
        }
    }
    
    var foregroundCircle: some View {
        let gradient = RadialGradient(
            colors: [.white, .gray],
            center: .center,
            startRadius: 1,
            endRadius: 30
        )
        let overlay = Circle()
            .stroke(.gray, lineWidth: 4)
            .blur(radius: 4)
            .shadow(color: .white, radius: 5)
        
        return Circle()
            .fill(gradient)
            .overlay(overlay)
    }
}
