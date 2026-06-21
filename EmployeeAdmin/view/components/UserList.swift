//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import Observation

struct UserList: View {
    
  @State private var delegate: UserListMediator
  
  init() {
    guard let delegate = facade.retrieveMediator(UserListMediator.NAME) as? UserListMediator else  {
      fatalError("UserListMediator not found.")
    }
    
    self.delegate = delegate
  }
  
  var body: some View {
    ZStack {
      users
        .disabled(delegate.isLoading)
        .blur(radius: delegate.isLoading ? 2 : 0)
      
      if delegate.isLoading {
        ProgressView()
          .padding()
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
    }
    .navigationTitle("User List")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          UserForm { user in
            withAnimation {
              delegate.users.append(user)
            }
          }
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        }
      }
    }
    .navigationDestination(for: User.self) { user in
      UserForm(id: user.id) { user in
        if let index = delegate.users.firstIndex(where: { $0.id == user.id }) {
          withAnimation {
            delegate.users[index] = user
          }
        }
      }
    }
    .task {
      if delegate.users.isEmpty {
        await delegate.findAll()
      }
    }
    .alert(
        "Error",
        isPresented: Binding(
          get: { delegate.error != nil },
          set: { _ in delegate.error = nil }
        )
    ) {
        Button("OK") {
          delegate.error = nil
        }
    } message: {
        Text(
          (delegate.error as? Exception)?.message ??
          delegate.error?.localizedDescription ??
          "An unknown error occurred."
        )
    }
  }
}

extension UserList {
  
  var users: some View {
      List {
        ForEach(delegate.users) { user in
          NavigationLink(value: user) {
              Text(user.givenName)
          }
        }
        .onDelete { indexes in
          for index in indexes.sorted(by: >) {
            let user = delegate.users[index]
            withAnimation {
              delegate.users.remove(at: index)
              return ()
            }
            
            Task {
              await delegate.deleteById(user.id)
            }
          }
        }
      }
  }
}

#Preview {
  UserList()
}
