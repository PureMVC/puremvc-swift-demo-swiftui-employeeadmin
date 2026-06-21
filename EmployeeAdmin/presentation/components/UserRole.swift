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
  
  @State private var viewModel: UserRoleViewModel
    
  @Environment(\.dismiss) private var dismiss

  init(id: Int, selection: [Role], onComplete: @escaping ([Role]) -> Void) {
    self.id = id
    self.selection = selection
    self.onComplete = onComplete
  
    _viewModel = State(initialValue: UserRoleViewModel(repository: container.roleRepository))
  }
    
  var body: some View {
    ZStack {
      VStack {
        roles
      }
      .disabled(viewModel.isLoading)
      .blur(radius: viewModel.isLoading ? 2 : 0)
      
      if viewModel.isLoading {
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
          onComplete(viewModel.selection)
          dismiss()
        }
      }
    }
    .task { // User Data
      await viewModel.findAll()
      
      if viewModel.selection.isEmpty {
        viewModel.selection = selection
      } else {
        await viewModel.findByUserId(id)
      }
    }
  }
}

extension UserRole {
    
  var roles: some View {
    List(viewModel.roles) { role in
      HStack {
        Text(role.name).foregroundColor(.primary)
        Spacer()
        if viewModel.selection.contains(where: { $0.id == role.id }) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        if let index = viewModel.selection.firstIndex(where: { $0.id == role.id }) {
          viewModel.selection.remove(at: index)
        } else {
          viewModel.selection.append(role)
        }
      }
    }
  }
  
}

#Preview {
  UserRole(id: 0, selection: []) {_ in }
}
