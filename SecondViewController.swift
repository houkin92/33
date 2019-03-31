//
//  SecondViewController.swift
//  userDefaults
//
//  Created by 方瑾 on 2019/3/27.
//  Copyright © 2019 方瑾. All rights reserved.
//

import UIKit
let host = "http://www.kinwork.jp:7775/LearnApi/"
var totalStudents:[StudentInfo] = []//JSOn是个字符串
var num = String()

class SecondViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    var session:URLSession?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        listTableView.delegate = self
        listTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allStudent()
    }
    func allStudent() {
        let strUrl = "\(host)getStudentList"
        if let url = URL(string: strUrl) {
            let task = session?.dataTask(with: url, completionHandler: {
                (data, reponse, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let realData = data {
                    do {
                        totalStudents = try JSONDecoder().decode([StudentInfo].self, from: realData)
                        DispatchQueue.main.async {
                            self.listTableView.reloadData()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            task?.resume()
        }
    }
    func singleStudent(studentNo:String) {
        let strUrl = "\(host)viewStudent"
        if let url = URL(string: strUrl) {
            let paraDict:[String:String] = ["s_no":studentNo]
            let list = NSMutableArray()//可变数组
            for (key,value) in paraDict {
                let str = "\(key)=\(value)"
                list.add(str)
            }
            let paraStr = list.componentsJoined(by: "&")//把数组的每个元素整到一起
            let postData = paraStr.data(using: String.Encoding.utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = session?.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                if let realData = data {
                    do {
                        let singleStudent = try JSONDecoder().decode(SingleStudent.self, from: realData)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "secondtothird", sender: singleStudent)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            task?.resume()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondtothird" {
            let nextPage = segue.destination as! ThirdViewController
            let dataForNext = sender as? SingleStudent //转类型，any-> SingleStudent
            nextPage.singleStudent = dataForNext
        }
    }
}//class func
extension SecondViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for:indexPath) as! ListTableViewCell
        cell.gradeLabel.text = totalStudents[indexPath.row].grade
        cell.name.text = totalStudents[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let studentNo = totalStudents[indexPath.row].s_no {
            singleStudent(studentNo: studentNo)
            num = studentNo
            tableView.reloadData()
        }
    }
}
