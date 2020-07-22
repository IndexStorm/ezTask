//
//  NewTaskVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 21.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

protocol SecondControllerDelegate : NSObjectProtocol {
    func didBackButtonPressed(task: TaskModel)
}

struct TaskModel {
    let mainText: String
}

class NewTaskVC: UIViewController, UITextViewDelegate {
    // Var
    var isPriority: Bool = false
    weak var delegate: SecondControllerDelegate?

    // Views

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

        return image
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "July 20, Monday"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        return label
    }()

    private let timeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "bell")
        image.contentMode = .scaleAspectFit

        return image
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "20:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        return label
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @objc
    func dateTapped() {
        print("hoh")
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let task = TaskModel(mainText: mainText.text)
        delegate?.didBackButtonPressed(task: task)
    }

    func dismiss() {
        // TODO: add dismiss cross button
        self.dismiss(animated: true, completion: nil)
    }

    func setup() {
        self.view.backgroundColor = .white

        self.view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true

        self.view.addSubview(planning)
        planning.translatesAutoresizingMaskIntoConstraints = false
        planning.heightAnchor.constraint(equalToConstant: 17).isActive = true
        planning.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        planning.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        planning.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 25).isActive = true

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
        dateImage.isUserInteractionEnabled = true
        dateImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateTapped)))

        self.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: dateImage.trailingAnchor, constant: 12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 35).isActive = true
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateTapped)))

        self.view.addSubview(timeImage)
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        timeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        timeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        timeImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        timeImage.isUserInteractionEnabled = true
        timeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeTapped)))

        self.view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImage.trailingAnchor, constant: 12).isActive = true
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.isUserInteractionEnabled = true
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeTapped)))

        self.view.addSubview(priorityImage)
        priorityImage.translatesAutoresizingMaskIntoConstraints = false
        priorityImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priorityImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        priorityImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        priorityImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        priorityImage.isUserInteractionEnabled = true
        priorityImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priorityTapped)))

        self.view.addSubview(priorityLabel)
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priorityLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        priorityLabel.leadingAnchor.constraint(equalTo: priorityImage.trailingAnchor, constant: 12).isActive = true
        priorityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
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
