//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 04.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ColorThemeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorThemeCell.identifier, for: indexPath) as! ColorThemeCell
        cell.configure(row: indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            ThemeManager.applyTheme(theme: .theme1)
        case 1:
            ThemeManager.applyTheme(theme: .theme2)
        case 2:
            ThemeManager.applyTheme(theme: .theme3)
        case 3:
            ThemeManager.applyTheme(theme: .theme4)
        case 4:
            ThemeManager.applyTheme(theme: .theme5)
        case 5:
            ThemeManager.applyTheme(theme: .theme6)
        case 6:
            ThemeManager.applyTheme(theme: .theme7)
        case 7:
            ThemeManager.applyTheme(theme: .theme8)
        case 8:
            ThemeManager.applyTheme(theme: .theme9)
        default:
            ThemeManager.applyTheme(theme: .theme1)
        }
        tableView.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        self.navigationItem.title = "Theme Color"
        setup()
        self.tableView.reloadData()
    }
    
    private func setup() {
        self.tableView.register(ColorThemeCell.self, forCellReuseIdentifier: ColorThemeCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.backgroundColor = .tertiarySystemBackground
        self.tableView.contentInset.bottom = 10
    }
}
