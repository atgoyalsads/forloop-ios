//
//  ChatViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var messageTextview: UITextView!
    @IBOutlet weak var clipButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var navView: UIView!
    var tableSectionHeader: MessageHeaderView!
    let messages = ["Be yourself; everyone else is already taken","So many books, so little time","Two things are infinite: the universe and human stupidity; and I'm not sure about the universe","Be who you are and say what you feel, because those who mind don't matter, and those who matter don't mind","You've gotta dance like there's nobody watching,Love like you'll never be hurt, Sing like there's nobody listening, And live like it's heaven on earth","You know you're in love when you can't fall asleep because reality is finally better than your dreams","You only live once, but if you do it right, once is enough","not now","yes"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.navView.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
        CommonClass.makeViewCircularWithRespectToHeight(self.userImage, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.activeView, borderColor: .clear, borderWidth: 0)
    }
    
    func registerCells() {
        let textIncomingTableViewCellNib = UINib(nibName: "TextIncomingTableViewCell", bundle: nil)
        tableview.register(textIncomingTableViewCellNib, forCellReuseIdentifier: "TextIncomingTableViewCell")
        let textOutgoingTableViewCellNib = UINib(nibName: "TextOutgoingTableViewCell", bundle: nil)
        tableview.register(textOutgoingTableViewCellNib, forCellReuseIdentifier: "TextOutgoingTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        
    }
    
    @IBAction func clipTapped(_ sender: Any) {
        
    }
    
    @IBAction func optionTapped(_ sender: Any) {
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextOutgoingTableViewCell", for: indexPath) as! TextOutgoingTableViewCell
            cell.messageLabel.text = messages[indexPath.row]
            cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
            cell.backView.clipsToBounds = true
            cell.backView.layer.cornerRadius = 19
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextIncomingTableViewCell", for: indexPath) as! TextIncomingTableViewCell
            cell.message.text = messages[indexPath.row]
            cell.backView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
            cell.backView.clipsToBounds = true
            cell.backView.layer.cornerRadius = 19
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderNib = Bundle.main.loadNibNamed("MessageHeaderView", owner: nil, options: nil)
        self.tableSectionHeader = tableHeaderNib?[0] as? MessageHeaderView
        let height = CGFloat(40)
        var frame = tableSectionHeader.frame
        frame.size.width = self.view.frame.size.width
        frame.size.height = height
        tableSectionHeader.frame = frame
        self.tableSectionHeader.dateLabel.text = "Just now"
        return tableSectionHeader
    }
    
}
