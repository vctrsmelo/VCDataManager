//
//  VCDataManager.swift
//  VCDataManager
//
//  Created by Victor S Melo on 12/03/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import CoreData

class VCCoreDataManager: NSObject, VCDataManager {
    
    typealias Object = NSManagedObject
    
    private(set) var dataModelName: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// Should never be called
    private override init() {
        fatalError("VCDataManager.init() not implemented. Use init(dataModel:) instead")
    }
    
    init(modelName: String) {
        dataModelName = modelName
        super.init()
    }
    
    /**
    Saves object into Core Data.
    */
    func persist(object: NSManagedObject, completionHandler: @escaping (Error?) -> Void) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            completionHandler(error)
        }
   
        completionHandler(nil)
    }
    
    /**
    Get an object from Core Data.
    - Parameters:
        - name: the object name, defined into data model.
     */
    func getObject<T>(name: String) -> T where T: NSManagedObject {
        return T(context: persistentContainer.viewContext)
    }
    
    /**
     Fetch entities from Core Data according to predicate.
     */
    func fetchEntities<T>(predicate: NSPredicate?, completionHandler: @escaping ([T]) -> Void) where T: NSManagedObject {
        
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = predicate
        
        self.persistentContainer.viewContext.perform {
            completionHandler(try! request.execute())
        }
    }
    
    func update(objects: [Object], completionHandler: @escaping (Error?) -> Void) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            completionHandler(error)
        }
        completionHandler(nil)
    }
    
    func delete(objects: [Object], completionHandler: @escaping (Error?) -> Void) {
        objects.forEach {
            persistentContainer.viewContext.delete($0)
        }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            completionHandler(error)
        }
        
        completionHandler(nil)
    }
    
}
