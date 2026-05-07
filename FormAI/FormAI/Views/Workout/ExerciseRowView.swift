import SwiftUI

struct ExerciseRowView: View {
    let exercise: ExerciseRecord
    let exerciseIndex: Int
    let viewModel: WorkoutViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(hex: exercise.muscleGroup.colorHex) ?? .blue)
                    .frame(width: 10, height: 10)
                Text(exercise.exerciseName)
                    .font(.headline)
                Spacer()
                Text(exercise.equipment.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { setIndex, set in
                SetInputView(
                    set: set,
                    setIndex: setIndex,
                    exerciseIndex: exerciseIndex,
                    viewModel: viewModel
                )
            }

            Button {
                viewModel.addSet(to: exerciseIndex)
            } label: {
                Label("Add Set", systemImage: "plus.circle")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
