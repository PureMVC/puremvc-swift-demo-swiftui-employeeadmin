//
//  RoleEnum.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

enum RoleEnum: Int, CaseIterable {
  case administrator      = 0
  case accountsPayable    = 1
  case accountsReceivable = 2
  case employeeBenefits   = 3
  case generalLedger      = 4
  case payroll            = 5
  case inventory          = 6
  case production         = 7
  case qualityControl     = 8
  case sales              = 9
  case orders             = 10
  case customers          = 11
  case shipping           = 12
  case returns            = 13
  
  var id: Int { rawValue }
  
  var name: String {
    switch self {
    case .administrator:      return "Administrator"
    case .accountsPayable:    return "Accounts Payable"
    case .accountsReceivable: return "Accounts Receivable"
    case .employeeBenefits:   return "Employee Benefits"
    case .generalLedger:      return "General Ledger"
    case .payroll:            return "Payroll"
    case .inventory:          return "Inventory"
    case .production:         return "Production"
    case .qualityControl:     return "Quality Control"
    case .sales:              return "Sales"
    case .orders:             return "Orders"
    case .customers:          return "Customers"
    case .shipping:           return "Shipping"
    case .returns:            return "Returns"
    }
  }
}
