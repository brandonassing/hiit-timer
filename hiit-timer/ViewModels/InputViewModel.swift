//
//  InputViewModel.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import Foundation
import SwiftUI

class ExerciseItem: ObservableObject, Identifiable {
    let id: UUID
    @Published var name: String
    @Published var duration: Int
    
    init(id: UUID = UUID(), name: String, duration: Int) {
        self.id = id
        self.name = name
        self.duration = duration
    }
}

class InputViewModel: ObservableObject {
    @Published var exercises: [ExerciseItem] = []
    @Published var numberOfSets: Int = 1
    @Published var restTime: Int = 30
    
    init() {
        // Initialize with one default exercise
        addExercise()
    }
    
    func addExercise() {
        let exerciseNumber = exercises.count + 1
        let newExercise = ExerciseItem(
            name: "Exercise \(exerciseNumber)",
            duration: 30
        )
        exercises.append(newExercise)
    }
    
    func removeExercise(at index: Int) {
        guard index >= 0 && index < exercises.count && exercises.count > 1 else { return }
        exercises.remove(at: index)
    }
    
    func updateExercise(at index: Int, name: String, duration: Int) {
        guard index >= 0 && index < exercises.count else { return }
        exercises[index].name = name
        exercises[index].duration = duration
    }
    
    func isValid() -> Bool {
        return !exercises.isEmpty && 
               exercises.allSatisfy { $0.duration > 0 } &&
               numberOfSets > 0 &&
               (numberOfSets == 1 || restTime > 0)
    }
    
    func createWorkoutConfig() -> WorkoutConfig {
        let exerciseModels = exercises.map { exercise in
            Exercise(name: exercise.name, duration: exercise.duration)
        }
        return WorkoutConfig(
            exercises: exerciseModels,
            numberOfSets: numberOfSets,
            restTime: restTime
        )
    }
}

