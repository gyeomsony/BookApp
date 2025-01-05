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
        
        func resetPersistentStore() {
            if let storeURL = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
                do {
                    try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
                    print("Core Data 저장소 초기화 완료")
                } catch {
                    print("Core Data 저장소 초기화 실패: \(error)")
                }
            }
        }
        
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

      // Add
    func addBook(title: String, author: String, image: UIImage?, price: Int) {
        context.perform { [weak self] in
            guard let self = self else { return }
            
            print("Attempting to add book: \(title)")
            guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: self.context) else {
                print("Error: Book entity not found")
                return
            }
            
            let book = BookEntity(entity: entity, insertInto: self.context)
            book.title = title
            book.author = author
            book.dateAdded = Date()
            book.price = Int32(price)

            if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
                book.imageData = imageData
            }

            print("Book added successfully: \(title)")
            self.saveContext()
        }
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
        context.perform { [weak self] in
            guard let self = self else { return }
            
            print("Attempting to save book: \(book.title ?? "Unknown")") // 디버깅 로그
            
            let bookEntity = BookEntity(context: self.context)
            bookEntity.title = book.title ?? "제목 없음"
            bookEntity.author = book.authors.joined(separator: ", ")
            bookEntity.dateAdded = Date()
            bookEntity.price = Int32(book.price ?? 0)

            self.saveContext()
            print("Book saved successfully: \(book.title ?? "Unknown")") // 디버깅 로그
        }
    }
    
    func fetchBooks() -> [BookEntity] {
        context.performAndWait {
            do {
                let books = try context.fetch(BookEntity.fetchRequest())
                print("Fetched \(books.count) books from Core Data") // 디버깅
                return books
            } catch {
                print("Failed to fetch books: \(error)")
                return []
            }
        }
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
