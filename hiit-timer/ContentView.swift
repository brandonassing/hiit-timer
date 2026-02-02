//
//  ContentView.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import SwiftUI

struct ContentView: View {
    @State private var workoutConfig: WorkoutConfig?
    
    var body: some View {
        Group {
            if let config = workoutConfig {
                TimerView(workoutConfig: config) {
                    workoutConfig = nil
                }
            } else {
                InputView(workoutConfig: $workoutConfig)
            }
        }
    }
}

#Preview {
    ContentView()
}
