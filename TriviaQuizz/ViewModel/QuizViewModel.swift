//
//  QuizViewModel.swift
//  TriviaQuizz
//
//  Created by God on 26/8/24.
//

import Foundation
import Alamofire

class QuizViewModel {
    func fetchQuizzes(completion: @escaping (Result<([String], [String], [String: [Quiz]]), Error>) -> Void) {
        let url = "https://freaks.dev/quizzes.json"
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let quizResponses = try JSONDecoder().decode([QuizResponse].self, from: data)
                    let categories = quizResponses.map { $0.category }
                    let images = quizResponses.map { $0.image }
                    var quizzesDict: [String: [Quiz]] = [:]
                    for quizResponse in quizResponses {
                        quizzesDict[quizResponse.category] = quizResponse.quizzes
                    }
                    completion(.success((categories, images, quizzesDict)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCustomQuizzes(forKey key: String) -> [String: [Quiz]]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let quizzes = try decoder.decode([String: [Quiz]].self, from: data)
                return quizzes
            } catch {
                print("Failed to load quizzes: \(error)")
            }
        }
        return nil
    }
    
    func loadCustomQuizImages(forKey key: String) -> [String: Data]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let images = try decoder.decode([String: Data].self, from: data)
                return images
            } catch {
                print("Failed to load images: \(error)")
            }
        }
        return nil
    }
}
