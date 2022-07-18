//
//  TaskManager.swift
//  ToDoApp
//
//  Created by Andriy on 01.07.2022.
//

import UIKit

//Менеджер задач
class TaskManager {
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []

    var tasksCount: Int {
        return tasks.count
    }
    var doneTasksCount: Int {
        return doneTasks.count
    }
    
    //URL де зберігаються задачі
    var tasksURL: URL {
        //Тут зберігаються всі файли
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileUrl.first else { fatalError() }
        //В tasks.plist будуть зберігатись всі задачі
        return documentURL.appendingPathComponent("tasks.plist")
    }
    
    //Під час ініціалізації зробимо наглядача за повідомленням
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        //Отримуємо данні які зберігаються по якомусь адресу
        if let data = try? Data(contentsOf: tasksURL) {
            //Получаємо словники які зберігаються в файлі
            guard let dictionaries = try? PropertyListSerialization.propertyList(from: data,
                                                                                 options: [],
                                                                                 format: nil) as? [[String : Any]]
            else { return }
            
            //Використаємо ці словники щоб створити задачі
            for dict in dictionaries {
                //Якщо створимо задачу через словник то добавимо її в масив невиконаних задач
                if let task = Task(dict: dict) {
                    tasks.append(task)
                }
            }
        }
    }
    
    //Коли буде deinit також збережимо данні
    deinit {
        save()
    }
    
    //Метод який буде зберігати данні
    @objc func save() {
        //Всі задачі які є ми повинні перетворити в словники
        let taskDictionaries = self.tasks.map { $0.dict }
        //Перевіряємо кількість елементів
        guard taskDictionaries.count > 0 else {
            //Якщо немає ніяких задач то видаляємо все те що зберігаєтьяс на диску
            try? FileManager.default.removeItem(at: tasksURL)
            return
        }
        
        //Получаємо taskDictionaries в форматі XML
        let plistData = try? PropertyListSerialization.data(fromPropertyList: taskDictionaries,
                                                            format: .xml,
                                                            options: PropertyListSerialization.WriteOptions(0))
        
        //Пробуємо зберегти данні
        try? plistData?.write(to: tasksURL, options: .atomic)
    }

    //Метод додає задачі в масив та змінює кількість задач
    func add(task: Task) {
        //Перевіримо чи ця задача вже не добавлена в масив, для того щоб задачі неповторювались
        if !tasks.contains(task) {
            //Додаємо задачу в масив невиконаних задач
            tasks.append(task)
        }
    }

    //Метод вертає задачу з масива невиконаних по індексу
    func task(at index: Int) -> Task {
        return tasks[index]
    }

    //Видаляємо задачу з масива невиконаних та переміщаємо її в масив виконаних
    func checkTask(at index: Int) {
        //Видаляємо задачу по індексу з масива невиконаних задач
        var task = tasks.remove(at: index)
        //Міняємо задачу на виконану
        task.isDone.toggle()
        //Додаємо цю задачу в масив виконаних задач
        doneTasks.append(task)
    }

    //Видаляємо задачу з масива виконаних та переміщаємо її в масив невиконаних
    func uncheckTask(at index: Int) {
        var task = doneTasks.remove(at: index)
        task.isDone.toggle()
        tasks.append(task)
    }

    //Метод вертає задачу з масива виконаних по індексу
    func doneTask(at index: Int) -> Task {
        return doneTasks[index]
    }

    //Масиви з задачами робимо пустими
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}


