//
//  SearchItem+CoreDataClass.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//

import UIKit
import CoreData

@objc(SearchItem)
public class SearchItem: NSManagedObject {
    var occurredDate: Date? {
        get {
            return self.rawOccurredDate as Date?
        }
        set {
            self.rawOccurredDate = newValue as NSDate?
        }
    }
    
    convenience init?(context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext, text: String, occurredDate: Date = Date()) {
        guard let context = context else {
            return nil
        }
        
        self.init(entity: type(of: self).entity(), insertInto: context)
        
        self.text = text
        self.occurredDate = occurredDate
    }
    
    static func retrieveLatest(in context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) -> [SearchItem] {
        guard let context = context else {
            return []
        }
        
        do {
            let request: NSFetchRequest<SearchItem> = SearchItem.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SearchItem.rawOccurredDate), ascending: false)]
            return try context.fetch(request)
        } catch {
            return []
        }
    }
}
