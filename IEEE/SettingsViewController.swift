//
//  SettingsViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 07/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func LogOutButton(_ sender: Any) {
        //Go to the LoginPageViewController if the login is sucessful
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController")
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "MyKey")
        defaults.synchronize()
        self.present(vc!, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
