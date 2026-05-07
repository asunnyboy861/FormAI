import Foundation

struct AdaptiveProgressionService {
    struct ProgressionSuggestion {
        let targetWeight: Double
        let targetReps: Int
        let targetSets: Int
        let targetRPE: Int
        let reasoning: String
    }

    static func suggestNextWorkout(
        exerciseName: String,
        startingWeight: Double?,
        lastSessionRecords: [SetRecord],
        adjustment: ReadinessEngine.TrainingAdjustment,
        repRange: ClosedRange<Int>
    ) -> ProgressionSuggestion {
        guard let bestSet = lastSessionRecords.max(by: { $0.weight < $1.weight }) else {
            return ProgressionSuggestion(
                targetWeight: startingWeight ?? 45.0,
                targetReps: repRange.lowerBound,
                targetSets: 3,
                targetRPE: 7,
                reasoning: "Starting with baseline weight for new exercise."
            )
        }

        let baseWeight = bestSet.weight
        let baseReps = bestSet.completedReps
        let weightIncrement = calculateWeightIncrement(for: baseWeight)
        let volumeMultiplier = adjustment.volumeMultiplier
        let intensityMultiplier = adjustment.intensityMultiplier
        let rpeAdjustment = adjustment.rpeAdjustment

        var targetReps: Int
        var targetWeight: Double
        var targetSets: Int
        var targetRPE: Int
        var reasoning: String

        if baseReps >= repRange.upperBound {
            targetWeight = baseWeight + weightIncrement
            targetReps = repRange.lowerBound
            reasoning = "You hit \(baseReps) reps at \(formatWeight(baseWeight)) — increasing weight by \(formatWeight(weightIncrement))."
        } else if baseReps >= repRange.lowerBound {
            targetWeight = baseWeight
            targetReps = baseReps + 1
            reasoning = "Adding one rep at \(formatWeight(baseWeight)). Keep pushing!"
        } else {
            targetWeight = baseWeight
            targetReps = repRange.lowerBound
            reasoning = "Re-targeting \(repRange.lowerBound) reps at \(formatWeight(baseWeight))."
        }

        targetWeight = max(targetWeight * intensityMultiplier, 0)
        targetSets = max(Int(Double(3) * volumeMultiplier), 1)
        targetRPE = min(max(7 + rpeAdjustment, 1), 10)

        if adjustment != .maintain {
            reasoning += " " + adjustment.description
        }

        return ProgressionSuggestion(
            targetWeight: targetWeight,
            targetReps: targetReps,
            targetSets: targetSets,
            targetRPE: targetRPE,
            reasoning: reasoning
        )
    }

    static func calculateWeightIncrement(for currentWeight: Double) -> Double {
        if currentWeight >= 100 { return 5.0 }
        if currentWeight >= 50 { return 2.5 }
        return 2.5
    }

    static func formatWeight(_ weight: Double) -> String {
        if weight == floor(weight) {
            return "\(Int(weight))"
        }
        return String(format: "%.1f", weight)
    }
}
