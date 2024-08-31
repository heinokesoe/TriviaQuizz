//
//  CustomQuizViewController.swift
//  TriviaQuizz
//
//  Created by God on 26/8/24.
//

import UIKit

class CustomQuizViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var customQuizzesDict: [String: [Quiz]] = [:]
    var customQuizImagesDict: [String: Data] = [:]
    var categories: [String] = []
    var viewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedQuizzes = viewModel.loadCustomQuizzes(forKey: "customQuizzes") {
            customQuizzesDict = savedQuizzes
            categories = Array(customQuizzesDict.keys)
        }
        if let saveImages = viewModel.loadCustomQuizImages(forKey: "customQuizImages") {
            customQuizImagesDict = saveImages
        }
        tableView.reloadData()
    }
    
    @IBAction func create(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "customQuizInputVC") as? CustomQuizInputViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func importQuiz(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "importQuizVC") as? ImportQuizViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CustomQuizViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCategoryCell", for: indexPath) as? CategoryCell {
            cell.categoryName.text = categories[indexPath.row]
            cell.categoryImage.image = UIImage(data: customQuizImagesDict[categories[indexPath.row]] ?? Data())
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "quizVC") as? QuizViewController {
            vc.quesitions = customQuizzesDict[categories[indexPath.row]]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
