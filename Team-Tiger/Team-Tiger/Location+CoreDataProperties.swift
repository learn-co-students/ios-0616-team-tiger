//
//  Location+CoreDataProperties.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/17/16.
//  Copyright © 2016 kencooke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var address: String?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var type: String?
    @NSManaged var zip: String?
    @NSManaged var waterfront: String?
    @NSManaged var hours: String?
    @NSManaged var user: User?

}
