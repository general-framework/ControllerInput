//
//  ControllerInputExampleApp.swift
//  ControllerInputExample
//
//  Created by Jacob Martin on 3/31/23.
//

import SwiftUI
import GameController
import ControllerInput

@main
struct ControllerInputExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ControlHostView {
                ContentView()
            }
        }
    }
}
