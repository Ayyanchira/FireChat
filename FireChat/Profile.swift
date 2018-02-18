//
//  Profile.swift
//  FireChat
//
//  Created by Akshay Ayyanchira on 2/18/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation

class Profile: NSObject {
    var name: String
    var email: String
    var uuid:String
    
    init(name:String, email:String, uuid:String) {
        self.name = name
        self.email = email
        self.uuid = uuid
    }
}
