//
//  ViewController.swift
//  BirthdayNoteTaker
//
//  Created by Bhumika Hirapara on 2/14/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    let defaults = UserDefaults.standard    // whenever we call UserDefaults.standard (Singleton) -> I get the same object so that I reach the same data that I have been working on
    
    let nameKey = "name"
    let birthdayKey = "birthday"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storedName = defaults.object(forKey: nameKey)   // because we set Any? -> get from object()
        let storedBirthday = defaults.object(forKey: birthdayKey)
        
//        casting as? -> optional casting vs. as! -> force casting
        
        if let newName = storedName as? String {    // convert Any? to String
            nameLabel.text = "Name: \(newName)"
        }
        
        if let newBirthday = storedBirthday as? String {
            birthdayLabel.text = "Birthday: \(newBirthday)"
        }
    }

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        defaults.set(nameTextField.text!, forKey: nameKey)   // value -> Any?
        defaults.set(birthdayTextField.text!, forKey: birthdayKey)  // UserDefaults
        
        nameLabel.text = "Name: \(nameTextField.text!)"
        birthdayLabel.text = "Birthday: \(birthdayTextField.text!)"
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
        let storedName = defaults.object(forKey: nameKey)   // because we set Any? -> get from object()
        let storedBirthday = defaults.object(forKey: birthdayKey)
        
        if storedName as? String != nil {
            defaults.removeObject(forKey: nameKey)
            nameLabel.text = "Name: "
        }
        
        if storedBirthday as? String != nil {
           defaults.removeObject(forKey: birthdayKey)
            birthdayLabel.text = "Birthday: "
        }
        
    }
    
}

