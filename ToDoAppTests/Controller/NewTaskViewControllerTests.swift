//
//  NewTaskViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 07.07.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class NewTaskViewControllerTests: XCTestCase {

    var sut: NewTaskViewController!
    //Передаємо фейкові координати
    var placemark: MockCLPlacemark!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Перевіримо чи є titleTextField
    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є titleTextField
    func testHasTitleLocationField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є dateTextField
    func testHasTitleDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є addressTextField
    func testHasTitleAddressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є descriptionTextField
    func testHasTitleDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є saveButton
    func testHasTitleSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи є cancelButton
    func testHasTitleCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    //Перевіримо чи при збереженні нового завдання в нас буде використовуватись геокодер який буде робити трансфер з adressTextField в координати)
    func testSaveUsesGeocoderToConvertCoordinateFromAddress() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.19")

        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "01.01.19"
        sut.addressTextField.text = "Уфа"
        sut.descriptionTextField.text = "Baz"

        sut.taskManager = TaskManager()
        //Фейковий геокодер
        let mokeGeocoder = MockCLGeocoder()
        sut.geocoder = mokeGeocoder
        sut.save()

        let coordinate = CLLocationCoordinate2D(latitude: 54.7373058, longitude: 55.9722491)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)

        //Передаємо фейкові координати
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        mokeGeocoder.completionHandler?([placemark], nil)

        //Перевіримо чи задача попала в масив невиконаних задач
        let task = sut.taskManager.task(at: 0)

        XCTAssertEqual(task, generatedTask)
    }
    
    //Перевіримо чи кнопка saveButton має actions
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        //Чи має кнопка actions
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    //Перевіримо чи кнопка cancelButton має actions
    func testCancelButtonHasDismissNewTaskViewController() {
        let cancelButton = sut.cancelButton
        
        //Чи має кнопка actions
        guard let actions = cancelButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return }
        
        XCTAssertTrue(actions.contains("cancel"))
    }
    
    //Перевіримо чи закривається контроллер при нажиманні на кнопку cancel
    func testCenceldismissesNewTaskViewController() {
        let mokeNewTaskViewController = MokeNewTaskViewController()
        mokeNewTaskViewController.cancel()
        
        XCTAssertTrue(mokeNewTaskViewController.isDismissed)
    }
    
    //Перевіримо чи вертається нормальні координати
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addressString = "Ufa"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard let latitude = location?.coordinate.latitude,
                  let longitude = location?.coordinate.longitude
            else {
                XCTFail()
                return }

            XCTAssertEqual(latitude, 54.7373019)
            XCTAssertEqual(longitude, 55.9722162)
            //Задовільняємо дію
            geocoderAnswer.fulfill()
        }

        //Якщо ще не задовільнили то ставим таймаут
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //Тест який перевірить чи закривається контролер коли ми нажимаємо кнопку save нової задачі
    func testSavaDismissesNewTaskViewController() {
        let mokeNewTaskViewController = MokeNewTaskViewController()
        mokeNewTaskViewController.titleTextField = UITextField()
        mokeNewTaskViewController.titleTextField.text = "Foo"
        mokeNewTaskViewController.descriptionTextField = UITextField()
        mokeNewTaskViewController.descriptionTextField.text = "Bar"
        mokeNewTaskViewController.locationTextField = UITextField()
        mokeNewTaskViewController.locationTextField.text = "Baz"
        mokeNewTaskViewController.addressTextField = UITextField()
        mokeNewTaskViewController.addressTextField.text = "Уфа"
        mokeNewTaskViewController.dateTextField = UITextField()
        mokeNewTaskViewController.dateTextField.text = "01.01.19"
        
        mokeNewTaskViewController.save()
        
        //Зробимо затримку бо задача спрацьовує в замиканні
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertTrue(mokeNewTaskViewController.isDismissed)
        }
    }
}



extension NewTaskViewControllerTests {
    
    //Створимо фейковий геокодер - щоб не бути залежним від інтернету
    class MockCLGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    //Фейкові координати
    class MockCLPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}


extension NewTaskViewControllerTests {
    
    //ПЕревіримо чи був викликаний метод який закриєває контроллер
    class MokeNewTaskViewController: NewTaskViewController {
        var isDismissed = false
        
        //Перевірими чи цей метод був викликаний
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
    }
}
