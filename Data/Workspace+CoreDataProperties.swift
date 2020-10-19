//
//  Workspace+CoreDataProperties.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//
//

import Foundation
import CoreData


extension Workspace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workspace> {
        return NSFetchRequest<Workspace>(entityName: "Workspace")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var matrix: [[String]]?
    @NSManaged public var result: [String]?
    @NSManaged public var operation: String?
    @NSManaged public var notes: NSSet?
    
    public var notesArray: [Note] {
        let set = notes as? Set<Note> ?? []
        return set.sorted {
            $0.date ?? Date() < $1.date ?? Date()
        }
    }

}

// MARK: Generated accessors for notes
extension Workspace {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension Workspace : Identifiable {

}
