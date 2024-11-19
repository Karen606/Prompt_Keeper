//
//  PromptFormViewModel.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import Foundation

class PromptFormViewModel {
    static let shared = PromptFormViewModel()
    @Published var promptModel = PromptModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.savePrompt(promptModel: promptModel, completion: completion)
    }
    
    func clear() {
        promptModel = PromptModel(id: UUID())
    }
}
