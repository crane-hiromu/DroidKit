# DroidKit

## Description

### - Do you know **'Droid Inventor Kit'** ?

![littlebits-box-1-1024x686](https://user-images.githubusercontent.com/24838521/190877953-560dd403-e13f-4e0d-a3af-90ebd0cf1393.jpeg)


(Quote: [‘TURN EVERYONE INTO AN INVENTOR’: THE STORY OF THE LITTLEBITS DROID INVENTOR KIT](https://www.starwars.com/news/turn-everyone-into-an-inventor-the-story-of-the-littlebits-droid-inventor-kit))

<br>

**'Droid Inventor Kit'** is a kit to create a droid. 
In addition, the droid can be operated with simple programming from a smartphone.
However, there is a problem. 
Currently, [the app has been removed from the store and cannot be installed](https://community.sphero.com/t/droid-inventor-kit-app-gone-from-play-app-store/2783).
So I decided to provide code that can operate the droid from **Swift**.
In short, you can create your own application with this **Swift** package.

<br>

### - Sample Screen

|App|Color Picker|Sound Menu|
|:---:|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/24838521/190878634-ed828063-3215-4d18-9ce6-9493b13994e8.png" width=300>|<img src="https://user-images.githubusercontent.com/24838521/190878637-d149a8e2-14af-4622-80a2-54e416aa2959.png" width=300>|<img src="https://user-images.githubusercontent.com/24838521/190878640-acd9968e-4a0d-4a8d-93eb-ae166510b08c.png" width=300>|

<br>

You can check the operation on [`DroidKitDebugView`](https://github.com/crane-hiromu/DroidKit/blob/main/Sources/DroidKit/View/DroidKitDebugView.swift).

```.swift
import SwiftUI
import DroidKit

struct ContentView: View {
    
    var body: some View {
        DroidKitDebugView()
    }
}
```


<br>

## Code

There are 2 core code in this package.

Inspired by [tinkertanker/DroidKit](https://github.com/tinkertanker/DroidKit) and are also built on a **'Concurrency'** basis with [AsyncBluetooth](https://github.com/manolofdez/AsyncBluetooth).

### - DroidConnector.swift

```.swift
public protocol DroidConnectorProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    
    /// CentralManager Method
    func scan() async throws
    func connect() async throws
    func disconnect() async throws
    
    /// Peripheral Method
    func discoverServices() async throws
    func discoverCharacteristics() async throws
    func setNotifyValue(with characteristic: Characteristic) async throws
    func setNotifyValues() async throws
    func writeValue(command: UInt8, payload: [UInt8]) async throws
}
```

This code contains the implementation around **Bluetooth**. You can access it, but basically you don't have to do it.

### - DroidOperator.swift

```.swift
public protocol DroidOperatorProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    
    /// Connection Method
    func connect() async throws
    func disconnect() async throws
    
    /// Action Method
    func action(command: DroidCommand, payload: [UInt8]) async throws
    func go(at speed: Double) async throws
    func back(at speed: Double) async throws
    func turn(by degree: Double) async throws
    func stop(_ type: DroidWheel) async throws
    func changeLEDColor(to color: UIColor) async throws
    func playSound(_ type: DroidSound) async throws
    func wait(for seconds: Double) async throws
}
```

This code contains the implementation around droid operation. You can operate droid.

<br>

## Document

The following actions can be used.

### - connect

Turn on the connection.

```.swift
Task {
    do {
        try await DroidOperator.default.connect()
    } catch {
        // catch error
    }
}
```

### - disconnect

Turn off the connection.

```.swift
Task {
    do {
        try await DroidOperator.default.disconnect()
    } catch {
        // catch error
    }
}
```

### - go

Move forward.

```.swift
Task {
    do {
        try await DroidOperator.default.go(at: 0.7)
    } catch {
        // catch error
    }
}
```

### - back

Move back.

```.swift
Task {
    do {
        try await DroidOperator.default.back(at: 0.3)
    } catch {
        // catch error
    }
}
```

### - turn

Turn towards.

```.swift
Task {
    do {
        try await DroidOperator.default.turn(by: 30)
    } catch {
        // catch error
    }
}
```

### - stop

Stop moving.

```.swift
Task {
    do {
        try await DroidOperator.default.stop(.move)
    } catch {
        // catch error
    }
}
```

### - changeLEDColor

Change body's LED ramp color.

```.swift
Task {
    do {
        try await DroidOperator.default.changeLEDColor(to: .blue)
    } catch {
        // catch error
    }
}
```

### - playSound

Play sound from droid.

```.swift
Task {
    do {
        try await DroidOperator.default.playSound(.s10)
    } catch {
        // catch error
    }
}
```

### - wait

Keep the action.

```.swift
Task {
    do {
        try await DroidOperator.default.go(at: 0.7)
        try await DroidOperator.default.wait(for: 2)
        try await DroidOperator.default.stop(.move)
    } catch {
        // catch error
    }
}
```

<br>

## Swift Package Manager

Add the following dependency to your Package.swift file:

```
.package(url: "https://github.com/crane-hiromu/DroidKit", "2.0.1"..<"3.0.0")
```

<br>

## License

MIT, of course ;-) See the LICENSE file.

