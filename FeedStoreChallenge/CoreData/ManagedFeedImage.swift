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
	@NSManaged var id: UUID?
	@NSManaged var imageDescription: String?
	@NSManaged var imageLocation: String?
	@NSManaged var url: URL?
	@NSManaged var cache: ManagedCache?
}
