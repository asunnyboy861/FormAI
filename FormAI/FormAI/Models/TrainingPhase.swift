import Foundation
import SwiftData

@Model
final class TrainingPhase {
    var id: UUID
    var phaseType: PhaseType
    var weekNumber: Int
    var totalWeeks: Int
    var repRangeLower: Int
    var repRangeUpper: Int
    var rpeTarget: Int
    var trainingPlan: TrainingPlan?

    init(
        phaseType: PhaseType = .foundation,
        weekNumber: Int = 1,
        totalWeeks: Int = 4,
        repRangeLower: Int = 8,
        repRangeUpper: Int = 12,
        rpeTarget: Int = 7
    ) {
        self.id = UUID()
        self.phaseType = phaseType
        self.weekNumber = weekNumber
        self.totalWeeks = totalWeeks
        self.repRangeLower = repRangeLower
        self.repRangeUpper = repRangeUpper
        self.rpeTarget = rpeTarget
    }

    var repRange: ClosedRange<Int> {
        repRangeLower...repRangeUpper
    }
}
