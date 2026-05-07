import SwiftUI

struct ReadinessGaugeView: View {
    let score: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
            Circle()
                .trim(from: 0, to: score / 100.0)
                .stroke(gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 4) {
                Text("\(Int(score))")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(scoreColor)
                Text("/ 100")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 160, height: 160)
    }

    private var gradient: AngularGradient {
        AngularGradient(
            colors: [.red, .orange, .yellow, .green, .blue],
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }

    private var scoreColor: Color {
        if score >= 80 { return .blue }
        if score >= 60 { return .green }
        if score >= 40 { return .yellow }
        if score >= 25 { return .orange }
        return .red
    }
}
