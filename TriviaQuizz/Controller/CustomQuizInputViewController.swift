//
//  CustomQuizViewController.swift
//  TriviaQuizz
//
//  Created by God on 26/8/24.
//

import UIKit

class CustomQuizInputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var customQuizzes = [Quiz]()
    var customQuizzesDict: [String: [Quiz]] = [:]
    var customQuizImagesDict: [String: Data] = [:]
    var categoryNameTextField: UITextField!
    var questionTextFields: [UITextField] = []
    var choiceTextFields: [[UITextField]] = []
    var correctAnswerTextFields: [UITextField] = []
    var selectImageButton: UIButton!
    var categoryImageView: UIImageView!
    var viewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedQuizzes = viewModel.loadCustomQuizzes(forKey: "customQuizzes") {
            customQuizzesDict = savedQuizzes
        }
        if let saveImages = viewModel.loadCustomQuizImages(forKey: "customQuizImages") {
            customQuizImagesDict = saveImages
        }
        setupUI()
    }
    
    func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        var previousView: UIView? = nil
        let padding: CGFloat = 20
        
        let categoryNameLabel = UILabel()
        categoryNameLabel.text = "Category Name:"
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryNameLabel)
        
        categoryNameTextField = UITextField()
        categoryNameTextField.placeholder = "Enter category name"
        categoryNameTextField.borderStyle = .roundedRect
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            categoryNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            categoryNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            
            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8),
            categoryNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            categoryNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)
        ])
        
        previousView = categoryNameTextField
        
        categoryImageView = UIImageView()
        categoryImageView.layer.borderWidth = 1
        categoryImageView.layer.borderColor = UIColor.lightGray.cgColor
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryImageView)
        
        selectImageButton = UIButton(type: .system)
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(selectImageButton)
        
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
            categoryImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            categoryImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            categoryImageView.heightAnchor.constraint(equalToConstant: 200),
            categoryImageView.widthAnchor.constraint(equalToConstant: 200),
            selectImageButton.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 8),
            selectImageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        previousView = selectImageButton
        
        for i in 0..<10 {
            let questionLabel = UILabel()
            questionLabel.text = "Question \(i + 1):"
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(questionLabel)
            
            let questionTextField = UITextField()
            questionTextField.placeholder = "Enter your question"
            questionTextField.borderStyle = .roundedRect
            questionTextField.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(questionTextField)
            questionTextFields.append(questionTextField)
            
            var choiceFields: [UITextField] = []
            for j in 0..<4 {
                let choiceTextField = UITextField()
                choiceTextField.placeholder = "Choice \(j + 1)"
                choiceTextField.borderStyle = .roundedRect
                choiceTextField.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(choiceTextField)
                choiceFields.append(choiceTextField)
            }
            choiceTextFields.append(choiceFields)
            
            let correctAnswerTextField = UITextField()
            correctAnswerTextField.placeholder = "Correct answer"
            correctAnswerTextField.borderStyle = .roundedRect
            correctAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(correctAnswerTextField)
            correctAnswerTextFields.append(correctAnswerTextField)
            
            NSLayoutConstraint.activate([
                questionLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
                questionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                questionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
                
                questionTextField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
                questionTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                questionTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)
            ])
            
            var lastChoiceField: UIView = questionTextField
            for choiceField in choiceFields {
                NSLayoutConstraint.activate([
                    choiceField.topAnchor.constraint(equalTo: lastChoiceField.bottomAnchor, constant: 8),
                    choiceField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                    choiceField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)
                ])
                lastChoiceField = choiceField
            }
            
            NSLayoutConstraint.activate([
                correctAnswerTextField.topAnchor.constraint(equalTo: lastChoiceField.bottomAnchor, constant: 8),
                correctAnswerTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                correctAnswerTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)
            ])
            
            previousView = correctAnswerTextField
        }
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitCustomQuiz), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
            submitButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
        ])
    }
    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            categoryImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addCustomCategory(categoryName: String, quizzes: [Quiz]) {
        customQuizzesDict[categoryName] = quizzes
    }
    
    func saveCustomQuizzes(_ quizzes: [String: [Quiz]], forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(quizzes)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save quizzes: \(error)")
        }
    }
    
    func saveCustomQuizImages(_ images: [String: Data], forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(images)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save images: \(error)")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "", message: "Please check if you have filled all the questions, choices, correct answer and make sure the correct answer is in the choices.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func submitCustomQuiz() {
        customQuizzes.removeAll()
        var categoryName = categoryNameTextField.text ?? ""
        if categoryName.isEmpty {
            categoryName = "Custom Category"
        }
        let imageData = categoryImageView.image?.pngData()
        for i in 0..<10 {
            let question = questionTextFields[i].text ?? ""
            if question.isEmpty {
                showAlert()
                return
            }
            var choices: [String] = []
            for j in 0..<4 {
                let choice = choiceTextFields[i][j].text ?? ""
                if choice.isEmpty {
                    showAlert()
                    return
                }
                choices.append(choice)
            }
            let correctAnswer = correctAnswerTextFields[i].text ?? ""
            if correctAnswer.isEmpty {
                showAlert()
                return
            }
            if choices.contains(correctAnswer) {
                let customQuiz = Quiz(question: question, choices: choices, correctAnswer: correctAnswer)
                customQuizzes.append(customQuiz)
            } else {
                showAlert()
                return
            }
        }
        customQuizzesDict[categoryName] = customQuizzes
        customQuizImagesDict[categoryName] = imageData
        saveCustomQuizzes(customQuizzesDict, forKey: "customQuizzes")
        saveCustomQuizImages(customQuizImagesDict, forKey: "customQuizImages")
        navigationController?.popToRootViewController(animated: true)
    }
}

