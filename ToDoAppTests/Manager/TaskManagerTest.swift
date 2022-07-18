//
//  TaskManager.swift
//  ToDoAppTests
//
//  Created by Andriy on 01.07.2022.
//

import XCTest
@testable import ToDoApp

class TaskManagerTest: XCTestCase {
    
    var sut: TaskManager!

    override func setUpWithError() throws {
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut.removeAll()
        sut = nil
    }

    //Перевіримо наш менеджер на те, що при ініціалізації немає ніяких задач
    func testInitTaskManagerWithZeroTask() {
        XCTAssertEqual(sut.tasksCount, 0)
    }
    
    //Перевіряє кулькість виконаних задач
    func testInitTaskManagerWithZeroDoneTask() {
        XCTAssertEqual(sut.doneTasksCount, 0)
    }

    //Перевіряє що коли задача додається то tasksCount буде також додаватись
    func testAddTaskIncrumentTasksCount() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        XCTAssertEqual(sut.tasksCount, 1)
    }
    
    //Перевіримо що такск який добавили це буде саме цей таск по індексу
    func testTaskAtIndexIsAddedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        let returnetTask = sut.task(at: 0)
        
        XCTAssertEqual(task.title, returnetTask.title)
    }
    
    //перевиримо кількість виконинах задач та кількість задач які потрібно виконати
    func testCheckTaskAtIndexChangesCounts() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.checkTask(at: 0)
        
        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 1)
    }
    
    //ПЕревіримо чи задача видаляється з масива tasks
    func testCheckedTaskRemovedFromTasks() {
        let firstTask = Task(title: "Foo")
        let secondTask = Task(title: "Bar")
        
        sut.add(task: firstTask)
        sut.add(task: secondTask)
        
        sut.checkTask(at: 0)
        
        XCTAssertEqual(sut.task(at: 0), secondTask)
    }
    
    //Перевіримо що задача яка виконалась збережиться в масиві виконаних задач
    func testDoneTaskAtReturnsCheckedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.checkTask(at: 0)
        let retutnedTask = sut.doneTask(at: 0)
        
        XCTAssertEqual(retutnedTask, task)
    }
    
    //Перевіримо видалення задач з 2 масивів
    func testRemoveAllResultsCountsBeZero() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Bar"))
        sut.checkTask(at: 0)
        
        sut.removeAll()
        
        XCTAssertTrue(sut.tasksCount == 0)
        XCTAssertTrue(sut.doneTasksCount == 0)
    }
    
    //Перевіримо чи будуть задачі в масиві унікальними
    func testAddingSameObjectDoesNotIncrementCount() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Foo"))
        
        XCTAssertTrue(sut.tasksCount == 1)
    }
    
    //Перевіримо чи можемо зберігати наші задачі
    func testWhenTaskManageRecreatedSavedTasksShouldBeEqual() {
        var taskManager: TaskManager! = TaskManager()
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        
        taskManager.add(task: task)
        taskManager.add(task: task1)
        
        //Скриваємо програму та від час цього будемо зберігати задачі
        //Відправляємо повідомлення про те що ми скриваємо програму(падаємо в background)
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        
        taskManager = nil
        
        //Десь тут вже збереженні данні повинні прочитатись
        taskManager = TaskManager()
        
        XCTAssertEqual(taskManager.tasksCount, 2)
        XCTAssertEqual(taskManager.task(at: 0), task)
        XCTAssertEqual(taskManager.task(at: 1), task1)
    }
}
