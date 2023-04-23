//
//  ViewController.swift
//  Lesson21Firebase
//
//  Created by Алина Власенко on 04.04.2023.
//

import UIKit
import Firebase

//Model for Realm //Щоб засетапити Realm, наша модель має наслідуватись від Object 
//та щоб можна було сторити - кожна властивість починається з @Persisted
class Cat {
    var name: String?
    var age: String?
    
    //створюємо обов'язковий ініціалізатор, для того, щоб функція getCats могла обробити дані моделі
    init(name: String, age: String) {
        self.name = name
        self.age = age
    }
    
    //і створимо опціональний(фейлбл конструктор), який буде інітитися снапшот із дата снапшоту.
    //В цьому снапшоті ми будемо перевіряти усі велью, які в нас є у цьому снап шоті
    
    init?(snapshot: DataSnapshot?) {
        
        //робимо перевірку - чи в снашпоті є дані, які нам потрібні.
        
        //[String: AnyObject] - вказує на дані dictionary. Так як DataSnapshot це є dictionary. 
        //AnyObject - це може бути будь-який кастомний клас
        //(Просто Any - це більш загальніший тіп - це може бути і String, і Bool, і Int, 
        //а AnyObject - це об'єкти від кастомних класів, або об'єкт будь-якого класу). 
        //Тобто ми перевіряємо, що це є dictionary в першу чергу, також перевіряємо усі властивості моделі 
        //- що властивість name - це є значення з ключем "name" як стрінга, 
        //і також що властивість age - це є значення з ключем "age" як стрінга
        
        //Якщо ми не зможемо отримати цю інформацію зі знапшота(яка прописана в guard), 
        //то ми повертаємо nil. Тобто ми не змогли створити кота.
        //А якщо ми цю інформацію отримали - то ми ініціалізуємо дані, які змогли витягнути
        //Тепер ми можемо у функції getCats проініціалізувати дані моделі зі снапшотом - повертаємося 
        //у функцію в DatabaseService
        
        guard let value = snapshot?.value as? [String: AnyObject],
              let name = value["name"] as? String,
              let age = value["age"] as? String else { return nil }
        
        self.name = name
        self.age = age
    }
}

//View
class CatsTableViewController: UITableViewController {

    private var cats = [Cat]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //тестуємо роботу DatabaseService
        print("ROOT REF: ",  DatabaseService.shared.rootRef)
        
        //викликаємо функцію getCats для считування збережених в БД даних
        //і бачимо що викликається функцією наш комплішн, який нам і потрібен, 
        //щоб заповнити наш масив котів і викликати апдейт на UI
        
        DatabaseService.shared.getCats { [weak self] cats in
            //додаємо масив котів в масив котів - використовуючи contentsOf, 
            //що дозволяє додати не 1 елемент а усіх котів, яки є в БД
                                        
            self?.cats.append(contentsOf: cats)
                                        
            //і оновлюємо табличку
            self?.tableView.reloadData()
        }
    }

    //Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cats.count
    }
    
    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell ", for: indexPath)
        
        //indexPath дає можливість прописувати далі cell без опціоналів. 
        //Бо без нього UITableViewCell?, якій підпорядковується створена нами cell - опціональна. 
        //З ним - знак питання пропадає.
        
        //передаємо в тайтл ім'я кота
        cell.textLabel?.text = cats[indexPath.row].name
        
        //передаємо оунера в сабтайтл під тайтлом, так як створили cell з параметром Style = Subtitle
        cell.detailTextLabel?.text = cats[indexPath.row].age
        return cell
    }
    
    @IBAction func addCatDidTouch(_ sender: Any) {
        presentAlertWithTextField(
            title: "New cat",
            message: "add new cat",
            acceptTitle: "OK",
            declineTitle: "Cancel",
            okActionHandler: { [weak self] in //обробка параметру okActionHandler через кложуру 
                              //- де приходить новий кіт. [weak self] - будемо апдейтити наші self властивості тут 
                              //- буде приходити name з стрінги текст філда
                //тепер хочемо додати розділення тексту в текст філді за допомогою компонентів, 
                //щоб записати різні слова, які відділені пробілом в різні поля БД. - той ще костиль:) 
                //типу щоб не витрачати час. Отже, це формує масив - і ми звертаємось по індексу.
                
                //створюємо об'єкт нашого кота
                let newCat = Cat(
                    name: $0?.components(separatedBy: " ")[0] ?? "",
                    age: $0?.components(separatedBy: " ")[1] ?? ""
                )
                self?.cats.append(newCat)
                //викликаємо функцію, яка сетить дані в БД, відповідно до нашої моделі.
                DatabaseService.shared.addNewCat(cat: newCat)
                self?.tableView.reloadData()
            },
            cancelActionHandler: nil)
    }
}
