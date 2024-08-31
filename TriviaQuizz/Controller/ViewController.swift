//
//  ViewController.swift
//  TriviaQuizz
//
//  Created by God on 25/8/24.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    typealias Quizzes = [String: [Quiz]]
    var quizzes: Quizzes = [:]
    var categories: [String] = []
    var imageLinks: [String] = []
    var viewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.fetchQuizzes { result in
            switch result {
            case .success(let (categories, images, quizzes)):
                self.categories = categories
                self.imageLinks = images
                self.quizzes = quizzes
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching quizzes:", error)
            }
        }
    }
    
}

extension ViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            cell.configure(imageURL: imageLinks[indexPath.row], category: categories[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "quizVC") as? QuizViewController {
            vc.quesitions = quizzes[categories[indexPath.row]]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
