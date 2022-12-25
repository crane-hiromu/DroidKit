//
//  DroidJoystickDebugView.swift
//  
//
//  Created by h.tsuruta on 2022/12/26.
//

import Combine
import SwiftUI
import SwiftUIJoystick

// MARK: - View
@available(iOS 15.0, *)
public struct DroidJoystickDebugView: View {
    @StateObject private var viewModel = DroidJoystickViewModel()
    
    public var body: some View {
        VStack {
            Text("XY Point = (x: \(viewModel.monitor.xyPoint.x), y: \(viewModel.monitor.xyPoint.y))")
                .fixedSize()
            
            Text("Polor Point = (\(viewModel.monitor.polarPoint.degrees), \(viewModel.monitor.polarPoint.distance)))")
                .fixedSize()
            
            JoystickBuilder(
                monitor: viewModel.monitor,
                width: viewModel.output.radius,
                shape: .circle,
                background: { backgroundCircle },
                foreground: { foregroundCircle },
                locksInPlace: false)
        }
        .padding()
    }
}

// MARK: - Private
@available(iOS 15.0, *)
private extension DroidJoystickDebugView {
    
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
