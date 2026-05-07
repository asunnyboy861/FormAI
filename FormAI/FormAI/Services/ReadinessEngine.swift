import Foundation

struct ReadinessEngine {
    enum TrainingAdjustment: String, Codable {
        case scaleUp = "scaleUp"
        case maintain = "maintain"
        case scaleDown = "scaleDown"
        case deload = "deload"
        case rest = "rest"

        var volumeMultiplier: Double {
            switch self {
            case .scaleUp: 1.15
            case .maintain: 1.0
            case .scaleDown: 0.75
            case .deload: 0.5
            case .rest: 0.0
            }
        }

        var intensityMultiplier: Double {
            switch self {
            case .scaleUp: 1.05
            case .maintain: 1.0
            case .scaleDown: 0.85
            case .deload: 0.7
            case .rest: 0.0
            }
        }

        var rpeAdjustment: Int {
            switch self {
            case .scaleUp: 1
            case .maintain: 0
            case .scaleDown: -2
            case .deload: -3
            case .rest: 0
            }
        }

        var description: String {
            switch self {
            case .scaleUp: "You're recovered and ready to push! Increasing volume and intensity."
            case .maintain: "On track. Maintaining planned progression."
            case .scaleDown: "Your body needs a lighter session. Reducing volume and intensity."
            case .deload: "Signs of fatigue detected. Taking a deload to recover."
            case .rest: "Your body needs rest today. Recovery is part of the process."
            }
        }

        var shortLabel: String {
            switch self {
            case .scaleUp: "Scale Up"
            case .maintain: "On Track"
            case .scaleDown: "Scale Down"
            case .deload: "Deload"
            case .rest: "Rest Day"
            }
        }
    }

    static func evaluate(readiness: ReadinessScore) -> TrainingAdjustment {
        let score = readiness.overallScore
        if score >= 80 { return .scaleUp }
        if score >= 60 { return .maintain }
        if score >= 40 { return .scaleDown }
        if score >= 25 { return .deload }
        return .rest
    }

    static func evaluateWithHealthKit(
        readiness: ReadinessScore,
        recentPerformance: [SetRecord]
    ) -> TrainingAdjustment {
        let baseAdjustment = evaluate(readiness: readiness)
        var fatigueSignals = 0
        if let hrv = readiness.healthKitHRV, let restingHR = readiness.healthKitRestingHR {
            if restingHR > 70 { fatigueSignals += 1 }
            if hrv < 40 { fatigueSignals += 1 }
        }
        let recentFailedSets = recentPerformance.filter { $0.completedReps < $0.targetReps }
        if Double(recentFailedSets.count) / Double(max(recentPerformance.count, 1)) > 0.4 {
            fatigueSignals += 1
        }
        if fatigueSignals >= 2 {
            switch baseAdjustment {
            case .scaleUp: return .maintain
            case .maintain: return .scaleDown
            case .scaleDown: return .deload
            default: return baseAdjustment
            }
        }
        return baseAdjustment
    }
}
