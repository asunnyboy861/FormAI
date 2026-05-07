import Foundation
import SwiftData

@Observable
final class ReadinessViewModel {
    var energyLevel: ReadinessScore.EnergyLevel = .moderate
    var sleepQuality: ReadinessScore.SleepQuality = .fair
    var sorenessLevel: ReadinessScore.SorenessLevel = .none
    var motivationLevel: ReadinessScore.MotivationLevel = .moderate
    var overallScore: Double = 0
    var adjustment: ReadinessEngine.TrainingAdjustment = .maintain
    var hasCheckedToday: Bool = false

    func calculateScore() {
        overallScore = ReadinessScore.calculateScore(
            energy: energyLevel,
            sleep: sleepQuality,
            soreness: sorenessLevel,
            motivation: motivationLevel
        )
    }

    func evaluate() {
        calculateScore()
        let score = ReadinessScore(
            energyLevel: energyLevel,
            sleepQuality: sleepQuality,
            sorenessLevel: sorenessLevel,
            motivationLevel: motivationLevel
        )
        adjustment = ReadinessEngine.evaluate(readiness: score)
    }

    func saveReadiness(modelContext: ModelContext) {
        let score = ReadinessScore(
            energyLevel: energyLevel,
            sleepQuality: sleepQuality,
            sorenessLevel: sorenessLevel,
            motivationLevel: motivationLevel
        )
        score.adjustmentRaw = adjustment.rawValue
        modelContext.insert(score)
        try? modelContext.save()
        hasCheckedToday = true
    }

    func checkIfAlreadyCheckedToday(modelContext: ModelContext) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let predicate = #Predicate<ReadinessScore> { $0.date >= today }
        let descriptor = FetchDescriptor(predicate: predicate)
        if let existing = try? modelContext.fetch(descriptor).first {
            overallScore = existing.overallScore
            adjustment = ReadinessEngine.TrainingAdjustment(rawValue: existing.adjustmentRaw) ?? .maintain
            hasCheckedToday = true
        }
    }
}
