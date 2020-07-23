//
//  TaskCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 18.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func checkboxTapped(cell: TaskCell)
}

class TaskCell: UITableViewCell {
    // Var
    var delegate: TableViewCellDelegate?
    public var id: UUID?

    static let identifier = "TaskCell"
    
    private let priorityIcon: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemRed
        view.alpha = 0
        
        return view
    }()

    private let checkbox: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "square")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        image.alpha = 0.9

        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finish the app"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    public func configure(title: String, id: UUID, isPriority: Bool) {
        self.titleLabel.text = title
        self.id = id
        self.priorityIcon.alpha = isPriority ? 0.9 : 0
    }

    @objc
    func checkboxTapped() {
        checkbox.image = UIImage(named: "square_filled")
        delegate?.checkboxTapped(cell: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(priorityIcon)
        priorityIcon.translatesAutoresizingMaskIntoConstraints = false
        priorityIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        priorityIcon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        self.contentView.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.heightAnchor.constraint(equalToConstant: 22).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 22).isActive = true
        checkbox.leadingAnchor.constraint(equalTo: priorityIcon.trailingAnchor, constant: 12).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        checkbox.isUserInteractionEnabled = true
        checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxTapped)))

        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        checkbox.image = UIImage(named: "square")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
