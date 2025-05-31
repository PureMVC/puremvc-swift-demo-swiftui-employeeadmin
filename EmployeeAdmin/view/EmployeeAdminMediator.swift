//
//  EmployeeAdminMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import Observation
import PureMVC

import Foundation
import Combine

@Observable
class EmployeeAdminMediator: Mediator {
    
    override class var NAME: String { "EmployeeAdminMediator" }
    
    var users: [User] = []
    
    var user: User?
        
    var departments: [Department] = [Department(id: 0, name: "--None Selected--")]
    
    var roles: [Role] = []
    
    var error: String?
    
    private var cancellables = Set<AnyCancellable>()
        
    private var userProxy: IUserProxy?
    
    private var roleProxy: IRoleProxy?
    
    init() {
        super.init(name: EmployeeAdminMediator.NAME, viewComponent: nil)
    }
    
    public override func onRegister() {
        userProxy = facade?.retrieveProxy(UserProxy.NAME) as? IUserProxy
        roleProxy = facade?.retrieveProxy(RoleProxy.NAME) as? IRoleProxy
    }
    
    func findAllUsers() {
        userProxy?.findAll()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellables)
    }
    
    func findUserById(_ id: Int) {
        userProxy?.findById(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] user in
                self?.user = user
                self?.user?.roles = []
            })
            .store(in: &cancellables)
    }
    
    func findAllDepartments() {
        userProxy?.findAllDepartments()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] departments in
                self?.departments.append(contentsOf: departments)
            })
            .store(in: &cancellables)
    }

    func saveOrUpdate() {
        guard let user else { return }
        
        let operation = (user.id == 0) ? userProxy?.save(user) : userProxy?.update(user)
        operation?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }
    
    func deleteById(_ id: Int) {
        userProxy?.deleteById(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func findAllRoles() {
        roleProxy?.findAll()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] roles in
                self?.roles = roles
            })
            .store(in: &cancellables)
    }
    
    func findAllUserRoles(_ id: Int) {
        roleProxy?.findRolesById(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] roles in
                self?.user?.roles = roles
            })
            .store(in: &cancellables)
    }
    
    func fault(_ error: Error) {
        self.error = (error as? Exception).map { "Code: \($0.code) Message: \($0.message)" } ?? "Error: \(error.localizedDescription)"
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
}
