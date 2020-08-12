//
//  SettingsCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 12.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
    
    let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "badge")
        image.tintColor = ThemeManager.currentTheme().mainColor
//        image.tintColor = .tertiarySystemBackground

        return image
    }()

    let label: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        return label
    }()
    
    let subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.contentMode = .left
        subtitle.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        subtitle.textColor = .secondaryLabel

        return subtitle
    }()
    
    public func configure(row: Int) {
        switch row {
        case 0:
            label.text = "App Badge"
            subtitle.text = "Equals to the number of today's tasks"
            icon.image = UIImage(named: "badge")
        default:
            label.text = "Test"
            subtitle.text = "Lurum upsil see me fuck off"
        }
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground
        
        self.contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: icon.topAnchor, constant: -2).isActive = true
        
        self.contentView.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.widthAnchor.constraint(equalToConstant: 250).isActive = true
        subtitle.heightAnchor.constraint(equalToConstant: 14).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 2).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
