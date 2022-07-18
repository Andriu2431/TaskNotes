//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 07.07.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Тест перевіряє чи є в нашому контролері titleLabel
    func testHasTitleLabele() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    //Тест перевіряє чи є в нашому контролері TitleLable
    func testHasDescriptionLable() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertNotNil(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    //Тест перевіряє чи є в нашому контролері dateLabel
    func testHasDateLable() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertNotNil(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    //Тест перевіряє чи є в нашому контролері locationLabel
    func testHasLocationLable() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertNotNil(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є mapView на контролеррі
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertNotNil(sut.mapView.isDescendant(of: sut.view))
    }
    
    //Створювання повної задачі
    func setupTaskAndApperenceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 49.83968, longitude: 24.02972)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        sut.task = task
        
        //Імітуємо відпрацювання метода viewWillAppear and viewDidAppear
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    //Перевіримо чи ми можемо з задачі взяти title
    func testSettingTaskSetsTitleLabel() {
        setupTaskAndApperenceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    //Перевіримо чи ми можемо з задачі взяти description
    func testSettingTaskSetsDescriptionLabel() {
        setupTaskAndApperenceTransition()
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    //Перевіримо чи ми можемо з задачі взяти locationLabel
    func testSettingTaskSetsLocationLabel() {
        setupTaskAndApperenceTransition()
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    //Перевіримо чи ми можемо з задачі взяти dateLabel
    func testSettingTaskSetsDateLabel() {
        setupTaskAndApperenceTransition()
        XCTAssertEqual(sut.dateLabel.text, "01.01.19")
    }
    
    //Перевірими чи встановлюємо ми mapView
    func testSettingTaskSetsMapView() {
        setupTaskAndApperenceTransition()
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 49.83968, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 24.02972, accuracy: 0.001)
    }

}
