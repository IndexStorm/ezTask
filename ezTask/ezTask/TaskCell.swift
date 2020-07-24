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

    class alarm: UIView {
        var label: UILabel!
        var image: UIImageView!

        convenience init(frame: CGRect, labelText: String) {
            self.init(frame: frame)
            self.label.text = labelText
            setup()
        }

        override init(frame: CGRect) {
            self.label = UILabel()
            self.image = UIImageView()
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            self.backgroundColor = .green

            self.addSubview(self.image)
            self.image.image = UIImage(named: "alarm")
            self.image.contentMode = .scaleAspectFit
            self.image.tintColor = .systemYellow
            self.image.translatesAutoresizingMaskIntoConstraints = false
            self.image.heightAnchor.constraint(equalToConstant: 14).isActive = true
            self.image.widthAnchor.constraint(equalToConstant: 14).isActive = true
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            self.addSubview(self.label)
            self.label.text = "20:11"
            self.label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            self.label.textColor = .systemYellow
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.sizeToFit()
            self.label.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 2).isActive = true
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        public func viewWidth() -> CGFloat {
            if self.alpha == 0 {
                return 0
            }
//            print(self.label.frame.width, self.image.frame.width)
            return self.label.frame.width + 14 + 2
        }
    }

    private var alarmView = alarm()

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "just test"

        return label
    }()

//    private let alarmView: UIView = {
//        let view = UIView()
//        view.alpha = 0
//
//        let image = UIImageView()
//        view.addSubview(image)
//        image.image = UIImage(named: "alarm")
//        image.contentMode = .scaleAspectFit
//        image.tintColor = .systemYellow
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        image.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//        let label = UILabel()
//        view.addSubview(label)
//        label.text = "20:00"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        label.textColor = .systemYellow
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.sizeToFit()
//        label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 2).isActive = true
//        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//        return view
//    }()

    public func configure(task: TaskModel) {
        self.titleLabel.text = task.mainText
        self.id = task.id
        self.priorityIcon.alpha = task.isPriority ? 0.9 : 0
        if task.isAlarmSet {
            alarmView = alarm(frame: CGRect(), labelText: "testik")
        } else {
            alarmView.alpha = 0
        }
        self.contentView.addSubview(alarmView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        priorityIcon.translatesAutoresizingMaskIntoConstraints = false
        priorityIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        priorityIcon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.heightAnchor.constraint(equalToConstant: 22).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 22).isActive = true
        checkbox.leadingAnchor.constraint(equalTo: priorityIcon.trailingAnchor, constant: 12).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        checkbox.isUserInteractionEnabled = true
        checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxTapped)))

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        alarmView.translatesAutoresizingMaskIntoConstraints = false
        alarmView.widthAnchor.constraint(equalToConstant: alarmView.viewWidth() + 5).isActive = true
        alarmView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        alarmView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12).isActive = true
        alarmView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.sizeToFit()
        dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: alarmView.trailingAnchor, constant: 0).isActive = true
        dayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        dayLabel.backgroundColor = .red
    }

    @objc
    func checkboxTapped() {
        checkbox.image = UIImage(named: "square_filled")
        delegate?.checkboxTapped(cell: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(priorityIcon)
        self.contentView.addSubview(checkbox)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(alarmView)
        self.contentView.addSubview(dayLabel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        checkbox.image = UIImage(named: "square")
        alarmView = alarm()
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

 extension UIView {
    final func sizeToFitCustom() {
        var w: CGFloat = 0,
            h: CGFloat = 0
        for view in subviews {
            if view.frame.origin.x + view.frame.width > w { w = view.frame.origin.x + view.frame.width }
            if view.frame.origin.y + view.frame.height > h { h = view.frame.origin.y + view.frame.height }
        }
        print(w, h)
//        frame.size = CGSize(width: w, height: h)
    }
 }
