//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI
import Observation

struct UserForm: View {
    
    let id: Int
    let onComplete: ((User?) -> Void)?
    let delegate: EmployeeAdminMediator?

    @Environment(\.dismiss) private var dismiss

    @State private var confirm: String?
    @State private var isSheetPresented: Bool = false
    @State private var error: Error?

    init(id: Int = 0, onComplete: ((User?) -> Void)? = nil) {
        self.id = id
        self.onComplete = onComplete
        self.delegate = facade?.retrieveMediator(EmployeeAdminMediator.NAME) as? EmployeeAdminMediator
     }
    
    var body: some View {
        VStack {
            HStack {
                first()
                last()
            }
            
            HStack {
                email()
                username()
            }
            
            HStack {
                password()
                confirmPassword()
            }
            
            VStack {
                department()
                roles()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .background(Color(UIColor.systemGray6))
        .navigationTitle("User Form")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if delegate?.user?.isValid(confirm: self.confirm) == true {
                        delegate?.saveOrUpdate()
                        dismiss()
                    } else {
                        self.error = Exception(code: 1, message: "Invalid Form Data.")
                    }
                }) {
                    Text(self.id == 0 ? "Save" : "Update")
                }
            }
        }
        .onAppear() { // UI Data
            if (delegate?.departments.count ?? 0) <= 1 {
                delegate?.findAllDepartments()
            }
        }
        .task(id: id) { // User Data
            if id != 0 {
                delegate?.findUserById(id)
            } else {
                delegate?.user = User(id: 0)
            }
        }
        .onChange(of: delegate?.user) { // sync state
            confirm = delegate?.user?.password ?? ""
        }
        .onDisappear { // cleanup
            delegate?.user = nil
            confirm = ""
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                UserRole() { roles in
                    delegate?.user?.roles = roles
                }
            }
        }
        .alert(isPresented: Binding(get:{ error != nil }, set:{ _ in error = nil })) {
            Alert(
                title: Text("Error"),
                message: Text(((error as? Exception)?.message ?? error?.localizedDescription) ?? "An unknown error occurred."),
                primaryButton: .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }
    }
    
}

extension UserForm {
    func first() -> some View {
        TextField("First", text: Binding(
            get: { delegate?.user?.first ?? "" },
            set: { delegate?.user?.first = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
    }
    
    func last() -> some View {
        TextField("Last", text: Binding(
            get: { delegate?.user?.last ?? "" },
            set: { delegate?.user?.last = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
    }
    
    func email() -> some View {
        TextField("Email", text: Binding(
            get: { delegate?.user?.email ?? "" },
            set: { delegate?.user?.email = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
    }
    
    func username() -> some View {
        TextField("Username", text: Binding(
            get: { delegate?.user?.username ?? "" },
            set: { delegate?.user?.username = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
    }
    
    func password() -> some View {
        SecureField("Password", text: Binding(
            get: { delegate?.user?.password ?? "" },
            set: { delegate?.user?.password = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    func confirmPassword() -> some View {
        SecureField("Confirm Password", text: Binding(
            get: { self.confirm ?? "" },
            set: { self.confirm = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(size: 16))
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    func department() -> some View {
        Picker(selection: Binding(
            get: { delegate?.user?.department ?? nil },
            set: { delegate?.user?.department = $0 }
        ), label: Text("")) {
            ForEach(delegate?.departments ?? [], id: \.id) { department in
                Text(department.name ?? "").tag(Optional(department))
            }
        }
        .pickerStyle(.wheel)
    }
    
    func roles() -> some View {
        Button(action: { isSheetPresented.toggle() }) { // User Roles
            HStack {
                Text("User Roles")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
    }
}

#Preview {
    UserForm(id: 0)
}
