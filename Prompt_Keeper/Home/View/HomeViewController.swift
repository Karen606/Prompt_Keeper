//
//  HomeViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var totalPromptsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        let fullText = "160 TOTAL PROMPTS"
        let attributedString = NSMutableAttributedString(string: fullText)

        if let range160 = fullText.range(of: "160") {
            let nsRange = NSRange(range160, in: fullText)
            attributedString.addAttribute(.font, value: UIFont.regular(size: 100) ?? .systemFont(ofSize: 100), range: nsRange)
        }

        // Apply the small font to "TOTAL PROMPTS"
        if let rangeTotalPrompts = fullText.range(of: "TOTAL PROMPTS") {
            let nsRange = NSRange(rangeTotalPrompts, in: fullText)
            attributedString.addAttribute(.font, value: UIFont.bold(size: 14) ?? .systemFont(ofSize: 14), range: nsRange)
        }
    }

}
