//
//  SearchItem+CoreDataClass.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//

import Foundation
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
    
    convenience init?(context: NSManagedObjectContext, text: String, occurredDate: Date) {
        self.init(entity: type(of: self).entity(), insertInto: context)
        
        self.text = text
        self.occurredDate = occurredDate
    }
}
