/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormInfoCell.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      03/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormInfoCell class
class FormInfoCell: FormBaseCell {
    
    // MARK: Cell views
    /// UIImagePickerController
    let imagePicker = UIImagePickerController()
    
    /// UIButton change profile photo
    let photoBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.background
        
        return button
    }()
    
    /// UITextField first name
    let firstNameTextField: UITextField = {
        
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = NSLocalizedString("first_name", comment: "")
        text.tag = 0
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    /// UITextField last name
    let lastNameTextField: UITextField = {
        
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = NSLocalizedString("last_name", comment: "")
        text.tag = 1
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    /// setup initial configuration cell view
    func setupViews() {
        contentView.addSubview(photoBotton)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
    }
    
    // MARK: Constraints
    /// configure constraints
    func addConstraints() {
        photoBotton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        photoBotton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        photoBotton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        firstNameTextField.bottomAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: -4).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: photoBotton.rightAnchor, constant: 8).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        lastNameTextField.topAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: 4).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: photoBotton.rightAnchor, constant: 8).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        lastNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
    
    /// `override configure()`
    override func configure() {
        super.configure()
        
        setupViews()
        addConstraints()
        
        photoBotton.addTarget(self, action: #selector(FormInfoCell.loadPhoto(_:)), for: .touchUpInside)
        firstNameTextField.addTarget(self, action: #selector(FormInfoCell.editingChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(FormInfoCell.editingChanged(_:)), for: .editingChanged)
    }
    
    /// `override update()`
    override func update() {
        super.update()
        
        if let first = row?.value?["firstname"] as? String, !first.isEmpty {
            firstNameTextField.text = first
        }
        
        if let last = row?.value?["lastname"] as? String, !last.isEmpty {
            lastNameTextField.text = last
        }
        
        if let photo = row?.value?["picture"] as? UIImage {
            photoBotton.setBackgroundImage(photo, for: .normal)
        }
    }
    
    /// `override firstResponderElement()`
    open override func firstResponderElement() -> UIResponder? {
        return firstNameTextField
    }
    
    /// `override formRowCanBecomeFirstResponder()`
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    /// update data when change UITextField
    internal func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.characters.count > 0 else {

            if sender.tag == 0 {
                var rowValue = [String: AnyObject]()
                rowValue["firstname"] = "" as AnyObject
                row?.value = rowValue as AnyObject
            }
            if sender.tag == 1 {
                var rowValue = [String: AnyObject]()
                rowValue["lastname"] = "" as AnyObject
                row?.value = rowValue as AnyObject
            }
            update()
            return
        }

        if var rowValue = row?.value as? [String: AnyObject] {
        
            if sender.tag == 0 {
                rowValue["firstname"] = text as AnyObject
                row?.value = rowValue as AnyObject
            }
            
            if sender.tag == 1 {
                rowValue["lastname"] = text as AnyObject
                row?.value = rowValue as AnyObject
            }
        }
    }
    
    /// Load user photo in profile
    internal func loadPhoto(_ sender: UIButton) {
        
        formViewController?.view.endEditing(true)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.formViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// open camera for take photo of profile
    func openCamera() {
        imagePicker.delegate = self
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            formViewController?.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            formViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /// open photo library for set photo of profile
    func openGallary() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        formViewController?.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension FormInfoCell:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// get `UIImage` from `UIImagePickerController`
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if var rowValue = row?.value as? [String: AnyObject] {
                rowValue["picture"] = chosenImage
                row?.value = rowValue as AnyObject
            }
        }
        
        formViewController?.dismiss(animated: true, completion: nil)
        self.update()
    }
}
