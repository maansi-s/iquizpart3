//
//  FinalView.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/10/25.
//

import SwiftUI

struct FinishedView: View {
    @ObservedObject var quizSession: QuizSession
    @Binding var isQuizActive: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text(quizSession.performanceText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(performanceColor)
            
            VStack(spacing: 20) {
                Text("Your score:")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(quizSession.correctAnswersCount) of \(quizSession.topic.questions.count) correct.")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: {
                isQuizActive = false
            }) {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
    
    var performanceColor: Color {
        switch quizSession.scorePercentage {
        case 80...100:
            return .green
        case 60..<80:
            return .orange
        default:
            return .red
        }
    }
}

#Preview {
    let topic = QuizTopic(
        name: "Sample",
        questions: [
            Question(text: "Q1", answers: ["A", "B", "C", "D"], correctAnswer: 0),
            Question(text: "Q2", answers: ["A", "B", "C", "D"], correctAnswer: 1),
            Question(text: "Q3", answers: ["A", "B", "C", "D"], correctAnswer: 2)
        ]
    )
    let session = QuizSession(topic: topic)
    session.userAnswers = [0, 1, 2]
    
    return FinishedView(
        quizSession: session,
        isQuizActive: .constant(true)
    )
}
