//
//  DepartmentManagedObject+CoreDataProperties.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

public typealias DepartmentManagedObjectCoreDataPropertiesSet = NSSet

extension DepartmentManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartmentManagedObject> {
        return NSFetchRequest<DepartmentManagedObject>(entityName: "DepartmentManagedObject")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var users: UserManagedObject?

}

extension DepartmentManagedObject : Identifiable {

}
