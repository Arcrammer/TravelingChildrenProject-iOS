//  TCPNavigatorController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/30/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPNavigatorController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet var menuTable: UITableView!
  @IBOutlet var iconLabel: UILabel!
  
  // MARK: - Properties
  let menuLabels = [
    "Passport Profile",
    "Reading Log",
//    "Downloads",
//    "Travel Tokens",
    "Sign Out"
  ]

  // MARK: - Methods
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let navigatorCell = tableView.dequeueReusableCell(withIdentifier: "navigatorCell")!
    navigatorCell.textLabel!.text = self.menuLabels[indexPath.row].uppercased()
    navigatorCell.textLabel!.textColor = UIColor.white
    navigatorCell.textLabel!.font = UIFont(name: "ProximaSansBold", size: 20)
    navigatorCell.selectedBackgroundView = UIView()
    navigatorCell.selectedBackgroundView!.backgroundColor = UIColor.TCPLightBrown
    navigatorCell.layoutMargins = UIEdgeInsets.zero
    
    // Custom (thicker) separators
    let separatorWidth: CGFloat = 2
    let separator = UIView(frame: CGRect(
      x: 0,
      y: navigatorCell.frame.size.height - separatorWidth,
      width: navigatorCell.frame.size.width,
      height: separatorWidth)
    )
    separator.backgroundColor = UIColor.TCPLightBrown
    separator.leadingAnchor.constraint(equalTo: navigatorCell.leadingAnchor)
    separator.trailingAnchor.constraint(equalTo: navigatorCell.trailingAnchor)
    separator.bottomAnchor.constraint(equalTo: navigatorCell.bottomAnchor)
    navigatorCell.addSubview(separator)
    
    return navigatorCell
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!
    self.iconLabel.text = "\u{f141}"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuLabels.count
  }
  
  // MARK: - UITableViewDelegate Methods
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCell = tableView.cellForRow(at: indexPath)
    
    // Deselect the row
    tableView.deselectRow(at: indexPath, animated: false)
    
    switch selectedCell!.textLabel!.text! {
    case "PASSPORT PROFILE":
      performSegue(withIdentifier: "passportProfileSegue", sender: self)
    
    case "READING LOG":
      performSegue(withIdentifier: "readingLogSegue", sender: self)
      
    case "SIGN OUT":
      // Deauth the user
      TCPAuthenticationController.logOut()
      
      // Send the user to the auth view
      let authenticationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAuthenticationView")
      authenticationView.modalTransitionStyle = .crossDissolve
      present(authenticationView, animated: true, completion: nil)

    default:
      break
    }
  }
}
