//
//  Favorites+CoreDataProperties.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/5/16.
//  Copyright © 2016 kencooke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorites {

    @NSManaged var name: String?
    @NSManaged var favorites: User?

}
