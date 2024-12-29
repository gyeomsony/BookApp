//
//  Book.swift
//  BookApp
//
//  Created by 손겸 on 12/26/24.
//

import Foundation
import CoreData

@objc(BookEntity)
public class BookEntity: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var imageData: Data?
}

extension BookEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "Book")
    }
}


