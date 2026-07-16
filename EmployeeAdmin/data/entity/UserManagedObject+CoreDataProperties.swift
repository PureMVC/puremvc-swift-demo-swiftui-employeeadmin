//
//  UserManagedObject+CoreDataProperties.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

public typealias UserManagedObjectCoreDataPropertiesSet = NSSet

extension UserManagedObject {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserManagedObject> {
    return NSFetchRequest<UserManagedObject>(entityName: "UserManagedObject")
  }
  
  @NSManaged public var id: Int64
  @NSManaged public var first: String
  @NSManaged public var last: String
  @NSManaged public var email: String
  @NSManaged public var username: String
  @NSManaged public var password: String
  @NSManaged public var department: DepartmentManagedObject?
  @NSManaged public var roles: NSSet
  
}

// MARK: Generated accessors for roles
extension UserManagedObject {
  
  @objc(addRolesObject:)
  @NSManaged public func addToRoles(_ value: RoleManagedObject)
  
  @objc(removeRolesObject:)
  @NSManaged public func removeFromRoles(_ value: RoleManagedObject)
  
  @objc(addRoles:)
  @NSManaged public func addToRoles(_ values: NSSet)
  
  @objc(removeRoles:)
  @NSManaged public func removeFromRoles(_ values: NSSet)
  
}

extension UserManagedObject : Identifiable {
  
}
