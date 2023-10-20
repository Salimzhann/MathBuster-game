//
//  WelcomePageViewController.swift
//  MathBuster
//
//  Created by Manas Salimzhan on 19.10.2023.
//

import UIKit

class WelcomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBOutlet weak var UserLabels: UILabel!
    func getUserScore () {
        guard let userDef = UserDefaults.standard.array(forKey: ViewController().userScoreKey ) else {
            return
        }
        
        guard let getUserScoreInDictionary = userDef as? [[String: Any]] else{
            return
        }
        
        var text: String = ""
        getUserScoreInDictionary.forEach{ dictionary in
            let name = dictionary["name"] as! String
            let score = dictionary["score"] as! Int
            
            text += "Name: \(name) , score: \(score)\n"
        }
        UserLabels.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserScore()
    }
}
