//
//  HomeViewModel.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    @Published var prompts: [PromptModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchPrompts { [weak self] prompts, _ in
            guard let self = self else { return }
            self.prompts = prompts
        }
    }
}
