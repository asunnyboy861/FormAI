import SwiftUI
import SwiftData

struct ReadinessCheckView: View {
    @State private var viewModel = ReadinessViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let onComplete: (ReadinessEngine.TrainingAdjustment) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    if viewModel.hasCheckedToday {
                        readinessResultView
                    } else {
                        readinessInputView
                    }
                }
                .padding()
            }
            .navigationTitle("How are you feeling?")
            .onAppear { viewModel.checkIfAlreadyCheckedToday(modelContext: modelContext) }
        }
    }

    private var readinessInputView: some View {
        VStack(spacing: 24) {
            sliderRow(
                title: "Energy",
                icon: "bolt.fill",
                value: Binding(
                    get: { viewModel.energyLevel.rawValue },
                    set: { viewModel.energyLevel = .init(rawValue: $0) ?? .moderate }
                ),
                options: ReadinessScore.EnergyLevel.allCases.map { $0.label }
            )
            sliderRow(
                title: "Sleep",
                icon: "bed.double.fill",
                value: Binding(
                    get: { viewModel.sleepQuality.rawValue },
                    set: { viewModel.sleepQuality = .init(rawValue: $0) ?? .fair }
                ),
                options: ReadinessScore.SleepQuality.allCases.map { $0.label }
            )
            sliderRow(
                title: "Soreness",
                icon: "figure.strengthtraining.traditional",
                value: Binding(
                    get: { viewModel.sorenessLevel.rawValue },
                    set: { viewModel.sorenessLevel = .init(rawValue: $0) ?? .none }
                ),
                options: ReadinessScore.SorenessLevel.allCases.map { $0.label }
            )
            sliderRow(
                title: "Motivation",
                icon: "flame.fill",
                value: Binding(
                    get: { viewModel.motivationLevel.rawValue },
                    set: { viewModel.motivationLevel = .init(rawValue: $0) ?? .moderate }
                ),
                options: ReadinessScore.MotivationLevel.allCases.map { $0.label }
            )

            if viewModel.overallScore > 0 {
                scorePreview
            }

            Button("Check Readiness") {
                viewModel.evaluate()
                HapticService.readinessCheck()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if viewModel.adjustment != .maintain || viewModel.overallScore > 0 {
                Button("Save & Continue") {
                    viewModel.saveReadiness(modelContext: modelContext)
                    onComplete(viewModel.adjustment)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.large)
            }
        }
    }

    private var readinessResultView: some View {
        VStack(spacing: 20) {
            ReadinessGaugeView(score: viewModel.overallScore)
            Text(viewModel.adjustment.shortLabel)
                .font(.title2.bold())
            Text(viewModel.adjustment.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
    }

    private var scorePreview: some View {
        VStack {
            Text("\(Int(viewModel.overallScore))")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(scoreColor)
            Text("Readiness Score")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var scoreColor: Color {
        if viewModel.overallScore >= 80 { return .blue }
        if viewModel.overallScore >= 60 { return .green }
        if viewModel.overallScore >= 40 { return .yellow }
        if viewModel.overallScore >= 25 { return .orange }
        return .red
    }

    private func sliderRow(title: String, icon: String, value: Binding<Int>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: icon)
                .font(.headline)
            Picker(title, selection: value) {
                ForEach(1...5, id: \.self) { i in
                    Text(options[i - 1]).tag(i)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: value.wrappedValue) { viewModel.calculateScore() }
        }
    }
}
