//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 03.07.2022.
//

import XCTest
@testable import ToDoApp

class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!

    override func setUpWithError() throws {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: String(describing:
                                                                                    TaskListViewController.self)) as! TaskListViewController
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        let dataSourse = FakeDataSourse()
        tableView?.dataSource = dataSourse
        
        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Перевіримо чи є в нашому контейнері заголовок
    func testCellHasTitleLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }

    //Перевіримо чи titleLabel знаходиться на view
    func testCellHasTitleLabelInContetnView() {
        //Перевіримо чи titleLabel знаходиться на cell.contentView
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    //Перевіримо чи є в нашому контейнері locationLabel
    func testCellHasLocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }

    //Перевіримо чи locationLabel знаходиться на view
    func testCellHasLocatioLabelInContetnView() {
        //Перевіримо чи titleLabel знаходиться на cell.contentView
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    //Перевіримо чи є в нашому контейнері Data
    func testCellHasDataLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }

    //Перевіримо чи Data знаходиться на view
    func testCellHasDataLabelInContetnView() {
        //Перевіримо чи titleLabel знаходиться на cell.contentView
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    //Тест який перевірить чи встановлюються заголовки
    func testConfigureSetsTitle() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
    }
    
    //Тест який перевірить чи втановлюється дата в контейнер
    func testConfigureSetsDate() {
        let tast = Task(title: "Foo")
        cell.configure(withTask: tast)
        
        let df = DateFormatter()
        //https://nsdateformatter.com
        df.dateFormat = "dd.MM.yy"
        
        let date = tast.date
        let dateString = df.string(from: date)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    //Тест перевірить чи втановлюється location в контейнер
    func testConfigureSetsLocationName() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar", location: location)
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }
    
    //Створюємо задачу
    func configureCellWithTask() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task, done: true)
    }
    
    //Перевіримо чи виконані задачі перекреслені
    func testDoneTaskShouldStrikeThrough() {
        configureCellWithTask()
        //Строка в яку ми можемо задавати якісь атрибути
        let attributedString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])

        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    }
    
    //Тест для перевірки, чи скритий dateLabel коли задача виконана
    func testDoneTaskDataLabelTextEqualsEmptyString() {
        configureCellWithTask()
        XCTAssertEqual(cell.dateLabel.text, "")
    }
    
    //Тест для перевірки, чи скритий locationLabel коли задача виконана
    func testDoneTaskLocationLabelTextEqualsEmptyString() {
        configureCellWithTask()
        XCTAssertEqual(cell.locationLabel.text, "")
    }
    
    //Перевірить коли задача невиконана то location є на екрані
    func testUndoneTasksLocationOn() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar", location: location)
        cell.configure(withTask: task, done: false)
        
        XCTAssertEqual(task.location?.name, cell.locationLabel.text)
    }
    
    //Перевірить коли задача виконана то location немає на екрані
    func testDoneTasksLocationOff() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar", location: location)
        cell.configure(withTask: task, done: true)
        
        XCTAssertEqual(cell.locationLabel.text, "")
    }
    
}


extension TaskCellTests {
    
    //Створюємо фейковий dataSourse
    class FakeDataSourse: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
    }
}
