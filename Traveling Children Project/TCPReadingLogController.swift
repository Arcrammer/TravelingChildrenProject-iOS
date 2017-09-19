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
      for traveler in travelers {
        if traveler["currently_reading"] != nil {
          self.travelers.append(traveler)
        }
      }
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
    
    if let currentBook = traveler["currently_reading"] as? [String: Any] {
      // Book title
      if let travelerBookTitleField = cell.viewWithTag(2) as? UILabel,
         let currentBookTitle = currentBook["title"] as? String {
        travelerBookTitleField.text = currentBookTitle
      }
      
      // Author name
      if let travelerBookAuthorField = cell.viewWithTag(3) as? UILabel,
         let currentBookAuthorName = currentBook["author"] as? String {
        travelerBookAuthorField.text = currentBookAuthorName
      }
      
      // Date
      if let travelerBookDateField = cell.viewWithTag(4) as? UILabel,
         var currentBookDate = currentBook["began_reading"] as? String {
        
        // Remove the milliseconds since 'ISO8601DateFormatter' doesn't support those
        currentBookDate = currentBookDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        
        // Try to make a 'Date' out of the ISO 8601 string
        if let formattedDate = ISO8601DateFormatter().date(from: currentBookDate) {
          // Set a format for the date
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"

          // Set the label
          travelerBookDateField.text = dateFormatter.string(from: formattedDate)
        }
      }
      
      // Minutes
      if let travelerBookMinutes = cell.viewWithTag(5) as? UILabel,
         let currentBookMinutes = currentBook["minutes"] as? NSNumber {
        travelerBookMinutes.text = currentBookMinutes.stringValue
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.travelers.count
  }
}
