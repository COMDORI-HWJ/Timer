//
//  Setting.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//

import Foundation
import UIKit

class Setting: UIViewController { // UITableViewDataSource, UITableViewDelegate
    
    @IBOutlet weak var Table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Table.delegate = self
//        Table.dataSource = self
//        self.Table.backgroundColor = UIColor.systemBlue
//

    }
   
    let cell1: String = "cell"
    
    let a: [String] = ["1", "2"]
    let b = ["1번 입니다", "2번입니다", "hello"]

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return b.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = b[indexPath.row]
//        return cell
//        }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//           // 오른쪽에 만들기
//
//           let modity = UIContextualAction(style: .normal, title: "수정") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
//               print("수정 클릭 됨")
//               success(true)
//           }
//           modity.backgroundColor = .systemBlue
//
//        return UISwipeActionsConfiguration(actions: [modity])
//
//
//    }


    

}


    


