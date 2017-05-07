//  TCPAuthenticationController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 4/30/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

class TCPAuthenticationController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet var signInForm: UIView!
  @IBOutlet var signUpForm: UIScrollView!
  @IBOutlet var signUpView: UIView!
  @IBOutlet var signUpViewBottom: NSLayoutConstraint!
  @IBOutlet var firstFormField: UITextField!

  // MARK: - Actions
  @IBAction func revealSignUpForm() {
    self.signInForm.isHidden = true
    self.signUpForm.isHidden = false
  }

  @IBAction func revealSignInForm() {
    self.signUpForm.isHidden = true
    self.signInForm.isHidden = false
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func keyboardDidShow(notification: NSNotification) {
    // Make sure we have the keyboard frame and the bottom scroll view constraint
    guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
          let signUpViewBottom = self.signUpViewBottom else {
      return
    }
    
    // Move the bottom of the scroll view to the top
    // of the keyboard now that we know its' height
    signUpViewBottom.constant = keyboardFrame.size.height
  }
  
  func keyboardWillHide(notification: NSNotification) {
    // Remove the extra space we added earlier when the keyboard is dismissed
    guard let signUpViewBottom = self.signUpViewBottom else {
      return
    }
    
    // Move the scroll view back to the bottom
    signUpViewBottom.constant = 0
  }
  
  // MARK: - UIGestureRecognizerDelegate Methods
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // Dismiss the keyboard if you tap the 'Sign Up' scroll view
    if touch.view! == self.signUpForm {
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
