//
//  Stopwatch extension.swift
//  Timer
//
//  Created by Wonji Ha on 2022/07/12.
//

/* Reference
 
  https://babbab2.tistory.com/124 extension(확장)이란?
  https://dev200ok.blogspot.com/2020/06/swift-30-projects-02-ios-stopwatch.html 스톱워치 예제
 
 */

import Foundation
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
//            TimeLabel.text = self.recordList[indexPath.row]
        }

        print("기록리스트:",recordList.count)
        return cell
        
       }
}
