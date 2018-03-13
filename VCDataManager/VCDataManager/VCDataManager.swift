//
//  VCDataManager.swift
//  VCDataManager
//
//  Created by Victor S Melo on 13/03/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import Foundation
import CoreData

enum VCDataManagerError: Error {
    case unableToCreateObject
    case unableToFetchEntity
}

protocol VCDataManager {
    
    associatedtype Object
    
    func getObject<T>(name: String) -> T where T == Object
    
    func persist(object: Object, completionHandler: @escaping (Error?) -> Void)
    
    func fetchEntities<T>(predicate: NSPredicate?, completionHandler: @escaping ([T]) -> Void) where T == Object
    
    func update(objects: [Object], completionHandler: @escaping (Error?) -> Void)
    
    func delete(objects: [Object], completionHandler: @escaping (Error?) -> Void)
    
}
