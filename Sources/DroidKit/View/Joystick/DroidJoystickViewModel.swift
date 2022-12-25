//
//  JoystickViewModel.swift
//
//
//  Created by h.tsuruta on 2022/12/25.
//

import SwiftUI
import Combine
import SwiftUIJoystick
import CombineAsyncable

// MARK: - ViewModel
@available(iOS 15.0, *)
final class DroidJoystickViewModel: ObservableObject {
    
    // MARK: Property
    
    let input: Input
    let output: Output
    let binding: Binding
    
    private let droidOperator: DroidOperatorProtocol
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject var monitor = JoystickMonitor()
    
    // MARK: Initializer
    
    init(
        input: Input = .init(),
        output: Output = .init(),
        binding: Binding = .init(),
        droidOperator: DroidOperatorProtocol = DroidOperator.default
    ) {
        self.input = input
        self.output = output
        self.binding = binding
        self.droidOperator = droidOperator
        
        bind(input: input,
             output: output,
             binding: binding)
    }
    
}

// MARK: - Class
@available(iOS 15.0, *)
extension DroidJoystickViewModel {
    
    final class Input {
        // NOP
    }
    
    final class Output {
        let radius: CGFloat = 100
    }
    
    final class Binding {
        // NOP
    }
}

// MARK: - Private
@available(iOS 15.0, *)
private extension DroidJoystickViewModel {
    
    func bind(
        input: Input,
        output: Output,
        binding: Binding
    ) {
        monitor.$xyPoint
            .map { (radius: output.radius, point: $0) }
            .map(DroidWheelMovementAction.joystick(params:))
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .asyncSinkWithThrows(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    try await self?.move(type: $0)
                }
            )
            .store(in: &cancellables)

        monitor.$xyPoint
            .map(DroidWheelTurnAction.joystick(point:))
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .asyncSinkWithThrows(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    try await self?.turn(type: $0)
                }
            )
            .store(in: &cancellables)

        monitor
            .objectWillChange
            .sink { self.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    func move(type: DroidWheelMovementAction) async throws {
        switch type {
        case .go(let speed):   try await droidOperator.go(at: speed)
        case .back(let speed): try await droidOperator.back(at: speed)
        case .end:             try await droidOperator.stop()
        }
    }
    
    func turn(type: DroidWheelTurnAction) async throws {
        switch type {
        case .turn(let degree): try await self.droidOperator.turn(by: degree)
        case .end:              try await self.droidOperator.endTurn()
        }
    }
}
