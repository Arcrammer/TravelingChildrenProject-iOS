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
  
  // MARK: - Actions
  @IBAction func dismissPassportProfile(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func logOut(_ sender: Any) {
    // Forget the user
    UserDefaults.standard.removeObject(forKey: "Traveler")
    
    // Send the user to the tab bar view
    let authenticationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAuthenticationView")
    authenticationViewController.modalTransitionStyle = .crossDissolve
    self.present(authenticationViewController, animated: true, completion: nil)
  }
  
  // MARK: - Methods
  override func viewDidLoad() {
    // Grab the user data from UserDefaults
    let userData = UserDefaults.standard.object(forKey: "Traveler") as! Dictionary<String, Any>

    // Make spiffy
    self.formContainer.layer.cornerRadius = 10
    self.formContainer.layer.masksToBounds = true
    
    // Set the portraits
    if let travelerPortrait = userData["travelerPortrait"] as? Data {
      self.ownerPortrait.image = UIImage(data: travelerPortrait)!
      
      // Round the edges
      self.ownerPortrait.layer.cornerRadius = self.ownerPortrait.bounds.size.width / 2
      self.ownerPortrait.layer.masksToBounds = true
    }
  }
}
