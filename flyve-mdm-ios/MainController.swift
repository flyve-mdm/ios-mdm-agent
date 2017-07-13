/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * MainController.swift is part of flyve-mdm-ios
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
 * @date      13/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class MainController: UIViewController {
    
    var userInfo = [String: String]()
    var mdmAgent = [String: Any]()
    let cellId = "cellId"
    
    init(mdmAgent: [String: Any]) {
        
        self.mdmAgent = mdmAgent
        
        print(self.mdmAgent)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        if let dataUserObject = getStorage(key: "dataUser") as? [String: String] {
            userInfo = dataUserObject
        }

        setupViews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupViews() {
        
        view.backgroundColor = .background
        view.addSubview(logoImageView)
        view.addSubview(mainTableView)

    }
    
    func addConstraints() {
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mainTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var mainTableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        
        table.register(MainCell.self, forCellReuseIdentifier: self.cellId)
        
        return table
        
    }()
    
    func goLogController() {
        navigationController?.pushViewController(TopicLogController(), animated: true)
    }
}

extension MainController: UITableViewDelegate {

}

extension MainController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! MainCell
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "Device supervised by".uppercased()
            
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "user information".uppercased()
            cell.descriptionLabel.text = "\(userInfo["firstname"] ?? "") \(userInfo["lastname"] ?? "")"
            cell.detailLabel.text = "\(userInfo["_email"] ?? "Email")"
            
        } else if indexPath.row == 2 {
            cell.titleLabel.text = "agent resources".uppercased()
            
        } else if indexPath.row == 3 {
            cell.titleLabel.text = "log report".uppercased()
            cell.openBotton.addTarget(self, action: #selector(self.goLogController), for: .touchUpInside)
            
        }

        return cell
    }
}

class MainCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = .clear
        setupView()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupView() {
        
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(openBotton)
    }
    
    func addConstraints() {
        
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        photoImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -16).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        
        descriptionLabel.bottomAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        
        openBotton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        openBotton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    let lineView: UIView = {
        
        let line = UIView()
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .gray
        
        return line
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightLight)
        
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        
        return label
    }()
    
    lazy var openBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPEN", for: .normal)
        
        return button
    }()
}


