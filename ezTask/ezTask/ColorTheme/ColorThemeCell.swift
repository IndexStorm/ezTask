//
//  ColorThemeCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 05.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ColorThemeCell: UITableViewCell {
    static let identifier = "ColorThemeCell" // change

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.contentMode = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

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
            default:
                self.contentView.backgroundColor = .systemIndigo
                return "Indigo"
            }
        }()
        if self.contentView.backgroundColor == ThemeManager.currentTheme().mainColor {
            self.contentView.layer.borderWidth = 4
            self.contentView.layer.borderColor = UIColor.systemGray3.cgColor
        } else {
            self.contentView.layer.borderWidth = 0
        }
        label.text = text
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.backgroundColor = .tertiarySystemBackground
        self.contentView.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.sizeToFit()
        self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
