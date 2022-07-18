//
//  LocationTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 30.06.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    //Перевіримо чи ми встановлюємо імя
    func testInitSetsName() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo")
    }
    
    //Тест який перевірить додавання координатів в властивість
    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1,
                                                longitude: 2)
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    //Тест який перевірить чи наш location приводитьяс до простих типів) Для того щоб можна було їх зберігати в info.plist
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 10))
        let dictionary: [String : Any] = ["name" : "Foo",
                                          "latitude" : 10.0,
                                          "longitude" : 10.0]
        
        let createdLocation = Location(dict: dictionary)
        
        XCTAssertEqual(location, createdLocation)
    }
    
    //перевіримо чи наш location може бути сереалізований в словник
    func testCanBeSerializetIntoDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 10))
        let generatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, generatedLocation)
    }
}
