//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Rhian Chavez on 6/26/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var TableView: UITableView!
    var messages: [PFObject] = []
    
    func onTimer() {
        // Add code to be run periodically
        let query = PFQuery(className: "Message_fbu2017")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground() {
            (post: [PFObject]!, error: Error?) -> Void in
            if error == nil{
                //print(post)
                self.messages = post
                self.TableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        TableView.delegate = self
        // Auto size row height based on cell autolayout constraints
        TableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        TableView.estimatedRowHeight = 50
        TableView.dataSource = self
        onTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitSend(_ sender: Any) {
        view.endEditing(true)
        let user = PFUser.current()
        let chatMessage = PFObject(className: "Message_fbu2017")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = user
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Message Send Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = TableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCellTableViewCell
        let object = self.messages[indexPath.row]
        let message = object["text"] as! String
        if let user = object["user"] as? PFUser{
            let username = user.username!
            cell.usernameLabel.text = username
        }
        cell.label.text = message
        return cell
    }

    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
