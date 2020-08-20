//
//  DailyNotificationsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 20.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import PinLayout
import UIKit

class DailyNotificationsVC: UIViewController {
    let morningHour = UserDefaults.standard.integer(forKey: "morningHour")
    let morningMinute = UserDefaults.standard.integer(forKey: "morningMinute")
    let eveningHour = UserDefaults.standard.integer(forKey: "eveningHour")
    let eveningMinute = UserDefaults.standard.integer(forKey: "eveningMinute")

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 20

        return view
    }()

    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lbl.text = "label.dailyNotifications".localized

        return lbl
    }()

    let mySwitch: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = false
        switchDemo.onTintColor = ThemeManager.currentTheme().mainColor

        return switchDemo
    }()

    let morning: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.text = "label.morning".localized

        return lbl
    }()

    let evening: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.text = "label.evening".localized

        return lbl
    }()

    private let morningTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "13:30"
        field.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        field.tintColor = .clear
        field.textAlignment = .center

        return field
    }()

    private let eveningTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "11:30"
        field.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        field.tintColor = .clear
        field.textAlignment = .center

        return field
    }()

    private let morningPicker = UIDatePicker()
    private let eveningPicker = UIDatePicker()

    func createTimePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timePickerDonePressed(picker:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneBtn], animated: true)
        morningTextField.inputAccessoryView = toolbar
        morningTextField.inputView = morningPicker

        eveningTextField.inputAccessoryView = toolbar
        eveningTextField.inputView = eveningPicker

        morningPicker.datePickerMode = .time
        morningPicker.minuteInterval = 15
        morningPicker.minimumDate = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 4))
        morningPicker.maximumDate = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 12))
        morningPicker.date = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * morningHour + 60 * morningMinute)) // TODO: set current date
        morningPicker.addTarget(self, action: #selector(timePickerChanged(picker:)), for: .valueChanged)
        updateTextFields(picker: morningPicker)

        eveningPicker.datePickerMode = .time
        eveningPicker.minuteInterval = 15
        eveningPicker.minimumDate = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 17))
        eveningPicker.maximumDate = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 23))
        eveningPicker.date = Date().startOfDay.addingTimeInterval(TimeInterval(60 * 60 * eveningHour + 60 * eveningMinute)) // TODO: set current date
        eveningPicker.addTarget(self, action: #selector(timePickerChanged(picker:)), for: .valueChanged)
        updateTextFields(picker: eveningPicker)
    }

    @objc
    func timePickerDonePressed(picker: UIDatePicker) {
        timePickerChanged(picker: picker)
        self.view.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func timePickerChanged(picker: UIDatePicker) {
        updateTextFields(picker: picker)
        if picker == morningPicker {
            UserDefaults.standard.set(morningPicker.date.hour, forKey: "morningHour")
            UserDefaults.standard.set(morningPicker.date.minute, forKey: "morningMinute")
        } else if picker == eveningPicker {
            UserDefaults.standard.set(eveningPicker.date.hour, forKey: "eveningHour")
            UserDefaults.standard.set(eveningPicker.date.minute, forKey: "eveningMinute")
        }
    }

    func updateTextFields(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        if picker == morningPicker {
            morningTextField.text = formatter.string(from: picker.date)
        } else if picker == eveningPicker {
            eveningTextField.text = formatter.string(from: picker.date)
        }
    }

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

    @objc func buttonPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        dismiss(animated: true, completion: {})
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        setup()
        createTimePicker()
        updateUI()
    }

    func setup() {
        self.view.addSubview(container)
        
        container.pin.horizontally().height(250).bottom(self.view.bounds.height / 2)

        container.addSubview(topLabel)
        topLabel.pin.hCenter().top(24).marginRight(57 / 2).sizeToFit()

        container.addSubview(mySwitch)
        mySwitch.pin.right(of: topLabel, aligned: .center).marginHorizontal(12).sizeToFit()
        mySwitch.isOn = UserDefaults.standard.bool(forKey: "dailyNotifications")
        mySwitch.addTarget(self, action: #selector(switchChange(_:)), for: .valueChanged)

        container.addSubview(morning)
        morning.pin.left(64).below(of: topLabel).marginTop(30).sizeToFit()

        container.addSubview(morningTextField)
        morningTextField.pin.below(of: morning, aligned: .center).marginTop(10).sizeToFit().minWidth(80)

        container.addSubview(evening)
        evening.pin.right(64).below(of: topLabel).marginTop(30).sizeToFit()

        container.addSubview(eveningTextField)
        eveningTextField.pin.below(of: evening, aligned: .center).marginTop(10).sizeToFit().minWidth(80)

        container.addSubview(button)
        button.pin.bottom(20).hCenter().width(250).height(50)
    }

    @objc func switchChange(_ sender: UISwitch!) {
        UserDefaults.standard.set(sender.isOn, forKey: "dailyNotifications")
        sendMorningReminder()
        updateUI()
    }

    func updateUI() {
        if mySwitch.isOn {
            morning.alpha = 1
            morningTextField.alpha = 1
            evening.alpha = 1
            eveningTextField.alpha = 1
        } else {
            morning.alpha = 0.3
            morningTextField.alpha = 0.3
            evening.alpha = 0.3
            eveningTextField.alpha = 0.3
        }
    }
}
