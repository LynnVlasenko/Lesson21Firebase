//
//  UIViewController+Extensions.swift
//  Lesson21Firebase
//
//  Created by Алина Власенко on 04.04.2023.
//

import UIKit

//розширення для алерта з текст філдом 
//shift+command+k - викликає клавіатуру на екрані(software клавіатура) для введення тексту в текст філд
//повторне натискання виключає. 
//Можна ще в Симуляторі в панелі керування обрати I/O -> Keyboard -> Connect Hardware Keyboard - прибирати або ставити галочку.

extension UIViewController {
    func presentAlertWithTextField(title: String,
                                   message : String,
                                   acceptTitle: String,
                                   declineTitle: String?,
                                   inputPlaceholder: String? = nil,
                                   okActionHandler: ((_ text: String?) -> (Void))? = nil,
                                   cancelActionHandler: (() -> ())? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // параметр preferredStyle: .alert - буде показувати повідомлення по середині екрану, 
        //а якщо обрати .actionSheet - то виїжджатиме знизу
        
        alertController.addTextField { (textField) in //на alertController додаєм текст філду
            textField.placeholder = inputPlaceholder
        }

        //дія при натисканні ОК на алерті
        let okAction = UIAlertAction(title: acceptTitle, style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                okActionHandler?(nil)
                return
            }
            okActionHandler?(textField.text)
        }
        alertController.addAction(okAction)

        //дія при натисканні Cancel на алерті
        if let declineTitle = declineTitle {
            let cancelAction = UIAlertAction(title: declineTitle, style: .cancel, handler: { _ in
                cancelActionHandler?()
            })
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true)
    }
}
