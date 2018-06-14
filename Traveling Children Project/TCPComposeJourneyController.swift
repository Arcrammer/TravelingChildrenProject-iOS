//
//  TCPComposeJourneyController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 6/14/18.
//  Copyright © 2018 Traveling Children Project. All rights reserved.
//

import UIKit

class TCPComposeJourneyController: UIViewController {
  // MARK: - Outlets
  @IBOutlet var iconLabel: UILabel!
  
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    // Set the icon
    if (self.iconLabel != nil) {
      self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!
      
      // Item label
      self.iconLabel.text = "\u{f067}"
    }
    
    
  }
}
