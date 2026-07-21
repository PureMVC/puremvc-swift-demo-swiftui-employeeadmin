//
//  RoleManagedObject+CoreDataProperties.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

public import Foundation
public import CoreData


public typealias RoleManagedObjectCoreDataPropertiesSet = NSSet

extension RoleManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoleManagedObject> {
        return NSFetchRequest<RoleManagedObject>(entityName: "RoleManagedObject")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var users: UserManagedObject?

}

extension RoleManagedObject : Identifiable {

}
