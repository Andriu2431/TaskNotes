//
//  TaskListViewContollerTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 02.07.2022.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self))
        sut = viewController as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Пeревіримо чи наш viewController після загрузки буде мити в собі tableView
    func testWhenViewIsLoadedTableViewNotNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    //Перевіримо чи DataProvider не буде ніл
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    //Перевірими чи при запуску viewController делегат tableView буде встановлений
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    //Перевірими чи при запуску viewController датасоурс tableView буде встановлений
    func testWhenViewIsLoadedTableViewDataSourseIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    //Перевіримо чи точно делегат да дата сорс точно є наш клас DataProvider
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSourse() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider,
                       sut.tableView.dataSource as? DataProvider)
    }
    
    //Перевіримо чи є в нас кнопка та чи є в неї таргет
    func testTaskLiskVCHasAddNBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButton.action else {
            return NewTaskViewController()
        }
        
        //Добавляємо контроллер
        UIApplication.shared.keyWindow?.rootViewController = sut
        //Беремо селетор то даємо йому дію
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        //Перевіримо чи правильно ми його створимо
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        
        return newTaskViewController
    }
    
    //Перевіримо чи при нажиманні на кнопку буде відкриватись контроллнр з добавленням задач
    func testAddNewTaskPresentsNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
    
    //Перевіримо чи TaskManager однаковий
    func testSharesSameTaskManagerWithNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(sut.dataProvider.taskManager)
        //=== повірвнює чи це один і тойже обєкт
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    //Тест перевірить чи обновляється tableView після додавання нових задач
    func testWhenViewAppearedTableViewReloaded() {
        let mokeTableView = MokeTableView()
        sut.tableView = mokeTableView
        
        //Імітуємо відпрацювання метода viewWillAppear and viewDidAppear
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MokeTableView).isReloaded)
    }
    
    //Перевіримо передачу задачі коли тапаємо по контейнеру на DetailViewController
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        //Відправляємо повідомлення
        expectation(forNotification: NSNotification.Name("DidSelectRow notification"), object: nil) { notification -> Bool in
            
            //Шукаємо задачу по ключу
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else { return false }
            return task == taskFromNotification
        }
        
        //Нажимаємо на контейнер
        let tableView = sut.tableView
        tableView?.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 1)
    }
    
    //Перпевіримо буде відкриватись DetailViewController коли тапаємо на контейнер
    func testSelectedCellNotificationPushesDetailVC() {
        let mokeNavigationController = MokeNavigationController(rootViewController: sut)
//        UIApplication.shared.keyWindow?.rootViewController = mokeNavigationController
        
        //ViewDidLoad
        sut.loadViewIfNeeded()
        
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: NSNotification.Name("DidSelectRow notification"), object: self, userInfo: ["task" : task1])
        
        guard let detailViewController = mokeNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task1)
    }
}

extension TaskListViewControllerTests {
    
    //Клас для перевірки чи tableView був перезагружений після дабавлення задачі
    class MokeTableView: UITableView {
        var isReloaded = false
        
        //Метод який робить перезагрузку
        override func reloadData() {
            isReloaded = true
        }
    }
}


extension TaskListViewControllerTests {
    
    //Для перевірки чи буде пушитись новий контроллер
    class MokeNavigationController: UINavigationController {
        
        //Перевірить чи ми перейшли на новий екран
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            //Присвоюємо той контроллер на який переходимо
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
