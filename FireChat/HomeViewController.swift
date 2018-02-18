//
//  HomeViewController.swift
//  FireChat
//
//  Created by Akshay Ayyanchira on 2/17/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol OpenChatWindowDirectly {
    func openChatWindow(chatKey:String)
}

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, OpenChatWindowDirectly {
    
    
    func openChatWindow(chatKey: String) {
        
        self.performSegue(withIdentifier: "openChat", sender: chatKey)
    }
    
    

    @IBOutlet weak var friendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //fetchChat
        
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "uuid")
        do {
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            print(signoutError.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddContact"{
            let contactsViewController = segue.destination as! ContactsViewController
            contactsViewController.delegate = self
        }else if segue.identifier == "openChat"{
            let chatKey = sender as? String
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.chatKey = chatKey
        }
    }
    
    
    // Pragma Mark - Table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
