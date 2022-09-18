//
//  DroidKitDebugView.swift
//
//
//  Created by h.crane on 2022/09/17.
//

import SwiftUI

// MARK: - View
public struct DroidKitDebugView: View {
    private let droidOperator: DroidOperatorProtocol
    @State private var speed: Double
    @State private var duration: Double
    @State private var degree: Double
    @State private var color: Color
    @State private var soundType: DroidSound
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                connectionSection
                movementSection
                rotationSection
                colorSection
                soundSection
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
        .background(Color.black)
    }
    
    public init(
        droidOperator: DroidOperatorProtocol = DroidOperator.default,
        speed: Double = 0.5,
        duration: Double = 1.5,
        degree: Double = 90,
        color: Color = .clear,
        soundType: DroidSound = .s0
    ) {
        self.droidOperator = droidOperator
        self.speed = speed
        self.duration = duration
        self.degree = degree
        self.color = color
        self.soundType = soundType
    }
}

// MARKL - Private
private extension DroidKitDebugView {
    
    var connectionSection: some View {
        VStack(spacing: 16) {
            DroidKitSectionTitle(title: "Connection")
            
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
            DroidKitSectionTitle(title: "Movement")
            DroidKitSliderRow(
                label: "Speed: \(String(format:"%.1f", speed))",
                value: $speed,
                range: 0...1,
                step: 0.1
            )
            DroidKitSliderRow(
                label: "Duration: \(String(format:"%.1f", duration))",
                value: $duration,
                range: 0...5,
                step: 0.1
            )
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
            DroidKitSectionTitle(title: "Rotation")
            DroidKitSliderRow(
                label: "Degree: \(String(format:"%.f", degree))°",
                value: $degree,
                range: 0...180,
                step: 1
            )
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
    
    var colorSection: some View {
        VStack(spacing: 16) {
            DroidKitSectionTitle(title: "Color")
            DroidKitColorPickerRow(color: $color)
            HStack(spacing: 16) {
                DroidKitActionButton(title: "Set") {
                    try await droidOperator.changeLEDColor(to: color.asUIColor)
                }
                DroidKitActionButton(title: "Reset") {
                    color = .clear
                    try await droidOperator.changeLEDColor(to: .clear)
                }
            }
        }
    }
    
    var soundSection: some View {
        VStack(spacing: 16) {
            DroidKitSectionTitle(title: "Sound")
            DroidKitMenuRow(soundType: soundType) { type in
                guard let command = DroidSound(rawValue: type.rawValue) else { return }
                try await droidOperator.playSound(command)
                soundType = type
            }
        }
    }
}
