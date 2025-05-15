//
//  ContentView.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTopic: QuizTopic? = nil
    @State private var isQuizActive = false
    @State private var showingSettings = false
    @ObservedObject var networkManager = NetworkManager.shared
    
    var body: some View {
        NavigationView {
            if isQuizActive, let topic = selectedTopic {
                QuizView(topic: topic, isQuizActive: $isQuizActive)
            } else {
                TopicListView(
                    selectedTopic: $selectedTopic,
                    isQuizActive: $isQuizActive,
                    showingSettings: $showingSettings
                )
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct TopicListView: View {
    @Binding var selectedTopic: QuizTopic?
    @Binding var isQuizActive: Bool
    @Binding var showingSettings: Bool
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                Spacer().frame(height: 20)
                
                if networkManager.quizTopics.isEmpty && !networkManager.isLoading {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Quiz Topics Available")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Pull to refresh or check settings")
                            .foregroundColor(.secondary)
                        
                        Button("Refresh") {
                            networkManager.loadQuizData()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    ForEach(networkManager.quizTopics) { topic in
                        Button(action: {
                            selectedTopic = topic
                            isQuizActive = true
                        }) {
                            HStack {
                                Text(topic.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 255/255, green: 218/255, blue: 243/255))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
                
                if networkManager.isLoading {
                    ProgressView("Loading quiz topics...")
                        .padding()
                }
                
                if let error = networkManager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
        .refreshable {
            await refreshData()
        }
        .navigationTitle("Pick a topic!")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings") {
                    showingSettings = true
                }
                .foregroundColor(.black)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Refresh") {
                    networkManager.loadQuizData()
                }
                .foregroundColor(.black)
            }
        }
    }
    
    func refreshData() async {
        isRefreshing = true
        networkManager.loadQuizData()
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        isRefreshing = false
    }
}

#Preview {
    ContentView()
}
