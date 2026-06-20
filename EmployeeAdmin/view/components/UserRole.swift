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
    
  private let id: Int
  private let selection: [Role]
  private let onComplete: ([Role]) -> Void
  
  @State private var delegate: UserRoleMediator
    
  @Environment(\.dismiss) private var dismiss

  init(id: Int, selection: [Role], onComplete: @escaping ([Role]) -> Void) {
    self.id = id
    self.selection = selection
    self.onComplete = onComplete
    
    guard let delegate = facade.retrieveMediator(UserRoleMediator.NAME) as? UserRoleMediator else {
      fatalError("UserRoleMediator not found.")
    }
    
    self.delegate = delegate
  }
    
  var body: some View {
    ZStack {
      VStack {
        roles
      }
      .disabled(delegate.isLoading)
      .blur(radius: delegate.isLoading ? 2 : 0)
      
      if delegate.isLoading {
        ProgressView()
          .padding()
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
    }
    .navigationTitle("User Roles")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Done") {
          onComplete(delegate.selection)
          dismiss()
        }
      }
    }
    .task { // User Data
      await delegate.findAll()
      
      if delegate.selection.isEmpty {
        delegate.selection = selection
      } else {
        await delegate.findByUserId(id)
      }
    }
  }
}

extension UserRole {
    
  var roles: some View {
    List(delegate.roles) { role in
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
  UserRole(id: 0, selection: []) {_ in }
}
