//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Andriy on 07.07.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    //задачі та дії з ними
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    //Транформуємо строку в date
    var dateFormater: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }

    //Метод закриває клавіатуру
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //Метод буде зберігати задачу в масив невиконаних задач
    @IBAction func save() {
        
        guard let titleText = titleTextField.text,
              let locationText = locationTextField.text,
              let dateText = dateTextField.text,
              let addressText = addressTextField.text,
              let descriptionText = descriptionTextField.text
        else { return print("Некоректні данні")}

        let titleString = titleText
        let locationString = locationText
        let dateString = dateFormater.date(from: dateText)
        let addressString = addressText
        let descriptionString = descriptionText


        //Використаємо геокодер для того щоб з строки получити координати
        geocoder.geocodeAddressString(addressString) { [unowned self] placemarks, error in
            if error != nil {
                print("Некоректно введене місто")
            }

            //Візьмемо перші координати
            let placemark = placemarks?.first
            //Отримуємо координати
            let coordinate = placemark?.location?.coordinate
            //Створимо локацію по цих координатах
            let location = Location(name: locationString, coordinate: coordinate)

            //Коли маємо координати тоді створимо вже задачу
            let task = Task(title: titleString, description: descriptionString, date: dateString, location: location)
            //В taskManager додаємо задачу
            self.taskManager.add(task: task)

            DispatchQueue.main.async {
                //Закриваємо екран коли задача буде створена
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
