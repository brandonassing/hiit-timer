//
//  TimerView.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    let workoutConfig: WorkoutConfig
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Set and Exercise Info
                HStack(spacing: 30) {
                    VStack {
                        Text("SET")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(viewModel.currentSet)/\(viewModel.totalSets)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    if viewModel.currentPhase == .exercise {
                        VStack {
                            Text("EXERCISE")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("\(viewModel.currentExerciseIndex + 1)/\(viewModel.totalExercises)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Main Timer Display
                VStack(spacing: 20) {
                    if viewModel.currentPhase == .exercise && !viewModel.currentExerciseName.isEmpty {
                        Text(viewModel.currentExerciseName)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    } else if viewModel.currentPhase == .rest {
                        Text("REST")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.yellow)
                    } else if viewModel.currentPhase == .countdown {
                        Text("GET READY")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    } else if viewModel.currentPhase == .complete {
                        Text("WORKOUT COMPLETE")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    Text(viewModel.displayText)
                        .font(.system(size: 120, weight: .bold, design: .rounded))
                        .foregroundColor(viewModel.isInLastThreeSeconds ? .red : .white)
                        .monospacedDigit()
                    
                    // Show next exercise info
                    if let nextExercise = viewModel.nextExerciseName,
                       (viewModel.currentPhase == .exercise || viewModel.currentPhase == .rest) {
                        Text("Next: \(nextExercise)")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                }
                
                Spacer()
                
                // Complete button (only shown when workout is done)
                if viewModel.currentPhase == .complete {
                    Button(action: onComplete) {
                        Text("BACK TO SETUP")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            viewModel.startWorkout(config: workoutConfig)
        }
        .onDisappear {
            viewModel.stop()
        }
        .orientationLock(.portrait)
    }
}

#Preview {
    let config = WorkoutConfig(
        exercises: [
            Exercise(name: "Jumping Jacks", duration: 30),
            Exercise(name: "Push Ups", duration: 30)
        ],
        numberOfSets: 2,
        restTime: 30
    )
    TimerView(workoutConfig: config, onComplete: {})
}

