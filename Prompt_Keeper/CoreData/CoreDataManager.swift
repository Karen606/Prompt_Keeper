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
                prompt.isFavorite = promptModel.isFavorite
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
                    let promptModel = PromptModel(id: result.id, name: result.name, category: result.category, info: result.info, isFavorite: result.isFavorite)
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
    
    func deletePrompt(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let promptToDelete = results.first {
                    backgroundContext.delete(promptToDelete)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Prompt not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func updateIsFavorite(for id: UUID, to isFavorite: Bool, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let promptToUpdate = results.first {
                    promptToUpdate.isFavorite = isFavorite
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Prompt not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchFavoritePrompts(completion: @escaping ([PromptModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Prompt> = Prompt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) // Filter only favorites
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let promptsModel = results.map { result in
                    PromptModel(
                        id: result.id,
                        name: result.name,
                        category: result.category,
                        info: result.info,
                        isFavorite: result.isFavorite
                    )
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
