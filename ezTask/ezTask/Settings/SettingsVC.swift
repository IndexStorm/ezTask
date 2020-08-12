//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 06.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
        cell.configure(row: indexPath.row)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    let menuBtn: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "menu")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white

        return image
    }()

    let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white

        return label
    }()

    @objc
    func menuBtnTapped() {
        if let mainVC = self.parent as? MainVC {
            mainVC.menuBtnTapped()
        }
    }
    
    let settingsTable = UITableView()
    var safeAreaView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        
        setup()
    }
    
    func setup() {
        
        self.view.addSubview(settingsTable)
        safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 36))
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
        safeAreaView.layer.shadowColor = UIColor.black.cgColor
        safeAreaView.layer.shadowOpacity = 0.25
        safeAreaView.layer.shadowOffset = CGSize(width: 0, height: 4)
        safeAreaView.layer.shadowRadius = 5
        self.view.addSubview(safeAreaView)

        self.view.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21).isActive = true
        menuBtn.isUserInteractionEnabled = true
        menuBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuBtnTapped)))

        self.view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.sizeToFit()
        pageTitle.centerXAnchor.constraint(equalTo: safeAreaView.centerXAnchor).isActive = true
        pageTitle.topAnchor.constraint(equalTo: menuBtn.topAnchor).isActive = true
        
        createTable()
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        settingsTable.topAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: 0).isActive = true
        settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//        settingsTable.separatorStyle = .none
        settingsTable.contentInset.top = 10
        settingsTable.contentInset.bottom = 10
        settingsTable.showsHorizontalScrollIndicator = false
        settingsTable.showsVerticalScrollIndicator = false
        settingsTable.backgroundColor = .tertiarySystemBackground
    }
    
    func createTable() {
        settingsTable.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        settingsTable.dataSource = self
        settingsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
    }
}
