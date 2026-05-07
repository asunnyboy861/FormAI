import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WorkoutViewModel()
    @State private var showingFinishAlert = false
    @State private var selectedEffort: EffortLevel = .moderate

    let dayType: DayType

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                timerBar
                if viewModel.isWorkoutActive {
                    workoutContent
                } else {
                    workoutCompleteView
                }
            }
            .navigationTitle(viewModel.isWorkoutActive ? dayType.rawValue : "Workout Complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.isWorkoutActive {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { viewModel.cancelWorkout(modelContext: modelContext); dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Finish") { showingFinishAlert = true }
                    }
                } else {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
            }
            .alert("How was it?", isPresented: $showingFinishAlert) {
                ForEach(EffortLevel.allCases, id: \.self) { level in
                    Button(level.label) {
                        selectedEffort = level
                        viewModel.finishWorkout(effort: level, modelContext: modelContext)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .onAppear {
                if !viewModel.isWorkoutActive {
                    viewModel.startWorkout(dayType: dayType, modelContext: modelContext)
                }
            }
        }
    }

    private var timerBar: some View {
        HStack {
            Image(systemName: "clock")
            Text(viewModel.formattedElapsedTime)
                .font(.system(.title3, design: .monospaced))
                .bold()
            Spacer()
            if viewModel.isWorkoutActive, let session = viewModel.currentSession {
                Text("\(session.exercises.count) exercises")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }

    private var workoutContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let session = viewModel.currentSession {
                    ForEach(Array(session.exercises.enumerated()), id: \.element.id) { exerciseIndex, exercise in
                        ExerciseRowView(
                            exercise: exercise,
                            exerciseIndex: exerciseIndex,
                            viewModel: viewModel
                        )
                    }
                }
            }
            .padding()
        }
    }

    private var workoutCompleteView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            Text("Great workout!")
                .font(.title.bold())
            if let session = viewModel.currentSession {
                VStack(spacing: 8) {
                    Label("\(Int(session.totalVolume)) lbs volume", systemImage: "chart.bar")
                    Label("\(Int(session.duration / 60)) min", systemImage: "clock")
                    if let effort = session.effort {
                        Label("Effort: \(effort.label)", systemImage: "flame")
                    }
                }
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
