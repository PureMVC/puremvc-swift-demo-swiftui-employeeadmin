//
//  EmployeeAdminApp.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 5/23/25.
//

import SwiftUI
import PureMVC

@main
struct EmployeeAdminApp: App {
    
    var body: some Scene {
        
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY)?.startup();
        
        return WindowGroup {
            NavigationStack {
                UserList()
            }
        }
    }

}
