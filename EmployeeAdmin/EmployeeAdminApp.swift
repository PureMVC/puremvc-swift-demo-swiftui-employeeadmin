//
//  EmployeeAdminApp.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 5/23/25.
//

import SwiftUI
import PureMVC

let facade = ApplicationFacade.getInstance(key: ApplicationFacade.KEY)

@main
struct EmployeeAdminApp: App {
    
     init() {
         facade?.startup()
     }
    
    var body: some Scene {
        return WindowGroup {
            NavigationStack {
                UserList()
            }
        }
    }

}
