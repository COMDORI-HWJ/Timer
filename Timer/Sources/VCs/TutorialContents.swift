//
//  TutorialContents.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//

import UIKit

class TutorialContents: UIViewController {
    
    var titleText: String!
    var imageFile: String!
    var pageIndex: Int!
    
    var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel = UILabel()
//        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: imageFile)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func viewWillAppear(_ animated: Bool) {
//        titleLabel.text = titleText
//        print("현재 페이지: " , titleText!)
//        guard let img = UIImage(named: imageFile) else { return}
//        bgImageView.image = img
//        bgImageView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
//        view.addSubview(bgImageView)
//        titleLabel.frame = CGRect(x: view.frame.width/2, y: view.frame.height-100, width: 100, height: 30)
//        view.addSubview(titleLabel)
//    }

}
