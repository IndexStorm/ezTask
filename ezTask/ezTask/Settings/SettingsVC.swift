//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 04.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import SideMenu
import UIKit

class SettingsVC: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let text: String = {
            switch indexPath.row {
            case 0:
                cell.backgroundColor = .systemIndigo
                return "systemIndigo"
            case 1:
                cell.backgroundColor = .systemGreen
                return "systemGreen"
            case 2:
                cell.backgroundColor = .systemRed
                return "systemRed"
            case 3:
                cell.backgroundColor = .systemBlue
                return "systemBlue"
            case 4:
                cell.backgroundColor = .systemPink
                return "systemPink"
            case 5:
                cell.backgroundColor = .systemOrange
                return "systemOrange"
            case 6:
                cell.backgroundColor = .systemPurple
                return "systemPurple"
            case 7:
                cell.backgroundColor = .systemTeal
                return "systemTeal"
            case 8:
                cell.backgroundColor = .systemYellow
                return "systemYellow"
            default:
                cell.backgroundColor = .systemIndigo
                return "systemIndigo"
            }
        }()
        cell.textLabel?.text = text

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        self.view.backgroundColor = .tertiarySystemBackground
    }
}
