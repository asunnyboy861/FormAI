import Foundation
import SwiftData

enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case core = "Core"
    case forearms = "Forearms"
    case calves = "Calves"

    var colorHex: String {
        switch self {
        case .chest: return "FF6B6B"
        case .back: return "4ECDC4"
        case .shoulders: return "45B7D1"
        case .biceps: return "96CEB4"
        case .triceps: return "FFEAA7"
        case .quads: return "DDA0DD"
        case .hamstrings: return "98D8C8"
        case .glutes: return "F7DC6F"
        case .core: return "BB8FCE"
        case .forearms: return "F0B27A"
        case .calves: return "AED6F1"
        }
    }
}

enum Equipment: String, Codable, CaseIterable {
    case barbell = "Barbell"
    case dumbbell = "Dumbbell"
    case machine = "Machine"
    case cable = "Cable"
    case bodyweight = "Bodyweight"
    case kettlebell = "Kettlebell"
    case band = "Band"
}

enum TrainingSplit: String, Codable, CaseIterable {
    case fullBody3x = "Full Body 3x/week"
    case upperLower = "Upper/Lower 4x/week"
    case ppl = "Push/Pull/Legs 6x/week"
    case custom = "Custom"
}

enum DayType: String, Codable {
    case upper = "Upper"
    case lower = "Lower"
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"
    case fullBody = "Full Body"
    case rest = "Rest"
    case mobility = "Mobility"
}

enum EffortLevel: Int, Codable, CaseIterable {
    case easy = 1
    case moderate = 2
    case hard = 3
    case brutal = 4

    var label: String {
        switch self {
        case .easy: "Easy"
        case .moderate: "Moderate"
        case .hard: "Hard"
        case .brutal: "Brutal"
        }
    }
}

enum TrainingGoal: String, Codable, CaseIterable {
    case strength = "Strength"
    case hypertrophy = "Hypertrophy"
    case endurance = "Endurance"
    case general = "General Fitness"
}

enum ExperienceLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum PhaseType: String, Codable {
    case foundation = "Foundation"
    case build = "Build"
    case peak = "Peak"
    case deload = "Deload"
}
