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
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
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
      func fetchBooks() -> [BookEntity] {
          let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
          do {
              return try context.fetch(request)
          } catch {
              print("데이터 가져오기 실패: \(error)")
              return []
          }
      }

      // Add
    func addBook(title: String, author: String, image: UIImage?, price: Int) {
        let book = BookEntity(context: context)
        book.title = title
        book.author = author
        book.dateAdded = Date()
        book.price = Int32(price)

        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            book.imageData = imageData
        }

        saveContext()
    }
    
    func fetchRecentBooks() -> [KakaoBook] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        
        do {
            let bookEntities = try context.fetch(request)
            print("Fetched \(bookEntities.count) recent books")
            return bookEntities.map { entity in
                KakaoBook(
                    title: entity.title ?? "Unknown Title", // nil일 경우 기본값 사용
                    authors: entity.author?.components(separatedBy: ", ") ?? ["Unknown Author"], // nil일 경우 기본값 사용
                    price: Int(entity.price),
                    contents: nil,
                    thumbnail: entity.thumbnail ?? "Unknown Thumbnail" // nil일 경우 기본값 사용
                )
            }
        } catch {
            print("Failed to fetch recent books: \(error)")
            return []
        }
    }
    
    func saveBook(_ book: KakaoBook) {
        print("Saving book: \(book)")  // KakaoBook 객체 확인
        let bookEntity = BookEntity(context: context)
        bookEntity.title = book.title ?? "Unknown Title"
        bookEntity.author = book.authors.joined(separator: ", ") ?? "Unknown Author"
        bookEntity.dateAdded = Date()
        bookEntity.price = Int32(book.price ?? 0)

        saveContext()
    }


      // Delete All
      func deleteAllBooks() {
          let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
          let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          do {
              try context.execute(deleteRequest)
              saveContext()
          } catch {
              print("전체 삭제 실패: \(error)")
          }
      }

      // Delete One
      func deleteBook(_ book: BookEntity) {
          context.delete(book)
          saveContext()
      }
}
