//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 04.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import SideMenu
import UIKit

class SettingsVC: UIViewController {
    private var sideMenu: SideMenuNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground

        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 100))
        label.text = "Coming Soon.."
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)

        self.view.addSubview(label)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
