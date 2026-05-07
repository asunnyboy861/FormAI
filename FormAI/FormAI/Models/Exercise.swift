import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String
    var muscleGroup: MuscleGroup
    var secondaryMuscles: [MuscleGroup]
    var equipment: Equipment
    var startingWeight: Double?
    var isCustom: Bool
    var substitutionIds: [UUID]

    init(
        name: String,
        muscleGroup: MuscleGroup,
        secondaryMuscles: [MuscleGroup] = [],
        equipment: Equipment = .barbell,
        startingWeight: Double? = nil,
        isCustom: Bool = false,
        substitutionIds: [UUID] = []
    ) {
        self.id = UUID()
        self.name = name
        self.muscleGroup = muscleGroup
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.startingWeight = startingWeight
        self.isCustom = isCustom
        self.substitutionIds = substitutionIds
    }

    static let builtIn: [Exercise] = {
        let exercises: [(String, MuscleGroup, [MuscleGroup], Equipment, Double?)] = [
            ("Bench Press", .chest, [.triceps, .shoulders], .barbell, 45),
            ("Incline Bench Press", .chest, [.triceps, .shoulders], .barbell, 45),
            ("Dumbbell Bench Press", .chest, [.triceps, .shoulders], .dumbbell, 30),
            ("Overhead Press", .shoulders, [.triceps], .barbell, 45),
            ("Dumbbell Shoulder Press", .shoulders, [.triceps], .dumbbell, 25),
            ("Barbell Row", .back, [.biceps], .barbell, 45),
            ("Pull-Up", .back, [.biceps], .bodyweight, nil),
            ("Lat Pulldown", .back, [.biceps], .cable, 50),
            ("Deadlift", .back, [.hamstrings, .glutes], .barbell, 95),
            ("Squat", .quads, [.glutes, .hamstrings], .barbell, 45),
            ("Leg Press", .quads, [.glutes], .machine, 100),
            ("Romanian Deadlift", .hamstrings, [.glutes, .back], .barbell, 65),
            ("Leg Curl", .hamstrings, [], .machine, 40),
            ("Bicep Curl", .biceps, [.forearms], .dumbbell, 15),
            ("Tricep Pushdown", .triceps, [], .cable, 30),
            ("Cable Fly", .chest, [], .cable, 20),
            ("Lateral Raise", .shoulders, [], .dumbbell, 10),
            ("Face Pull", .shoulders, [], .cable, 20),
            ("Hip Thrust", .glutes, [.hamstrings], .barbell, 65),
            ("Plank", .core, [], .bodyweight, nil),
            ("Cable Crunch", .core, [], .cable, 30),
            ("Calf Raise", .calves, [], .machine, 60),
            ("Dip", .triceps, [.chest], .bodyweight, nil),
            ("Chin-Up", .back, [.biceps], .bodyweight, nil),
            ("Goblet Squat", .quads, [.glutes], .dumbbell, 25),
            ("Dumbbell Row", .back, [.biceps], .dumbbell, 25),
            ("Skull Crusher", .triceps, [], .barbell, 25),
            ("Hammer Curl", .biceps, [.forearms], .dumbbell, 15),
            ("Leg Extension", .quads, [], .machine, 40),
            ("Ab Wheel Rollout", .core, [], .bodyweight, nil),
        ]
        return exercises.map { Exercise(name: $0, muscleGroup: $1, secondaryMuscles: $2, equipment: $3, startingWeight: $4) }
    }()
}
