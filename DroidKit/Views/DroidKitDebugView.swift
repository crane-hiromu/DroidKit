import SwiftUI

// MARK: - View
struct DroidKitDebugView: View {
    private let droidOperator: DroidOperatorProtocol = DroidOperator.default
    @State private var speed: Double = 0.5
    @State private var duration: Double = 1.5
    @State private var degree: Double = 90
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                connectionSection
                movementSection
                rotationSection
                soundSection
                colorSection
            }
            .padding([.top, .bottom], 32)
        }
        .onReceive(droidOperator.eventPublisher) {
            switch $0 {
            case .didUpdateState(let state):
                debugPrint("didUpdateState: \(state)")
            case .willRestoreState(let state):
                debugPrint("willRestoreState: \(state)")
            case .didConnectPeripheral(let peripheral):
                debugPrint("didConnectPeripheral: \(peripheral)")
            case .didDisconnectPeripheral(let peripheral, let error):
                debugPrint("didDisconnectPeripheral: \(peripheral), \(String(describing: error))")
            }
        }
    }
}
    
// MARKL - Private
private extension DroidKitDebugView {
    
    var connectionSection: some View {
        VStack(spacing: 16) {
            Text("Connection")
                .font(.title2)
            
            HStack(spacing: 16) {
                DroidKitActionButton(title: "Connect") {
                    try await droidOperator.connect()
                }
                DroidKitActionButton(title: "Disconnect") {
                    try await droidOperator.disconnect()
                }
            }
        }
    }
    
    var movementSection: some View {
        VStack(spacing: 16) {
            Text("Movement")
                .font(.title2)
            
            HStack(spacing: 16) {
                Text("Speed: \(String(format:"%.1f", speed))")

                Slider(value: $speed, in: 0...1, step: 0.1)
                    .frame(width: 140)
            }
            
            HStack(spacing: 16) {
                Text("Duration: \(String(format:"%.1f", duration))")
                
                Slider(value: $duration, in: 0...5, step: 0.1)
                    .frame(width: 140)
            }

            HStack(spacing: 16) {
                DroidKitActionButton(title: "Go") {
                    try await droidOperator.go(at: speed)
                    try await droidOperator.wait(for: duration)
                    try await droidOperator.stop(.move)
                }
                DroidKitActionButton(title: "Back") {
                    try await droidOperator.back(at: speed)
                    try await droidOperator.wait(for: duration)
                    try await droidOperator.stop(.move)
                }
            }
        }
    }
    
    var rotationSection: some View {
        VStack(spacing: 16) {
            Text("Rotation")
                .font(.title2)
            
            HStack(spacing: 16) {
                Text("Degree: \(String(format:"%.f", degree))°")
                
                Slider(value: $degree, in: 0...180, step: 1)
                    .frame(width: 140)
            }
            
            HStack(spacing: 16) {
                DroidKitActionButton(title: "Turn") {
                    try await droidOperator.turn(by: degree)
                }
                DroidKitActionButton(title: "Reset") {
                    try await droidOperator.stop(.turn)
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    var soundSection: some View {
        VStack(spacing: 16) {
            Text("Sound")
                .font(.title2)
            
            // try await droidOperator.playSound(.s4)
        }
    }
    
    var colorSection: some View {
        VStack(spacing: 16) {
            Text("Color")
                .font(.title2)
            
//            ColorPicker(<#T##title: StringProtocol##StringProtocol#>, selection: <#T##Binding<CGColor>#>)
            // try await droidOperator.changeLEDColor(to: .green)
        }
    }
}
