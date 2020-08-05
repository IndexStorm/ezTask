//
//  MenuCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 05.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit
import ViewAnimator

class MenuCell: UITableViewCell {
    static let identifier = "MenuCell"

    let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "theme")

        return image
    }()

    let label: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .secondaryLabel

        return label
    }()

    public func configure(text: String, isChosen: Bool) {
        label.text = text
        self.contentView.layer.cornerRadius = 15
        if isChosen {
            label.textColor = .label
            self.contentView.backgroundColor = .systemBackground
            self.icon.tintColor = ThemeManager.currentTheme().mainColor
        } else {
            label.textColor = .secondaryLabel
            self.contentView.backgroundColor = .clear
            self.icon.tintColor = .secondaryLabel
        }

        switch text {
        case "Home":
            self.icon.image = UIImage(named: "home")
        case "Theme":
            self.icon.image = UIImage(named: "theme")
        case "Settings":
            self.icon.image = UIImage(named: "settings")
        default:
            self.icon.image = UIImage(named: "home")
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .secondarySystemBackground

        self.contentView.addSubview(icon)
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.icon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.icon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.icon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true

        self.contentView.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.sizeToFit()
        self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 10).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
