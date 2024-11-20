//
//  FavoritesViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit
import Combine
import DropDown

class FavoritesViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var categoryButtons: [CategoryButton]!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var promptyLabel: UILabel!
    @IBOutlet weak var promptyTableView: UITableView!
    private let viewModel = FavoritePromtViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func setupUI() {
        searchTextField.setupLeftViewIcon(.search, size: CGSize(width: 40, height: 40))
        searchTextField.font = .regular(size: 18)
        searchTextField.delegate = self
        categoryLabel.font = .semibold(size: 17)
        promptyLabel.font = .medium(size: 20)
        promptyTableView.register(UINib(nibName: "PromptTableViewCell", bundle: nil), forCellReuseIdentifier: "PromptTableViewCell")
        promptyTableView.delegate = self
        promptyTableView.dataSource = self
        categoryButtons.first?.isSelected = true
    }
    
    func setupDropDown() {
        dropDown.backgroundColor = .background
        dropDown.layer.cornerRadius = 8
        dropDown.dataSource = ["Edit", "Copy", "Remove from favorites", "Delete"]
        dropDown.anchorView = self.view
        dropDown.direction = .bottom
        dropDown.separatorColor = .baseBlack
        DropDown.appearance().textColor = .baseBlack
        DropDown.appearance().textFont = .regular(size: 16) ?? .systemFont(ofSize: 16)
        dropDown.selectionBackgroundColor = .background
        dropDown.selectedTextColor = .baseBlack
        dropDown.addShadow()
        dropDown.width = 230
        dropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            switch index {
            case 0:
                cell.iconImageView.image = UIImage.dropDown1
            case 1:
                cell.iconImageView.image = UIImage.dropDown2
            case 2:
                cell.iconImageView.image = UIImage.minus
            case 3:
                cell.iconImageView.image = UIImage.dropDown3
            default:
                break
            }
            let color = (index == 3 || index == 2) ? UIColor.baseRed : .baseBlack
            cell.optionLabel.attributedText = NSAttributedString(string: item, attributes: [.foregroundColor: color])
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self, let prompt = self.viewModel.selectedPrompt else { return }
            switch index {
            case 0:
                PromptFormViewModel.shared.promptModel = prompt
                self.openPromptFormVC()
            case 1:
                if let info = self.viewModel.selectedPrompt?.info {
                    UIPasteboard.general.string = info
                    print("Text copied to clipboard: \(info)")
                }
            case 2:
                self.viewModel.updateIsFavorite(isfavorite: false) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        self.showErrorAlert(message: error.localizedDescription)
                    } else {
                        viewModel.fetchData()
                    }
                }
            case 3:
                self.viewModel.delete { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        self.showErrorAlert(message: error.localizedDescription)
                    } else {
                        viewModel.fetchData()
                    }
                }
            default:
                break
            }
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.selectedPrompt = nil
        }
        
    }
    
    func subscribe() {
        viewModel.$prompts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] prompts in
                guard let self = self else { return }
                self.promptyTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openPromptFormVC() {
        let promtFormVC = PromptFormViewController(nibName: "PromptFormViewController", bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(promtFormVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseCategory(_ sender: CategoryButton) {
        if sender.isSelected { return }
        categoryButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        viewModel.chooseCatergory(category: sender.titleLabel?.text ?? "All")
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromptTableViewCell", for: indexPath) as! PromptTableViewCell
        cell.configure(prompt: viewModel.prompts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension FavoritesViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text.checkValidation() {
            viewModel.search(by: textField.text)
        } else {
            viewModel.search(by: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension FavoritesViewController: PromtTableViewCellDelegate {
    func clickedMore(cell: PromptTableViewCell) {
        let buttonFrameInTableView = cell.moreButton.convert(cell.moreButton.bounds, to: promptyTableView)
        let buttonFrameInSuperview = promptyTableView.convert(buttonFrameInTableView, to: self.view)
        dropDown.bottomOffset = CGPoint(x: buttonFrameInSuperview.maxX - 230, y: buttonFrameInSuperview.maxY + 2)
        dropDown.show()
    }
}
