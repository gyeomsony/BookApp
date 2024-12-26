//
//  CoreDataManager.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Book")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("실패: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
          return persistentContainer.viewContext
      }

      // Save Context
      func saveContext() {
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  print("Context 저장 실패: \(error)")
              }
          }
      }

      // Fetch
      func fetchBooks() -> [Book] {
          let request: NSFetchRequest<Book> = Book.fetchRequest()
          do {
              return try context.fetch(request)
          } catch {
              print("데이터 가져오기 실패: \(error)")
              return []
          }
      }

      // Add
      func addBook(title: String, author: String) {
          let book = Book(context: context)
          book.title = title
          book.author = author
          book.dateAdded = Date()
          saveContext()
      }

      // Delete All
      func deleteAllBooks() {
          let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
          let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          do {
              try context.execute(deleteRequest)
              saveContext()
          } catch {
              print("전체 삭제 실패: \(error)")
          }
      }

      // Delete One
      func deleteBook(_ book: Book) {
          context.delete(book)
          saveContext()
      }
}
