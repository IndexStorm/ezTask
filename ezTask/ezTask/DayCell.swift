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

    private let dayNumber: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let dayName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5.0 / 2.0
        view.alpha = 0

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayName)
        contentView.addSubview(dayNumber)
        contentView.addSubview(circleView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        dayName.translatesAutoresizingMaskIntoConstraints = false
//        dayName.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        dayName.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        dayName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        dayName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//
//        dayNumber.translatesAutoresizingMaskIntoConstraints = false
//        dayNumber.heightAnchor.constraint(equalToConstant: 29).isActive = true
//        dayNumber.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        dayNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        dayNumber.topAnchor.constraint(equalTo: dayName.bottomAnchor).isActive = true
//
//        circleView.translatesAutoresizingMaskIntoConstraints = false
//        circleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        circleView.widthAnchor.constraint(equalToConstant: 5).isActive = true
//        circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        circleView.topAnchor.constraint(equalTo: dayNumber.bottomAnchor).isActive = true
        
        dayName.translatesAutoresizingMaskIntoConstraints = false
        dayName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayName.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dayName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        dayNumber.translatesAutoresizingMaskIntoConstraints = false
        dayNumber.heightAnchor.constraint(equalToConstant: 28).isActive = true
        dayNumber.widthAnchor.constraint(equalToConstant: 28).isActive = true
        dayNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayNumber.topAnchor.constraint(equalTo: dayName.bottomAnchor).isActive = true

        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        circleView.topAnchor.constraint(equalTo: dayNumber.bottomAnchor, constant: 1).isActive = true
    }

    public func configure(name: String, number: Int, busy: Bool, isChosen: Bool) {
        if busy {
            circleView.alpha = 1
        } else {
            circleView.alpha = 0
        }
        if isChosen {
            contentView.alpha = 1
        } else {
            contentView.alpha = 0.6
        }
        dayNumber.text = "\(number)"
        dayName.text = name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayNumber.text = ""
        dayName.text = ""
        circleView.alpha = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
