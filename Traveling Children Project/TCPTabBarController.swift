//  TCPTabBarController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/23/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Make the tab bar taller (not sure if this still works 6/12)
//    print("self.tabBar.frame.size.height:", self.tabBar.frame.size.height)
//    self.tabBar.frame.size.height -= 23
//    self.tabBar.frame.origin.y = self.view.frame.size.height - 60
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
