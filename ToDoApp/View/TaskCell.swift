//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Andriy on 02.07.2022.
//

import UIKit

//Контейнер з задачами
class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    //Попрацюємо з датаою
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }

    //Метод буде заповнювати інформацію в контейнерах
    func configure(withTask task: Task, done: Bool = false) {

        //В залежності від done задамо стиль строки
        if done {

            //Строка в яку ми можемо задавати якісь атрибути
            let attributedString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])

            titleLabel.attributedText = attributedString
            
            //Коли задача виконана то скриємо непотрібні лейбли
            dateLabel.text = ""
            locationLabel.text = ""
            
        } else {
            //отримаюємо строку з дати
            let dateString = dateFormatter.string(from: task.date)
            
            self.dateLabel.text = dateString
            //передаємо заголовок в label
            self.titleLabel.text = task.title
            //Передаємо локацію в лейбел
            self.locationLabel.text = task.location?.name
        }
    }
}

