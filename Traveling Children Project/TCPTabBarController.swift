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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    // Change the bar colors by the selected view
    switch item.tag {
      case 3:
        // Compose Journey
        self.tabBar.barTintColor = UIColor.TCPBrown
        self.tabBar.tintColor = UIColor.TCPOrange
        break

      case 5:
        // Navigator
        self.tabBar.barTintColor = UIColor.TCPOrange
        self.tabBar.tintColor = UIColor.TCPYellow
        break
      
      default:
        // Everything else
        self.tabBar.barTintColor = UIColor.TCPBrown
        self.tabBar.tintColor = UIColor.TCPYellow
        break
    }
  }
}
