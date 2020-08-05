//
//  SettingsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 04.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ColorThemeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorThemeCell.identifier, for: indexPath) as! ColorThemeCell
        cell.configure(row: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        case 9:
            ThemeManager.applyTheme(theme: .theme10)
        default:
            ThemeManager.applyTheme(theme: .theme1)
        }
        collectionView.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        self.navigationItem.title = "Theme"
        setup()
    }

    private func setup() {
        createCollection()
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
    }

    func createCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.width / 2 - 48, height: self.view.frame.width / 2 - 48)
        layout.sectionInset = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 32

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(ColorThemeCell.self, forCellWithReuseIdentifier: ColorThemeCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        self.view.addSubview(collectionView!)
    }
}
