//
//  ApplicationContainer.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI

final class ApplicationContainer {
    
  let userRepository: IUserRepository = UserRepository()
  let roleRepository: IRoleRepository = RoleRepository()
  
}
