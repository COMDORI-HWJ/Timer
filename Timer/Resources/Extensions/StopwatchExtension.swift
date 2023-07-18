//
//  Stopwatch extension.swift
//  Timer
//
//  Created by Wonji Ha on 2022/07/12.
//

/* Reference
  https://babbab2.tistory.com/124 extension(확장)이란?
 */

import Foundation
import UIKit

extension Stopwatch: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let Lapnum = cell.viewWithTag(1) as? UILabel {
            Lapnum.text = " \( recordList.count - (indexPath as NSIndexPath).row)"
        }
        
        if let TimeLabel = cell.viewWithTag(2) as? UILabel {
            TimeLabel.text = recordList[recordList.count - (indexPath as NSIndexPath).row - 1]
        }
        
        //        print("기록횟수:",recordList.count)
        return cell
    }
}
