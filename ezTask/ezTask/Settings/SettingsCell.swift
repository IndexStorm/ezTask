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

    public var indexPath: IndexPath!

    let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "clock")
        image.contentMode = .scaleAspectFit

        return image
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        return label
    }()

    let subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.textAlignment = .left
        subtitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        subtitle.textColor = .secondaryLabel
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.numberOfLines = 0

        return subtitle
    }()

    let cellSwitch: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = false

        return switchDemo
    }()

    let arrow: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "right_arrow")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray2

        return image
    }()

    @objc
    func cellSwitchChange(_ sender: UISwitch!) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                UserDefaults.standard.set(sender.isOn, forKey: "badgeToday")
            case 3:
                UserDefaults.standard.set(sender.isOn, forKey: "hideCompleted")
            default:
                return
            }
        }
    }

    public func configure(indexPath: IndexPath) {
        self.selectionStyle = .none
        self.indexPath = indexPath
        cellSwitch.isOn = false
        cellSwitch.alpha = 1
        arrow.alpha = 0
        arrow.tintColor = ThemeManager.currentTheme().mainColor
        icon.tintColor = ThemeManager.currentTheme().mainColor
        cellSwitch.onTintColor = ThemeManager.currentTheme().mainColor
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                label.text = "label.appBadge".localized
                subtitle.text = "Set equal to the number of today's tasks".localized
                icon.image = UIImage(named: "badge")
                cellSwitch.isOn = UserDefaults.standard.bool(forKey: "badgeToday")
            case 1:
                label.text = "label.dailyNotifications".localized
                subtitle.text = "Send morning and evening notifications".localized
                icon.image = UIImage(named: "clock")
                cellSwitch.alpha = 0
                arrow.alpha = 1
                self.selectionStyle = .default
            case 2:
                label.text = "Import from Calendar"
                subtitle.text = "Import events from calendar"
                icon.image = UIImage(named: "calendar")
                cellSwitch.alpha = 0
                arrow.alpha = 1
                self.selectionStyle = .default
            case 3:
                label.text = "label.hideCompleted".localized
                subtitle.text = "Hide completed tasks in List".localized
                icon.image = UIImage(named: "hide")
                cellSwitch.isOn = UserDefaults.standard.bool(forKey: "hideCompleted")
            default:
                label.text = "label.test".localized
                subtitle.text = "Lurum upsil I'm broken"
            }
        }

        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                label.text = "label.giveFeedback".localized
                subtitle.text = "Feel free to mail us any questions".localized
                icon.image = UIImage(named: "mail")
                cellSwitch.alpha = 0
                arrow.alpha = 1
                self.selectionStyle = .default
            case 1:
                label.text = "label.rateOnTheAppStore".localized
                subtitle.text = "Leave your feedback on the app page".localized
                icon.image = UIImage(named: "star")
                cellSwitch.alpha = 0
                arrow.alpha = 1
                self.selectionStyle = .default
            default:
                label.text = "Test".localized
                subtitle.text = "Lurum upsil I'm broken"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground

        self.contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        icon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14).isActive = true

        self.contentView.addSubview(cellSwitch)
        cellSwitch.translatesAutoresizingMaskIntoConstraints = false
        cellSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        cellSwitch.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        cellSwitch.addTarget(self, action: #selector(cellSwitchChange(_:)), for: .valueChanged)

        self.contentView.addSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -28).isActive = true
        arrow.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 18).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 18).isActive = true

        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: cellSwitch.leadingAnchor, constant: -10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: icon.topAnchor, constant: -2).isActive = true

        self.contentView.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.trailingAnchor.constraint(equalTo: cellSwitch.leadingAnchor, constant: -10).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        subtitle.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -7).isActive = true
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
