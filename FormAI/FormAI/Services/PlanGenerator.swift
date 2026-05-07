import Foundation
import SwiftData

struct PlanGenerator {
    static func generatePlan(
        name: String,
        goal: TrainingGoal,
        split: TrainingSplit,
        daysPerWeek: Int,
        experienceLevel: ExperienceLevel
    ) -> TrainingPlan {
        let dayTypes = generateDayTypes(for: split, daysPerWeek: daysPerWeek)
        let totalWeeks = experienceLevel == .beginner ? 8 : 12

        let plan = TrainingPlan(
            name: name,
            goal: goal,
            split: split,
            daysPerWeek: daysPerWeek,
            totalWeeks: totalWeeks,
            currentWeek: 1,
            isActive: true,
            dayTypes: dayTypes
        )

        let phases = generatePhases(totalWeeks: totalWeeks, goal: goal)
        plan.phases = phases

        return plan
    }

    static func generateDayTypes(for split: TrainingSplit, daysPerWeek: Int) -> [DayType] {
        switch split {
        case .fullBody3x:
            return [.fullBody, .rest, .fullBody, .rest, .fullBody, .rest, .rest]
        case .upperLower:
            return [.upper, .lower, .rest, .upper, .lower, .rest, .rest]
        case .ppl:
            return [.push, .pull, .legs, .push, .pull, .legs, .rest]
        case .custom:
            return Array(repeating: .fullBody, count: 7)
        }
    }

    static func generatePhases(totalWeeks: Int, goal: TrainingGoal) -> [TrainingPhase] {
        var phases: [TrainingPhase] = []

        let foundationWeeks = max(totalWeeks / 4, 2)
        let buildWeeks = max(totalWeeks / 2, 4)
        let peakWeeks = max(totalWeeks / 6, 1)
        let deloadWeeks = 1

        var currentWeek = 1

        phases.append(TrainingPhase(
            phaseType: .foundation,
            weekNumber: currentWeek,
            totalWeeks: foundationWeeks,
            repRangeLower: goal == .strength ? 5 : 8,
            repRangeUpper: goal == .strength ? 8 : 12,
            rpeTarget: 7
        ))
        currentWeek += foundationWeeks

        phases.append(TrainingPhase(
            phaseType: .build,
            weekNumber: currentWeek,
            totalWeeks: buildWeeks,
            repRangeLower: goal == .strength ? 3 : 6,
            repRangeUpper: goal == .strength ? 6 : 10,
            rpeTarget: 8
        ))
        currentWeek += buildWeeks

        phases.append(TrainingPhase(
            phaseType: .peak,
            weekNumber: currentWeek,
            totalWeeks: peakWeeks,
            repRangeLower: goal == .strength ? 1 : 4,
            repRangeUpper: goal == .strength ? 5 : 8,
            rpeTarget: 9
        ))
        currentWeek += peakWeeks

        phases.append(TrainingPhase(
            phaseType: .deload,
            weekNumber: currentWeek,
            totalWeeks: deloadWeeks,
            repRangeLower: 8,
            repRangeUpper: 12,
            rpeTarget: 5
        ))

        return phases
    }

    static func exercisesForDayType(_ dayType: DayType) -> [(String, MuscleGroup, Equipment)] {
        switch dayType {
        case .upper:
            return [
                ("Bench Press", .chest, .barbell),
                ("Barbell Row", .back, .barbell),
                ("Overhead Press", .shoulders, .barbell),
                ("Lat Pulldown", .back, .cable),
                ("Bicep Curl", .biceps, .dumbbell),
                ("Tricep Pushdown", .triceps, .cable),
            ]
        case .lower:
            return [
                ("Squat", .quads, .barbell),
                ("Romanian Deadlift", .hamstrings, .barbell),
                ("Leg Press", .quads, .machine),
                ("Leg Curl", .hamstrings, .machine),
                ("Hip Thrust", .glutes, .barbell),
                ("Calf Raise", .calves, .machine),
            ]
        case .push:
            return [
                ("Bench Press", .chest, .barbell),
                ("Overhead Press", .shoulders, .barbell),
                ("Incline Bench Press", .chest, .barbell),
                ("Lateral Raise", .shoulders, .dumbbell),
                ("Tricep Pushdown", .triceps, .cable),
                ("Dip", .triceps, .bodyweight),
            ]
        case .pull:
            return [
                ("Barbell Row", .back, .barbell),
                ("Pull-Up", .back, .bodyweight),
                ("Face Pull", .shoulders, .cable),
                ("Bicep Curl", .biceps, .dumbbell),
                ("Hammer Curl", .biceps, .dumbbell),
                ("Cable Fly", .chest, .cable),
            ]
        case .legs:
            return [
                ("Squat", .quads, .barbell),
                ("Romanian Deadlift", .hamstrings, .barbell),
                ("Leg Press", .quads, .machine),
                ("Leg Curl", .hamstrings, .machine),
                ("Hip Thrust", .glutes, .barbell),
                ("Calf Raise", .calves, .machine),
            ]
        case .fullBody:
            return [
                ("Squat", .quads, .barbell),
                ("Bench Press", .chest, .barbell),
                ("Barbell Row", .back, .barbell),
                ("Overhead Press", .shoulders, .barbell),
                ("Plank", .core, .bodyweight),
            ]
        case .rest, .mobility:
            return []
        }
    }
}
