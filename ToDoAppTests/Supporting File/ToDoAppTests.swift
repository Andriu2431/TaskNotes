//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 30.06.2022.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Перевіримо чи перший контроллер це контроллер з задачами
    func testInitialViewControllerTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Шукаємо navigationViewController
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        //В navigationController беремо його перший контроллер
        let rootViewController = navigationController.viewControllers.first as! TaskListViewController
        
        XCTAssertTrue(rootViewController is TaskListViewController)
    }
    


}
