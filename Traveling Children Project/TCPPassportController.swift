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
    // Make spiffy
    self.formContainer.layer.cornerRadius = 10
    self.formContainer.layer.masksToBounds = true
  }
}
