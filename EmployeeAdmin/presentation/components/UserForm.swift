//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI

struct UserForm: View {
  
  @Environment(\.container) private var container
  @Environment(\.dismiss) private var dismiss
  
  @State private var viewModel: UserFormViewModel
  @State private var selection: Set<Role>?
  @State private var confirm: String = ""
  @State private var isSheetPresented = false
  
  private let id: Int64
  
  init(id: Int64, viewModel: UserFormViewModel) {
    self.id = id
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      content
      
      if viewModel.loading {
        ProgressView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding()
    .navigationTitle("User Form")
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        save
      }
    }
    .task {
      await viewModel.findAllDepartments()
      
      if id != 0 {
        await viewModel.find(byId: id)
        confirm = viewModel.user.password
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

private extension UserForm {
    
  var content: some View {
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
  }

}

private extension UserForm {
  var first: some View {
    TextField("First", text: $viewModel.user.first)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.words)
  }
  
  var last: some View {
    TextField("Last", text: $viewModel.user.last)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.words)
  }
  
  var email: some View {
    TextField("Email", text: $viewModel.user.email)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
      .keyboardType(.emailAddress)
  }
  
  var username: some View {
    TextField("Username", text: $viewModel.user.username)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
  }
  
  var password: some View {
    SecureField("Password", text: $viewModel.user.password)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
      .textContentType(.oneTimeCode)
  }
  
  var confirmPassword: some View {
    SecureField("Confirm Password", text: $confirm)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
      .textContentType(.oneTimeCode)
  }
  
  var department: some View {
    Picker("Department", selection: $viewModel.user.department) {
      ForEach(Array(viewModel.departments).sorted { $0.id < $1.id }) { department in
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
      Text("Roles")
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.glassProminent)
    .sheet(isPresented: $isSheetPresented) {
      if let container {
        NavigationStack {
          UserRole(id: id, selection, viewModel: container.userRoleViewModel()) { roles in
            selection = roles
          }
        }
      }
    }
  }
  
  var save: some View {
    Button(id == 0 ? "Save" : "Update") {
      Task {
        await viewModel.save(selection: selection)
        guard viewModel.error == nil else { return }
        dismiss()
      }
    }
    .buttonStyle(.glassProminent)
  }
  
}

#Preview {
  let container = ApplicationContainer.preview

  NavigationStack {
    UserForm(id: 1, viewModel: container.userFormViewModel())
  }
  .environment(\.container, container)
}
