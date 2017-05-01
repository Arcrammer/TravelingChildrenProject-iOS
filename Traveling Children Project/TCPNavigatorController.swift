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
  override func viewWillAppear(_ animated: Bool) {
    // Make the tab bar orange
    self.tabBarController!.tabBar.barTintColor = UIColor.TCPOrange
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let navigatorCell = tableView.dequeueReusableCell(withIdentifier: "navigatorCell")!
    navigatorCell.textLabel!.text = self.menuLabels[indexPath.row].uppercased()
    navigatorCell.textLabel!.textColor = UIColor.white
    navigatorCell.textLabel!.font = UIFont(name: "ProximaSansSemibold", size: 20)
    navigatorCell.selectedBackgroundView = UIView()
    navigatorCell.selectedBackgroundView!.backgroundColor = UIColor.TCPLightBrown
    
    // Custom (thicker) separators
    let separatorWidth: CGFloat = 3
    let separator = UIView(frame: CGRect(
      x: 0,
      y: navigatorCell.frame.size.height - separatorWidth,
      width: navigatorCell.frame.size.width,
      height: separatorWidth)
    )
    separator.backgroundColor = UIColor.TCPLightBrown
    separator.leadingAnchor.constraint(equalTo: navigatorCell.leadingAnchor)
    separator.trailingAnchor.constraint(equalTo: navigatorCell.trailingAnchor)
    navigatorCell.addSubview(separator)
    
    return navigatorCell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuLabels.count
  }
  
  // MARK: - UITableViewDelegate Methods
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}
