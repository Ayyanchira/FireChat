//
//  ChatViewController.swift
//  FireChat
//
//  Created by Akshay Ayyanchira on 2/18/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var chatTextView: UITextView!
    var chatKey:String?
    let rootref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded...with parameter\(chatKey)")
        fetchText(chatKey: chatKey!)
        // Do any additional setup after loading the view.
    }

    func fetchText(chatKey:String) {
        print("To do ")
        let chatRef = self.rootref.child("Chats")
        chatRef.observe(DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                let message = values[chatKey]
                self.chatTextView.text = message as! String
            }
            
        }
        
        chatRef.observe(DataEventType.childChanged) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                let message = values[chatKey]
                self.chatTextView.text = message as! String
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.rootref.child("Chats").setValue([chatKey!:textView.text])
    }

}
