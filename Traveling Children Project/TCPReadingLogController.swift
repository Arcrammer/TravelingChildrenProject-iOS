//  TCPReadingLogController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 9/19/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPReadingLogController: UIViewController, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var monthlyReadingGoalLabelContainer: UIView!
  @IBOutlet weak var monthlyReadingGoalLabel: UILabel!
  
  // MARK: - Properties
  var travelers: Array<Dictionary<String, Any>> = []
  
  // MARK: - Actions
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Methods
  override func viewWillAppear(_ animated: Bool) {
    // Apply rounded corners to the container view
    self.containerView.layer.cornerRadius = 10
    self.containerView.layer.masksToBounds = true
    
    let userData = UserDefaults.standard.object(forKey: "Traveler") as! Dictionary<String, AnyObject>
    if let travelers = userData["travelers"] as? Array<Dictionary<String, Any>> {
      self.travelers = travelers
    }
  }
  
  override func viewDidLoad() {
    // Set the icon label
    self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!
    self.iconLabel.text = "\u{f036}"
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "readingLogCell")!
    let traveler = self.travelers[indexPath.row]
    
    // Traveler name
    if let travelerNameField = cell.viewWithTag(1) as? UILabel,
       let travelerName = traveler["name"] as? String {
      travelerNameField.text = travelerName
    }
    
    // Book title
    if let travelerBookTitleField = cell.viewWithTag(2) as? UILabel,
      let currentBookTitle = traveler["currentBookTitle"] as? String {
      travelerBookTitleField.text = currentBookTitle
    }

    // Author name
    if let travelerBookAuthorField = cell.viewWithTag(3) as? UILabel,
       let currentBookAuthorName = traveler["currentBookAuthorName"] as? String {
      travelerBookAuthorField.text = currentBookAuthorName
    }
 
    // Date
    if let travelerBookDateField = cell.viewWithTag(4) as? UILabel,
       let currentBookDate = traveler["currentBookDate"] as? String {
      travelerBookDateField.text = currentBookDate
    }
    
    // Minutes
    if let travelerBookMinutes = cell.viewWithTag(5) as? UILabel,
       let currentBookMinutes = traveler["currentBookMinutes"] as? String {
      travelerBookMinutes.text = currentBookMinutes
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.travelers.count
  }
}
