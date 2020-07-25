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
        var containerView: UIView!
        var label: UILabel!
        var image: UIImageView!

        convenience init(frame: CGRect, labelText: String) {
            self.init(frame: frame)
            setup()
            self.label.text = labelText
        }

        override init(frame: CGRect) {
            self.containerView = UIView()
            self.label = UILabel()
            self.image = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
            
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            self.containerView.addSubview(self.image)
            self.image.image = UIImage(named: "alarm")
            self.image.contentMode = .scaleAspectFit
            self.image.tintColor = .systemYellow
            self.image.translatesAutoresizingMaskIntoConstraints = false
            self.image.heightAnchor.constraint(equalToConstant: 14).isActive = true
            self.image.widthAnchor.constraint(equalToConstant: 14).isActive = true
            self.image.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
            self.image.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true

            self.containerView.addSubview(self.label)
            self.label.text = "20:30"
            self.label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            self.label.textColor = .systemYellow
            self.label.sizeToFit()
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 2).isActive = true
            self.label.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        public func set(time: Date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.label.text = formatter.string(from: time)
            self.label.layoutIfNeeded()
            self.addSubview(containerView)
            self.containerView.backgroundColor = .green
            self.containerView.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            self.containerView.widthAnchor.constraint(equalToConstant: viewWidth()).isActive = true
        }
        
        public func unset() {
            self.containerView.removeFromSuperview()
            self.label.text = ""
            self.label.layoutIfNeeded()
        }

        public func viewWidth() -> CGFloat {
            if self.alpha == 0 {
                return 0
            }
            return self.label.frame.width + self.image.frame.width + 2 + 5 // margin between and left
        }
    }

    private var alarmView = alarm(frame: CGRect(), labelText: "privet")


    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.alpha = 0.4
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    public func configure(task: TaskModel) {
        self.titleLabel.text = task.mainText
        self.id = task.id
        self.priorityIcon.alpha = task.isPriority ? 0.9 : 0
        
        if task.taskDate.isToday() { // TODO: make it switch
            self.dayLabel.text = "Today"
        } else if task.taskDate.isTomorrow() {
            self.dayLabel.text = "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            self.dayLabel.text = formatter.string(from: task.taskDate)
        }
        if task.isAlarmSet {
            if let alarmDate = task.alarmDate {
                alarmView.set(time: alarmDate)
            }
        }
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
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        dayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

        alarmView.translatesAutoresizingMaskIntoConstraints = false
        alarmView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5).isActive = true
        alarmView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        alarmView.backgroundColor = .black
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
        alarmView.unset()
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
