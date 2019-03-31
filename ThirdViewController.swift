//
//  ThirdViewController.swift
//  userDefaults
//
//  Created by 方瑾 on 2019/3/27.
//  Copyright © 2019 方瑾. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    var session:URLSession?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var singleStudent :SingleStudent?
//    lazy var nameTextField: UITextField = {
//        let textField = UITextField()
//        textField.frame = self.nameLabel.frame
//        return textField
//    }()
    var nameTextField :UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.brown.cgColor
        return textField
    }()
    var gradeTextField :UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.brown.cgColor
        return textField
    }()
    var birthTextField :UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.brown.cgColor
        return textField
    }()
    var phoneTextField :UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.brown.cgColor
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = singleStudent?.name ?? ""
        gradeLabel.text = singleStudent?.grade ?? ""
        birthLabel.text = singleStudent?.birthday ?? ""
        phoneLabel.text = singleStudent?.phone_number ?? ""
        session = URLSession(configuration: .default)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.addSubview(nameTextField)//控件添加到画面
        self.view.addSubview(gradeTextField)
        self.view.addSubview(birthTextField)
        self.view.addSubview(phoneTextField)
        nameTextField.frame = nameLabel.frame
        nameTextField.isHidden = true
        gradeTextField.frame = gradeLabel.frame
        gradeTextField.isHidden = true
        birthTextField.frame = birthLabel.frame
        birthTextField.isHidden = true
        phoneTextField.frame = phoneLabel.frame
        phoneTextField.isHidden = true
    }
    
    @IBAction func updata(_ sender: UIButton) {
        nameTextField.becomeFirstResponder()
        nameTextField.text = nameLabel.text
        nameLabel.isHidden = true
        nameTextField.isHidden = false
        gradeTextField.text = gradeLabel.text
        gradeLabel.isHidden = true
        gradeTextField.isHidden = false
        birthTextField.text = birthLabel.text
        birthLabel.isHidden = true
        birthTextField.isHidden = false
        phoneTextField.text = phoneLabel.text
        phoneLabel.isHidden = true
        phoneTextField.isHidden = false
    }
    
    @IBAction func certainButton(_ sender: UIButton) {
            let strUrl = "\(host)updateStudent"
            if let realUrl = URL(string: strUrl) {
                var request = URLRequest(url: realUrl)
                let name = nameTextField.text!
                print(1)
                let grade = gradeTextField.text!
                let birth = birthTextField.text!
                let phone = phoneTextField.text!

                let paraDict: [String: String] = ["s_no":(singleStudent?.s_no!)!,
                                                  "name":name,
                                                  "grade":grade,
                                                  "birthday":birth,
                                                  "phone_number":phone]
                let list = NSMutableArray()//可变数组
                for (key,value) in paraDict {
                    let str = "\(key)=\(value)"
                    list.add(str)
                }
                let paraStr = list.componentsJoined(by: "&")//把数组的每个元素整到一起
                let postData = paraStr.data(using: String.Encoding.utf8)
                request.httpMethod = "POST"
                request.httpBody = postData
                let task = session?.dataTask(with: request
                    , completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let realData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: realData, options:[])
                            if let jsonDict = json as? [String: Any] {
                                let message = jsonDict["message"] as? String
                                print(message)
                            }
             
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
                task?.resume()
            }
        }
}
