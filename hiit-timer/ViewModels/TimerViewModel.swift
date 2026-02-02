//
//  TimerViewModel.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import Foundation
import SwiftUI
import Combine

enum WorkoutPhase {
    case countdown
    case exercise
    case rest
    case complete
}

class TimerViewModel: ObservableObject {
    @Published var currentPhase: WorkoutPhase = .countdown
    @Published var timeRemaining: Int = 5
    @Published var currentExerciseIndex: Int = 0
    @Published var currentSet: Int = 1
    @Published var currentExerciseName: String = ""
    
    private var workoutConfig: WorkoutConfig?
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    var totalSets: Int {
        return workoutConfig?.numberOfSets ?? 0
    }
    
    var totalExercises: Int {
        return workoutConfig?.exercises.count ?? 0
    }
    
    var nextExerciseName: String? {
        guard let config = workoutConfig else { return nil }
        
        switch currentPhase {
        case .exercise:
            // Show next exercise in current set
            let nextIndex = currentExerciseIndex + 1
            if nextIndex < config.exercises.count {
                return config.exercises[nextIndex].name
            }
            return nil
        case .rest:
            // Show first exercise of next set
            if currentSet < config.numberOfSets {
                return config.exercises.first?.name
            }
            return nil
        default:
            return nil
        }
    }
    
    var isInLastThreeSeconds: Bool {
        return (currentPhase == .exercise || currentPhase == .rest) && timeRemaining <= 3 && timeRemaining > 0
    }
    
    var isActive: Bool {
        return timer != nil && currentPhase != .complete
    }
    
    var displayText: String {
        switch currentPhase {
        case .countdown:
            return "\(timeRemaining)"
        case .exercise:
            return formatTime(timeRemaining)
        case .rest:
            return formatTime(timeRemaining)
        case .complete:
            return "DONE"
        }
    }
    
    func startWorkout(config: WorkoutConfig) {
        workoutConfig = config
        currentSet = 1
        currentExerciseIndex = 0
        currentPhase = .countdown
        timeRemaining = 5
        
        startCountdown()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        currentPhase = .complete
    }
    
    private func startCountdown() {
        timeRemaining = 5
        currentExerciseName = ""
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.checkAndPlayBeep()
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.startExercise()
            }
        }
    }
    
    private func startExercise() {
        guard let config = workoutConfig,
              currentExerciseIndex < config.exercises.count else {
            // All exercises in this set are done
            handleSetComplete()
            return
        }
        
        let exercise = config.exercises[currentExerciseIndex]
        currentExerciseName = exercise.name
        currentPhase = .exercise
        timeRemaining = exercise.duration
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.checkAndPlayBeep()
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.moveToNextExercise()
            }
        }
    }
    
    private func moveToNextExercise() {
        guard let config = workoutConfig else { return }
        
        currentExerciseIndex += 1
        
        if currentExerciseIndex >= config.exercises.count {
            // All exercises in this set are complete
            handleSetComplete()
        } else {
            // Move to next exercise immediately
            startExercise()
        }
    }
    
    private func handleSetComplete() {
        guard let config = workoutConfig else { return }
        
        // Check if there are more sets
        if currentSet < config.numberOfSets {
            // Start rest period
            startRest()
        } else {
            // All sets complete
            currentPhase = .complete
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startRest() {
        guard let config = workoutConfig else { return }
        
        currentExerciseName = "Rest"
        currentPhase = .rest
        timeRemaining = config.restTime
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.checkAndPlayBeep()
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                // Move to next set
                self.currentSet += 1
                self.currentExerciseIndex = 0
                self.startExercise()
            }
        }
    }
    
    private func checkAndPlayBeep() {
        // Play beep at 3, 2, and 1 seconds for exercise and rest phases
        if (currentPhase == .exercise || currentPhase == .rest) && timeRemaining <= 3 && timeRemaining > 0 {
            AudioHelper.playBeep()
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, secs)
        } else {
            return "\(secs)"
        }
    }
}

