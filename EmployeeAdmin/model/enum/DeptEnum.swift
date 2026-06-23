//
//  DeptEnum.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

enum DeptEnum: Int, CaseIterable {

  case noneSelected = -1
  case accounting = 0
  case sales = 1
  case plant = 2
  case shipping = 3
  case qualityControl = 4
  
  var id: Int { rawValue }
  
  var name: String {
    switch self {
    case .noneSelected: return "--None Selected--"
    case .accounting: return "Accounting"
    case .sales: return "Sales"
    case .plant: return "Plant"
    case .shipping: return "Shipping"
    case .qualityControl: return "Quality Control"
    }
  }
}
