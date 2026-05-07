import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("healthKitEnabled") private var healthKitEnabled = false
    @State private var purchaseManager = PurchaseManager()
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            List {
                proSection
                healthKitSection
                dataSection
                aboutSection
                resetSection
            }
            .navigationTitle("Settings")
        }
    }

    private var proSection: some View {
        Section {
            if purchaseManager.isPro {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("FormAI Pro Active")
                        .font(.headline)
                }
            } else {
                Button {
                    showingPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown")
                        Text("Upgrade to Pro")
                    }
                }
                .fullScreenCover(isPresented: $showingPaywall) {
                    PaywallView(purchaseManager: purchaseManager)
                }
            }
        } header: {
            Text("Subscription")
        }
    }

    private var healthKitSection: some View {
        Section {
            Toggle("HealthKit Integration", isOn: $healthKitEnabled)
            if healthKitEnabled {
                Text("FormAI can read sleep, HRV, and resting heart rate from Apple Health to enhance your readiness score.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("Health")
        }
    }

    private var dataSection: some View {
        Section {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }
            Link(destination: URL(string: "https://asunnyboy861.github.io/FormAI/support.html")!) {
                Label("Support", systemImage: "questionmark.circle")
            }
            Link(destination: URL(string: "https://asunnyboy861.github.io/FormAI/privacy.html")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
            }
            Link(destination: URL(string: "https://asunnyboy861.github.io/FormAI/terms.html")!) {
                Label("Terms of Use", systemImage: "doc.text")
            }
        } header: {
            Text("Legal & Support")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("About")
        }
    }

    private var resetSection: some View {
        Section {
            Button("Reset Onboarding", role: .destructive) {
                hasCompletedOnboarding = false
            }
        }
    }
}

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    let purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.yellow)
                    Text("FormAI Pro")
                        .font(.largeTitle.bold())
                    Text("Unlock your full adaptive coaching experience")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    featureList

                    if let monthly = purchaseManager.monthlyProduct {
                        purchaseButton(product: monthly, label: "Monthly", price: monthly.displayPrice)
                    }
                    if let yearly = purchaseManager.yearlyProduct {
                        purchaseButton(product: yearly, label: "Yearly", price: yearly.displayPrice)
                    }
                    if let lifetime = purchaseManager.lifetimeProduct {
                        purchaseButton(product: lifetime, label: "Lifetime", price: lifetime.displayPrice)
                    }

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .font(.caption)
                }
                .padding()
            }
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 8) {
            featureRow("Daily Readiness Check", icon: "heart.circle.fill")
            featureRow("AI Adaptive Adjustments", icon: "brain")
            featureRow("Periodized Plan Generation", icon: "list.bullet.clipboard")
            featureRow("Injury/Pain Substitutions", icon: "bandage")
            featureRow("Progress Charts & Analysis", icon: "chart.bar")
            featureRow("PR Tracking & Milestones", icon: "trophy")
            featureRow("Unlimited Training Templates", icon: "square.grid.2x2")
            featureRow("Data Export (CSV/JSON)", icon: "square.and.arrow.up")
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func featureRow(_ text: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }

    private func purchaseButton(product: Product, label: String, price: String) -> some View {
        Button {
            Task {
                _ = await purchaseManager.purchase(product)
                if purchaseManager.isPro { dismiss() }
            }
        } label: {
            HStack {
                Text(label)
                    .font(.headline)
                Spacer()
                Text(price)
                    .font(.subheadline)
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
