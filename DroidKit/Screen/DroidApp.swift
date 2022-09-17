//
//  DroidApp.swift
//
//
//  Created by h.tsuruta on 2022/09/17.
//

#if DEBUG

import SwiftUI

/*
 If you want to check the debug screen, please remove the code comment out and build.
 */
// @main
struct DroidApp: App {
    
    var body: some Scene {
        WindowGroup {
            DroidKitDebugView()
        }
    }
}

#endif
