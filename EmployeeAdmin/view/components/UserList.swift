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
    users
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
    .task {
      if delegate.users.isEmpty {
        await delegate.findAll()
      }
    }
  }
}

extension UserList {
  
  var users: some View {
    List {
      ForEach(delegate.users, id: \.self) { user in
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
            delegate.delete(user)
          }
        }
      }
    }
    .navigationDestination(for: UserVO.self) { user in
      UserForm(username: user.username) { user in
        if let index = delegate.users.firstIndex(where: { $0.username == user.username }) {
          withAnimation {
            delegate.users[index] = user
          }
        }
      }
    }
  }
}

#Preview {
  UserList()
}
