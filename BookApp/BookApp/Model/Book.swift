//
//  Book.swift
//  BookApp
//
//  Created by 손겸 on 12/26/24.
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var dateAdded: Date?
}

extension Book {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }
}

