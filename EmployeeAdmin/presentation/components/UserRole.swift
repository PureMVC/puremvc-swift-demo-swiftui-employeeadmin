//
//  UserRole.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import ComposableArchitecture

struct UserRole: View {
    
  private let id: Int
  private let selection: [Role]
  private let onComplete: ([Role]) -> Void
  
  @Bindable var store: StoreOf<UserRoleStore>
  
  @Environment(\.dismiss) private var dismiss

  init(id: Int, selection: [Role], onComplete: @escaping ([Role]) -> Void) {
    self.id = id
    self.selection = selection
    self.onComplete = onComplete
    self.store = Store(initialState: UserRoleStore.State()) {
      UserRoleStore()
    }
  }
    
  var body: some View {
    ZStack {
      VStack {
        roles
      }
      .disabled(store.isLoading)
      .blur(radius: store.isLoading ? 2 : 0)
      
      if store.isLoading {
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
          onComplete(store.selection)
          dismiss()
        }
      }
    }
    .task { // User Data
      store.send(.findAll)
      
      if selection.isEmpty { // iterate and append
        store.send(.findByUserId(id: id))
      } else {
        selection.forEach {
          store.send(.append($0))
        }
      }
    }
  }
}

extension UserRole {
    
  var roles: some View {
    List(store.roles) { role in
      HStack {
        Text(role.name).foregroundColor(.primary)
        Spacer()
        if store.selection.contains(where: { $0.id == role.id }) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        if let index = store.selection.firstIndex(where: { $0.id == role.id }) {
          store.send(.remove(index))
        } else {
          store.send(.append(role))
        }
      }
    }
  }
  
}

#Preview {
  UserRole(id: 0, selection: []) {_ in }
}
