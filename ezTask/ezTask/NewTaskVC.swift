//
//  NewTaskVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 21.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit
import ViewAnimator

protocol SecondControllerDelegate: NSObjectProtocol {
    func didBackButtonPressed(task: TaskModel)
}

class NewTaskVC: UIViewController, UITextViewDelegate {
    // Var
    var isPriority: Bool = false
    var delegate: SecondControllerDelegate?

    // Views

    private let swipeArrow: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "swipe_down")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        image.alpha = 0.2

        return image
    }()

    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "New Task"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        return label
    }()

    private let planning: UILabel = {
        let label = UILabel()
        label.text = "What are you planning?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.alpha = 0.25

        return label
    }()

    private let mainText: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        text.isScrollEnabled = false

        return text
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1

        return view
    }()

    private let dateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "calendar")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        image.alpha = 0.9

        return image
    }()

    private let dateTextField: UITextField = {
        let field = UITextField()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        field.text = formatter.string(from: Date())
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.tintColor = .clear

        return field
    }()

    private let datePicker = UIDatePicker()

    private let timeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "alarm")
        image.contentMode = .scaleAspectFit
//        image.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        image.tintColor = .black
        image.alpha = 0.3

        return image
    }()

    private let timeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Add Reminder"
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        return field
    }()

    private let timePicker = UIDatePicker()

    private let priorityImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "square")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.8509803922, green: 0.2196078431, blue: 0.1607843137, alpha: 1)
        image.alpha = 0.9

        return image
    }()

    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "High Priority"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = #colorLiteral(red: 0.8509803922, green: 0.2196078431, blue: 0.1607843137, alpha: 1)
        label.alpha = 0.9

        return label
    }()

    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed))
        let cancelBtn = UIBarButtonItem(title: "Today", style: .plain, target: nil, action: #selector(datePickerCancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }

    func createTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timePickerDonePressed))
        let cancelBtn = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: #selector(timePickerCancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
        timeTextField.inputAccessoryView = toolbar
        timeTextField.inputView = timePicker
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 5
        timePicker.date = Date()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createDatePicker()
        createTimePicker()
    }

    @objc
    func timeTapped() {}

    @objc
    func priorityTapped() {
        if isPriority {
            isPriority = false
            priorityImage.image = UIImage(named: "square")
        } else {
            isPriority = true
            priorityImage.image = UIImage(named: "square_filled")
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func datePickerDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func datePickerCancelPressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: Date())
        self.view.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func timePickerDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
        timeImage.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        timeImage.alpha = 0.9
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func timePickerCancelPressed() {
        timeTextField.text = ""
        self.view.endEditing(true)
        timeImage.tintColor = .black
        timeImage.alpha = 0.3
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let task = TaskModel(mainText: mainText.text)
        // if reminder
        setupReminder()
        delegate?.didBackButtonPressed(task: task)
    }

    func setupReminder() {}

    func dismiss() {
        // TODO: add dismiss cross button
        self.dismiss(animated: true, completion: nil)
    }

    func setup() {
        self.view.backgroundColor = .white

        self.view.addSubview(swipeArrow)
        swipeArrow.translatesAutoresizingMaskIntoConstraints = false
        swipeArrow.heightAnchor.constraint(equalToConstant: 10).isActive = true
        swipeArrow.widthAnchor.constraint(equalToConstant: 140).isActive = true
        swipeArrow.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        swipeArrow.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true

        self.view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: swipeArrow.bottomAnchor, constant: 15).isActive = true

        self.view.addSubview(planning)
        planning.translatesAutoresizingMaskIntoConstraints = false
        planning.heightAnchor.constraint(equalToConstant: 17).isActive = true
        planning.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        planning.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        planning.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30).isActive = true

        self.view.addSubview(mainText)
        mainText.translatesAutoresizingMaskIntoConstraints = false
        mainText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21).isActive = true
        mainText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        mainText.topAnchor.constraint(equalTo: planning.bottomAnchor, constant: 10).isActive = true
        mainText.becomeFirstResponder()
        mainText.returnKeyType = .done
        mainText.delegate = self

        self.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        separator.topAnchor.constraint(equalTo: mainText.bottomAnchor, constant: 20).isActive = true

        self.view.addSubview(dateImage)
        dateImage.translatesAutoresizingMaskIntoConstraints = false
        dateImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dateImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        dateImage.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 35).isActive = true

        self.view.addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: dateImage.trailingAnchor, constant: 12).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 25).isActive = true
        dateTextField.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 35).isActive = true

        self.view.addSubview(timeImage)
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        timeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        timeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        timeImage.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20).isActive = true
        timeImage.isUserInteractionEnabled = true
        timeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeTapped)))

        self.view.addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timeTextField.leadingAnchor.constraint(equalTo: timeImage.trailingAnchor, constant: 12).isActive = true
        timeTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20).isActive = true

        self.view.addSubview(priorityImage)
        priorityImage.translatesAutoresizingMaskIntoConstraints = false
        priorityImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priorityImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        priorityImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        priorityImage.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20).isActive = true
        priorityImage.isUserInteractionEnabled = true
        priorityImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priorityTapped)))

        self.view.addSubview(priorityLabel)
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priorityLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        priorityLabel.leadingAnchor.constraint(equalTo: priorityImage.trailingAnchor, constant: 12).isActive = true
        priorityLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20).isActive = true
        priorityLabel.isUserInteractionEnabled = true
        priorityLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priorityTapped)))
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            dismiss()
            return false
        }
        return true
    }
}
