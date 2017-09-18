//  TCPPassportController.swift
//  
//
//  Created by Alexander Rhett Crammer on 9/14/17.
//
//
import UIKit

class TCPPassportProfileController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var formContainer: UIView!
  @IBOutlet weak var ownerPortrait: UIImageView!
  @IBOutlet weak var ownerFirstNameField: UITextField!
  @IBOutlet weak var ownerLastNameField: UITextField!
  @IBOutlet weak var ownerEmailField: UITextField!
  @IBOutlet weak var ownerGender: UITextField!
  @IBOutlet weak var ownerPhoneNumber: UITextField!
  @IBOutlet weak var ownerBirthdayField: UITextField!
  @IBOutlet weak var ownerAddressStreetField: UITextField!
  @IBOutlet weak var ownerAddressCityField: UITextField!
  @IBOutlet weak var ownerAddressStateField: UITextField!
  @IBOutlet weak var ownerAddressZIPField: UITextField!
  
  // MARK: - Actions
  @IBAction func dismissPassportProfile(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func logOut(_ sender: Any) {
    // Deauth the user
    TCPAuthenticationController.logOut()
    
    // Send the user to the auth view
    let authenticationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAuthenticationView")
    authenticationView.modalTransitionStyle = .crossDissolve
    present(authenticationView, animated: true, completion: nil)
  }
  
  // MARK: - Methods
  override func viewDidLoad() {
    // Grab the user data from UserDefaults
    let userData = UserDefaults.standard.object(forKey: "Traveler") as! Dictionary<String, AnyObject>

    // Make spiffy
    self.formContainer.layer.cornerRadius = 10
    self.formContainer.layer.masksToBounds = true
    
    // Set the owner portrait
    if let ownerPortrait = userData["travelerPortrait"] as? Data {
      self.ownerPortrait.image = UIImage(data: ownerPortrait)!
      
      // Round the edges
      self.ownerPortrait.layer.cornerRadius = self.ownerPortrait.bounds.size.width / 2
      self.ownerPortrait.layer.masksToBounds = true
    }
    
    // Set the owner data beginning with the first name
    if let ownerFirstName = userData["first_name"] as? String {
      self.ownerFirstNameField.text = ownerFirstName
    }

    // Last name
    if let ownerLastName = userData["last_name"] as? String {
      self.ownerLastNameField.text = ownerLastName
    }
    
    if let ownerEmailAddress = userData["email"] as? String {
      self.ownerEmailField.text = ownerEmailAddress
    }
    
    // Gender
    if let ownerGender = userData["gender"] as? String {
      switch ownerGender {
      case "1":
        self.ownerGender.text = "M"
      case "2":
        self.ownerGender.text = "F"
      case "3":
        self.ownerGender.text = "U"
      default:
        break
      }
    }
    
    // Birthday
    if var ownerBirthday = userData["birthday"] as? String {
      // Remove the milliseconds since 'ISO8601DateFormatter' doesn't support those
      ownerBirthday = ownerBirthday.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
      
      // Try to make a 'Date' out of the ISO 8601 string
      if let formattedDate = ISO8601DateFormatter().date(from: ownerBirthday) {
        // Set a format for the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        // Update the birthday field value
        self.ownerBirthdayField.text = dateFormatter.string(from: formattedDate)
      }
    }
    
    // Phone number
    if let ownerPhoneNumber = userData["phone"] as? String {
      self.ownerPhoneNumber.text = ownerPhoneNumber
    }
    
    // Street address
    if let ownerStreetAddress = userData["address_street"] as? String {
      self.ownerAddressStreetField.text = ownerStreetAddress
    }
    
    // City
    if let ownerCity = userData["address_city"] as? String {
      self.ownerAddressCityField.text = ownerCity
    }
    
    // State
    if let ownerState = userData["address_state"] as? String {
      self.ownerAddressStateField.text = ownerState
    }
    
    // ZIP
    if let ownerZIP = userData["address_ZIP"] as? String {
      self.ownerAddressZIPField.text = ownerZIP
    }
  }
}
