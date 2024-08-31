//
//  QuizModel.swift
//  TriviaQuizz
//
//  Created by God on 25/8/24.
//

import Foundation

struct QuizResponse: Codable {
    let category: String
    let image: String
    let quizzes: [Quiz]
}

struct Quiz: Codable {
    let question: String
    let choices: [String]
    let correctAnswer: String

    enum CodingKeys: String, CodingKey {
        case question
        case choices
        case correctAnswer = "correct_answer"
    }
}

struct ImportedQuiz: Codable {
    let quizzes: [Quiz]
}

struct Fact: Codable {
    let facts: [String]
}
