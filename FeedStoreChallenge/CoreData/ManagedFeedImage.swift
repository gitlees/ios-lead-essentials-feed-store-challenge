//
//  ManagedFeedImage+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by Stas Lee on 11/8/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var imageLocation: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache?

	var asLocal: LocalFeedImage {
		return LocalFeedImage(id: id, description: imageDescription, location: imageLocation, url: url)
	}
}

extension ManagedFeedImage {
	static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: feed.map { local in
			let managedFeedImage = ManagedFeedImage(context: context)
			managedFeedImage.id = local.id
			managedFeedImage.imageDescription = local.description
			managedFeedImage.imageLocation = local.location
			managedFeedImage.url = local.url
			return managedFeedImage
		})
	}
}
