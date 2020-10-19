//
//  Note+CoreDataProperties.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var ofWorkspace: Workspace?

}

extension Note : Identifiable {

}
