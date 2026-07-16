//
//  EmployeeAdminUITests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import XCTest

final class EmployeeAdminUITests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchArguments = ["--ui-testing"]
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testUserList() {
    XCTAssertEqual(app.staticTexts["userList.user.1.name"].label, "Stooge, Larry")
    XCTAssertEqual(app.staticTexts["userList.user.2.name"].label, "Stooge, Curly")
    XCTAssertEqual(app.staticTexts["userList.user.3.name"].label, "Stooge, Moe")
  }
  
  func testLarry() {
    XCTAssertEqual(app.staticTexts["userList.user.1.name"].label, "Stooge, Larry")
    app.buttons["userList.user.1"].tap()
        
    XCTAssertEqual(app.textFields["userForm.first"].value as? String, "Larry")
    XCTAssertEqual(app.textFields["userForm.last"].value as? String, "Stooge")
    XCTAssertEqual(app.textFields["userForm.email"].value as? String, "larry@stooges.com")
    XCTAssertEqual(app.textFields["userForm.username"].value as? String, "lstooge")
    XCTAssertTrue(app.secureTextFields["userForm.password"].exists)
    XCTAssertTrue(app.secureTextFields["userForm.confirm"].exists)
    XCTAssertEqual(app.pickers["userForm.department"].pickerWheels.firstMatch.value as? String, "Accounting")

    app.buttons["userForm.roles"].tap()
    
    XCTAssertEqual(app.staticTexts["userRole.role.5.name"].label, "General Ledger")
    XCTAssertEqual(app.buttons["userRole.role.5"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.5.checkmark"].exists)

    XCTAssertEqual(app.staticTexts["userRole.role.7.name"].label, "Inventory")
    XCTAssertEqual(app.buttons["userRole.role.7"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.7.checkmark"].exists)
    
    XCTAssertFalse(app.images["userRole.role.1.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.2.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.3.checkmark"].exists)
  }
  
  func testCurly() {
    XCTAssertEqual(app.staticTexts["userList.user.2.name"].label, "Stooge, Curly")
    app.buttons["userList.user.2"].tap()
    
    XCTAssertEqual(app.textFields["userForm.first"].value as? String, "Curly")
    XCTAssertEqual(app.textFields["userForm.last"].value as? String, "Stooge")
    XCTAssertEqual(app.textFields["userForm.email"].value as? String, "curly@stooges.com")
    XCTAssertEqual(app.textFields["userForm.username"].value as? String, "cstooge")
    XCTAssertTrue(app.secureTextFields["userForm.password"].exists)
    XCTAssertTrue(app.secureTextFields["userForm.confirm"].exists)
    XCTAssertEqual(app.pickers["userForm.department"].pickerWheels.firstMatch.value as? String, "Sales")
    
    app.buttons["userForm.roles"].tap()
    
    XCTAssertEqual(app.staticTexts["userRole.role.4.name"].label, "Employee Benefits")
    XCTAssertEqual(app.buttons["userRole.role.4"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.4.checkmark"].exists)
    
    XCTAssertEqual(app.staticTexts["userRole.role.6.name"].label, "Payroll")
    XCTAssertEqual(app.buttons["userRole.role.6"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.6.checkmark"].exists)
  }
  
  func testMoe() {
    XCTAssertEqual(app.staticTexts["userList.user.3.name"].label, "Stooge, Moe")
    app.buttons["userList.user.3"].tap()
    
    XCTAssertEqual(app.textFields["userForm.first"].value as? String, "Moe")
    XCTAssertEqual(app.textFields["userForm.last"].value as? String, "Stooge")
    XCTAssertEqual(app.textFields["userForm.email"].value as? String, "moe@stooges.com")
    XCTAssertEqual(app.textFields["userForm.username"].value as? String, "mstooge")
    XCTAssertTrue(app.secureTextFields["userForm.password"].exists)
    XCTAssertTrue(app.secureTextFields["userForm.confirm"].exists)
    XCTAssertEqual(app.pickers["userForm.department"].pickerWheels.firstMatch.value as? String, "Plant")
    
    app.buttons["userForm.roles"].tap()
    XCTAssertEqual(app.staticTexts["userRole.role.9.name"].label, "Quality Control")
    XCTAssertEqual(app.buttons["userRole.role.9"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.9.checkmark"].exists)
    
    XCTAssertEqual(app.staticTexts["userRole.role.11.name"].label, "Orders")
    XCTAssertEqual(app.buttons["userRole.role.11"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.11.checkmark"].exists)
    
    XCTAssertEqual(app.staticTexts["userRole.role.14.name"].label, "Returns")
    XCTAssertEqual(app.buttons["userRole.role.14"].value as? String, "Selected")
    XCTAssertTrue(app.images["userRole.role.14.checkmark"].exists)
  }
  
  func testRoleSelectionPersists() {
    app.buttons["userList.create"].tap()
    app.buttons["userForm.roles"].tap()
    
    app.buttons["userRole.role.1"].tap()
    app.buttons["userRole.role.2"].tap()
    app.buttons["userRole.done"].tap()
    
    app.buttons["userForm.roles"].tap()
    
    XCTAssertTrue(app.images["userRole.role.1.checkmark"].exists)
    XCTAssertTrue(app.images["userRole.role.2.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.3.checkmark"].exists)
  }
  
  func testCreate() {
    app.buttons["userList.create"].tap()
    
    // select roles
    app.buttons["userForm.roles"].tap()
    app.buttons["userRole.role.1"].tap()
    app.buttons["userRole.role.2"].tap()
    app.buttons["userRole.done"].tap()
    
    // fill the form
    XCTAssertEqual(app.buttons["userForm.save"].label, "Save")
    app.textFields["userForm.first"].tap()
    app.textFields["userForm.first"].typeText("Joe")
    app.textFields["userForm.last"].tap()
    app.textFields["userForm.last"].typeText("Stooge")
    app.textFields["userForm.email"].tap()
    app.textFields["userForm.email"].typeText("joe@stooges.com")
    XCTAssertTrue(app.textFields["userForm.username"].isEnabled)
    app.textFields["userForm.username"].tap()
    app.textFields["userForm.username"].typeText("jstooge")
    app.secureTextFields["userForm.password"].tap()
    app.secureTextFields["userForm.password"].typeText("abc123")
    app.secureTextFields["userForm.confirm"].tap()
    app.secureTextFields["userForm.confirm"].typeText("abc123")
    app.pickers["userForm.department"].pickerWheels.firstMatch.adjust(toPickerWheelValue: "Shipping")
    app.buttons["userForm.save"].tap()
    
    // verify new record
    XCTAssertEqual(app.staticTexts["userList.user.1.name"].label, "Stooge, Larry")
    XCTAssertEqual(app.staticTexts["userList.user.2.name"].label, "Stooge, Curly")
    XCTAssertEqual(app.staticTexts["userList.user.3.name"].label, "Stooge, Moe")
    XCTAssertEqual(app.staticTexts["userList.user.4.name"].label, "Stooge, Joe")
    
    // verify form data
    app.buttons["userList.user.4"].tap()
    XCTAssertEqual(app.buttons["userForm.save"].label, "Update")
    XCTAssertTrue(app.textFields["userForm.first"].value as? String == "Joe")
    XCTAssertTrue(app.textFields["userForm.last"].value as? String == "Stooge")
    XCTAssertTrue(app.textFields["userForm.email"].value as? String == "joe@stooges.com")
    XCTAssertTrue(app.textFields["userForm.username"].value as? String == "jstooge")
    XCTAssertTrue(app.pickers["userForm.department"].pickerWheels.firstMatch.value as? String == "Shipping")
    
    // verify roles
    app.buttons["userForm.roles"].tap()
    XCTAssertTrue(app.images["userRole.role.1.checkmark"].exists)
    XCTAssertTrue(app.images["userRole.role.2.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.3.checkmark"].exists)
    app.buttons["userRole.cancel"].tap()
    
    app.buttons["userForm.back"].tap()
    
    // delete user
    XCTAssertTrue(app.buttons["userList.user.4"].waitForExistence(timeout: 5))
    app.buttons["userList.user.4"].swipeLeft()
    app.buttons["Delete"].tap()
    XCTAssertFalse(app.buttons["userList.user.4"].exists)
  }
  
  func testCreateWithoutRoles() {
    app.buttons["userList.create"].tap()
    
    // fill the form
    XCTAssertEqual(app.buttons["userForm.save"].label, "Save")
    app.textFields["userForm.first"].tap()
    app.textFields["userForm.first"].typeText("Shemp")
    app.textFields["userForm.last"].tap()
    app.textFields["userForm.last"].typeText("Stooge")
    app.textFields["userForm.email"].tap()
    app.textFields["userForm.email"].typeText("shemp@stooges.com")
    XCTAssertTrue(app.textFields["userForm.username"].isEnabled)
    app.textFields["userForm.username"].tap()
    app.textFields["userForm.username"].typeText("sstooge")
    app.secureTextFields["userForm.password"].tap()
    app.secureTextFields["userForm.password"].typeText("xyz987")
    app.secureTextFields["userForm.confirm"].tap()
    app.secureTextFields["userForm.confirm"].typeText("xyz987")
    app.pickers["userForm.department"].pickerWheels.firstMatch.adjust(toPickerWheelValue: "Shipping")
    XCTAssertTrue(app.buttons["userForm.save"].isEnabled)
    app.buttons["userForm.save"].tap()
    
    // verify new record
    XCTAssertEqual(app.staticTexts["userList.user.1.name"].label, "Stooge, Larry")
    XCTAssertEqual(app.staticTexts["userList.user.2.name"].label, "Stooge, Curly")
    XCTAssertEqual(app.staticTexts["userList.user.3.name"].label, "Stooge, Moe")
    XCTAssertEqual(app.staticTexts["userList.user.4.name"].label, "Stooge, Shemp")
    
    app.buttons["userList.user.4"].tap()
    XCTAssertEqual(app.buttons["userForm.save"].label, "Update")
    
    // verify roles
    app.buttons["userForm.roles"].tap()
    XCTAssertFalse(app.images["userRole.role.1.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.2.checkmark"].exists)
    XCTAssertFalse(app.images["userRole.role.3.checkmark"].exists)
    app.buttons["userRole.cancel"].tap()
    
    app.buttons["userForm.back"].tap()
    
    // delete user
    XCTAssertTrue(app.buttons["userList.user.4"].waitForExistence(timeout: 5))
    app.buttons["userList.user.4"].swipeLeft()
    app.buttons["Delete"].tap()
    XCTAssertFalse(app.buttons["userList.user.4"].exists)
  }
  
  func testSaveInvalidForm() {
    app.buttons["userList.create"].tap()
    
    // fill the form
    XCTAssertFalse(app.buttons["userForm.save"].isEnabled)
    XCTAssertEqual(app.buttons["userForm.save"].label, "Save")
    
    app.textFields["userForm.first"].tap()
    app.textFields["userForm.first"].typeText("Shemp")
    app.textFields["userForm.last"].tap()
    app.textFields["userForm.last"].typeText("Stooge")
    app.textFields["userForm.email"].tap()
    app.textFields["userForm.email"].typeText("shemp@stooges.com")
    XCTAssertTrue(app.textFields["userForm.username"].isEnabled)
    app.textFields["userForm.username"].tap()
    app.textFields["userForm.username"].typeText("sstooge")
    app.secureTextFields["userForm.password"].tap()
    app.secureTextFields["userForm.password"].typeText("xyz987")
    app.secureTextFields["userForm.confirm"].tap()
    app.secureTextFields["userForm.confirm"].typeText("xyz98")
    app.pickers["userForm.department"].pickerWheels.firstMatch.adjust(toPickerWheelValue: "Shipping")
    
    XCTAssertFalse(app.buttons["userForm.save"].isEnabled)
  }
  
  
//  @MainActor
//  func testLaunchPerformance() throws {
//    // This measures how long it takes to launch your application.
//    measure(metrics: [XCTApplicationLaunchMetric()]) {
//      XCUIApplication().launch()
//    }
//  }
  
}
