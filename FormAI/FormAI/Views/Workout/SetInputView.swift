import SwiftUI

struct SetInputView: View {
    @Bindable var set: SetRecord
    let setIndex: Int
    let exerciseIndex: Int
    let viewModel: WorkoutViewModel

    @State private var weightText: String = ""
    @State private var repsText: String = ""

    var body: some View {
        HStack(spacing: 12) {
            Text("Set \(setIndex + 1)")
                .font(.caption.bold())
                .frame(width: 40, alignment: .leading)

            HStack(spacing: 4) {
                TextField("0", text: $weightText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
                    .onChange(of: weightText) { _, newValue in
                        if let w = Double(newValue) {
                            viewModel.updateSet(exerciseIndex: exerciseIndex, setIndex: setIndex, weight: w, reps: set.completedReps, rpe: set.actualRPE)
                        }
                    }
                Text("lbs")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 4) {
                TextField("\(set.targetReps)", text: $repsText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 44)
                    .onChange(of: repsText) { _, newValue in
                        if let r = Int(newValue) {
                            viewModel.updateSet(exerciseIndex: exerciseIndex, setIndex: setIndex, weight: set.weight, reps: r, rpe: set.actualRPE)
                        }
                    }
                Text("reps")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if set.completedReps >= set.targetReps && set.completedReps > 0 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else if set.completedReps > 0 {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.orange)
            }
        }
        .onAppear {
            weightText = set.weight > 0 ? String(format: "%.0f", set.weight) : ""
            repsText = set.completedReps > 0 ? "\(set.completedReps)" : ""
        }
    }
}
