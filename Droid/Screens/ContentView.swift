import SwiftUI

struct ContentView: View {
    var droidOperator: DroidOperatorProtocol = DroidOperator.default
    
    var body: some View {
        VStack {
            Button("connect") {
                Task {
                    do {
                        try await droidOperator.connect()
                        
                        try await droidOperator.playSound(.s4)
                        try await droidOperator.changeLEDColor(to: .green)
                        try await droidOperator.turn(by: 15)
                        try await droidOperator.go(at: 0.5)
                        droidOperator.wait(for: 1)
                        try await droidOperator.back(at: 0.5)
                        droidOperator.wait(for: 1)
                        try await droidOperator.stop(.move)
                        try await droidOperator.stop(.turn)
                    } catch {
                        debugPrint("connect error: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            
            Button("disconnect") {
                Task {
                    do {
                        try await droidOperator.disconnect()
                    } catch {
                        debugPrint("disconnect error: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
        }
//        .onReceive(droidOperator.eventPublisher) {
//            switch $0 {
//            case .didUpdateState(let state):
//                debugPrint("didUpdateState: \(state)")
//            case .willRestoreState(let state):
//                debugPrint("willRestoreState: \(state)")
//            case .didConnectPeripheral(let peripheral):
//                debugPrint("didConnectPeripheral: \(peripheral)")
//            case .didDisconnectPeripheral(let peripheral, let error):
//                debugPrint("didDisconnectPeripheral: \(peripheral), \(String(describing: error))")
//            }
//        }
    }
}
