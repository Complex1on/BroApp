//
//  ChatViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/3/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    var convoID: String? {
        didSet{
            print("convo Id set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        messageTextfield.isUserInteractionEnabled = false
        loadMessages()
    }
    //MARK: - Load Messages from db
    func loadMessages() {
        
        db.collection("All Messages").document(convoID ?? "").collection("Messages")
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                if let e = error {
                    print("there was an issue retrieving data from FireStore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                                
                            }
                            
                        }
                    }
                }
        }
    }
    
    //MARK: - Bottom Section Buttons
    @IBAction func leftBroButtonPushed(_ sender: UIButton) {
        messageTextfield!.text! += "Bro! "
    }
    
    @IBAction func middleBroButtonPushed(_ sender: UIButton) {
        messageTextfield!.text! += "Bro "
    }
    @IBAction func rightBroButtonPushed(_ sender: UIButton) {
        messageTextfield!.text! += "Broooo "
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text{
            if messageBody != ""{
                if let messageSender = Auth.auth().currentUser?.uid{
                    db.collection("All Messages").document(convoID ?? "").collection("Messages").addDocument(data: [K.FStore.senderField: messageSender,
                                                                              K.FStore.bodyField: messageBody,
                                                                              K.FStore.dateField: Date().timeIntervalSince1970
                        ]) { (error) in
                        if let e = error {
                            print("There was an issue saving data to firestore, \(e)")
                        } else {
                            self.messageTextfield.text = ""
                            print("successfually saved data")
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
          
    }
    
}

//MARK: - tableview controller data source methods
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body

        //message from current user
        if message.sender == Auth.auth().currentUser?.uid {

            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else {

            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
    
}
