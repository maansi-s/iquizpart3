//
//  QuizLayout.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/10/25.
//

import SwiftUI

struct QuizView: View {
    let topic: QuizTopic
    @Binding var isQuizActive: Bool
    @StateObject private var quizSession: QuizSession
    
    init(topic: QuizTopic, isQuizActive: Binding<Bool>) {
        self.topic = topic
        self._isQuizActive = isQuizActive
        self._quizSession = StateObject(wrappedValue: QuizSession(topic: topic))
    }
    
    var body: some View {
        ZStack {
            if quizSession.showingFinished {
                FinishedView(quizSession: quizSession, isQuizActive: $isQuizActive)
            } else {
                QuestionContainerView(quizSession: quizSession, isQuizActive: $isQuizActive)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    isQuizActive = false
                }
            }
        }
    }
}

struct QuestionContainerView: View {
    @ObservedObject var quizSession: QuizSession
    @Binding var isQuizActive: Bool
    @State private var selectedAnswer: Int? = nil
    
    var body: some View {
        VStack {
            if quizSession.showingAnswer {
                AnswerView(
                    question: quizSession.currentQuestion,
                    userAnswer: selectedAnswer,
                    onNext: {
                        quizSession.nextQuestion()
                        selectedAnswer = nil
                    }
                )
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                quizSession.nextQuestion()
                                selectedAnswer = nil
                            } else if value.translation.width < -100 {
                                isQuizActive = false
                            }
                        }
                )
            } else {
                QuestionView(
                    question: quizSession.currentQuestion,
                    selectedAnswer: $selectedAnswer,
                    onSubmit: {
                        if let answer = selectedAnswer {
                            quizSession.submitAnswer(answer)
                        }
                    }
                )
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 && selectedAnswer != nil {
                                if let answer = selectedAnswer {
                                    quizSession.submitAnswer(answer)
                                }
                            } else if value.translation.width < -100 {
                                isQuizActive = false
                            }
                        }
                )
            }
        }
    }
}

#Preview {
    NavigationView {
        QuizView(
            topic: QuizTopic(
                name: "Sample",
                questions: [
                    Question(text: "Sample question?", answers: ["A", "B", "C", "D"], correctAnswer: 0)
                ]
            ),
            isQuizActive: .constant(true)
        )
    }
}
