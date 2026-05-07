import Foundation
import SwiftData

@Observable
final class HistoryViewModel {
    var sessions: [WorkoutSession] = []

    func loadSessions(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<WorkoutSession>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        sessions = (try? modelContext.fetch(descriptor)) ?? []
    }

    func sessionsForLast30Days(modelContext: ModelContext) -> [WorkoutSession] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate { $0.date >= cutoff },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func totalVolumeLast30Days(modelContext: ModelContext) -> Double {
        sessionsForLast30Days(modelContext: modelContext).reduce(0) { $0 + $1.totalVolume }
    }

    func totalWorkoutsLast30Days(modelContext: ModelContext) -> Int {
        sessionsForLast30Days(modelContext: modelContext).count
    }
}
