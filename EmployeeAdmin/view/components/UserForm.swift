//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import Observation

struct UserForm: View {
  private let username: String
  private let onComplete: (UserVO) -> Void
  
  @Environment(\.dismiss) private var dismiss

  @State private var delegate: UserFormMediator
  @State private var selection: [RoleEnum] = []
  @State private var confirm: String = ""
  @State private var isSheetPresented: Bool = false

  init(username: String = "", onComplete: @escaping (UserVO) -> Void) {
    self.username = username
    self.onComplete = onComplete
    
    guard let delegate = facade.retrieveMediator(UserFormMediator.NAME) as? UserFormMediator else {
      fatalError("UserFormMediator not found.")
    }

    self.delegate = delegate
  }
  
  var body: some View {
    VStack {
      HStack {
        first
        last
      }
      
      HStack {
        email
        usernameField
      }
      
      HStack {
        password
        confirmPassword
      }
      
      VStack {
        department
        roles
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding()
    .background(Color(UIColor.systemGray6))
    .navigationTitle("User Form")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        saveOrUpdate
      }
    }
    .task {
      if username != "" {
        delegate.findByUsername(username)
        confirm = delegate.user.password
      } else {
        delegate.user = .empty
        confirm = ""
      }
    }
    .alert(
      "Error",
      isPresented: Binding(
        get: { delegate.error != nil },
        set: { _ in delegate.error = nil }
      )
    ) {
        Button("OK", role: .cancel) {
          delegate.error = nil
        }
    } message: {
      Text(delegate.error ?? "An unknown error occurred.")
    }
  }
}

extension UserForm {
  var first: some View {
    TextField("First", text: $delegate.user.first)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var last: some View {
    TextField("Last", text: $delegate.user.last)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var email: some View {
    TextField("Email", text: $delegate.user.email)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .keyboardType(.emailAddress)
  }
  
  var usernameField: some View {
    TextField("Username", text: $delegate.user.username)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var password: some View {
    SecureField("Password", text: $delegate.user.password)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
  }
  
  var confirmPassword: some View {
    SecureField("Confirm Password", text: $confirm)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
  }
  
  var department: some View {
    Picker("Department", selection: $delegate.user.department) {
      ForEach(DeptEnum.allCases, id: \.self) { department in
        Text(department.name)
          .tag(department)
      }
    }
    .pickerStyle(.wheel)
  }
    
  var roles: some View {
    Button {
      isSheetPresented.toggle()
    } label: {
      HStack {
        Text("User Roles")
          .fontWeight(.bold)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
      }
    }
    .sheet(isPresented: $isSheetPresented) {
      NavigationStack {
        UserRole(username: delegate.user.username, selection: self.selection) { roles in
          self.selection = roles
        }
      }
    }
  }
    
  var saveOrUpdate: some View {
    Button {
      guard delegate.user.isValid(confirm: confirm) else {
        delegate.error = "Invalid Form Data."
        return
      }
      
      Task {
        if self.username.isEmpty {
          delegate.save(delegate.user, roles: selection)
        } else {
          delegate.update(delegate.user, roles: selection)
        }
        
        guard delegate.error == nil else { return }
              
        dismiss()
        
        try? await Task.sleep(for: .milliseconds(500))
        onComplete(delegate.user)
      }
      
    } label: {
      Text(username.isEmpty ? "Save" : "Update")
    }
  }
}

#Preview {
  UserForm(username: "") { _ in }
}
