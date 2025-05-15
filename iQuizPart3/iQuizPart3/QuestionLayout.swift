//
//  QuestionLayout.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/10/25.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    @Binding var selectedAnswer: Int?
    let onSubmit: () -> Void
    
    var body: some View {
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 20) {
            Text(question.text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 50)
            
            Spacer()
            
            VStack(spacing: 20) {
                ForEach(0..<question.answers.count, id: \.self) { index in
                    AnswerOption(
                        text: question.answers[index],
                        isSelected: selectedAnswer == index,
                        onTap: {
                            selectedAnswer = index
                        }
                    )
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: onSubmit) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedAnswer != nil ? Color.blue : Color.black)
                    .cornerRadius(20)
            }
            .disabled(selectedAnswer == nil)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}

struct AnswerOption: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void
    
    let lightBlue = Color(red: 218/255, green: 240/255, blue: 255/255)

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? lightBlue : Color.gray.opacity(0.2))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuestionView(
        question: Question(
            text: "What is 2 + 2?",
            answers: ["3", "4", "5", "6"],
            correctAnswer: 1
        ),
        selectedAnswer: .constant(nil),
        onSubmit: {}
    )
}
