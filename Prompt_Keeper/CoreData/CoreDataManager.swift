//
//  CoreDataManager.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 20.11.24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Prompt_Keeper")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func savePrompt(promptModel: PromptModel, completion: @escaping (Error?) -> Void) {
        let id = promptModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let prompt: Prompt
                
                if let existingPrompt = results.first {
                    prompt = existingPrompt
                } else {
                    prompt = Prompt(context: backgroundContext)
                    prompt.id = id
                }
                prompt.name = promptModel.name
                prompt.category = promptModel.category
                prompt.info = promptModel.info
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPrompts(completion: @escaping ([PromptModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var promptsModel: [PromptModel] = []
                for result in results {
                    let promptModel = PromptModel(id: result.id, name: result.name, category: result.category, info: result.info)
                    promptsModel.append(promptModel)
                }
                DispatchQueue.main.async {
                    completion(promptsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}
