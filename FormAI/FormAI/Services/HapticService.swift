import UIKit

struct HapticService {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    static func prAchieved() {
        notification(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            impact(.heavy)
        }
    }

    static func workoutComplete() {
        notification(.success)
    }

    static func readinessCheck() {
        impact(.light)
    }
}
