//
//  DroidApp.swift
//
//
//  Created by h.crane on 2022/09/17.
//

import SwiftUI
import PlaygroundTester

/*
 If you want to check the debug screen, please remove the code comment out and build.
 */
//@main
struct DroidApp: App {
    
    init() {
        PlaygroundTester.PlaygroundTesterConfiguration.isTesting = false
    }
    
    var body: some Scene {
        WindowGroup {
            PlaygroundTester.PlaygroundTesterWrapperView {
                DroidKitDebugView()
            }
        }
    }
}
