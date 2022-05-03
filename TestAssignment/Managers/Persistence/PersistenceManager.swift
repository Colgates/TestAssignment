//
//  PersistenceManager.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import CoreData
import Foundation

class PersistenceManager {
    
    let persistentContainer: NSPersistentContainer
    
    static let shared = PersistenceManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
    func delete(_ item: Favorites) {
        viewContext.delete(item)
        saveContext()
    }
    
    func fetchContext() -> [Favorites] {
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func createAndSaveNewObject(id: String, imageUrl: String, authorName: String) {
        let favoritePhoto = Favorites(context: viewContext)
        favoritePhoto.id = id
        favoritePhoto.imageUrl = imageUrl
        favoritePhoto.authorName = authorName
        saveContext()
    }
    
    func getObjectWith(id: String) -> Favorites? {
        let favorites = fetchContext()
        
        for item in favorites {
            if item.id == id {
                return item
            }
        }
        return nil
    }
}
