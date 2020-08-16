//
//  ChatListTableViewController.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import RealmSwift

class ChatListTableViewController: UITableViewController {
    
    var array_ChatList = [ChatListModel]()
    var listNumber = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat List"
        self.generateData()
        self.createIdIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sortData()
    }
    
    func createIdIfNeeded() {
        let myId = Utils.fetchUserDefault(key: MY_USER_ID)
        if myId == nil {
            Utils.saveUserDefault(inKey: MY_USER_ID, withValue: UUID.init().uuidString)
        }
    }
    
    func generateData() {
        
        var array_Names = [String]()
        self.array_ChatList = ChatListModel.currentList()
        let profilePic = UIImage.init(named: "user")
        profilePic?.withTintColor(.lightGray)
        if self.array_ChatList.isEmpty {
            while array_Names.count<listNumber {
                let name = DataGenerator.randomString()
                if !array_Names.contains(name) {
                    array_Names.append(name)
                    self.array_ChatList.append(ChatListModel.create(withUserName: name, profilePicture: profilePic?.pngData() ?? Data()))
                }
            }
            self.array_ChatList.saveInRealm()
        }
    }
    
    func sortData() {
        let realm = try! Realm()
        let sorted = realm.objects(ChatListModel.self).sorted(byKeyPath: "date", ascending: false)
        
        self.array_ChatList = Array(sorted)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_ChatList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let lastMessage = self.array_ChatList[indexPath.row].messages.last?.messageText ?? ""
        
        (cell.viewWithTag(2) as? UILabel)?.text = self.array_ChatList[indexPath.row].userName.capitalizingFirstLetter()
        
        if lastMessage != "" {
            (cell.viewWithTag(3) as? UILabel)?.isHidden = false
            (cell.viewWithTag(4) as? UILabel)?.isHidden = false
            (cell.viewWithTag(3) as? UILabel)?.text = "\(lastMessage)"
            (cell.viewWithTag(1) as? UIImageView)?.image = UIImage.init(named: "user-lastMessage")
            let dateString = Utils.fetchFormatedDateString(date: self.array_ChatList[indexPath.row].date ?? Date())
            (cell.viewWithTag(4) as? UILabel)?.text = dateString
        }else {
            (cell.viewWithTag(1) as? UIImageView)?.image = UIImage.init(named: "user")
            (cell.viewWithTag(1) as? UIImageView)?.tintColor = .lightGray
            (cell.viewWithTag(3) as? UILabel)?.isHidden = true
            (cell.viewWithTag(4) as? UILabel)?.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let chatVC = storyboard?.instantiateViewController(identifier: "ChatViewController") as? ChatViewController
        chatVC?.title = self.array_ChatList[indexPath.row].userName.capitalizingFirstLetter()
        chatVC?.chatListModel = self.array_ChatList[indexPath.row]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(chatVC!, animated: true)
    }
}
