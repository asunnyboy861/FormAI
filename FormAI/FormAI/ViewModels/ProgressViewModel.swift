import Foundation
import SwiftData

struct WeeklyVolume: Identifiable {
    let id = UUID()
    let week: String
    let volume: Double
}

struct ReadinessTrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}

@Observable
final class ProgressViewModel {
    var readinessScores: [ReadinessScore] = []
    var sessions: [WorkoutSession] = []

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }()

    func loadData(modelContext: ModelContext) {
        let cutoff = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()

        let readinessDescriptor = FetchDescriptor<ReadinessScore>(
            predicate: #Predicate { $0.date >= cutoff },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        readinessScores = (try? modelContext.fetch(readinessDescriptor)) ?? []

        let sessionDescriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate { $0.date >= cutoff },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        sessions = (try? modelContext.fetch(sessionDescriptor)) ?? []
    }

    func volumeByWeek() -> [WeeklyVolume] {
        let calendar = Calendar.current
        var weekData: [String: Double] = [:]

        for session in sessions {
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: session.date))!
            let key = dateFormatter.string(from: weekStart)
            weekData[key, default: 0] += session.totalVolume
        }

        return weekData.map { WeeklyVolume(week: $0.key, volume: $0.value) }.sorted { $0.week < $1.week }
    }

    func readinessTrend() -> [ReadinessTrendPoint] {
        readinessScores.map { ReadinessTrendPoint(date: $0.date, score: $0.overallScore) }
    }

    func personalRecords(for exerciseName: String) -> SetRecord? {
        var best: SetRecord?
        for session in sessions {
            for exercise in session.exercises where exercise.exerciseName == exerciseName {
                for set in exercise.sets {
                    let e1rm = set.weight * Double(36.0 / (37.0 - Double(set.completedReps)))
                    let bestE1rm = best.map { $0.weight * Double(36.0 / (37.0 - Double($0.completedReps))) } ?? 0
                    if e1rm > bestE1rm {
                        best = set
                    }
                }
            }
        }
        return best
    }
}
