//  TCPParentPINCodeViewController.swift
//  Traveling Children Project
//
//  Created by Alexander Rhett Crammer on 10/10/17.
//  Copyright © 2017 Traveling Children Project. All rights reserved.
//
import UIKit

protocol TCPParentPINCodeDelegate {
  func parentPINWasSuccessful()
}

class TCPParentPINCodeViewController: UIViewController, UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet weak var firstPasscodeField: UITextField!
  
  // MARK: - Actions
  @IBAction func dismiss(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func passcodeFieldValueChanged(_ sender: UITextField) {
    // Either send the user to the next field or verify their passcode
    if sender.text!.count == 1 {
      if let nextTextField = view.viewWithTag(sender.tag + 1) {
        // Send the user to the next passcode field
        nextTextField.becomeFirstResponder()
      } else {
        // Dismiss the keyboard because we're on the last passcode bullet
        sender.resignFirstResponder()
      }
    } else if sender.text!.count == 0, let previousTextField = view.viewWithTag(sender.tag - 1) {
      // Send the user to the previous passcode field
      previousTextField.becomeFirstResponder()
    }
  }

  @IBAction func submitPasscode() {
    guard self.delegate != nil else {
      return
    }
    
    // Tell the delgate the passcode was successful
    print("Pretending the parent PIN was successful")
    self.delegate!.parentPINWasSuccessful()
    
    // Dismiss the parent PIN view
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Properties
  var delegate: TCPParentPINCodeDelegate?
  
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    // Send the user to the first passcode field
    self.firstPasscodeField.becomeFirstResponder()
  }
  
  // MARK: - UITextFieldDelegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // If the user hit the back button, the current passcode field is
    // empty, and there's a previous passcode field send the user to it
    if strcmp(string.cString(using: String.Encoding.utf8)!, "\\b") == -92,
      textField.text! == "",
      let previousTextField = view.viewWithTag(textField.tag - 1) {
      previousTextField.becomeFirstResponder()
    }

    return true
  }
}
