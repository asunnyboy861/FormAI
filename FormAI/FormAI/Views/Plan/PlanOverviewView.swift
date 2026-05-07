import SwiftUI
import SwiftData

struct PlanOverviewView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var planVM = PlanViewModel()
    @State private var showingCreator = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let plan = planVM.activePlan {
                        planHeaderView(plan)
                        weekScheduleView(plan)
                        phasesView(plan)
                    } else {
                        noPlanView
                    }
                }
                .padding()
            }
            .navigationTitle("Plan")
            .onAppear { planVM.loadActivePlan(modelContext: modelContext) }
            .sheet(isPresented: $showingCreator) {
                PlanCreatorView(planVM: planVM)
            }
        }
    }

    private func planHeaderView(_ plan: TrainingPlan) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(plan.name)
                .font(.title2.bold())
            HStack {
                Label(plan.goal.rawValue, systemImage: "target")
                Spacer()
                Label("\(plan.daysPerWeek)x/week", systemImage: "calendar")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            ProgressView(value: Double(plan.currentWeek), total: Double(plan.totalWeeks))
            HStack {
                Text("Week \(plan.currentWeek) of \(plan.totalWeeks)")
                    .font(.caption)
                Spacer()
                if let phase = plan.currentPhase {
                    Text(phase.phaseType.rawValue)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(phaseColor(for: phase.phaseType).opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func weekScheduleView(_ plan: TrainingPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.headline)
            let schedule = planVM.weekSchedule()
            HStack(spacing: 8) {
                ForEach(schedule, id: \.day) { item in
                    VStack(spacing: 4) {
                        Text(item.day)
                            .font(.caption2)
                        Text(item.type.rawValue.prefix(3))
                            .font(.caption.bold())
                            .frame(width: 36, height: 36)
                            .background(item.isToday ? Color.blue : (item.type == .rest ? Color.purple.opacity(0.3) : Color.gray.opacity(0.2)))
                            .foregroundStyle(item.isToday ? .white : .primary)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func phasesView(_ plan: TrainingPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Training Phases")
                .font(.headline)
            ForEach(plan.phases, id: \.id) { phase in
                HStack {
                    Circle()
                        .fill(phaseColor(for: phase.phaseType))
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading) {
                        Text(phase.phaseType.rawValue)
                            .font(.subheadline.bold())
                        Text("Weeks \(phase.weekNumber)-\(phase.weekNumber + phase.totalWeeks - 1) · \(phase.repRangeLower)-\(phase.repRangeUpper) reps · RPE \(phase.rpeTarget)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if plan.currentWeek >= phase.weekNumber && plan.currentWeek < phase.weekNumber + phase.totalWeeks {
                        Text("Current")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var noPlanView: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No active training plan")
                .font(.title3)
            Text("Create a plan to get periodized workouts tailored to your goals.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Create Plan") { showingCreator = true }
                .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }

    private func phaseColor(for phase: PhaseType) -> Color {
        switch phase {
        case .foundation: .blue
        case .build: .green
        case .peak: .orange
        case .deload: .purple
        }
    }
}

struct PlanCreatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let planVM: PlanViewModel

    @State private var name = "My Plan"
    @State private var goal: TrainingGoal = .strength
    @State private var split: TrainingSplit = .upperLower
    @State private var daysPerWeek = 4
    @State private var experience: ExperienceLevel = .intermediate

    var body: some View {
        NavigationStack {
            Form {
                Section("Plan Details") {
                    TextField("Plan Name", text: $name)
                    Picker("Goal", selection: $goal) {
                        ForEach(TrainingGoal.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    Picker("Split", selection: $split) {
                        ForEach(TrainingSplit.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    Picker("Days/Week", selection: $daysPerWeek) {
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                        Text("6").tag(6)
                    }
                    Picker("Experience", selection: $experience) {
                        ForEach(ExperienceLevel.allCases, id: \.self) { Text($0.rawValue) }
                    }
                }
            }
            .navigationTitle("Create Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        planVM.createPlan(name: name, goal: goal, split: split, daysPerWeek: daysPerWeek, experienceLevel: experience, modelContext: modelContext)
                        dismiss()
                    }
                }
            }
        }
    }
}
