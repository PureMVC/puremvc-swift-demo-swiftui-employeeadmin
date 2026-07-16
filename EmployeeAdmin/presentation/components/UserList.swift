//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI

struct UserList: View {
  
  @Environment(\.container) private var container
  @State private var viewModel: UserListViewModel
  
  init(viewModel: UserListViewModel) {
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      content
      
      if viewModel.loading && viewModel.users.isEmpty {
        ProgressView("Loading...")
      }
    }
    .navigationTitle("User List")
    .accessibilityIdentifier("userList.screen")
    .glassEffect(.regular, in: .rect(cornerRadius: 24))
    .toolbar {
      NavigationLink(value: Int64(0)) {
        Label("Create", systemImage: "plus")
      }
      .accessibilityIdentifier("userList.create")
      .buttonStyle(.glass)
    }
    .overlay {
      if viewModel.loading && !viewModel.users.isEmpty {
        ProgressView()
          .accessibilityIdentifier("userList.loading")
      }
    }
    .onAppear {
      Task {
        await viewModel.findAll()
      }
    }
    .alert("Error", isPresented: Binding(
      get: { viewModel.error != nil },
      set: { if !$0 { viewModel.error = nil } }
    )) {
      Button("OK", role: .cancel) {
        viewModel.error = nil
      }
    } message: {
      Text(viewModel.error?.localizedDescription ?? "Unknown error")
    }
  }
}

private extension UserList {
  
  var content: some View {
    List {
      ForEach(viewModel.users) { user in
        NavigationLink(value: user.id) {
          Text(user.givenName)
            .accessibilityIdentifier("userList.user.\(user.id).name")
        }
        .accessibilityIdentifier("userList.user.\(user.id)")
      }
      .onDelete { indexSet in
        Task {
          for index in indexSet {
            let user = viewModel.users[index]
            await viewModel.delete(byID: user.id)
            
            _ = withAnimation {
              viewModel.users.remove(at: index)
            }
          }
        }
      }
    }
    .accessibilityIdentifier("userList.list")
    .navigationDestination(for: Int64.self) { id in
      if let container {
        UserForm(id: id, viewModel: container.userFormViewModel())
      }
    }
  }
  
}

#Preview {
  let container = ApplicationContainer.preview
  
  NavigationStack {
    UserList(viewModel: container.userListViewModel())
  }
  .environment(\.container, container)
}
