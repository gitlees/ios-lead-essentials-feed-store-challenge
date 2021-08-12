//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		context.perform {
			do {
				if let managedCache = try ManagedCache.find(in: self.context) {
					completion(.found(feed: managedCache.localFeed, timestamp: managedCache.timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		context.perform {
			do {
				try ManagedCache.find(in: self.context).map(self.context.delete)
			} catch {}
			let manageCacheToInsert = ManagedCache(context: self.context)
			manageCacheToInsert.feed = NSOrderedSet(array: feed.map { local in
				let managedFeedImage = ManagedFeedImage(context: self.context)
				managedFeedImage.id = local.id
				managedFeedImage.imageDescription = local.description
				managedFeedImage.imageLocation = local.location
				managedFeedImage.url = local.url
				return managedFeedImage
			})
			manageCacheToInsert.timestamp = timestamp
			do {
				try self.context.save()
				completion(nil)
			} catch {
				self.context.rollback()
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		completion(nil)
	}
}
