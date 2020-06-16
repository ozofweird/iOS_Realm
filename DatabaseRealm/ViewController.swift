//
//  ViewController.swift
//  DatabaseRealm
//
//  Created by Ahn on 2020/06/16.
//  Copyright © 2020 ozofweird. All rights reserved.
//

import UIKit
import RealmSwift

class PersonData: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userAge: Int = 0
}

class ViewController: UIViewController {

    @IBOutlet weak var createName: UITextField!
    @IBOutlet weak var createAge: UITextField!
    
    @IBOutlet weak var readName: UILabel!
    @IBOutlet weak var readAge: UILabel!
    
    @IBOutlet weak var deleteName: UITextField!
    
    var personData = PersonData()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Create
    @IBAction func createBtn(_ sender: Any) {
        self.personData = inputData(db: self.personData)
        
        try? realm.write {
            realm.add(self.personData)
        }
    }
    
    // Read
    @IBAction func readBtn(_ sender: Any) {
        let savedData = realm.objects(PersonData.self)
        
        // 구조 확인
        print(savedData.sorted(byKeyPath: "userName", ascending: true))
        print(savedData.count)
        
        // 가장 마지막으로 저장된 값 불러오기
        self.readName.text = savedData[0].userName
        self.readAge.text = String(savedData[0].userAge)
    }
    
    //Delete
    @IBAction func deleteBtn(_ sender: Any) {
        do {
            try self.realm.write {
                let name = deleteName.text
                let predicate = NSPredicate(format: "userName = %@", name!)
                realm.delete(realm.objects(PersonData.self).filter(predicate))
            }
        } catch {
            print("\(error)")
        }
    }
}

extension ViewController {
    
    func inputData(db: PersonData) -> PersonData {
        if let name = createName.text {
            db.userName = name
        }
        
        if let age = createAge.text {
            if age == "" {
                db.userAge = 0
            } else {
                db.userAge = Int(age)!
            }
        }
        return db
    }
}
