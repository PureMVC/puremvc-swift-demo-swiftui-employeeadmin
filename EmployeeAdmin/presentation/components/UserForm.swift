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

  @State private var viewModel: UserFormViewModel
  @State private var confirm: String = ""
  @State private var isSheetPresented: Bool = false

  init(id: Int = 0, onComplete: @escaping (User) -> Void) {
    self.id = id
    self.onComplete = onComplete
    _viewModel = State(initialValue: UserFormViewModel(service: container.userService))
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
      .disabled(viewModel.isLoading)
      .blur(radius: viewModel.isLoading ? 2 : 0)
      
      if viewModel.isLoading {
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
      if viewModel.departments.isEmpty {
        await viewModel.findAllDepartments()
      }
      
      if id != 0 {
        await viewModel.findById(id)
        confirm = viewModel.user.password
      } else {
        viewModel.user = .empty
        confirm = ""
      }
    }
  }
}

extension UserForm {
  var first: some View {
    TextField("First", text: $viewModel.user.first)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var last: some View {
    TextField("Last", text: $viewModel.user.last)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var email: some View {
    TextField("Email", text: $viewModel.user.email)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .keyboardType(.emailAddress)
  }
  
  var username: some View {
    TextField("Username", text: $viewModel.user.username)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var password: some View {
    SecureField("Password", text: $viewModel.user.password)
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
    Picker("Department", selection: $viewModel.user.department) {
      ForEach([.empty] + viewModel.departments, id: \.id) { department in
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
        UserRole(id: viewModel.user.id, selection: viewModel.user.roles) { roles in
          viewModel.user.roles = roles
        }
      }
    }
  }
    
  var saveOrUpdate: some View {
    Button {
      guard viewModel.user.isValid(confirm: confirm) else {
        viewModel.error = Exception(code: 1, message: "Invalid Form Data.")
        return
      }
      
      Task {
        await viewModel.saveOrUpdate(viewModel.user)
        
        guard viewModel.error == nil else { return }
              
        dismiss()
        
        try? await Task.sleep(for: .milliseconds(500))
        onComplete(viewModel.user)
      }
      
    } label: {
      Text(id == 0 ? "Save" : "Update")
    }
    .alert(
      "Error",
      isPresented: Binding(
        get: { viewModel.error != nil },
        set: { _ in viewModel.error = nil }
      )
    ) {
        Button("OK", role: .cancel) {
          viewModel.error = nil
        }
    } message: {
      Text((viewModel.error as? Exception)?.message ?? viewModel.error?.localizedDescription ?? "An unknown error occurred.")
    }
  }
}

#Preview {
  UserForm(id: 0) { _ in }
}
