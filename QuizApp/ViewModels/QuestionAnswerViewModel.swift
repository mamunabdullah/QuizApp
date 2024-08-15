//
//  QuestionAnswerViewModel.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import Foundation
import UIKit

class QuestionAnswerViewModel {
    private var questions: [QuizQuestion] = []
    private var currentQuestionIndex: Int = 0
    private var totalScore: Int = 0
    private var correctAnswerCount: Int = 0
    
    var currentQuestion: QuizQuestion? {
        return questions.isEmpty ? nil : questions[currentQuestionIndex]
    }
    
    var totalQuestions: Int {
        return questions.count
    }
    
    private let quizService = QuizService()
    
    func fetchQuestions(completion: @escaping () -> Void) {
        quizService.fetchQuestions { [weak self] result in
            switch result {
            case .success(let questions):
                self?.questions = questions
                completion()
            case .failure(let error):
                print("Error fetching questions: \(error)")
            }
        }
    }
    
    func getNextQuestion() -> QuizQuestion? {
        guard currentQuestionIndex < questions.count - 1 else { return nil }
        currentQuestionIndex += 1
        return currentQuestion
    }
    
    func getQuestionNumber() -> String {
        return "Question \(currentQuestionIndex + 1)/\(totalQuestions)"
    }
    
    func getScore() -> Int? {
          return currentQuestion?.score
      }
    
    func getTotalScore() -> Int {
        return totalScore
    }
    
    func getCorrectAnswerCount() -> Int {
        return correctAnswerCount
    }
    
    func getOptionLabels() -> [String: String]? {
        return currentQuestion?.answers
    }
    
    func getQuestionImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageUrlString = currentQuestion?.questionImageUrl, let url = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func hasQuestions() -> Bool {
        return !questions.isEmpty
    }
    
    func isAnswerCorrect(selectedKey: String) -> Bool {
        let isCorrect = selectedKey == currentQuestion?.correctAnswer
        if isCorrect {
            totalScore += currentQuestion?.score ?? 0
            correctAnswerCount += 1
        }
        return isCorrect
    }
}
