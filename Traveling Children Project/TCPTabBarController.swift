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

    print("self.tabBar.frame.size.height:", self.tabBar.frame.size.height)
    self.tabBar.frame.size.height -= 23
    self.tabBar.frame.origin.y = self.view.frame.size.height - 60
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Remove tab bar titles
    for tab in tabBar.items! {
      tab.title = nil
      tab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
