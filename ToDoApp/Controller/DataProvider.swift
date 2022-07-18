//
//  DataProvider.swift
//  ToDoApp
//
//  Created by Andriy on 02.07.2022.
//

import UIKit

//Енум дозволить позбавитись дефолтного кейсу - для секцій
enum Section: Int, CaseIterable {
    case toDo
    case done
}

//Тут будемо працювати з tableView
class DataProvider: NSObject {
    var taskManager: TaskManager?
}


extension DataProvider: UITableViewDelegate {

    //Метод спрацьовує коли йде свайп по контейнеру вліво або вправо та вилвзять кнопки
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {

        //Отримуємо секцію
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        //Вертаємо або кнопку Done або Undone
        switch section {
        case .toDo: return "Done"
        case .done: return "Undone"
        }
    }
    
    //Метод для тапу на контейнер
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        switch section {
        case .toDo:
            //Отримуємо task
            guard let task = taskManager?.task(at: indexPath.row) else { return }
            //Надсилаємо повідомлення з задачею
            NotificationCenter.default.post(name: NSNotification.Name("DidSelectRow notification"), object: self, userInfo: ["task" : task])
        case .done: break
        }
    }
    
    //Метод який відповідає за UI секцій
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let section = Section(rawValue: section) else { fatalError() }
        
        switch section {
        case .toDo: return "Undone tasks"
        case .done: return "Done tasks"
        }
        
    }
}

extension DataProvider: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //Передаємо секції в енум
        guard let section = Section(rawValue: section) else { fatalError() }
        guard let taskManager = taskManager else { return 0 }

        //В залежності від секції будемо повертати строки
        switch section {
        case .toDo: return taskManager.tasksCount
        case .done: return taskManager.doneTasksCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell

        //Отримуємо секцію
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        guard let taskManager = taskManager else { fatalError() }

        //Задача
        let task: Task
        //Заповнюємо контейнер по секціям. 1 Секція вертає невиконані задачі. 2 виконані.
        switch section {
        case .toDo: task = taskManager.task(at: indexPath.row)
        case .done: task = taskManager.doneTask(at: indexPath.row)
        }

        //Передаємо її
        cell.configure(withTask: task, done: task.isDone)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    //Метод який буде перекидувати задачі з масива невиконаних в масив виконаних та наобород
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard let section = Section(rawValue: indexPath.section),
              let taskManager = taskManager else { fatalError() }

        switch section {
        case .toDo: taskManager.checkTask(at: indexPath.row)       //Видаляє не виконану задачу по додає цю задачу в масив виконаних
        case .done: taskManager.uncheckTask(at: indexPath.row)     //Видаляє виконану задачу по додає цю задачу в масив не виконаних
        }

        tableView.reloadData()
    }
}

