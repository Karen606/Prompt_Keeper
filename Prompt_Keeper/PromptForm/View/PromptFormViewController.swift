//
//  PromptFormViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit
import Combine
import DropDown

class PromptFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: PaddingTextField!
    @IBOutlet weak var descriptionTextView: BaseTextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var saveButton: BaseButton!
    private let dropDown = DropDown()
    private let viewModel = PromptFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        dropDown.width = categoryView.bounds.width
        dropDown.bottomOffset = CGPoint(x: categoryView.frame.minX, y: categoryView.frame.maxY + 2)
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        titleLabels.forEach({ $0.font = .regular(size: 16) })
        nameTextField.font = .regular(size: 16)
        nameTextField.layer.borderColor = UIColor.baseBlack.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 8
        categoryView.layer.borderColor = UIColor.baseBlack.cgColor
        categoryView.layer.borderWidth = 1
        categoryView.layer.cornerRadius = 8
        categoryButton.titleLabel?.font = .regular(size: 16)
        descriptionTextView.layer.borderColor = UIColor.baseBlack.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.font = .regular(size: 16)
        saveButton.titleLabel?.font = .regular(size: 24)
        nameTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    func setupDropDown() {
        dropDown.backgroundColor = .background
        dropDown.layer.cornerRadius = 4
        dropDown.dataSource = ["All", "Work", "Personal", "Studies"]
        dropDown.anchorView = self.view
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .baseBlack
        DropDown.appearance().textFont = .regular(size: 16) ?? .systemFont(ofSize: 16)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.categoryButton.setTitle(item, for: .normal)
            self.viewModel.promptModel.category = item
        }
    }
    
    func subscribe() {
        viewModel.$promptModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] prompt in
                guard let self = self else { return }
                self.saveButton.isEnabled = (prompt.name.checkValidation() && prompt.category.checkValidation() && prompt.info.checkValidation())
                self.nameTextField.text = prompt.name
                self.categoryButton.setTitle(prompt.category, for: .normal)
                self.descriptionTextView.text = prompt.info
            }
            .store(in: &cancellables)
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension PromptFormViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.promptModel.name = textField.text
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.promptModel.info = textView.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
