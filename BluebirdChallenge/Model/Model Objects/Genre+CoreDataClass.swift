//
//  Genre+CoreDataClass.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Genre)
public class Genre: NSManagedObject {
    var id: Int {
        get {
            return Int(rawID)
        }
        set {
            self.rawID = Int64(newValue)
        }
    }
    
    convenience init?(context: NSManagedObjectContext, id: Int, name: String) {
        self.init(entity: type(of: self).entity(), insertInto: context)
        
        self.name = name
        self.id = id
    }
}

