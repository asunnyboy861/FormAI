import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var dayType: DayType
    var effort: EffortLevel?
    var totalVolume: Double
    var notes: String
    @Relationship(deleteRule: .cascade, inverse: \ExerciseRecord.workoutSession)
    var exercises: [ExerciseRecord]
    var readinessScore: ReadinessScore?

    init(
        date: Date = Date(),
        duration: TimeInterval = 0,
        dayType: DayType = .fullBody,
        effort: EffortLevel? = nil,
        totalVolume: Double = 0,
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.dayType = dayType
        self.effort = effort
        self.totalVolume = totalVolume
        self.notes = notes
        self.exercises = []
    }
}
