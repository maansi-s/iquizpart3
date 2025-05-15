//
//  Settings.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/14/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var customURL: String = UserDefaults.standard.string(forKey: "quizDataURL") ?? "https://tednewardsandbox.site44.com/questions.json"
    @Environment(\.dismiss) var dismiss
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Data URL")) {
                    TextField("Quiz Data URL", text: $customURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        UserDefaults.standard.set(customURL, forKey: "quizDataURL")
                        networkManager.loadQuizData(from: customURL)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if networkManager.errorMessage != nil {
                                showingError = true
                            }
                        }
                    }) {
                        HStack {
                            Text("Check Now")
                            Spacer()
                            if networkManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            }
                        }
                    }
                    .disabled(networkManager.isLoading)
                }
                
                Section {
                    Button("Reset URL") {
                        customURL = "https://tednewardsandbox.site44.com/questions.json"
                        UserDefaults.standard.set(customURL, forKey: "quizDataURL")
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Network Error", isPresented: $showingError) {
                Button("OK") {
                    networkManager.errorMessage = nil
                }
            } message: {
                Text(networkManager.errorMessage ?? "Failed to load quiz data. Please check your URL and network connection.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
