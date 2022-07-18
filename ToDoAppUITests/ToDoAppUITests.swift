//
//  ToDoAppUITests.swift
//  ToDoAppUITests
//
//  Created by Andriy on 30.06.2022.
//

import XCTest

class ToDoAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func addTask() {
        
        //Перевіримо чи ми на головному екрані чи ні
        XCTAssertTrue(app.isOnMainView)
        
        app.navigationBars["Task"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        //Позволяє нам написати троку в titleTextField
        titleTextField.typeText("Foo")
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Baz")
        
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("01.01.19")
        
        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.typeText("Bar")
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Ufa")
        addressTextField.typeText("\n")
        
        XCTAssertFalse(app.isOnMainView)
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Save"]/*[[".buttons[\"Save\"].staticTexts[\"Save\"]",".staticTexts[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    //Перевіримо введення данних
    func testExample() throws {
        
        addTask()
        
        //Перевіримо чи є такий елемент
        XCTAssertTrue(app.textFields["Title"].exists)
        
        //Переівіримо чи текст елемента буде такий як вписуємо в textField
        XCTAssertEqual(app.textFields["Title"].value as! String, "Foo")
        XCTAssertEqual(app.textFields["Location"].value as! String, "Bar")
        XCTAssertEqual(app.textFields["Date"].value as! String, "01.01.19")
    }
    
    //Перевіримо чи при свойпі появляється кнопка Done
    func testWhenCellIsSwipedLeftDoneButtonAppeared() {
        
        addTask()
        
        //Добераємось до контейнерів
        let tablesQuery = app.tables.cells
        //Беремо контейнер по індексу та свайпаємо його в ліво
        tablesQuery.element(boundBy: 0).swipeLeft()
        //Перевіримо чи появилась кнопка Done, та нажимаємо на неї
        tablesQuery.element(boundBy: 0).buttons["Done"].tap()
        
        //Перевіримо чи по ідентифікатору date буде пуста строка - тому що коли задача виконана то дата скривається
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "date").label, "")
    }
}


extension XCUIApplication {
    
    //Властивість яка перевіряє чи є контроллер з таким ідентифікатопом(mainView) на екрані
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
}
