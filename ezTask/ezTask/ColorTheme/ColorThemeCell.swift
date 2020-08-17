//
//  ColorThemeCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 05.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ColorThemeCell: UICollectionViewCell {
    static let identifier = "ColorThemeCell"

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    public func configure(row: Int) {
        self.contentView.layer.cornerRadius = 15
        let text: String = {
            switch row {
            case 0:
                self.contentView.backgroundColor = .systemIndigo
                return "Indigo"
            case 1:
                self.contentView.backgroundColor = .systemGreen
                return "Green"
            case 2:
                self.contentView.backgroundColor = .systemRed
                return "Red"
            case 3:
                self.contentView.backgroundColor = .systemBlue
                return "Blue"
            case 4:
                self.contentView.backgroundColor = .systemPink
                return "Pink"
            case 5:
                self.contentView.backgroundColor = .systemOrange
                return "Orange"
            case 6:
                self.contentView.backgroundColor = .systemPurple
                return "Purple"
            case 7:
                self.contentView.backgroundColor = .systemTeal
                return "Teal"
            case 8:
                self.contentView.backgroundColor = .systemYellow
                return "Yellow"
            case 9:
                self.contentView.backgroundColor = UIColor().colorFromHexString("#fe828c")
                return "Salmon"
            case 10:
                self.contentView.backgroundColor = UIColor().colorFromHexString("#191919")
                return "Black"
            case 11:
                self.contentView.backgroundColor = UIColor().colorFromHexString("#d98695")
                return "Blush Pink"
            default:
                self.contentView.backgroundColor = .systemIndigo
                return "Indigo"
            }
        }()
        if self.contentView.backgroundColor == ThemeManager.currentTheme().mainColor {
            self.contentView.layer.borderWidth = 5
            self.contentView.layer.borderColor = UIColor.systemGray3.cgColor
        } else {
            self.contentView.layer.borderWidth = 0
        }
        label.text = text
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.shadowRadius = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .tertiarySystemBackground
        self.contentView.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.sizeToFit()
        self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
