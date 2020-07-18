//
//  DayCell.swift
//  ezTask
//
//  Created by Mike Ovyan on 18.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    static let identifier = "DayCell"

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 150.0 / 2.0
        imageView.backgroundColor = .white
        

        return imageView
    }()

    private let dayNumber: UILabel = {
        let label = UILabel() // frame: CGRect(x: 5, y: 0, width: 35, height: 45))
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .yellow
        
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayNumber)
        contentView.backgroundColor = .red
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc
    func tap() {
        print("tapped")
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        myImageView.frame = contentView.bounds
        dayNumber.frame = contentView.bounds
    }

    public func configure(with name: String) {
        dayNumber.text = name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        myImageView.image = nil
        dayNumber.text = ""
    }
}
