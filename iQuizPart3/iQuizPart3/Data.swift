//
//  Data.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/10/25.
//

import Foundation

struct QuizTopic: Identifiable {
    let id = UUID()
    let name: String
    let questions: [Question]
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let answers: [String]
    let correctAnswer: Int
}

class QuizSession: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var userAnswers: [Int?] = []
    @Published var showingAnswer = false
    @Published var showingFinished = false
    
    let topic: QuizTopic
    
    init(topic: QuizTopic) {
        self.topic = topic
        self.userAnswers = Array(repeating: nil, count: topic.questions.count)
    }
    
    var currentQuestion: Question {
        topic.questions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == topic.questions.count - 1
    }
    
    var correctAnswersCount: Int {
        var count = 0
        for (index, userAnswer) in userAnswers.enumerated() where userAnswer != nil {
            if userAnswer == topic.questions[index].correctAnswer {
                count += 1
            }
        }
        return count
    }
    
    var scorePercentage: Double {
        Double(correctAnswersCount) / Double(topic.questions.count) * 100
    }
    
    var performanceText: String {
        switch scorePercentage {
        case 100:
            return "Amazing!"
        case 80..<100:
            return "Almost!"
        case 60..<80:
            return "Great!"
        case 40..<60:
            return "Not bad!"
        default:
            return "Practice makes perfect!"
        }
    }
    
    func submitAnswer(_ answerIndex: Int) {
        userAnswers[currentQuestionIndex] = answerIndex
        showingAnswer = true
    }
    
    func nextQuestion() {
        if isLastQuestion {
            showingFinished = true
        } else {
            currentQuestionIndex += 1
            showingAnswer = false
        }
    }
    
    func reset() {
        currentQuestionIndex = 0
        userAnswers = Array(repeating: nil, count: topic.questions.count)
        showingAnswer = false
        showingFinished = false
    }
}
