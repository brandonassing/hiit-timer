//
//  InputView.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import SwiftUI

struct InputView: View {
    @StateObject private var viewModel = InputViewModel()
    @Binding var workoutConfig: WorkoutConfig?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercises")) {
                    ForEach(viewModel.exercises) { exercise in
                        ExerciseInputRow(
                            exercise: exercise,
                            canRemove: viewModel.exercises.count > 1,
                            onRemove: {
                                if let index = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) {
                                    viewModel.removeExercise(at: index)
                                }
                            }
                        )
                    }
                    
                    Button(action: {
                        viewModel.addExercise()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Exercise")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Sets")) {
                    Stepper("Number of Sets: \(viewModel.numberOfSets)", value: $viewModel.numberOfSets, in: 1...10)
                }
                
                if viewModel.numberOfSets > 1 {
                    Section(header: Text("Rest Between Sets")) {
                        HStack {
                            Text("Rest Time")
                            Spacer()
                            Picker("Rest Time", selection: $viewModel.restTime) {
                                ForEach([10, 15, 20, 30, 45, 60, 90, 120], id: \.self) { seconds in
                                    Text("\(seconds)s").tag(seconds)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        if viewModel.isValid() {
                            workoutConfig = viewModel.createWorkoutConfig()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("START")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(viewModel.isValid() ? Color.green : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!viewModel.isValid())
                }
            }
            .navigationTitle("HIIT Timer")
        }
        .orientationLock(.portrait)
    }
}

struct ExerciseInputRow: View {
    @ObservedObject var exercise: ExerciseItem
    let canRemove: Bool
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Exercise Name", text: $exercise.name)
                    .textFieldStyle(.roundedBorder)
                
                if canRemove {
                    Button(action: onRemove) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            
            HStack {
                Text("Duration:")
                Spacer()
                Picker("Duration", selection: $exercise.duration) {
                    ForEach([10, 15, 20, 30, 45, 60, 90, 120], id: \.self) { seconds in
                        Text("\(seconds)s").tag(seconds)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InputView(workoutConfig: .constant(nil))
}

