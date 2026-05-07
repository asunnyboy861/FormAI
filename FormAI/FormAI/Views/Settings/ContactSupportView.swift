import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General Feedback"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    private let topics = [
        "General Feedback",
        "Bug Report",
        "Feature Request",
        "Subscription Issue",
        "Account & Data",
        "Other"
    ]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }

            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email (required)", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }

            Section {
                Button(action: submitFeedback) {
                    HStack {
                        Spacer()
                        if isSubmitting {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Text("Send Feedback")
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(message.isEmpty || email.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showSuccess) {
            Button("OK") {
                message = ""
                email = ""
                name = ""
                topic = "General Feedback"
            }
        } message: {
            Text("Your feedback has been received. We'll get back to you soon.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }

    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address."
            showError = true
            return
        }

        isSubmitting = true

        let feedbackURL = "https://feedback-board.iocompile67692.workers.dev"
        guard let url = URL(string: feedbackURL) else {
            errorMessage = "Unable to connect. Please try again later."
            showError = true
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "FormAI"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    showSuccess = true
                } else {
                    errorMessage = "Server error. Please try again or email us at support@zzoutuo.com"
                    showError = true
                }
            }
        }.resume()
    }
}
