//
//  AnswerLayout.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/10/25.
//

import SwiftUI

struct AnswerView: View {
    let question: Question
    let userAnswer: Int?
    let onNext: () -> Void
    
    var isCorrect: Bool {
        userAnswer == question.correctAnswer
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(question.text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 50)
            
            Spacer()
            
            VStack(spacing: 12) {
                ForEach(0..<question.answers.count, id: \.self) { index in
                    AnswerResult(
                        text: question.answers[index],
                        isCorrect: index == question.correctAnswer,
                        wasSelected: index == userAnswer
                    )
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text(isCorrect ? "Correct!" : "Not quite!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(isCorrect ? .green : .red)
            }
            .padding()
            
            Spacer()
            
            Button(action: onNext) {
                Text("Next")
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
}

struct AnswerResult: View {
    let text: String
    let isCorrect: Bool
    let wasSelected: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
        )
    }
    
    var backgroundColor: Color {
        if isCorrect {
            return Color.green
        } else if wasSelected {
            return Color.red
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    AnswerView(
        question: Question(
            text: "What is 2 + 2?",
            answers: ["3", "4", "5", "6"],
            correctAnswer: 1
        ),
        userAnswer: 0,
        onNext: {}
    )
}
