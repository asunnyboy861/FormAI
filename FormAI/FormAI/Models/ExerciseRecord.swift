import Foundation
import SwiftData

@Model
final class ExerciseRecord {
    var id: UUID
    var exerciseName: String
    var muscleGroup: MuscleGroup
    var equipment: Equipment
    var order: Int
    var notes: String
    @Relationship(deleteRule: .cascade, inverse: \SetRecord.exerciseRecord)
    var sets: [SetRecord]
    var workoutSession: WorkoutSession?

    init(
        exerciseName: String = "",
        muscleGroup: MuscleGroup = .chest,
        equipment: Equipment = .barbell,
        order: Int = 0,
        notes: String = ""
    ) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.equipment = equipment
        self.order = order
        self.notes = notes
        self.sets = []
    }
}
