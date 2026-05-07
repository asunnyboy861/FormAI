import Foundation
import SwiftData

struct DataExportService {
    static func exportSessionsAsCSV(sessions: [WorkoutSession]) -> String {
        var lines: [String] = []
        lines.append("Date,Day Type,Duration (min),Total Volume (lbs),Effort,Exercise,Set,Weight (lbs),Reps,RPE")

        for session in sessions {
            let dateStr = DateFormatter.shortDate.string(from: session.date)
            let duration = Int(session.duration / 60)
            let effortStr = session.effort?.label ?? ""

            for exercise in session.exercises.sorted(by: { $0.order < $1.order }) {
                for (setIndex, set) in exercise.sets.enumerated() {
                    let rpeStr = set.actualRPE.map { "\($0)" } ?? ""
                    lines.append("\(dateStr),\(session.dayType.rawValue),\(duration),\(Int(session.totalVolume)),\(effortStr),\(exercise.exerciseName),\(setIndex + 1),\(Int(set.weight)),\(set.completedReps),\(rpeStr)")
                }
            }
        }

        return lines.joined(separator: "\n")
    }

    static func exportSessionsAsJSON(sessions: [WorkoutSession]) -> String {
        let exportData: [[String: Any]] = sessions.map { session in
            let exercises: [[String: Any]] = session.exercises.sorted { $0.order < $1.order }.map { exercise in
                let sets: [[String: Any]] = exercise.sets.map { set in
                    return [
                        "weight": set.weight,
                        "completedReps": set.completedReps,
                        "targetReps": set.targetReps,
                        "actualRPE": set.actualRPE ?? NSNull(),
                        "targetRPE": set.targetRPE
                    ] as [String: Any]
                }
                return [
                    "name": exercise.exerciseName,
                    "muscleGroup": exercise.muscleGroup.rawValue,
                    "equipment": exercise.equipment.rawValue,
                    "sets": sets
                ] as [String: Any]
            }
            return [
                "date": ISO8601DateFormatter().string(from: session.date),
                "dayType": session.dayType.rawValue,
                "durationMinutes": Int(session.duration / 60),
                "totalVolume": session.totalVolume,
                "effort": session.effort?.label ?? NSNull(),
                "exercises": exercises
            ] as [String: Any]
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted) else {
            return "[]"
        }
        return String(data: jsonData, encoding: .utf8) ?? "[]"
    }

    static func saveToFile(content: String, filename: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f
    }()
}
