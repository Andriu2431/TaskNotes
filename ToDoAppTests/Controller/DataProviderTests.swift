//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 02.07.2022.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    var controller: TaskListViewController!

    override func setUpWithError() throws {
        sut = DataProvider()
        //Ініціалізуємо taskManager
        sut.taskManager = TaskManager()
        
        //ПРисвоюємо контроллер
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        //Викликаємо метод viewDidLoad
        controller.loadViewIfNeeded()
        
        
        tableView = controller.tableView
        //Данні беремо з DataProvider та передаємо їх через dataSource в tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Перевірими чи в нашому tableView 2 секції
    func testNumberOfSectionsIsTwo() {
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
    }
    
    //Перевіримо чи кількість задач які потрібно виконати дорівнює кількості строк в першій секції tableView
    func testNumberOfRowsInSectionZeroIsTaskCount() {
        
        //Додаємо задачу
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        //Пeревірка чи в 0 секції 1 строка
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    //Перевіримо чи кількість виконаних задач дорівнює кількості строк в другій секції tableView
    func testNumberOfRowsInSectionOneIsDoneTasksCount() {
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        //Перемістили задачу в виконаний масив задач
        sut.taskManager?.checkTask(at: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }

    //Перевіримо чи ми отримуємо контейнер з задачею а не рандомний контейнер
    func testCellForAtIndexPathReturnsTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    //Тест який перевірить чи перевикористовується контейнер
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mokeTableView = MokeTableView.mokeTableView(withDataSourse: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mokeTableView.reloadData()
        
        //Получаємо контейнер
        _ = mokeTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mokeTableView.cellIsDequeued)
    }
    
    //Перевіримо контейнер на наповнення невиконаних задач
    func testCellForRowInSectionZeroClassConfigure() {
        let mokeTableView = MokeTableView.mokeTableView(withDataSourse: sut)
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        mokeTableView.reloadData()
        
        let cell = mokeTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MokeTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    //Перевіримо контейнер на наповнення виконаних задач
    func testCellForRowInSectionOneClassConfigure() {
        let mokeTableView = MokeTableView.mokeTableView(withDataSourse: sut)
        
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mokeTableView.reloadData()
        
        let cell = mokeTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MokeTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    //Тест який перевіряє кнопки які вилазять по свайпу контейнера вліво або вправо
    //Кнопку Delete яка вилазить по свайпу контейнера перейменовується в Done
    func testDeleteButtonTitleZeroShowsDone() {
        //Отримуємо текст кнопки
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    //Кнопку Delete яка вилазить по свайпу контейнера перейменовується в Undone
    func testDeleteButtonTitleOneShowsDone() {
        //Отримуємо текст кнопки
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    //Перевіримо чи при нажиманні на кнопку задачі перекидуються в виконані
    func testCheckingTaskTestInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        //Нажимаємо на кнопку Done
        tableView.dataSource?.tableView?(tableView,
                                         commit: .delete,
                                         forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }

    //Перевіримо чи виконані задачі перекидуються в невиконані
    func testUncheckingTaskUncheckingsInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        //Нажимаємо на кнопку Undone
        tableView.dataSource?.tableView?(tableView,
                                         commit: .delete,
                                         forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
    //Метод перевірить загововки секції 0
    func testCheakTitleSection0() {
        let titleSection = tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: 0)
        XCTAssertEqual(titleSection, "Undone tasks")
    }
    
    //Метод перевірить загововки секції 1
    func testCheakTitleSection1() {
        let titleSection = tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: 1)
        XCTAssertEqual(titleSection, "Done tasks")
    }
    
}


extension DataProviderTests {
    
    //MokeTableView - заміняє tableView, перевірить чи контейнер перевикористовується.
    class MokeTableView: UITableView {
        var cellIsDequeued = false
        var id = false
        
        //Метод створює tableView з контейнером
        static func mokeTableView(withDataSourse dataSourse: UITableViewDataSource) -> MokeTableView {
            let mokeTableView = MokeTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 896), style: .plain)
            mokeTableView.dataSource = dataSourse
            //Рейструємо контейнер
            mokeTableView.register(MokeTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mokeTableView
        }
        
        //Спрацьовує коли контейнер перевикористовується
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            
            cellIsDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    //Перевіримо чи контейнер використовує задачі для самозаповнення
    class MokeTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
    }
}
