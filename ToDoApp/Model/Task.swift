//
//  Task.swift
//  ToDoApp
//
//  Created by Andriy on 30.06.2022.
//

import Foundation

//Задачі
//Equatable - властивості одної задачі можна порівнювати з властивостями другої задачі
struct Task {
    let title: String
    let description: String?
    let date: Date
    let location: Location?
    //Чи виконана задача чи ні
    var isDone = false
    
    //Властивість яка буде робити з словника Task
    var dict: [String : Any] {
        var dict: [String : Any] = [:]
        dict["title"] = title
        dict["description"] = description
        dict["date"] = date
        if let location = location {
            //Передаємо локацію як словник в Location
            dict["location"] = location.dict
        }
        return dict
    }

    init(title: String,
         description: String? = nil,
         date: Date? = nil,
         location: Location? = nil) {

        self.title = title
        self.description = description
        self.date = date ?? Date()
        self.location = location
    }
}

//Для створення задач через dictionary
extension Task {
    
    typealias PlistDicrionary = [String : Any]
    
    init?(dict: PlistDicrionary) {
        self.title = dict["title"] as! String
        self.description = dict["description"] as? String
        self.date = dict["date"] as? Date ?? Date()
        
        //Якщо получимо словник з координатами
        if let locationDictionary = dict["location"] as? [String : Any] {
            //То передамо його в локацію
            self.location = Location(dict: locationDictionary)
        } else  {
            self.location = nil
        }
    }
}

//Переоприділимо признаки рівності двох обєктів
extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        if lhs.title == rhs.title,
           lhs.description == rhs.description,
           lhs.location == rhs.location {
            return true
        }
        return false
    }
}

