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
    public var model: TaskModel?
    var alarmWidth: NSLayoutConstraint!
    var subtaskWidth: NSLayoutConstraint!
    var reccuringWidth: NSLayoutConstraint!
    var reccuringLead: NSLayoutConstraint!
    var calendarLead: NSLayoutConstraint!

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
        image.tintColor = ThemeManager.currentTheme().mainColor

        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finish the app"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    class alarm: UIView {
        var containerView: UIView!
        var label: UILabel!
        var image: UIImageView!
        var isVisible = false

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
            self.image.translatesAutoresizingMaskIntoConstraints = false
            self.image.heightAnchor.constraint(equalToConstant: 11).isActive = true
            self.image.widthAnchor.constraint(equalToConstant: 11).isActive = true
            self.image.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 4).isActive = true
            self.image.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true

            self.containerView.addSubview(self.label)
            self.label.text = "20:30"
            self.label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            self.label.sizeToFit()
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 2).isActive = true
            self.label.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }

        public func set(time: Date) {
            self.isVisible = true
            if time < Date() {
                self.label.text = "overdue"
                self.label.textColor = .systemRed
                self.image.tintColor = .systemRed
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                self.label.text = formatter.string(from: time)
                self.label.textColor = .systemYellow
                self.image.tintColor = .systemYellow
            }
            self.label.setNeedsLayout()
            self.label.layoutIfNeeded()

            self.addSubview(containerView)
            self.containerView.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }

        public func unset() {
            self.isVisible = false
            self.label.text = ""
            self.label.setNeedsLayout()
            self.label.layoutIfNeeded()
            self.containerView.removeFromSuperview()
        }

        public func viewWidth() -> CGFloat {
            if !self.isVisible {
                return 0
            }
            return self.label.frame.width + self.image.frame.width + 2 + 5 // margin between
        }
    }

    public var alarmView = alarm(frame: CGRect(), labelText: "privet")

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "label.today".localized
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    private let subtasksIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "list")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray

        return image
    }()

    private let reccuringIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "repeat")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray

        return image
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "Calendar"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    public func configure(task: TaskModel) {
        self.model = task
        self.titleLabel.text = task.mainText
        self.id = task.id
        self.priorityIcon.alpha = task.isPriority ? 0.9 : 0

        if task.taskDate.isToday() {
            self.dayLabel.text = "label.today".localized
        } else if task.taskDate.isTomorrow() {
            self.dayLabel.text = "label.tomorrow".localized
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            self.dayLabel.text = formatter.string(from: task.taskDate)
        }

        if task.isAlarmSet, let alarmDate = task.alarmDate {
            alarmView.set(time: alarmDate)
            alarmWidth.constant = alarmView.viewWidth()
        } else {
            alarmView.unset()
            alarmWidth.constant = 0
        }

        if task.isDone {
            checkbox.image = UIImage(named: "square_filled")
            self.contentView.alpha = 0.35
        } else {
            checkbox.image = UIImage(named: "square")
            self.contentView.alpha = 1
        }

        if task.subtasks != nil {
            subtaskWidth.constant = 10
            reccuringLead.constant = 5
        } else {
            subtaskWidth.constant = 0
            reccuringLead.constant = 0
        }

        if task.reccuringDays != nil {
            reccuringWidth.constant = 10
            calendarLead.constant = 5
        } else {
            reccuringWidth.constant = 0
            calendarLead.constant = 0
        }
        
        if task.calendarTitle != nil {
            calendarLabel.text = task.calendarTitle!
            calendarLabel.textColor = getColorOfCalendar(calendarTitle: task.calendarTitle!)
        } else {
            calendarLabel.text = ""
        }
    }

    public func setCompletedDate(date: Date) {
        if date.isToday() {
            self.dayLabel.text = "label.today".localized
        } else if date.isTomorrow() {
            self.dayLabel.text = "label.tomorrow".localized
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            self.dayLabel.text = formatter.string(from: date)
        }
    }

    public func setCellDone() {
        checkbox.image = UIImage(named: "square_filled")
        self.alarmView.unset()
        self.contentView.alpha = 0.35
    }

    public func setCellUndone() {
        checkbox.image = UIImage(named: "square")
        self.contentView.alpha = 1
    }

    @objc
    func checkboxTapped() {
        delegate?.checkboxTapped(cell: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground

        self.contentView.addSubview(priorityIcon)
        self.contentView.addSubview(checkbox)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dayLabel)
        self.contentView.addSubview(alarmView)
        self.contentView.addSubview(subtasksIcon)
        self.contentView.addSubview(reccuringIcon)
        self.contentView.addSubview(calendarLabel)

        priorityIcon.translatesAutoresizingMaskIntoConstraints = false
        priorityIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        priorityIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        priorityIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.leadingAnchor.constraint(equalTo: priorityIcon.trailingAnchor, constant: 10).isActive = true
        checkbox.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        checkbox.isUserInteractionEnabled = true
        checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxTapped)))

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: checkbox.topAnchor, constant: 0).isActive = true

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        dayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

        alarmView.translatesAutoresizingMaskIntoConstraints = false
        alarmView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 0).isActive = true
        alarmView.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 0).isActive = true
        alarmView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        alarmWidth = alarmView.widthAnchor.constraint(equalToConstant: 0)
        alarmWidth.isActive = true

        subtasksIcon.translatesAutoresizingMaskIntoConstraints = false
        subtasksIcon.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -4).isActive = true
        subtasksIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        subtasksIcon.leadingAnchor.constraint(equalTo: alarmView.trailingAnchor, constant: 5).isActive = true
        subtaskWidth = subtasksIcon.widthAnchor.constraint(equalToConstant: 0)
        subtaskWidth.isActive = true

        reccuringIcon.translatesAutoresizingMaskIntoConstraints = false
        reccuringIcon.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -4).isActive = true
        reccuringIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        reccuringLead = reccuringIcon.leadingAnchor.constraint(equalTo: subtasksIcon.trailingAnchor, constant: 5)
        reccuringLead.isActive = true
        reccuringWidth = reccuringIcon.widthAnchor.constraint(equalToConstant: 0)
        reccuringWidth.isActive = true
        
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        calendarLead = calendarLabel.leadingAnchor.constraint(equalTo: reccuringIcon.trailingAnchor, constant: 5)
        calendarLead.isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        checkbox.tintColor = ThemeManager.currentTheme().mainColor
        alarmView.unset()
        self.contentView.alpha = 1
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
