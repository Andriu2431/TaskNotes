//
//  ViewController.swift
//  ToDoApp
//
//  Created by Andriy on 30.06.2022.
//

import UIKit

//Головний екран 
class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        //Відкриваємо NewTaskViewController якщо ортимаємо NewTaskViewController
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            //Беремо taskManager з NewTaskViewController та присвоюємо йому taskManager з dataProvider
            viewController.taskManager = self.dataProvider.taskManager
            present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Створюємо taskManager
        let taskManager = TaskManager()
        //Передаємо його в dataProvider
        dataProvider.taskManager = taskManager
        
        //Будем виконувати якийсь код коли получемо повідомлення з задачею
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDetail(withNotification:)),
                                               name: NSNotification.Name("DidSelectRow notification"),
                                               object: nil)
        
        //Ідентифікатор контролера для тестів
        view.accessibilityIdentifier = "mainView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Перезагрузимо наш tableView
        tableView.reloadData()
    }
    
    //Метод який спрацьовує коли отримуємо повідомлення з задачею
    @objc func showDetail(withNotification notification: Notification) {

        //Отримуємо задачу з повідомлення
        guard let userInfo = notification.userInfo,
              let task = userInfo["task"] as? Task,
              let detailViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { fatalError() }
        
        //Передаємо задачу з повідомлення на detailViewController
        detailViewController.task = task
        //Пушим detailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

