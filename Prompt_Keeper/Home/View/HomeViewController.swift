//
//  HomeViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var totalPromptsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    private let viewModel = HomeViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }

    func setupUI() {
        let fullText = "160 TOTAL PROMPTS"
        let attributedString = NSMutableAttributedString(string: fullText)

        if let range160 = fullText.range(of: "160") {
            let nsRange = NSRange(range160, in: fullText)
            attributedString.addAttribute(.font, value: UIFont.regular(size: 100) ?? .systemFont(ofSize: 100), range: nsRange)
        }

        if let rangeTotalPrompts = fullText.range(of: "TOTAL PROMPTS") {
            let nsRange = NSRange(rangeTotalPrompts, in: fullText)
            attributedString.addAttribute(.font, value: UIFont.bold(size: 14) ?? .systemFont(ofSize: 14), range: nsRange)
        }
    }
    
    func subscribe() {
        viewModel.$prompts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] prompts in
                guard let self = self else { return }
                let totalPrompts = "\(prompts.count) TOTAL PROMPTS"
                let attributedString = NSMutableAttributedString(string: totalPrompts)

                if let range = totalPrompts.range(of: "\(prompts.count)") {
                    let nsRange = NSRange(range, in: totalPrompts)
                    attributedString.addAttribute(.font, value: UIFont.regular(size: 100) ?? .systemFont(ofSize: 100), range: nsRange)
                }
                self.totalPromptsLabel.attributedText = attributedString
                let favoritesPrompts = prompts.filter({ $0.isFavorite })
                let favorites = "\(favoritesPrompts.count) FAVORITES"
                let attributedFavoritesString = NSMutableAttributedString(string: favorites)

                if let range = favorites.range(of: "\(favoritesPrompts.count)") {
                    let nsRange = NSRange(range, in: favorites)
                    attributedFavoritesString.addAttribute(.font, value: UIFont.regular(size: 100) ?? .systemFont(ofSize: 100), range: nsRange)
                }
                self.favoritesLabel.attributedText = attributedFavoritesString
            }
            .store(in: &cancellables)
    }

}
