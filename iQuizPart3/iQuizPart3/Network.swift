//
//  Network.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/14/25.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published var quizTopics: [QuizTopic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isNetworkAvailable = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let correctURL = "https://tednewardsandbox.site44.com/questions.json"
    
    private init() {
        setupNetworkMonitoring()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadQuizData()
        }
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
                if path.status != .satisfied {
                    self?.errorMessage = "No network connection available"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func loadQuizData(from urlString: String? = nil) {
        guard isNetworkAvailable else {
            errorMessage = "No network connection available"
            return
        }
        
        let urlToUse = urlString ?? UserDefaults.standard.string(forKey: "quizDataURL") ?? correctURL
        
        guard let url = URL(string: urlToUse) else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedQuizzes = try JSONDecoder().decode([QuizJSON].self, from: data)
                    self?.quizTopics = decodedQuizzes.map { quiz in
                        let questions = quiz.questions.map { q in
                            // Convert string answer to Int and make it 0-based
                            let answerIndex = (Int(q.answer) ?? 1) - 1
                            return Question(
                                text: q.text,
                                answers: q.answers,
                                correctAnswer: answerIndex
                            )
                        }
                        return QuizTopic(name: quiz.title, questions: questions)
                    }
                    self?.errorMessage = nil
                } catch {
                    self?.errorMessage = "Failed to parse data: \(error.localizedDescription)"
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}

struct QuizJSON: Codable {
    let title: String
    let desc: String
    let questions: [QuestionJSON]
}

struct QuestionJSON: Codable {
    let text: String
    let answer: String
    let answers: [String]
}
