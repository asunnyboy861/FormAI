import Foundation
import SwiftData

@Model
final class SetRecord {
    var id: UUID
    var weight: Double
    var targetReps: Int
    var completedReps: Int
    var targetRPE: Int
    var actualRPE: Int?
    var isWarmup: Bool
    var exerciseRecord: ExerciseRecord?

    init(
        weight: Double = 0,
        targetReps: Int = 8,
        completedReps: Int = 0,
        targetRPE: Int = 7,
        actualRPE: Int? = nil,
        isWarmup: Bool = false
    ) {
        self.id = UUID()
        self.weight = weight
        self.targetReps = targetReps
        self.completedReps = completedReps
        self.targetRPE = targetRPE
        self.actualRPE = actualRPE
        self.isWarmup = isWarmup
    }
}
