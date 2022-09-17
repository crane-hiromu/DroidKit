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
        .font(.system(size: 16, weight: .bold, design: .default))
        .frame(width: 110, height: 44)
        .background(.white)
        .cornerRadius(8)
    }
}
