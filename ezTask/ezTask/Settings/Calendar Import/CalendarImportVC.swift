//
//  CalendarImportVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 22.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import EventKit
import UIKit

class CalendarImportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let calendars = getCalendars()
    var chosenCalendars: [String] = []

    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lbl.text = "Import from Calendar".localized

        return lbl
    }()

    let mySwitch: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = false
        switchDemo.onTintColor = ThemeManager.currentTheme().mainColor

        return switchDemo
    }()

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("label.done".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = ThemeManager.currentTheme().mainColor
        button.layer.cornerRadius = 25
        button.layer.shadowColor = ThemeManager.currentTheme().mainColor.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 3
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        return button
    }()

    let calendarTable = UITableView()

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        cell.configure(calendar: calendars[indexPath.row])
        if chosenCalendars.contains(cell.name.text!) {
            cell.setSelected()
        } else {
            cell.setDeselected()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CalendarCell
        if !chosenCalendars.contains(cell.name.text!) {
            cell.setSelected()
            chosenCalendars.append(cell.name.text!)
            loadCalendar(calendarTitle: cell.name.text!)
        } else {
            cell.setDeselected()
            chosenCalendars.removeAll(where: { $0 == cell.name.text! })
            removeCalendar(calendarTitle: cell.name.text!)
        }
        UserDefaults.standard.setValue(chosenCalendars, forKey: "chosenCalendars")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        if UserDefaults.standard.stringArray(forKey: "chosenCalendars") == nil {
            UserDefaults.standard.setValue([], forKey: "chosenCalendars")
        }
        chosenCalendars = UserDefaults.standard.stringArray(forKey: "chosenCalendars")!

        setup()
    }

    @objc func buttonPressed() {
        dismiss(animated: true, completion: {})
    }

    @objc func switchChange(_ sender: UISwitch!) {
        UserDefaults.standard.set(sender.isOn, forKey: "importCalendars")
        if sender.isOn {
            loadAllChosenCalendars()
        } else {
            removeAllCalendars()
        }
    }

    func setup() {
        self.view.addSubview(topLabel)
        topLabel.pin.hCenter().top(40).marginRight(57 / 2).sizeToFit()

        self.view.addSubview(mySwitch)
        mySwitch.pin.right(of: topLabel, aligned: .center).marginHorizontal(12).sizeToFit()
        mySwitch.isOn = UserDefaults.standard.bool(forKey: "importCalendars")
        mySwitch.addTarget(self, action: #selector(switchChange(_:)), for: .valueChanged)

        self.view.addSubview(button)
        self.view.addSubview(calendarTable)
        createTable()
        calendarTable.translatesAutoresizingMaskIntoConstraints = false
        calendarTable.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        calendarTable.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 0).isActive = true
        calendarTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        calendarTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        calendarTable.tableFooterView = UIView()
        calendarTable.contentInset.bottom = 10
        calendarTable.showsHorizontalScrollIndicator = false
        calendarTable.showsVerticalScrollIndicator = false
        calendarTable.backgroundColor = .tertiarySystemBackground

        button.pin.bottom(100).hCenter().width(250).height(50)
    }

    func createTable() {
        calendarTable.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        calendarTable.dataSource = self
        calendarTable.delegate = self
    }
}

class CalendarCell: UITableViewCell {
    static let identifier = "CalendarCell"

    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        return label
    }()

    let circle: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "circle")
        image.contentMode = .scaleAspectFit

        return image
    }()

    public func configure(calendar: EKCalendar) {
        name.text = calendar.title
        circle.tintColor = UIColor(cgColor: calendar.cgColor)
    }

    public func setSelected() {
        circle.image = UIImage(named: "circle_filled")
    }

    public func setDeselected() {
        circle.image = UIImage(named: "circle")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground

        self.contentView.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        circle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 32).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 22).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 22).isActive = true

        self.contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 12).isActive = true
        name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
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
