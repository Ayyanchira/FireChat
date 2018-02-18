//
//  ContactsViewController.swift
//  FireChat
//
//  Created by Akshay Ayyanchira on 2/18/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ContactsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var delegate:HomeViewController?
    
    @IBOutlet weak var contactsTable: UITableView!
    var contacts:[Profile] = []
    
    let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
    let rootref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOtherUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchOtherUsers() {
        let userRef = self.rootref.child("Users")
        userRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.contacts.removeAll()
                for value in values{
                    print(value)
                    if value.key as! String != self.uuid{
                        let userDetails = value.value as? [String:String]
                        if let username = userDetails!["name"],
                        let email = userDetails!["email"],
                            let contactUUID = value.key as? String{
                            let user = Profile(name: username, email: email, uuid:contactUUID)
                            self.contacts.append(user)
                        }
                    }
                }
                self.contactsTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedPerson = contacts[indexPath.row]
        var cell = UITableViewCell()
        cell.textLabel?.text = selectedPerson.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = contacts[indexPath.row]
        
        // if chat entry exists, open chat window
        let chatRef = self.rootref.child("Chats")
        chatRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                var matchFound = false
                for chat in values{
                    if (chat.key as? String == String(self.uuid+selectedPerson.uuid)) || (chat.key as? String == String(selectedPerson.uuid+self.uuid)){
                        matchFound = true
                        print("Open existing chat")
                        self.delegate?.openChatWindow(chatKey: chat.key as! String)
                        //self.dismiss(animated: true, completion: nil)
                       // return
                    }
                }
                
                //if no match is found, create a new chat entry in database
                if(!matchFound){
                    let chatEntryKey = String(self.uuid + selectedPerson.uuid)
                    let entry = [chatEntryKey : "There you go! Start flaming... It's realtime!!!"]
                    chatRef.setValue(entry)
                    self.delegate?.openChatWindow(chatKey: chatEntryKey)
//                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
    }

}
