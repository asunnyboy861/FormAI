import Foundation
import SwiftData

@Model
final class ReadinessScore {
    @Attribute(.unique) var id: UUID
    var date: Date
    var energyLevel: Int
    var sleepQuality: Int
    var sorenessLevel: Int
    var motivationLevel: Int
    var overallScore: Double
    var healthKitSleepHours: Double?
    var healthKitHRV: Double?
    var healthKitRestingHR: Double?
    var adjustmentRaw: String
    var workoutSession: WorkoutSession?

    var energyEnum: EnergyLevel {
        get { EnergyLevel(rawValue: energyLevel) ?? .moderate }
        set { energyLevel = newValue.rawValue }
    }
    var sleepEnum: SleepQuality {
        get { SleepQuality(rawValue: sleepQuality) ?? .fair }
        set { sleepQuality = newValue.rawValue }
    }
    var sorenessEnum: SorenessLevel {
        get { SorenessLevel(rawValue: sorenessLevel) ?? .none }
        set { sorenessLevel = newValue.rawValue }
    }
    var motivationEnum: MotivationLevel {
        get { MotivationLevel(rawValue: motivationLevel) ?? .moderate }
        set { motivationLevel = newValue.rawValue }
    }

    enum EnergyLevel: Int, Codable, CaseIterable {
        case exhausted = 1, low = 2, moderate = 3, high = 4, peaked = 5
        var label: String {
            switch self {
            case .exhausted: "Exhausted"
            case .low: "Low Energy"
            case .moderate: "Okay"
            case .high: "Energized"
            case .peaked: "Feeling Great"
            }
        }
    }
    enum SleepQuality: Int, Codable, CaseIterable {
        case terrible = 1, poor = 2, fair = 3, good = 4, excellent = 5
        var label: String {
            switch self {
            case .terrible: "Terrible"
            case .poor: "Poor"
            case .fair: "Fair"
            case .good: "Good"
            case .excellent: "Excellent"
            }
        }
    }
    enum SorenessLevel: Int, Codable, CaseIterable {
        case none = 1, mild = 2, moderate = 3, significant = 4, severe = 5
        var label: String {
            switch self {
            case .none: "None"
            case .mild: "Mild"
            case .moderate: "Moderate"
            case .significant: "Significant"
            case .severe: "Severe"
            }
        }
    }
    enum MotivationLevel: Int, Codable, CaseIterable {
        case zero = 1, low = 2, moderate = 3, high = 4, fired = 5
        var label: String {
            switch self {
            case .zero: "Zero"
            case .low: "Low"
            case .moderate: "Moderate"
            case .high: "High"
            case .fired: "Fired Up"
            }
        }
    }

    init(
        energyLevel: EnergyLevel = .moderate,
        sleepQuality: SleepQuality = .fair,
        sorenessLevel: SorenessLevel = .none,
        motivationLevel: MotivationLevel = .moderate,
        healthKitSleepHours: Double? = nil,
        healthKitHRV: Double? = nil,
        healthKitRestingHR: Double? = nil
    ) {
        self.id = UUID()
        self.date = Date()
        self.energyLevel = energyLevel.rawValue
        self.sleepQuality = sleepQuality.rawValue
        self.sorenessLevel = sorenessLevel.rawValue
        self.motivationLevel = motivationLevel.rawValue
        self.healthKitSleepHours = healthKitSleepHours
        self.healthKitHRV = healthKitHRV
        self.healthKitRestingHR = healthKitRestingHR
        self.adjustmentRaw = "maintain"
        self.overallScore = Self.calculateScore(
            energy: energyLevel,
            sleep: sleepQuality,
            soreness: sorenessLevel,
            motivation: motivationLevel
        )
    }

    static func calculateScore(
        energy: EnergyLevel,
        sleep: SleepQuality,
        soreness: SorenessLevel,
        motivation: MotivationLevel
    ) -> Double {
        let rawScore = (
            Double(energy.rawValue) * 0.30 +
            Double(sleep.rawValue) * 0.30 +
            (6.0 - Double(soreness.rawValue)) * 0.25 +
            Double(motivation.rawValue) * 0.15
        )
        return min(max(rawScore / 5.0 * 100.0, 0), 100)
    }
}
