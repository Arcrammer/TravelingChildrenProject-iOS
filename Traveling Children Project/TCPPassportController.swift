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
    let userData = UserDefaults.standard.object(forKey: "Traveler") as! Dictionary<String, Any>

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
    
    // Set the owner data
    if let ownerFirstName = userData["first_name"] as? String {
      self.ownerFirstNameField.text = ownerFirstName
    }

    if let ownerLastName = userData["last_name"] as? String {
      self.ownerLastNameField.text = ownerLastName
    }
  }
}
