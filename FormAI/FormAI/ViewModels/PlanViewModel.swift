import Foundation
import SwiftData

@Observable
final class PlanViewModel {
    var activePlan: TrainingPlan?
    var showingPlanCreator: Bool = false

    func loadActivePlan(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<TrainingPlan>(
            predicate: #Predicate { $0.isActive },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        activePlan = try? modelContext.fetch(descriptor).first
    }

    func createPlan(
        name: String,
        goal: TrainingGoal,
        split: TrainingSplit,
        daysPerWeek: Int,
        experienceLevel: ExperienceLevel,
        modelContext: ModelContext
    ) {
        if let existing = activePlan {
            existing.isActive = false
        }
        let plan = PlanGenerator.generatePlan(
            name: name,
            goal: goal,
            split: split,
            daysPerWeek: daysPerWeek,
            experienceLevel: experienceLevel
        )
        modelContext.insert(plan)
        try? modelContext.save()
        activePlan = plan
        showingPlanCreator = false
    }

    func todayDayType() -> DayType {
        guard let plan = activePlan else { return .rest }
        let weekday = Calendar.current.component(.weekday, from: Date())
        let index = (weekday + 5) % 7
        guard index < plan.dayTypes.count else { return .rest }
        return plan.dayTypes[index]
    }

    func weekSchedule() -> [(day: String, type: DayType, isToday: Bool)] {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let todayWeekday = Calendar.current.component(.weekday, from: Date())
        let todayIndex = (todayWeekday + 5) % 7

        guard let plan = activePlan else {
            return days.enumerated().map { (i, day) in (day: day, type: .rest, isToday: i == todayIndex) }
        }

        return days.enumerated().map { (i, day) in
            let type = i < plan.dayTypes.count ? plan.dayTypes[i] : .rest
            return (day: day, type: type, isToday: i == todayIndex)
        }
    }
}
