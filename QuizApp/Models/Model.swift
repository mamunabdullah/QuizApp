//
//  Model.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import Foundation
struct QuizQuestion: Codable {
    let question: String
    let answers: [String: String]
    let questionImageUrl: String?
    let correctAnswer: String
    let score: Int
}

struct Quiz: Codable {
    let questions: [QuizQuestion]
}
