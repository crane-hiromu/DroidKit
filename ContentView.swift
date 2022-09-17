import SwiftUI

struct ContentView: View {
    var manager: DroidManagerProtocol = DroidManager.default
    
    var body: some View {
        VStack {
            Button("connect") {
                Task {
                    do {
                        try await manager.configure()
                        
                        try await manager.playSound(.s4)
//                        try await manager.changeLEDColor(to: .green)
//                        try await manager.turnWheel(by: .degrees(0))
//                        try await manager.stopWheel()
                        try await manager.go(at: 0.5)
                        manager.wait(for: 1)
                        try await manager.back(at: 0.5)
                        manager.wait(for: 1)
                        try await manager.stop(.move)
                    } catch {
                        debugPrint("connect error: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            
            Button("disconnect") {
                Task {
                    do {
                        try await manager.disconnect()
                    } catch {
                        debugPrint("disconnect error: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
        }
//        .onReceive(manager.eventPublisher) {
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
