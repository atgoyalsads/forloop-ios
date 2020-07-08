//
//  ChatListViewController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    @IBOutlet weak var chatsLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        // Do any additional setup after loading the view.
    }
            
    func registerCells() {
        let chatListTableViewCellNib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        self.tableview.register(chatListTableViewCellNib, forCellReuseIdentifier: "ChatListTableViewCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//    }

}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = AppStoryboard.Dashboard.viewController(ChatViewController.self)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
