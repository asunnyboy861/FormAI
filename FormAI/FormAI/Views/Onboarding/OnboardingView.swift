import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userExperienceLevel") private var experienceLevelRaw = "intermediate"
    @AppStorage("userGoal") private var goalRaw = "strength"
    @AppStorage("userSplit") private var splitRaw = "upperLower"
    @AppStorage("userDaysPerWeek") private var daysPerWeek = 4

    @State private var step = 0

    var body: some View {
        TabView(selection: $step) {
            welcomeStep.tag(0)
            goalStep.tag(1)
            experienceStep.tag(2)
            splitStep.tag(3)
            finishStep.tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            Text("Welcome to FormAI")
                .font(.largeTitle.bold())
            Text("Your AI-powered adaptive workout coach that adjusts to how you feel every day.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Spacer()
            Button("Get Started") { withAnimation { step = 1 } }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            Spacer().frame(height: 40)
        }
    }

    private var goalStep: some View {
        VStack(spacing: 24) {
            Text("What's your goal?")
                .font(.title2.bold())
            ForEach(TrainingGoal.allCases, id: \.self) { goal in
                Button {
                    goalRaw = goal.rawValue
                    withAnimation { step = 2 }
                } label: {
                    HStack {
                        Text(goal.rawValue)
                        Spacer()
                        if goalRaw == goal.rawValue { Image(systemName: "checkmark") }
                    }
                    .padding()
                    .background(goalRaw == goal.rawValue ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 24)
    }

    private var experienceStep: some View {
        VStack(spacing: 24) {
            Text("Your experience level?")
                .font(.title2.bold())
            ForEach(ExperienceLevel.allCases, id: \.self) { level in
                Button {
                    experienceLevelRaw = level.rawValue
                    withAnimation { step = 3 }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(level.rawValue).font(.headline)
                            Text(level.description).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if experienceLevelRaw == level.rawValue { Image(systemName: "checkmark") }
                    }
                    .padding()
                    .background(experienceLevelRaw == level.rawValue ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 24)
    }

    private var splitStep: some View {
        VStack(spacing: 24) {
            Text("How many days per week?")
                .font(.title2.bold())
            Picker("Days", selection: $daysPerWeek) {
                Text("3 days").tag(3)
                Text("4 days").tag(4)
                Text("5 days").tag(5)
                Text("6 days").tag(6)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Text("Training split")
                .font(.title2.bold())
            ForEach(TrainingSplit.allCases.filter { $0 != .custom }, id: \.self) { split in
                Button {
                    splitRaw = split.rawValue
                    withAnimation { step = 4 }
                } label: {
                    HStack {
                        Text(split.rawValue)
                        Spacer()
                        if splitRaw == split.rawValue { Image(systemName: "checkmark") }
                    }
                    .padding()
                    .background(splitRaw == split.rawValue ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 24)
    }

    private var finishStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            Text("You're all set!")
                .font(.largeTitle.bold())
            Text("FormAI will create a personalized training plan based on your preferences. Your daily readiness check will adapt your workouts automatically.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Spacer()
            Button("Start Training") {
                let planVM = PlanViewModel()
                planVM.createPlan(
                    name: "My Plan",
                    goal: TrainingGoal(rawValue: goalRaw) ?? .strength,
                    split: TrainingSplit(rawValue: splitRaw) ?? .upperLower,
                    daysPerWeek: daysPerWeek,
                    experienceLevel: ExperienceLevel(rawValue: experienceLevelRaw) ?? .intermediate,
                    modelContext: modelContext
                )
                hasCompletedOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer().frame(height: 40)
        }
    }
}

extension ExperienceLevel {
    var description: String {
        switch self {
        case .beginner: "Less than 1 year of training"
        case .intermediate: "1-3 years of consistent training"
        case .advanced: "3+ years of serious training"
        }
    }
}
