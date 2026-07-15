//
//  UserRole.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import Observation

struct UserRole: View {
  
  @Environment(\.dismiss) private var dismiss
  @State private var delegate: UserRoleMediator
    
  private let username: String
  private let onComplete: ([RoleEnum]) -> Void
  
  init(username: String, selection: [RoleEnum], onComplete: @escaping ([RoleEnum]) -> Void) {
    self.username = username
    self.onComplete = onComplete
    
    _delegate = State(initialValue: UserRoleMediator())
    
    if !selection.isEmpty {
      delegate.selection = selection
    }
  }
    
  var body: some View {
    roles
    .navigationTitle("User Roles")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Done") {
          onComplete(delegate.selection)
          dismiss()
          delegate.selection = []
        }
      }
    }
    .task { // User Data
      if delegate.selection.isEmpty {
        delegate.findByUsername(username)
      }
    }
  }
}

extension UserRole {
    
  var roles: some View {
    List(RoleEnum.allCases, id: \.self) { role in
      HStack {
        Text(role.name).foregroundColor(.primary)
        Spacer()
        if delegate.selection.contains(where: { $0.id == role.id }) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        if let index = delegate.selection.firstIndex(where: { $0.id == role.id }) {
          delegate.selection.remove(at: index)
        } else {
          delegate.selection.append(role)
        }
      }
    }
  }
  
}

#Preview {
  UserRole(username: "", selection: []) {_ in }
}
