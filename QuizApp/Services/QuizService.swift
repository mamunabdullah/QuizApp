//
//  QuizService.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import Foundation
class QuizService {
    func fetchQuestions(completion: @escaping (Result<[QuizQuestion], Error>) -> Void) {
        let url = URL(string: "https://herosapp.nyc3.digitaloceanspaces.com/quiz.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let quiz = try JSONDecoder().decode(Quiz.self, from: data)
                completion(.success(quiz.questions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
