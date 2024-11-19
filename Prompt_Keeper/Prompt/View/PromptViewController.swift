//
//  PromptViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit

class PromptViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var categoryButtons: [CategoryButton]!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var promptyLabel: UILabel!
    @IBOutlet weak var addPromptButton: UIButton!
    @IBOutlet weak var promptyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        searchTextField.setupLeftViewIcon(.search, size: CGSize(width: 40, height: 40))
        searchTextField.font = .regular(size: 18)
        categoryLabel.font = .semibold(size: 17)
        addPromptButton.titleLabel?.font = .regular(size: 24)
        addPromptButton.addShadow()
        promptyLabel.font = .medium(size: 20)
    }

    @IBAction func clickedAdd(_ sender: UIButton) {
        self.hidesBottomBarWhenPushed = true
        self.pushViewController(PromptFormViewController.self)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func chooseCategory(_ sender: CategoryButton) {
    }
}
