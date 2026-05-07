import Foundation
import SwiftData

@Observable
final class WorkoutViewModel {
    var currentSession: WorkoutSession?
    var isWorkoutActive: Bool = false
    var elapsedTime: TimeInterval = 0
    var currentExerciseIndex: Int = 0
    var currentSetIndex: Int = 0

    private var timer: Timer?

    func startWorkout(dayType: DayType, modelContext: ModelContext) {
        let session = WorkoutSession(dayType: dayType)
        let exercises = PlanGenerator.exercisesForDayType(dayType)
        for (index, exercise) in exercises.enumerated() {
            let record = ExerciseRecord(
                exerciseName: exercise.0,
                muscleGroup: exercise.1,
                equipment: exercise.2,
                order: index
            )
            for _ in 1...3 {
                let setRecord = SetRecord(weight: 0, targetReps: 8, targetRPE: 7)
                record.sets.append(setRecord)
            }
            session.exercises.append(record)
        }
        modelContext.insert(session)
        try? modelContext.save()
        currentSession = session
        isWorkoutActive = true
        startTimer()
    }

    func finishWorkout(effort: EffortLevel?, modelContext: ModelContext) {
        stopTimer()
        currentSession?.effort = effort
        currentSession?.duration = elapsedTime
        calculateTotalVolume()
        try? modelContext.save()
        isWorkoutActive = false
        HapticService.workoutComplete()
    }

    func cancelWorkout(modelContext: ModelContext) {
        stopTimer()
        if let session = currentSession {
            modelContext.delete(session)
            try? modelContext.save()
        }
        currentSession = nil
        isWorkoutActive = false
    }

    func updateSet(exerciseIndex: Int, setIndex: Int, weight: Double, reps: Int, rpe: Int?) {
        guard let session = currentSession,
              exerciseIndex < session.exercises.count,
              setIndex < session.exercises[exerciseIndex].sets.count else { return }
        session.exercises[exerciseIndex].sets[setIndex].weight = weight
        session.exercises[exerciseIndex].sets[setIndex].completedReps = reps
        session.exercises[exerciseIndex].sets[setIndex].actualRPE = rpe
    }

    func addSet(to exerciseIndex: Int) {
        guard let session = currentSession,
              exerciseIndex < session.exercises.count else { return }
        let newSet = SetRecord(weight: 0, targetReps: 8, targetRPE: 7)
        session.exercises[exerciseIndex].sets.append(newSet)
    }

    func removeSet(from exerciseIndex: Int, at setIndex: Int) {
        guard let session = currentSession,
              exerciseIndex < session.exercises.count,
              setIndex < session.exercises[exerciseIndex].sets.count else { return }
        session.exercises[exerciseIndex].sets.remove(at: setIndex)
    }

    private func startTimer() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func calculateTotalVolume() {
        guard let session = currentSession else { return }
        var total: Double = 0
        for exercise in session.exercises {
            for set in exercise.sets {
                total += set.weight * Double(set.completedReps)
            }
        }
        session.totalVolume = total
    }

    var formattedElapsedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
