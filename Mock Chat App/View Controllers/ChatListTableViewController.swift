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
    var array_FilteredChatList = [ChatListModel]()
    var listNumber = 200
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat List"
        self.generateData()
        self.createIdIfNeeded()
        self.setupSeachBar()
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
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return self.array_FilteredChatList.count
        }
        return self.array_ChatList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var lastMessage = self.array_ChatList[indexPath.row].messages.last?.messageText ?? ""
        var date = self.array_ChatList[indexPath.row].date ?? Date()
        var username = self.array_ChatList[indexPath.row].userName
        
        if searchController.isActive == true && searchController.searchBar.text != "" {
            lastMessage = self.array_FilteredChatList[indexPath.row].messages.last?.messageText ?? ""
            date = self.array_FilteredChatList[indexPath.row].date ?? Date()
            username = self.array_FilteredChatList[indexPath.row].userName
        }
        
        (cell.viewWithTag(2) as? UILabel)?.text = username.capitalizingFirstLetter()
        
        if lastMessage != "" {
            (cell.viewWithTag(3) as? UILabel)?.isHidden = false
            (cell.viewWithTag(4) as? UILabel)?.isHidden = false
            (cell.viewWithTag(3) as? UILabel)?.text = "\(lastMessage)"
            (cell.viewWithTag(1) as? UIImageView)?.image = UIImage.init(named: "user-lastMessage")
            let dateString = Utils.fetchFormatedDateString(date: date)
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
        
        var list = [ChatListModel]()
        list = self.array_ChatList
        
        if searchController.isActive == true && searchController.searchBar.text != "" {
            list = self.array_FilteredChatList
        }
        
        let chatVC = storyboard?.instantiateViewController(identifier: "ChatViewController") as? ChatViewController
        chatVC?.title = list[indexPath.row].userName.capitalizingFirstLetter()
        chatVC?.chatListModel = list[indexPath.row]
        
        self.searchController.dismiss(animated: false, completion: nil)
        self.searchController.searchBar.text = nil
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(chatVC!, animated: true)
    }
}

extension ChatListTableViewController: UISearchBarDelegate {
    func setupSeachBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.text = nil
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchController.searchBar.text
        self.array_FilteredChatList = self.array_ChatList.filter({ (item) -> Bool in
            let value: NSString = item.userName as NSString
            return (value.range(of: searchString!, options: .caseInsensitive).location != NSNotFound)
        })
        self.tableView.reloadData()
    }
}
