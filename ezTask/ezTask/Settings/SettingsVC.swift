//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 06.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground

        let safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 36))
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
    }
}
