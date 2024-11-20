//
//  PromptViewModel.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import Foundation

class PromptViewModel {
    static let shared = PromptViewModel()
    private var data: [PromptModel] = []
    @Published var prompts: [PromptModel] = []
    var selectedPrompt: PromptModel?
    private var category: String = "All"
    private var search: String?
    private init() {}
    
    func chooseCatergory(category: String) {
        self.category = category
        filter()
    }
    
    func search(by value: String?) {
        self.search = value
        filter()
    }
    
    func filter() {
        let trimmedSearch = search?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self.prompts = data.filter { model in
            let matchesCategory = category.isEmpty || model.category?.lowercased() == category.lowercased()
            let matchesSearch = trimmedSearch == nil || model.name?.lowercased().contains(trimmedSearch!) == true
            return matchesCategory && matchesSearch
        }
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchPrompts { [weak self] prompts, _ in
            guard let self = self else { return }
            self.data = prompts
            filter()
        }
    }
    
    func delete(completion: @escaping (Error?) -> Void) {
        guard let id = selectedPrompt?.id else { return }
        CoreDataManager.shared.deletePrompt(by: id, completion: completion)
    }
    
    func updateIsFavorite(isfavorite: Bool, completion: @escaping (Error?) -> Void) {
        guard let id = selectedPrompt?.id else { return }
        CoreDataManager.shared.updateIsFavorite(for: id, to: isfavorite, completion: completion)
    }
}
