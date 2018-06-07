//  TCPAuthenticationController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/30/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit
import Alamofire

class TCPAuthenticationController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet var signInForm: UIView!
  @IBOutlet var signUpForm: UIScrollView!
  @IBOutlet var signUpView: UIView!
  @IBOutlet var signUpViewBottom: NSLayoutConstraint!
  @IBOutlet var firstFormField: UITextField!
  
  // Sign-in Fields
  @IBOutlet var signInEmailField: UITextField!
  @IBOutlet var signInPasswordField: UITextField!
  
  // Sign-up Fields
  @IBOutlet var signUpFirstNameField: UITextField!
  @IBOutlet var signUpLastNameField: UITextField!
  @IBOutlet var signUpTravelerFirstNameField: UITextField!
  @IBOutlet var signUpParentEmailField: UITextField!
  @IBOutlet var signUpParentPINCodeField: UITextField!
  @IBOutlet var signUpPasswordField: UITextField!
  @IBOutlet var signUpPasswordConfirmationField: UITextField!
  
  // MARK: - Actions
  @IBAction func revealSignUpForm() {
    self.signInForm.isHidden = true
    self.signUpForm.isHidden = false
  }

  @IBAction func revealSignInForm() {
    self.signUpForm.isHidden = true
    self.signInForm.isHidden = false
  }

  @IBAction func signIn() {
    // Make sure we have an email address
    // and password to give the server
    guard
      let emailAddress = self.signInEmailField.text,
      self.signInEmailField.text?.isEmpty == false,
      
      let password = self.signInPasswordField.text,
      self.signInPasswordField.text?.isEmpty == false
    else {
      // Tell the user they missed a field
      var missingCredentialsMessage: String?
      if self.signInEmailField.text?.isEmpty == true {
        missingCredentialsMessage = "Please provide an email address"
      }
      
      if self.signInPasswordField.text?.isEmpty == true {
        missingCredentialsMessage = "Please provide a password"
      }
      
      if self.signInEmailField.text?.isEmpty == true && self.signInPasswordField.text?.isEmpty == true {
        missingCredentialsMessage = "Please provide an email address and a password"
      }
      
      let missingCredentialsAlert = UIAlertController(title: "Missing Credentials", message: missingCredentialsMessage, preferredStyle: .actionSheet)
      missingCredentialsAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
      present(missingCredentialsAlert, animated: true, completion: nil)
      
      return
    }
    
    // Send the data to the server for validation
    Alamofire.request(
      "http://" + kServerDomain + "/auth/signin",
      method: .post,
      parameters: [
        "username": emailAddress,
        "password": password
      ]
    ).responseJSON {
      responseData in
      
      guard let statusCode = responseData.response?.statusCode else {
        let connectionIssueAlert = UIAlertController(title: "Connection Problem", message: "There was a problem getting a response from the server. Please make sure you're connected to the Internet.", preferredStyle: .actionSheet)
        connectionIssueAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(connectionIssueAlert, animated: true, completion: nil)
        
        return
      }
      
      // If the credentials matched save the traveler to the user defaults and send them to the tab bar view
      if statusCode == 200 {
        // Save the user object to the user defaults
        do {
          var userDictionary = try JSONSerialization.jsonObject(with: responseData.data!, options: []) as! [String: [String: Any]]
          
          print("userDictionary:")
          print(userDictionary)
          
          // Save the portrait Data if we find a photo for the account owner on the server
          var ownerPortrait: Data?
          if let portraitFilename = userDictionary["user"]!["photo"] as? String {
            do {
              ownerPortrait = try Data(contentsOf: URL(string: "http://" + kServerDomain + "/images/profile-images/" + portraitFilename)!, options: [])
              userDictionary["user"]!["travelerPortrait"] = ownerPortrait
            } catch let prob {
              // Log the error
              print(prob.localizedDescription)
            }
          }
          
          // Also grab all the traveler portraits
          if let travelers = userDictionary["user"]!["travelers"] as? Array<Dictionary<String, Any>> {
            for var traveler in travelers {
              do {
                if let travelerPortraitFilename = traveler["photo"] as? String {
                  traveler["portrait"] = try Data(contentsOf: URL(string: "http://" + kServerDomain + "/images/traveler-images/" + travelerPortraitFilename)!, options: [])
                }
              } catch let prob {
                // Log the error
                print(prob.localizedDescription)
                
                // Don't block the user from getting in
                continue
              }
            }
          }
          
          // Persist the defaults we grabbed from the server
          UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: userDictionary["user"]!), forKey: "Traveler")
          
          // Send the user to the tab bar view
          let mainTabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarView")
          mainTabBarViewController.modalTransitionStyle = .crossDissolve
          self.present(mainTabBarViewController, animated: true, completion: nil)
        } catch let err as NSError {
          print("Something happened parsing the user JSON from the server")
          print(err.localizedDescription)
        }
      } else if statusCode == 401 {
        // The credentials were wrong
        let wrongCredentialsAlert = UIAlertController(title: "Wrong Credentials", message: "Those credentials didn't work.", preferredStyle: .actionSheet)
        wrongCredentialsAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(wrongCredentialsAlert, animated: true, completion: nil)
      }
    }
  }

  @IBAction func signUp() {
    // Make sure we have an email address
    // and password to give the server
    guard
      let parentFirstName = self.signUpFirstNameField.text,
      self.signUpFirstNameField.text?.isEmpty == false,
      
      let parentLastName = self.signUpLastNameField.text,
      self.signUpLastNameField.text?.isEmpty == false,

      let travelerFirstName = self.signUpTravelerFirstNameField.text,
      self.signUpTravelerFirstNameField.text?.isEmpty == false,

      let parentEmail = self.signUpParentEmailField.text,
      self.signUpParentEmailField.text?.isEmpty == false,
    
      let parentPINCode = self.signUpParentPINCodeField.text,
      self.signUpParentPINCodeField.text?.isEmpty == false,
    
      let password = self.signUpPasswordField.text,
      self.signUpPasswordField.text?.isEmpty == false,

      let passwordConfirmation = self.signUpPasswordConfirmationField.text,
      self.signUpPasswordConfirmationField.text?.isEmpty == false
    else {
        let missingDataAlert = UIAlertController(title: "Missing Data", message: "Looks like there's something missing.", preferredStyle: .actionSheet)
        missingDataAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(missingDataAlert, animated: true, completion: nil)
      
        return
    }
    
    // Make sure the passwords match
    if password != passwordConfirmation {
      // Tell the user
      let passwordMismatchAlert = UIAlertController(title: "Mismatched Passwords", message: "Those passwords don't match.", preferredStyle: .actionSheet)
      passwordMismatchAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
      present(passwordMismatchAlert, animated: true, completion: nil)
      
      // Focus on the first password field
      self.signUpPasswordField.becomeFirstResponder()
    }
    
    // Send the data to the server for validation
    Alamofire.request(
      "http://" + kServerDomain + "/auth/signup",
      method: .post,
      parameters: [
        "first_name": parentFirstName,
        "last_name": parentLastName,
        "traveler_name": travelerFirstName,
        "pin_code": parentPINCode,
        "username": parentEmail,
        "password": password,
        "confirm_password": passwordConfirmation
      ]
    ).responseJSON {
      responseData in

      guard let statusCode = responseData.response?.statusCode else {
        let connectionIssueAlert = UIAlertController(title: "Connection Problem", message: "There was a problem getting a response from the server. Please make sure you're connected to the Internet.", preferredStyle: .actionSheet)
        connectionIssueAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(connectionIssueAlert, animated: true, completion: nil)
        
        return
      }
      
      if statusCode == 200 {
        // Save the user object to the user defaults
        do {
          let userDictionary = try JSONSerialization.jsonObject(with: responseData.data!, options: []) as! [String: [String: AnyObject]]
          
          UserDefaults.standard.set([
            "first_name": userDictionary["user"]!["first_name"] as Any,
            "last_name": userDictionary["user"]!["last_name"] as Any,
            "email": userDictionary["user"]!["email"] as Any,
            "password": userDictionary["user"]!["password"] as Any,
            "gender": userDictionary["user"]!["parent_gender"] as Any,
            "phone": userDictionary["user"]!["address"]!["phone"] as Any,
            "address_street": userDictionary["user"]!["address"]!["street"] as Any,
            "address_city": userDictionary["user"]!["address"]!["city"] as Any,
            "address_state": userDictionary["user"]!["address"]!["state"] as Any,
            "address_ZIP": userDictionary["user"]!["address"]!["zip"] as Any
          ], forKey: "Traveler")
          
          // Send the user to the tab bar view
          let mainTabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarView")
          mainTabBarViewController.modalTransitionStyle = .crossDissolve
          self.present(mainTabBarViewController, animated: true, completion: nil)
        } catch {
          print("Something happened parsing the user JSON from the server")
        }
      } else if statusCode == 409 {
        let unavailableUsernameAlert = UIAlertController(title: "Email Already in Use", message: "That email address is already associated with an account. Please use a different one or sign in.", preferredStyle: .actionSheet)
        unavailableUsernameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(unavailableUsernameAlert, animated: true, completion: nil)
      } else if statusCode == 500 {
        let unknownErrorAlert = UIAlertController(title: "Something Broke", message: "The server is a little confused at the moment. 🤔", preferredStyle: .actionSheet)
        unknownErrorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(unknownErrorAlert, animated: true, completion: nil)
      }
    }
  }
    
  // MARK: - Methods
  override func viewWillAppear(_ animated: Bool) {
    // Give the form view rounded corners
    self.signInForm.layer.cornerRadius = 10
    self.signUpView.layer.cornerRadius = 10
    
    // Give the launch animation a chance to finish then show
    // the keyboard if this is the root view controller
    if UIApplication.shared.keyWindow!.rootViewController! == self {
      if let firstFormField = self.firstFormField {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
          firstFormField.becomeFirstResponder()
        })
      }
    } else {
      // Select the first field without delay
      self.firstFormField.becomeFirstResponder()
    }
    
    // Watch the keyboard so we can adjust the bottom position of the scroll view when it shows and hides
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
      // Sign the user in if they're already authenticated
      if UserDefaults.standard.object(forKey: "Traveler") != nil {
        // Send the user to the tab bar view
        let mainTabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBarView")
        mainTabBarViewController.modalTransitionStyle = .crossDissolve
        self.present(mainTabBarViewController, animated: true, completion: nil)
      }
    })
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  @objc func keyboardDidShow(notification: NSNotification) {
    // Make sure we have the keyboard frame and the bottom scroll view constraint
    guard
      let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let signUpViewBottom = self.signUpViewBottom
    else {
      return
    }
    
    // Move the bottom of the scroll view to the top
    // of the keyboard now that we know its' height
    signUpViewBottom.constant = keyboardFrame.size.height
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    // Remove the extra space we added earlier when the keyboard is dismissed
    guard let signUpViewBottom = self.signUpViewBottom else {
      return
    }
    
    // Move the scroll view back to the bottom
    signUpViewBottom.constant = 0
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    return false
  }
  
  // MARK: - Class Methods
  class func logOut() {
    // Forget the user
    UserDefaults.standard.removeObject(forKey: "Traveler")
  }
  
  // MARK: - UIGestureRecognizerDelegate Methods
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // Dismiss the keyboard if you tap the 'Sign Up' scroll view
    if touch.view! == self.signUpForm || touch.view! == self.signUpView {
      self.view.endEditing(true)
    }

    return true
  }
  
  // MARK: - UITextFieldDelegate Methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Either move to the next tagged field or dismiss the keyboard
    if let nextField = textField.superview!.viewWithTag(textField.tag + 1) {
      nextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.tag == 4 && range.location >= 4 {
      return false
    } else {
      return true
    }
  }
}
