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
        return 12
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
        case 10:
            ThemeManager.applyTheme(theme: .theme11)
        case 11:
            ThemeManager.applyTheme(theme: .theme12)
        default:
            ThemeManager.applyTheme(theme: .theme1)
        }
        self.safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
        collectionView.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    var collectionView: UICollectionView?

    let menuBtn: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "menu")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white

        return image
    }()

    let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        setup()
        collectionView?.reloadData()
    }

    @objc
    func menuBtnTapped() {
        if let mainVC = self.parent as? MainVC {
            mainVC.menuBtnTapped()
        }
    }

    var safeAreaView = UIView()

    private func setup() {
        createCollection()

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

        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView?.topAnchor.constraint(equalTo: self.safeAreaView.bottomAnchor, constant: 0).isActive = true
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
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        self.view.addSubview(collectionView!)
    }
}
