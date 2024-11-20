//
//  PromptModel.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import Foundation

struct PromptModel {
    var id: UUID?
    var name: String?
    var category: String?
    var info: String?
    var isFavorite: Bool = false
}
