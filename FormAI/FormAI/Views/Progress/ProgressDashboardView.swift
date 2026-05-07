import SwiftUI
import SwiftData
import Charts

struct ProgressDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var progressVM = ProgressViewModel()
    @State private var purchaseManager = PurchaseManager()
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    statsCards
                    if purchaseManager.isPro {
                        volumeChart
                        readinessChart
                    } else {
                        proLockedSection
                    }
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Progress")
            .onAppear { progressVM.loadData(modelContext: modelContext) }
            .fullScreenCover(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private var statsCards: some View {
        HStack(spacing: 12) {
            statCard(title: "Workouts", value: "\(progressVM.sessions.count)", icon: "dumbbell", color: .blue)
            statCard(title: "Avg Readiness", value: String(format: "%.0f", averageReadiness), icon: "heart.fill", color: .green)
            statCard(title: "Total Volume", value: formatVolume(progressVM.sessions.reduce(0) { $0 + $1.totalVolume }), icon: "chart.bar.fill", color: .orange)
        }
    }

    private var averageReadiness: Double {
        guard !progressVM.readinessScores.isEmpty else { return 0 }
        return progressVM.readinessScores.reduce(0) { $0 + $1.overallScore } / Double(progressVM.readinessScores.count)
    }

    private func formatVolume(_ volume: Double) -> String {
        if volume >= 1_000_000 { return String(format: "%.1fM", volume / 1_000_000) }
        if volume >= 1_000 { return String(format: "%.0fK", volume / 1_000) }
        return "\(Int(volume))"
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var volumeChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Volume")
                .font(.headline)
            if progressVM.sessions.isEmpty {
                Text("No workout data yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                let weeklyData = progressVM.volumeByWeek()
                Chart(weeklyData) { point in
                    BarMark(
                        x: .value("Week", point.week),
                        y: .value("Volume", point.volume)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var readinessChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Readiness Trend")
                .font(.headline)
            if progressVM.readinessScores.isEmpty {
                Text("No readiness data yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                let trendData = progressVM.readinessTrend()
                Chart(trendData) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Score", point.score)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Score", point.score)
                    )
                    .foregroundStyle(.green.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: 0...100)
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var proLockedSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text("Progress Charts & Analysis")
                .font(.headline)
            Text("Upgrade to Pro to unlock volume trends, readiness history, and PR tracking.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Upgrade to Pro") { showingPaywall = true }
                .buttonStyle(.borderedProminent)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
