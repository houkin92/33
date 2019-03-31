//
//  MainViewController.swift
//  userDefaults
//
//  Created by 方瑾 on 2019/3/27.
//  Copyright © 2019 方瑾. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var keepMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = UserDefaults.standard.value(forKey: "1234") as? String {
            keepMessage = text
        }
       displayLabel.text = inputTextField.text
        inputTextField.delegate = self
        
    }
    
    @IBAction func GoButton(_ sender: UIButton) {
        let newMessage = displayLabel.text
        UserDefaults.standard.set(newMessage, forKey: "1234")
        performSegue(withIdentifier: "MainToFirst", sender: nil)
    }
}
extension MainViewController :UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        displayLabel.text = text
        return true
    }
}
