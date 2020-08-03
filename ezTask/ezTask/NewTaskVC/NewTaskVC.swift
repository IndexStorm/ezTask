//
//  NewTaskVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 21.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit
import UserNotifications
import ViewAnimator

class NewTaskVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // Var

    var isPriority: Bool = false
    var isAlarmSet: Bool = false
    public var returnTask: ((_ task: TaskModel) -> Void)?
    public var model: TaskModel?
    public var chosenDate: Date = Date()
    var isShowingKeyboard: Bool = false

    // Views

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.autoresizingMask = .flexibleHeight
        scroll.bounces = true
        scroll.showsVerticalScrollIndicator = false
        scroll.frame = self.view.bounds

        return scroll
    }()

    private let containerView: UIView = {
        let view = UIView()

        return view
    }()

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

    private let mainTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        text.isScrollEnabled = false

        return text
    }()

    private let addSubtaskView: UIView = {
        let view = UIView()

        let image = UIImageView()
        image.image = UIImage(named: "add_circle")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 25).isActive = true
        image.widthAnchor.constraint(equalToConstant: 25).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true

        let label = UILabel()
        label.text = "Add Subtask"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.alpha = 0.5

        return view
    }()

    private var subtaskStackView: UIStackView!

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
        field.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        field.tintColor = .clear

        return field
    }()

    private let datePicker = UIDatePicker()

    private let timeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "alarm")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        image.alpha = 0.3

        return image
    }()

    private let timeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Add Reminder"
        field.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        field.tintColor = .clear

        return field
    }()

    private let deleteAlarmImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "close")
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        image.alpha = 0

        return image
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
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed))
        let cancelBtn = UIBarButtonItem(title: "Today", style: .plain, target: nil, action: #selector(datePickerCancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.minimumDate = Date()

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: chosenDate)
        datePicker.date = chosenDate
    }

    func createTimePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
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
        timePicker.addTarget(self, action: #selector(timePickerChanged(picker:)), for: .valueChanged)
    }

    private func loadModel() {
        guard let model = model else {
            return
        }
        mainTextView.resignFirstResponder()
        mainTextView.text = model.mainText
        isPriority = model.isPriority
        priorityImage.image = UIImage(named: isPriority ? "square_filled" : "square")
        if model.taskDate.startOfDay < Date().startOfDay {
            datePicker.date = Date() // TODO: support old dates
        } else {
            datePicker.date = model.taskDate
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        if model.isAlarmSet {
            timePicker.date = model.alarmDate!
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            timeTextField.text = formatter.string(from: timePicker.date)
            timeImage.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
            timeImage.alpha = 0.9
            isAlarmSet = true
            deleteAlarmImage.alpha = 1
        }
        if let subtasksString = model.subtasks {
            loadSubtasks(str: subtasksString)
        }
    }

    func loadSubtasks(str: String) {
        var data = str.components(separatedBy: "\n")
        data.removeLast()
        for var i in stride(from: 0, to: data.count, by: 2) {
            let view = generateNewSubtask(shouldRespond: false, isPreloaded: true, isDoneSubtask: data[i] == "done", text: data[i + 1])
            subtaskStackView.insertArrangedSubview(view, at: subtaskStackView.arrangedSubviews.count - 1)
            i += 1
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addSubtaskWithResponder(callerView: textField.superview!)
        return true
    }

    func addSubtaskWithResponder(callerView: UIView) {
        let view = generateNewSubtask(shouldRespond: true)
        subtaskStackView.insertArrangedSubview(view, at: subtaskStackView.arrangedSubviews.firstIndex(of: callerView)! + 1)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func generateNewSubtask(shouldRespond: Bool, isPreloaded: Bool = false, isDoneSubtask: Bool = false, text: String = "") -> UIView {
        let view = UIView()

        let circle = UIImageView()
        circle.image = UIImage(named: "circle")
        circle.contentMode = .scaleAspectFit
        circle.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        view.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 25).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        circle.isUserInteractionEnabled = true
        circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:))))

        let textField = UITextField()
        textField.placeholder = "New Subtask"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular) // TODO: change to medium
        textField.returnKeyType = .done
        textField.delegate = self
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        let image = UIImageView()
        image.image = UIImage(named: "close")
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        image.alpha = 1
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 14).isActive = true
        image.widthAnchor.constraint(equalToConstant: 14).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 5).isActive = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(subtaskTapped(_:))))

        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true

        if shouldRespond {
            textField.becomeFirstResponder()
        }
        if isPreloaded {
            if isDoneSubtask {
                view.alpha = 0.35
                circle.image = UIImage(named: "circle_filled")
            }
            textField.text = text
        }
        return view
    }

    private func createStack() {
        addSubtaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addSubtaskTapped)))
        subtaskStackView = UIStackView(arrangedSubviews: [addSubtaskView])
        subtaskStackView.axis = .vertical
        subtaskStackView.alignment = .fill
        subtaskStackView.distribution = .equalSpacing
        subtaskStackView.spacing = 5
    }

    @objc
    func addSubtaskTapped() {
        let view = generateNewSubtask(shouldRespond: false)
        subtaskStackView.insertArrangedSubview(view, at: subtaskStackView.arrangedSubviews.count - 1)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func subtaskTapped(_ sender: UIGestureRecognizer) {
        guard let view = sender.view?.superview else {
            return
        }
        subtaskStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func circleTapped(_ sender: UIGestureRecognizer) {
        guard let view = sender.view?.superview else {
            return
        }
        guard let image = sender.view as? UIImageView else {
            return
        }
        if view.alpha == 1 {
            view.alpha = 0.35
            image.image = UIImage(named: "circle_filled")
        } else {
            view.alpha = 1
            image.image = UIImage(named: "circle")
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

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
    func deleteAlarmTapped() {
        deleteAlarmImage.alpha = 0
        verifyFiveMinutes()
        timeTextField.text = ""
        timeImage.tintColor = .black
        timeImage.alpha = 0.3
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        isAlarmSet = false
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
        setTimePickerDate()
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
        setTimePickerDate()
    }

    @objc
    func datePickerChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        setTimePickerDate()
    }

    func setTimePickerDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let formattedDate = formatter.string(from: datePicker.date)
        let today = formatter.string(from: Date())
        verifyFiveMinutes()
        if formattedDate == today {
            timePicker.minimumDate = Date().addingTimeInterval(2 * 60)
            timePicker.maximumDate = Date().endOfDay
            if timePicker.date < timePicker.minimumDate! {
                verifyFiveMinutes()
                timeTextField.text = ""
                timeImage.tintColor = .black
                timeImage.alpha = 0.3
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                isAlarmSet = false
                deleteAlarmImage.alpha = 0
            }
        } else {
            timePicker.minimumDate = datePicker.date.startOfDay
            timePicker.maximumDate = datePicker.date.endOfDay
            if Date() > timePicker.maximumDate! {
                verifyFiveMinutes()
                timeTextField.text = ""
                timeImage.tintColor = .black
                timeImage.alpha = 0.3
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                isAlarmSet = false
                deleteAlarmImage.alpha = 0
            }
        }
    }

    @objc
    func timePickerDonePressed() {
        timePickerChanged(picker: timePicker)
        self.view.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    func timePickerCancelPressed() {
        verifyFiveMinutes()
        timeTextField.text = ""
        self.view.endEditing(true)
        timeImage.tintColor = .black
        timeImage.alpha = 0.3
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        isAlarmSet = false
        deleteAlarmImage.alpha = 0
    }

    @objc
    func timePickerChanged(picker: UIDatePicker) {
        verifyFiveMinutes()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: picker.date)
        timeImage.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        timeImage.alpha = 0.9
        isAlarmSet = true
        deleteAlarmImage.alpha = 1
        checkIfAllowedNotifications(picker: picker)
    }

    func verifyFiveMinutes() {
        if timePicker.date.minute % 5 != 0 {
            timePicker.date += TimeInterval((5 - timePicker.date.minute % 5) * 60)
        }
    }

    func checkIfAllowedNotifications(picker: UIDatePicker) {
        if notificationsStatus == .authorized {
            return
        }
        if notificationsStatus == .denied {
            timePickerCancelPressed()
            alertNotificationsDenied()
        }
        if notificationsStatus == .notDetermined {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    checkNotifications()
                } else if error != nil {
                    print("error occured")
                } else if error == nil {
                    checkNotifications()
                    DispatchQueue.main.async {
                        self.timePickerCancelPressed()
                        self.alertNotificationsDenied()
                    }
                }
            })
        }
    }

    func getStringFromSubtasks() -> String? {
        var res = ""
        for subtask in subtaskStackView.arrangedSubviews {
            for subview in subtask.subviews as [UIView] {
                if let textField = subview as? UITextField {
                    if let text = textField.text {
                        if text != "" {
                            res += (subtask.alpha == 1 ? "undone" : "done") + "\n" + text + "\n"
                        }
                    }
                    break
                }
            }
        }

        return res == "" ? nil : res
    }

    func dismiss() {
        // TODO: add dismiss cross button to the top of view
        self.dismiss(animated: true, completion: nil)
    }

    func alertNotificationsDenied() { // TODO: finish this alert
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

        let dataFromSubtasks = getStringFromSubtasks()
        let id = model == nil ? UUID() : model!.id
        let isDone = model == nil ? false : model!.isDone
        let dateCompleted = isDone ? model!.dateCompleted : nil
        if dataFromSubtasks != nil, mainTextView.text == "" {
            mainTextView.text = "Empty task"
        }
        let task = TaskModel(id: id, mainText: mainTextView.text, subtasks: dataFromSubtasks, isPriority: isPriority, isDone: isDone, taskDate: datePicker.date, isAlarmSet: isAlarmSet, alarmDate: isAlarmSet ? timePicker.date : nil, dateCompleted: dateCompleted, dateModified: Date())
        returnTask?(task)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createStack()
        setup()
        checkNotifications()
        createDatePicker()
        createTimePicker()
        loadModel()
        setTimePickerDate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = {
            if isShowingKeyboard {
                return containerView.frame.height + 400
            } else {
                return containerView.frame.height + 200
            }
        }()
    }

    func setup() {
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true

        self.containerView.addSubview(swipeArrow)
        swipeArrow.translatesAutoresizingMaskIntoConstraints = false
        swipeArrow.heightAnchor.constraint(equalToConstant: 10).isActive = true
        swipeArrow.widthAnchor.constraint(equalToConstant: 140).isActive = true
        swipeArrow.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
        swipeArrow.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 15).isActive = true

        self.containerView.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: swipeArrow.bottomAnchor, constant: 15).isActive = true

        self.containerView.addSubview(planning)
        planning.translatesAutoresizingMaskIntoConstraints = false
        planning.heightAnchor.constraint(equalToConstant: 17).isActive = true
        planning.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        planning.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25).isActive = true
        planning.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30).isActive = true

        self.containerView.addSubview(mainTextView)
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 21).isActive = true
        mainTextView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -50).isActive = true
        mainTextView.topAnchor.constraint(equalTo: planning.bottomAnchor, constant: 10).isActive = true
        mainTextView.becomeFirstResponder()
        mainTextView.returnKeyType = .done
        mainTextView.delegate = self

        self.containerView.addSubview(subtaskStackView)
        subtaskStackView.translatesAutoresizingMaskIntoConstraints = false
        subtaskStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        subtaskStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25).isActive = true
        subtaskStackView.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 5).isActive = true

        self.containerView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25).isActive = true
        separator.topAnchor.constraint(equalTo: subtaskStackView.bottomAnchor, constant: 20).isActive = true

        self.containerView.addSubview(dateImage)
        dateImage.translatesAutoresizingMaskIntoConstraints = false
        dateImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dateImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        dateImage.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        dateImage.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 35).isActive = true

        self.containerView.addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: dateImage.trailingAnchor, constant: 12).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 25).isActive = true
        dateTextField.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 36).isActive = true

        self.containerView.addSubview(timeImage)
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        timeImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        timeImage.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        timeImage.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20).isActive = true

        self.containerView.addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeTextField.leadingAnchor.constraint(equalTo: timeImage.trailingAnchor, constant: 12).isActive = true
        timeTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20).isActive = true

        self.containerView.addSubview(deleteAlarmImage)
        deleteAlarmImage.translatesAutoresizingMaskIntoConstraints = false
        deleteAlarmImage.heightAnchor.constraint(equalToConstant: 14).isActive = true
        deleteAlarmImage.widthAnchor.constraint(equalToConstant: 14).isActive = true
        deleteAlarmImage.centerYAnchor.constraint(equalTo: timeTextField.centerYAnchor).isActive = true
        deleteAlarmImage.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25).isActive = true
        deleteAlarmImage.isUserInteractionEnabled = true
        deleteAlarmImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAlarmTapped)))

        self.containerView.addSubview(priorityImage)
        priorityImage.translatesAutoresizingMaskIntoConstraints = false
        priorityImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        priorityImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        priorityImage.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25).isActive = true
        priorityImage.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20).isActive = true
        priorityImage.isUserInteractionEnabled = true
        priorityImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priorityTapped)))

        self.containerView.addSubview(priorityLabel)
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        priorityLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        priorityLabel.leadingAnchor.constraint(equalTo: priorityImage.trailingAnchor, constant: 12).isActive = true
        priorityLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20).isActive = true
        priorityLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        priorityLabel.isUserInteractionEnabled = true
        priorityLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priorityTapped)))
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
//            dismiss() // TODO: don't hide
            return false
        }
        return true
    }

    @objc
    func keyboardWillAppear() {
        isShowingKeyboard = true
        self.viewDidLayoutSubviews()
    }

    @objc
    func keyboardWillDisappear() {
        isShowingKeyboard = false
        self.viewDidLayoutSubviews()
    }

    // TODO: placeholder. Now it saves with placeholder as a mainText
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.alpha == 0.25 { // TODO: fix 0.25 using colors
//            textView.text = nil
//            textView.alpha = 1
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "New task"
//            textView.alpha = 0.25
//        }
//    }
}
