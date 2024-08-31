//
//  QuizViewController.swift
//  TriviaQuizz
//
//  Created by God on 25/8/24.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var quesitions:[Quiz]?
    var answerSelected = false
    var isCorrectAnswer = false
    var  points = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onClickExit(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        if !answerSelected {
            let alert = UIAlertController(title: "Select One Option", message: "Please select one option before moving to the next question.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        answerSelected = false
        if isCorrectAnswer {
            points += 1
        }
        if index<(self.quesitions?.count ?? 0) - 1 {
            index += 1
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: true)
            
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "resultVC") as? ResultViewController else {return}
            vc.result = points
            vc.modalPresentationStyle = .automatic
            present(vc, animated: true)
        }
    }
}

extension QuizViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quesitions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quizCollectionVC", for: indexPath) as? QuizCollectionViewCell else {return QuizCollectionViewCell()}
        cell.optionA.layer.cornerRadius = 5
        cell.optionB.layer.cornerRadius = 5
        cell.optionC.layer.cornerRadius = 5
        cell.optionD.layer.cornerRadius = 5
        cell.setValues = quesitions?[indexPath.row]
        cell.selectedOption = { [weak self] isCorrect in
            self?.answerSelected = true
            self?.isCorrectAnswer = isCorrect
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
