//
//  SearchItem+CoreDataProperties.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchItem> {
        return NSFetchRequest<SearchItem>(entityName: "SearchItem")
    }

    @NSManaged public var text: String?
    @NSManaged public var rawOccurredDate: NSDate?

}
