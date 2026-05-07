import SwiftUI
import SwiftData

@main
struct FormAIApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [
            WorkoutSession.self,
            ExerciseRecord.self,
            SetRecord.self,
            ReadinessScore.self,
            TrainingPlan.self,
            TrainingPhase.self,
            Exercise.self
        ])
    }
}
