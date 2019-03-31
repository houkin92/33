//
//  StudentInfo.swift
//  userDefaults
//
//  Created by 方瑾 on 2019/3/27.
//  Copyright © 2019 方瑾. All rights reserved.
//

import Foundation
struct StudentInfo:Decodable {//通信拿来的数据，如果要用的，要遵守Decodable协议
    var s_no:String?
    var name:String?
    var grade:String?
}
