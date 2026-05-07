import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var readinessVM = ReadinessViewModel()
    @State private var planVM = PlanViewModel()
    @State private var showingReadinessCheck = false
    @State private var showingWorkout = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    readinessSection
                    todaysPlanSection
                    quickStartSection
                }
                .padding()
            }
            .navigationTitle("Today")
            .onAppear {
                readinessVM.checkIfAlreadyCheckedToday(modelContext: modelContext)
                planVM.loadActivePlan(modelContext: modelContext)
            }
            .sheet(isPresented: $showingReadinessCheck) {
                ReadinessCheckView { _ in
                    readinessVM.checkIfAlreadyCheckedToday(modelContext: modelContext)
                }
            }
            .fullScreenCover(isPresented: $showingWorkout) {
                ActiveWorkoutView(dayType: planVM.todayDayType())
            }
        }
    }

    private var readinessSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Daily Readiness")
                    .font(.headline)
                Spacer()
                if readinessVM.hasCheckedToday {
                    Text("Checked ✓")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }

            if readinessVM.hasCheckedToday {
                HStack(spacing: 16) {
                    ReadinessGaugeView(score: readinessVM.overallScore)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(readinessVM.adjustment.shortLabel)
                            .font(.title3.bold())
                        Text(readinessVM.adjustment.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Button {
                    showingReadinessCheck = true
                } label: {
                    Label("Check Readiness", systemImage: "heart.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var todaysPlanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Plan")
                .font(.headline)
            let dayType = planVM.todayDayType()
            if dayType == .rest {
                HStack {
                    Image(systemName: "bed.double.fill")
                        .foregroundStyle(.purple)
                    Text("Rest Day")
                        .font(.title3)
                    Spacer()
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                let exercises = PlanGenerator.exercisesForDayType(dayType)
                VStack(spacing: 8) {
                    HStack {
                        Text(dayType.rawValue)
                            .font(.title3.bold())
                        Spacer()
                        Text("\(exercises.count) exercises")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    ForEach(exercises.prefix(4), id: \.0) { exercise in
                        HStack {
                            Circle()
                                .fill(Color(hex: exercise.1.colorHex) ?? .blue)
                                .frame(width: 8, height: 8)
                            Text(exercise.0)
                            Spacer()
                            Text(exercise.2.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if exercises.count > 4 {
                        Text("+ \(exercises.count - 4) more")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var quickStartSection: some View {
        Button {
            showingWorkout = true
        } label: {
            Label("Start Workout", systemImage: "play.circle.fill")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(planVM.todayDayType() == .rest)
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}
