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
  private let id: Int
  private let onComplete: (User) -> Void
  
  @Environment(\.dismiss) private var dismiss

  @State private var delegate: UserFormMediator
  @State private var confirm: String = ""
  @State private var isSheetPresented: Bool = false

  init(id: Int = 0, onComplete: @escaping (User) -> Void) {
    self.id = id
    self.onComplete = onComplete
    
    guard let delegate = facade.retrieveMediator(UserFormMediator.NAME) as? UserFormMediator else {
      fatalError("UserFormMediator not found.")
    }

    self.delegate = delegate
  }
  
  var body: some View {
    ZStack {
      VStack {
        HStack {
          first
          last
        }
        
        HStack {
          email
          username
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
      .disabled(delegate.isLoading)
      .blur(radius: delegate.isLoading ? 2 : 0)
      
      if delegate.isLoading {
        ProgressView()
          .padding()
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 12))
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
      if delegate.departments.isEmpty {
        await delegate.findAllDepartments()
      }
      
      if id != 0 {
        await delegate.findById(id)
        confirm = delegate.user.password
      } else {
        delegate.user = .empty
        confirm = ""
      }
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
  
  var username: some View {
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
      ForEach([.empty] + delegate.departments, id: \.id) { department in
        Text(department.name).tag(department)
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
        UserRole(id: delegate.user.id, selection: delegate.user.roles) { roles in
          delegate.user.roles = roles
        }
      }
    }
  }
    
  var saveOrUpdate: some View {
    Button {
      guard delegate.user.isValid(confirm: confirm) else {
        delegate.error = Exception(code: 1, message: "Invalid Form Data.")
        return
      }
      
      Task {
        await delegate.saveOrUpdate(delegate.user)
        
        guard delegate.error == nil else { return }
              
        dismiss()
        
        try? await Task.sleep(for: .milliseconds(500))
        onComplete(delegate.user)
      }
      
    } label: {
      Text(id == 0 ? "Save" : "Update")
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
      Text((delegate.error as? Exception)?.message ?? delegate.error?.localizedDescription ?? "An unknown error occurred.")
    }
  }
}

#Preview {
  UserForm(id: 0) { _ in }
}
