//
//  UserRole.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI

struct UserRole: View {
  
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: UserRoleViewModel
  
  private let id: Int64
  private let selection: Set<Role>?
  private let onComplete: (Set<Role>) -> Void
  
  init(id: Int64, _ selection: Set<Role>?, viewModel: UserRoleViewModel, onComplete: @escaping (Set<Role>) -> Void) {
    self.id = id
    self.selection = selection
    self.onComplete = onComplete
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      content
      
      if (viewModel.loading) {
        ProgressView()
      }
    }
    .navigationTitle("User Role")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel", systemImage: "xmark") {
          dismiss()
        }
      }

      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Done") {
          onComplete(viewModel.selection)
          dismiss()
        }
        .buttonStyle(.glassProminent)
      }
    }
    .task {
      await viewModel.findAll()
      
      if let selection {
        viewModel.selection = selection
      } else {
        await viewModel.find(byUserID: id)
      }
    }
  }
  
}

extension UserRole {
  
  var content: some View {
    List(viewModel.roles.sorted { $0.id < $1.id }) { role in
      Button {
        if viewModel.selection.contains(role) {
          viewModel.selection.remove(role)
        } else {
          viewModel.selection.insert(role)
        }
      } label: {
        HStack {
          Text(role.name)
            .foregroundColor(.black)
          Spacer()
          if viewModel.selection.contains(role) {
            Image(systemName: "checkmark")
          }
        }
      }
    }
  }
  
}

#Preview {
  let container = ApplicationContainer.preview

  NavigationStack {
    UserRole(id: 1, [], viewModel: container.userRoleViewModel()) { _ in }
  }
  .environment(\.container, container)
}
