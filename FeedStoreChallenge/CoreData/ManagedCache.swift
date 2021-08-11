//
//  ManagedCache+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by Stas Lee on 11/8/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: ManagedFeedImage?
}
