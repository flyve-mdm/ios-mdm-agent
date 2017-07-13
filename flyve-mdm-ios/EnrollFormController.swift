/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * RegisterFormController.swift is part of flyve-mdm-ios
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
 * @date      10/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class EnrollFormController: UIViewController {
    
    var userInfo = ["firstName": "","lastName": "", "phone": "", "email": ""]
    
    let cellIdMain = "cellIdMain"
    
    var countPhone = 0
    var countEmail = 0
    
    override func loadView() {
        super.loadView()
        
        self.setupViews()
        self.addConstraints()
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = false
        
        
        let saveButton = UIBarButtonItem(title: "Done",
                                         style: UIBarButtonItemStyle.plain,
                                         target: self,
                                         action: #selector(self.done))
        
        self.navigationItem.title = "Enrollment"
        self.navigationItem.rightBarButtonItem = saveButton

        self.view.addSubview(self.enrollTableView)
        
    }
    
    func addConstraints() {
        
        self.enrollTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.enrollTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.enrollTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.enrollTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    lazy var enrollTableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        table.isEditing = true
        table.allowsSelectionDuringEditing = true
        table.isScrollEnabled = false
        
        return table
        
    }()
    
    lazy var enrollButton: UIButton = {
        
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.init(red: 64.0/255.0, green: 186.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        button.setTitle("Enroll", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.enroll), for: .touchUpInside)
        return button
    }()
    
    func enroll() {
        
        guard let email = self.userInfo["email"], let phone = self.userInfo["phone"], let first = self.userInfo["firstName"], let last = self.userInfo["lastName"], !email.isEmpty, !phone.isEmpty, !first.isEmpty, !last.isEmpty else {
            return
        }
        
        let dataUser: [String: String] = ["_email": email, "firstname": first, "lastname": last]
        
        let notificationData = NotificationCenter.default
        
        notificationData.post(name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil, userInfo: dataUser)
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func done() {
        
        self.enroll()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EnrollFormController: UITableViewDelegate {
    
}

extension EnrollFormController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        return cell
        
    }
}





