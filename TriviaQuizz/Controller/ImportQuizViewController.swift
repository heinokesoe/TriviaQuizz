//
//  ImportQuizViewController.swift
//  TriviaQuizz
//
//  Created by God on 29/8/24.
//

import UIKit

class ImportQuizViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var importedQuizzes: [Quiz] = []
    var customQuizzesDict: [String: [Quiz]] = [:]
    var customQuizImagesDict: [String: Data] = [:]
    var categories: [String] = []
    var categoryImageView: UIImageView!
    var categoryNameTextField: UITextField!
    var viewModel = QuizViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
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
        
        let selectImageButton = UIButton(type: .system)
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
        
        let jsonFormatLabel = UILabel()
        jsonFormatLabel.text = """
        JSON file format must be:
        {
          "quizzes": [
            {
              "question": "Who painted the 'Mona Lisa'?",
              "choices": ["Vincent van Gogh", "Pablo Picasso", "Leonardo da Vinci", "Michelangelo"],
              "correct_answer": "Leonardo da Vinci"
            },
            ...
          ]
        }
        And there must be 10 quizzes.
        """
        jsonFormatLabel.numberOfLines = 0
        jsonFormatLabel.font = UIFont.systemFont(ofSize: 14)
        jsonFormatLabel.textColor = .darkGray
        jsonFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(jsonFormatLabel)
        
        NSLayoutConstraint.activate([
            jsonFormatLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
            jsonFormatLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            jsonFormatLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        
        previousView = jsonFormatLabel
        
        let importButton = UIButton(type: .system)
        importButton.setTitle("Import JSON", for: .normal)
        importButton.addTarget(self, action: #selector(importJSON), for: .touchUpInside)
        importButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(importButton)
        
        NSLayoutConstraint.activate([
            importButton.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
            importButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        previousView = importButton
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Category", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: padding),
            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
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
    
    @objc func importJSON() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
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
        let alert = UIAlertController(title: "", message: "Please check if you have imported json file.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func save() {
        var categoryName = categoryNameTextField.text ?? ""
        if categoryName.isEmpty {
            categoryName = "Custom Category"
        }
        if importedQuizzes.isEmpty {
            showAlert()
            return
        }
        let imageData = self.categoryImageView.image?.pngData()
        self.customQuizzesDict[categoryName] = self.importedQuizzes
        self.customQuizImagesDict[categoryName] = imageData
        self.saveCustomQuizzes(self.customQuizzesDict, forKey: "customQuizzes")
        self.saveCustomQuizImages(self.customQuizImagesDict, forKey: "customQuizImages")
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ImportQuizViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedQuiz = try decoder.decode(ImportedQuiz.self, from: data)
            self.importedQuizzes = importedQuiz.quizzes
            print("Imported \(importedQuizzes.count) quizzes")
        } catch {
            print("Failed to import JSON: \(error)")
        }
    }
}
