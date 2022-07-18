//
//  APIClient.swift
//  ToDoApp
//
//  Created by Andriy on 08.07.2022.
//

import Foundation

//Зробимо енум для помилки
enum NetworkError: Error {
    case emptyData
}

//Протокол для того щоб тест проходив
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}

//Робота з інтернетом
class APIClient {
    
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    //Метод буде рейструвати користувача та робити запит на сервер
    func login(withName name: String, password: String, complitionHandler: @escaping (String?, Error?) -> Void) {
        
        //Шифруємо символи для запиту
        let allowedCharacters = CharacterSet.urlQueryAllowed
//        URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
//        URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
//        URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
//        URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
//        URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
//        URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
        
        //Додаємо шифровані символи
        guard let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
              let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else { fatalError() }
        
        //Створимо параметри запиту
        let query = "name=\(name)&password=\(password)"
        
        //Пишемо куди буде запит
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else { fatalError() }
        
        //Запит
        urlSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                return complitionHandler(nil, error)
            }
            
            do {
                
                //Отримуємо дату
                guard let data = data else {
                    //Якщо буде помилка то передамо її далі
                    complitionHandler(nil, NetworkError.emptyData)
                    return
                }
                
                //Отримуємо з дати dictionary
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String : String] 
                //Отримуємо токен з словника
                let token = dictionary["token"]
                //Передаємо його далі
                complitionHandler(token, nil)
                
            } catch {
                complitionHandler(nil, error)
            }
            
        }.resume()
    }
}


