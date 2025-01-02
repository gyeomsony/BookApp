//
//  Book+CoreDataProperties.swift
//  BookApp
//
//  Created by 손겸 on 12/31/24.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var price: Int32

}

extension Book : Identifiable {

}
