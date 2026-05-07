import Foundation

struct InjuryAdapter {
    struct PainEntry {
        let muscleGroup: MuscleGroup
        let severity: ReadinessScore.SorenessLevel
    }

    static let substitutionMap: [MuscleGroup: [(String, MuscleGroup, Equipment)]] = [
        .chest: [
            ("Cable Fly", .chest, .cable),
            ("Dumbbell Bench Press", .chest, .dumbbell),
        ],
        .back: [
            ("Lat Pulldown", .back, .cable),
            ("Dumbbell Row", .back, .dumbbell),
        ],
        .shoulders: [
            ("Lateral Raise", .shoulders, .dumbbell),
            ("Face Pull", .shoulders, .cable),
        ],
        .quads: [
            ("Leg Press", .quads, .machine),
            ("Leg Extension", .quads, .machine),
        ],
        .hamstrings: [
            ("Leg Curl", .hamstrings, .machine),
            ("Goblet Squat", .quads, .dumbbell),
        ],
        .biceps: [
            ("Hammer Curl", .biceps, .dumbbell),
        ],
        .triceps: [
            ("Skull Crusher", .triceps, .barbell),
        ],
    ]

    static func substituteExercises(
        exercises: [(String, MuscleGroup, Equipment)],
        painEntries: [PainEntry]
    ) -> [(original: String, substituted: (String, MuscleGroup, Equipment)?, reason: String)] {
        let painfulGroups = Set(painEntries.filter { $0.severity.rawValue >= 3 }.map { $0.muscleGroup })

        return exercises.map { exercise in
            if painfulGroups.contains(exercise.1) {
                if let sub = substitutionMap[exercise.1]?.first {
                    return (original: exercise.0, substituted: sub, reason: "Substituted \(exercise.0) with \(sub.0) due to \(exercise.1.rawValue) discomfort.")
                }
                return (original: exercise.0, substituted: nil, reason: "No substitution available for \(exercise.0). Consider skipping.")
            }
            return (original: exercise.0, substituted: nil, reason: "")
        }
    }
}
