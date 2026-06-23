//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import ComposableArchitecture

struct UserForm: View {
  private let id: Int
  private let onComplete: (User) -> Void
  
  @Bindable var store: StoreOf<UserFormStore>
    
  @State private var confirm: String = ""
  @State private var selection: [Role] = []
  @State private var isSheetPresented: Bool = false
  
  @Environment(\.dismiss) private var dismiss
  
  init(id: Int = 0, onComplete: @escaping (User) -> Void) {
    self.id = id
    self.onComplete = onComplete
    self.store = Store(initialState: UserFormStore.State()) {
      UserFormStore()
    }
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
      .disabled(store.isLoading)
      .blur(radius: store.isLoading ? 2 : 0)
      
      if store.isLoading {
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
      store.send(.departments)
      if (id != 0) {
        store.send(.findById(id))
      }
    }
    .onChange(of: store.user.password) { _, password in
      confirm = password
    }
    .alert(
        "Error",
        isPresented: .constant(store.error != nil)
    ) {
      Button("OK") {}
    } message: {
      Text(store.error ?? "An unknown error occurred.")
    }
  }
}

extension UserForm {
  var first: some View {
    TextField("First", text: $store.user.first)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var last: some View {
    TextField("Last", text: $store.user.last)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var email: some View {
    TextField("Email", text: $store.user.email)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
      .keyboardType(.emailAddress)
  }
  
  var username: some View {
    TextField("Username", text: $store.user.username)
      .textFieldStyle(.roundedBorder)
      .font(.system(size: 16))
      .textInputAutocapitalization(.never)
  }
  
  var password: some View {
    SecureField("Password", text: $store.user.password)
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
    Picker("Department", selection: $store.user.department) {
      ForEach([.empty] + store.departments, id: \.id) { department in
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
        UserRole(id: store.user.id, selection: selection) { roles in
          selection = roles
          print(selection)
        }
      }
    }
  }
    
  var saveOrUpdate: some View {
    Button {
      guard store.user.isValid(confirm: confirm) else {
        store.error = "Invalid Form Data."
        return
      }
      
      Task {
        store.send(.saveOrUpdate)
        
        guard store.error == nil else { return }
              
        dismiss()
        
        try? await Task.sleep(for: .milliseconds(500))
        onComplete(store.user)
      }
      
    } label: {
      Text(id == 0 ? "Save" : "Update")
    }
  }
}

#Preview {
  UserForm(id: 0) { _ in }
}
