//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by Andriy on 08.07.2022.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {

    var sut: APIClient!
    var mockURLSession: MockURLSesion!

    override func setUpWithError() throws {
        mockURLSession = MockURLSesion(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func userLogin() {
        let complitionHandler = { (token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", complitionHandler: complitionHandler)
    }

    //перевіримо чи запит використовує правильний host
    func testLoginUsersCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }

    //перевіримо чи запит використовує правильний path
    func testLoginUsersCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }

    //Перевіримо параметри запиту
    func testLoginUserExpectedQueryParameters() {
        userLogin()

        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }

        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")

        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    //Перевіримо чи генеруються токени для рейстрованих рористувачів) Token -> Data -> complitionHandler -> DataTask -> urlSesion
    func testSuccessfulLoginCreatesToken() {
        //Створюємо токен
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        //Передаємо відповідь, токен
        mockURLSession = MockURLSesion(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        
        //Будемо чекати на токен бо він в замиканні
        let tokenExpectation = expectation(description: "Token expectation")
        
        //Тут буде токен
        var caughtToken: String?
        
        //Рейструємо користувача, робимо запит та отримуємо відповідь від сервера
        sut.login(withName: "login", password: "password") { token, _ in
            //Лапаємо токей який передали в замиканні в класі APIClient
            caughtToken = token
            //Тут будемо чекати поки не виконяється код в замиканні
            tokenExpectation.fulfill()
        }
        
        //Час який будемо очікувати
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    //Перевіримо чи буде вертатись помилка якщо формат json буде невірним
    func testLoginInvalidJSONReturnsError() {
        mockURLSession = MockURLSesion(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    //Перевіримо чи буде вертатись помилка якщо data буде nil
    func testLoginWhenDataIsNilReturnsError() {
        mockURLSession = MockURLSesion(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    //Тест якщо сервер верне помилку
    func testLoginWhenResponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        mockURLSession = MockURLSesion(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}


extension APIClientTests {

    //Заглушка для запиту
    class MockURLSesion: URLSessionProtocol {

        var url: URL?
        //Від MokeURLSesionDataTask потрібен completionHandler
        private let mockDataTask: MokeURLSesionDataTask

        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            //Ініціалізуємо клас MokeURLSesionDataTask
            mockDataTask = MokeURLSesionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }

        //Створюємо запит та отримуємо відповідь
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            
            //Витягуюємо completionHandler з відповіддю та передаємо його
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    //Клас з відповідю на запит сервера
    class MokeURLSesionDataTask: URLSessionDataTask {
        
        //Властивості для completionHandler
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        //Сюди передамо completionHandler відповіді з сервера
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}





