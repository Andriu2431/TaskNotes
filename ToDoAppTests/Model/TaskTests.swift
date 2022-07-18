//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 30.06.2022.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {

    //Перевірка що ми можемо ініціалізувати клас
    func testInitTaskWithTitle() {
        //Задача
        let task = Task(title: "Foo")
        
        //Перевірка задачі на ніл
        XCTAssertNotNil(task)
    }
    
    //Перевірка на заголовок і опис
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    //Перевіримо чи title встановився
    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: "Foo")
        
        //Перевіримо чи можемо встановити та чи він буде дорівнювати Foo
        XCTAssertEqual(task.title, "Foo")
    }
    
    //Перевіримо чи description встановився
    func testWhenGivenDescriptionTitleSetsDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertTrue(task.description == "Bar")
    }
    
    //Перевіримо чи є дата
    func testTaskInitWithDate() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task.date)
    }

    //Тест для локації
    func testWhenGivenLocationTitleSetsLocation() {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar", description: "Baz", location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    //Тест який перевірить чи наші задачі приводяться до простих типів данних) Для того щоб можна було їх зберігати в info.plist
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 10)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        let locationDictionary: [String : Any] = ["name" : "Baz"]
        
        let dictionary: [String : Any] = ["title" : "Foo",
                                          "description" : "Bar",
                                          "date" : date,
                                          "location" : locationDictionary]
        
        let createdTask = Task(dict: dictionary)
        
        XCTAssertEqual(task, createdTask)
    }
    
    //перевіримо чи наш task може бути сереалізований в словник
    func testCanBeSerializetIntoDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 10)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let generatedTask = Task(dict: task.dict)
        
        XCTAssertEqual(task, generatedTask)
    }
    
}
