//
//  WorkoutConfig.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import Foundation

struct WorkoutConfig {
    let exercises: [Exercise]
    let numberOfSets: Int
    let restTime: Int // in seconds
    
    init(exercises: [Exercise], numberOfSets: Int, restTime: Int) {
        self.exercises = exercises
        self.numberOfSets = numberOfSets
        self.restTime = restTime
    }
}

