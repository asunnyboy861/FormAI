import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var historyVM = HistoryViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(historyVM.sessions) { session in
                    NavigationLink {
                        SessionDetailView(session: session)
                    } label: {
                        sessionRow(session)
                    }
                }
            }
            .navigationTitle("History")
            .onAppear { historyVM.loadSessions(modelContext: modelContext) }
        }
    }

    private func sessionRow(_ session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.dayType.rawValue)
                    .font(.headline)
                Spacer()
                Text(session.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label("\(Int(session.totalVolume)) lbs", systemImage: "chart.bar")
                Spacer()
                if session.duration > 0 {
                    Label("\(Int(session.duration / 60)) min", systemImage: "clock")
                }
                if let effort = session.effort {
                    Label(effort.label, systemImage: "flame")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct SessionDetailView: View {
    let session: WorkoutSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.dayType.rawValue)
                        .font(.title2.bold())
                    Text(session.date, style: .date)
                        .foregroundStyle(.secondary)
                    HStack {
                        Label("\(Int(session.totalVolume)) lbs volume", systemImage: "chart.bar")
                        if session.duration > 0 {
                            Label("\(Int(session.duration / 60)) min", systemImage: "clock")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                ForEach(session.exercises.sorted { $0.order < $1.order }) { exercise in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color(hex: exercise.muscleGroup.colorHex) ?? .blue)
                                .frame(width: 8, height: 8)
                            Text(exercise.exerciseName)
                                .font(.headline)
                            Spacer()
                            Text(exercise.equipment.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            Text("Set")
                                .frame(width: 40, alignment: .leading)
                            Text("Weight")
                                .frame(width: 60)
                            Text("Reps")
                                .frame(width: 44)
                            Text("RPE")
                                .frame(width: 30)
                        }
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                        ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text("\(index + 1)")
                                    .frame(width: 40, alignment: .leading)
                                Text(set.weight > 0 ? "\(Int(set.weight))" : "-")
                                    .frame(width: 60)
                                Text(set.completedReps > 0 ? "\(set.completedReps)" : "-")
                                    .frame(width: 44)
                                Text(set.actualRPE.map { "\($0)" } ?? "-")
                                    .frame(width: 30)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Workout Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
