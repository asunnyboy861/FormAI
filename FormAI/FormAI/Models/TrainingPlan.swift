import Foundation
import SwiftData

@Model
final class TrainingPlan {
    var id: UUID
    var name: String
    var goal: TrainingGoal
    var split: TrainingSplit
    var daysPerWeek: Int
    var totalWeeks: Int
    var currentWeek: Int
    var isActive: Bool
    var createdAt: Date
    var dayTypes: [DayType]
    @Relationship(deleteRule: .cascade, inverse: \TrainingPhase.trainingPlan)
    var phases: [TrainingPhase]

    init(
        name: String = "My Plan",
        goal: TrainingGoal = .strength,
        split: TrainingSplit = .upperLower,
        daysPerWeek: Int = 4,
        totalWeeks: Int = 12,
        currentWeek: Int = 1,
        isActive: Bool = true,
        dayTypes: [DayType] = [.upper, .lower, .rest, .upper, .lower, .rest, .rest]
    ) {
        self.id = UUID()
        self.name = name
        self.goal = goal
        self.split = split
        self.daysPerWeek = daysPerWeek
        self.totalWeeks = totalWeeks
        self.currentWeek = currentWeek
        self.isActive = isActive
        self.createdAt = Date()
        self.dayTypes = dayTypes
        self.phases = []
    }

    var currentPhase: TrainingPhase? {
        phases.first { $0.weekNumber <= currentWeek && currentWeek < $0.weekNumber + $0.totalWeeks }
    }
}
