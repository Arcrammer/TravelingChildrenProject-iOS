//  TCPNavigatorController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/30/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPNavigatorController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - IBOutlets
  @IBOutlet var menuTable: UITableView!
  
  // MARK: - Properties
  let menuLabels = [
    "Passport Profile",
    "Reading Log",
    "Downloads",
    "Travel Tokens",
    "Sign Out"
  ]
  
  // MARK: - Methods
  override func viewDidLoad() {
    // Remove extra cell separators
    self.menuTable.tableFooterView = UIView()
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let navigatorCell = tableView.dequeueReusableCell(withIdentifier: "navigatorCell")!
    navigatorCell.textLabel!.text = self.menuLabels[indexPath.row].uppercased()
    navigatorCell.textLabel!.textColor = UIColor.white
    navigatorCell.textLabel!.font = UIFont(name: "ProximaSansRegular", size: 20)
    navigatorCell.selectedBackgroundView = UIView()
    navigatorCell.selectedBackgroundView!.backgroundColor = UIColor(red: 95/255, green: 57/255, blue: 23/255, alpha: 1)
    
    return navigatorCell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuLabels.count
  }
}
