//  TCPPassportController.swift
//  
//
//  Created by Alexander Rhett Crammer on 9/14/17.
//
//
import UIKit
import Alamofire

class TCPPassportProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets
  @IBOutlet weak var iconLabel: UILabel!
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
  @IBOutlet weak var travelersTableView: UITableView!
  @IBOutlet weak var travelersView: UIView!
  
  // MARK: - Actions
  @IBAction func persistPassportChanges(_ sender: Any) {
    // Make sure we have an email address
    // and password to give the server
    guard
      let firstNameField = self.ownerFirstNameField.text,
      let lastNameField = self.ownerLastNameField.text,
      let emailField = self.ownerEmailField.text,
      let gender = self.ownerGender.text,
      let phoneNumber = self.ownerPhoneNumber.text,
      let birthdayField = self.ownerBirthdayField.text,
      let addressStreetField = self.ownerAddressStreetField.text,
      let addressCityField = self.ownerAddressCityField.text,
      let addressStateField = self.ownerAddressStateField.text,
      let addressZIPField = self.ownerAddressZIPField.text
    else {
      return
    }
    
    let userData = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "Traveler") as! Data) as! [String: AnyObject]
    
    Alamofire.request(
      "http://" + kServerDomain + "/passport/update",
      method: .post,
      parameters: [
        "_id": userData["_id"]!,
        "first_name": firstNameField,
        "last_name": lastNameField,
        "email": emailField,
        // "gender": gender,
        "address_tel": phoneNumber,
        "parent_birthday": birthdayField,
        "address_street": addressStreetField,
        "address_city": addressCityField,
        "address_state": addressStateField,
        "address_zip": addressZIPField
      ]
      ).responseJSON {
        responseData in
        
    }
  }
  
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
  
  // MARK: - Properties
  var travelers: Array<Dictionary<String, Any>> = []
  var travelerCount = 0
  
  // MARK: - Methods
  override func viewDidLoad() {
    // Set the icon label
    self.iconLabel.font = UIFont(name: "FontAwesome", size: 20)!
    self.iconLabel.text = "\u{f02d}"
    
    // Grab the user data from UserDefaults
    let userData = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "Traveler") as! Data) as! [String: AnyObject]

    // Make spiffy
    self.formContainer.layer.cornerRadius = 10
    self.formContainer.layer.masksToBounds = true
    
    // Round the edges of the owner portrait
    self.ownerPortrait.layer.cornerRadius = self.ownerPortrait.bounds.size.width / 2
    self.ownerPortrait.layer.masksToBounds = true

    // Set the owner portrait
    if let ownerPortrait = userData["travelerPortrait"] as? Data {
      self.ownerPortrait.image = UIImage(data: ownerPortrait)!
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
    
    // Remove 'Travelers' list item separators
    self.travelersTableView.separatorStyle = .none
    
    // Travelers
    if let travelers = userData["travelers"] as? Array<Dictionary<String, Any>> {
      // Hide the list of travelers if there aren't any travelers
      if travelers.count == 0 {
        self.travelersView.isHidden = true
      } else {
        // Save the travelers for use elsewhere
        self.travelers = travelers as! Array<Dictionary<String, String>>
        self.travelerCount = travelers.count
      }
    }
  }
  
  // MARK: - UITableViewDataSource Methods
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "travelerCell")!
    
    if let travelerPortraitView = cell.viewWithTag(1) as? UIImageView {
      // Cut the traveler portrait to a circle
      travelerPortraitView.layer.cornerRadius = travelerPortraitView.bounds.size.width / 2
      travelerPortraitView.layer.masksToBounds = true
      
      // Traveler portrait
      if let travelerPortrait = self.travelers[indexPath.row]["portrait"] as? Data {
        // Set the travelers' portrait
        travelerPortraitView.image = UIImage(data: travelerPortrait)!
      }
    }
    
    // Traveler name
    if let travelerName = self.travelers[indexPath.row]["name"] as? String,
       let travelerNameField = cell.viewWithTag(2) as? UITextField {
      travelerNameField.text = travelerName
    }

    // Traveler birthday
    if let travelerBirthday = self.travelers[indexPath.row]["birthday"] as? String,
       let travelerBirthdayField = cell.viewWithTag(3) as? UITextField {
      travelerBirthdayField.text = travelerBirthday
    }

    // Traveler gender
    if let travelerGender = self.travelers[indexPath.row]["gender"] as? String,
       let travelerGenderField = cell.viewWithTag(4) as? UITextField {
      switch travelerGender {
      case "Male":
        travelerGenderField.text = "M"
      case "Female":
        travelerGenderField.text = "F"
      default:
        travelerGenderField.text = "U"
      }
    }

    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.travelerCount
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}
