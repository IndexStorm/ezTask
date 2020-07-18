//
//  TaskCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 18.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = UIFont.systemFont(ofSize: 22)
        label.backgroundColor = .red
        return label
    }()
    
    public func configure(title: String) {
        titleLabel.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
